//
//  SocketManager.h
//  Wits
//
//  Created by Mr on 06/02/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"
#import "SocketIOPacket.h"

@protocol SocketManagerDelegate <NSObject>
@optional
-(void)DataRevieved:(SocketIOPacket *)dict;
-(void)socketDisconnected:(SocketIO *)socket onError:(NSError *)error;
-(void)socketError:(SocketIO *)socket disconnectedWithError:(NSError *)error;
@end

@interface SocketManager : NSObject<SocketIODelegate> {
    __weak id <SocketManagerDelegate> socketdelegate;
}
@property (nonatomic,strong) SocketIO* socketIO;
@property (nonatomic, weak) id <SocketManagerDelegate> socketdelegate;
+(SocketManager *)getInstance;

-(void)openSockets;
-(void)closeWebSocket;
-(void)sendEvent:(NSString*)eventName andParameters:(NSDictionary*)params;

@end
