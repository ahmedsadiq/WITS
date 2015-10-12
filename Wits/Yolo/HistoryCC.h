//
//  CustomCell.h
//  Yolo
//
//  Created by Jawad Mahmood  on 24/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface HistoryCC : UITableViewCell{
    
    IBOutlet UIImageView *logo;
    IBOutlet UILabel *topicLbl;
    IBOutlet UILabel *messageLbl;
    IBOutlet AsyncImageView *opponentImageView;
}

@property (nonatomic, strong) UILabel *topicLbl;
@property (nonatomic, strong) UILabel *messageLbl;
@property (nonatomic, strong) UIImageView *opponentImageView;
@property (strong, nonatomic) IBOutlet UIImageView *logo;

#pragma new UI
@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *leftSubTitles;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIView *rightOverLay;
@property (weak, nonatomic) IBOutlet UIView *leftOverLay;

@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
@property (weak, nonatomic) IBOutlet UILabel *rightSubTitles;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;



@end
