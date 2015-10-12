//
//  ChallengeSearchObject.h
//  Wits
//
//  Created by Ahmed Sadiq on 03/09/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChallengeSearchObject : NSObject
@property (strong, nonatomic) NSString *recieverName;
@property (strong, nonatomic) NSString *senderName;
@property (strong, nonatomic) NSString *senderProfileImgLink;
@property (strong, nonatomic) NSString *recieverProfileImgLink;
@property (strong, nonatomic) UIImage *senderProfileImage;

@end
