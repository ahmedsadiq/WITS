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

@end
