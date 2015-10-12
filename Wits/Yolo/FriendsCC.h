//
//  FriendsCC.h
//  Yolo
//
//  Created by Jawad Mahmood  on 28/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface FriendsCC : UITableViewCell{
    
}
//@property (strong, nonatomic) IBOutlet UIButton *profileBtnOutlet;
//@property (strong, nonatomic) IBOutlet UIImageView *imgFrame;
//
//@property (strong, nonatomic) IBOutlet UIImageView *onlineImg;
//@property (weak, nonatomic) IBOutlet AsyncImageView *profileImgView;
//@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
//@property (weak, nonatomic) IBOutlet UIImageView *statusBg;
//@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
//@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
//@property BOOL isFriendRequest;
//@property (strong, nonatomic) IBOutlet UIButton *acceptBtn;
//@property (strong, nonatomic) IBOutlet UIButton *rejectBtn;
//@property (weak, nonatomic) IBOutlet UIButton *profileBtn;
//
//@property (strong, nonatomic) IBOutlet UIImageView *OnlineStatus;



#pragma New UI Changes
@property (weak, nonatomic) IBOutlet AsyncImageView *leftUserImg;
@property (weak, nonatomic) IBOutlet UIImageView *leftUserFrndStatus;
@property (weak, nonatomic) IBOutlet UILabel *leftUserName;
@property (weak, nonatomic) IBOutlet UIImageView *leftUserVerified;
@property (weak, nonatomic) IBOutlet UIButton *leftUserActionBtn;
@property (weak, nonatomic) IBOutlet UIView *leftOverLay;

@property (weak, nonatomic) IBOutlet AsyncImageView *rightUserImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightUserFrndStatus;
@property (weak, nonatomic) IBOutlet UIImageView *rightUserVerified;
@property (weak, nonatomic) IBOutlet UILabel *rightUserName;
@property (weak, nonatomic) IBOutlet UIButton *rightUserActionBtn;
@property (weak, nonatomic) IBOutlet UIView *rightOverlayView;


@end
