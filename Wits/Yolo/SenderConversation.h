//
//  SenderConversation.h
//  Wits
//
//  Created by Ahmed Sadiq on 25/08/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenderConversation : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *senderImg;
@property (weak, nonatomic) IBOutlet UILabel *senderTitle;
@property (weak, nonatomic) IBOutlet UILabel *messageLbl;

@end
