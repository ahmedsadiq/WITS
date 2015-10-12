//
//  FriendsSelectedCC.h
//  Yolo
//
//  Created by Nisar Ahmad on 30/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface FriendsSelectedCC : UITableViewCell{
    
}
@property (strong, nonatomic) IBOutlet UIImageView *imgFrame;

@property (weak, nonatomic) IBOutlet AsyncImageView *profileImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *statusBg;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *unFriendBtn;
@property (strong, nonatomic) IBOutlet UILabel *transferPointLbl;
@property (strong, nonatomic) IBOutlet UIButton *transferPointBrn;


@end
