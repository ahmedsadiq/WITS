//
//  CustomCell_SelectedCC.h
//  Wits
//
//  Created by Mr on 01/01/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell_SelectedCC : UITableViewCell {

IBOutlet UIImageView *titleImageView;
IBOutlet UILabel *titleLbl;

IBOutlet UIButton *playBowBtn;
IBOutlet UIButton *challengeBtn;
IBOutlet UIButton *rankingBtn;
IBOutlet UIButton *discussionBtn;
   
    
    
}

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UIImageView *rightarrow;


@property (nonatomic, strong) IBOutlet UIButton *playBowBtn;
@property (nonatomic, strong) IBOutlet UIButton *challengeBtn;
@property (nonatomic, strong) IBOutlet UIButton *rankingBtn;
@property (nonatomic, strong) IBOutlet UIButton *discussionBtn;

#pragma New UI

@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UIView *OverlayMain;
@property (weak, nonatomic) IBOutlet UIImageView *mainImgThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *mainSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UIButton *mainBtn;


@end
