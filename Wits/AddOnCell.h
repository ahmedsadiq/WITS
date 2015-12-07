//
//  AddOnCell.h
//  Wits
//
//  Created by Ahmed Sadiq on 02/06/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddOnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addonCount;
@property (weak, nonatomic) IBOutlet UIImageView *lockedImg;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIImageView *gemsImgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (strong, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightPrice;
@property (weak, nonatomic) IBOutlet UILabel *leftDiscription;
@property (weak, nonatomic) IBOutlet UILabel *rightDiscription;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *leftcellbg;
@property (weak, nonatomic) IBOutlet UIImageView *rightGemlogo;
@property (weak, nonatomic) IBOutlet UIImageView *rightlockedimg;
@property (weak, nonatomic) IBOutlet UIButton *buybtnright;
@property (weak, nonatomic) IBOutlet UIButton *buybtnleft;

@end
