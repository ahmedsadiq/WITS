//
//  SocketManager.m
//  Wits
//
//  Created by Mr on 06/02/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import "SocketManager.h"
#import "SharedManager.h"

static SocketManager *socket_instance = nil;

@implementation SocketManager
@synthesize socketdelegate;
+(SocketManager *)getInstance{
     
     @synchronized (self)
     {
          if(socket_instance == NULL)
          {
               socket_instance = [[SocketManager alloc] init];
          }
     }
     return socket_instance;
}
#pragma mark Socket Communication Methods    

-(void)sendEvent:(NSString*)eventName andParameters:(NSDictionary*)params {
     [_socketIO sendEvent:eventName withData:params];
}
-(void)openSockets {
     
     _socketIO = [[SocketIO alloc] initWithDelegate:self];
     
     NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id", nil];
     //For Live
  [_socketIO connectToHost:@"nodeapp.witsapplication.com" onPort:3000 withParams:registerDictionary];
     
     //For Dev
     //[_socketIO connectToHost:@"witsnodedev.witsapplication.com" onPort:11000 withParams:registerDictionary];

}
-(void)closeWebSocket {
     [_socketIO disconnect];
}

# pragma mark -
# pragma mark socket.IO-objc delegate methods

- (void) socketIODidConnect:(SocketIO *)socket{
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
     [socketdelegate DataRevieved:packet];
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
     NSLog(@"onError() %@", error);
     [socketdelegate socketDisconnected:socket onError:error];
}

- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
     NSLog(@"socket.io disconnected. did error occur? %@", error);
     [socketdelegate socketError:socket disconnectedWithError:error];
}

@end
