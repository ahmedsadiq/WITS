//
//  CustomCell.h
//  Yolo
//
//  Created by Jawad Mahmood  on 24/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell{
    
    IBOutlet UIImageView *titleImageView;
    IBOutlet UILabel *titleLbl;
    IBOutlet UILabel *pricelbl;
    IBOutlet UIImageView *rightArrow;
}
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *pricelbl;
@property (nonatomic, strong) UIImageView *rightArrow;


#pragma new UI
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *leftSubTitles;
@property (weak, nonatomic) IBOutlet UIView *leftOverLay;
@property (weak, nonatomic) IBOutlet UIView *rightOverLay;

@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *rightSubTitles;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;

@end
