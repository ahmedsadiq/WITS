//
//  CustomCell.h
//  Yolo
//
//  Created by Jawad Mahmood  on 24/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubTopicCC : UITableViewCell{
    
}


#pragma new UI
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *leftSubTitles;
@property (weak, nonatomic) IBOutlet UIView *rightOverLay;

@property (weak, nonatomic) IBOutlet UIView *leftOverLay;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *rightSubTitles;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@end
