//
//  CustomCell.h
//  Yolo
//
//  Created by Jawad Mahmood  on 24/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubTopicSelectedCC : UITableViewCell{
    
    IBOutlet UIImageView *titleImageView;
    IBOutlet UILabel *titleLbl;
    
    IBOutlet UIButton *playBowBtn;
    IBOutlet UIButton *challengeBtn;
    IBOutlet UIButton *rankingBtn;
    IBOutlet UIButton *discussionBtn;
}

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *titleLbl;

@property (strong, nonatomic) IBOutlet UIImageView *downArrow;

@property (nonatomic, strong) IBOutlet UIButton *playBowBtn;
@property (nonatomic, strong) IBOutlet UIButton *challengeBtn;


#pragma New UI
@property (weak, nonatomic) IBOutlet UIView *OverLayMain;

@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UIImageView *mainImgThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *mainSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UIButton *mainBtn;
@end
