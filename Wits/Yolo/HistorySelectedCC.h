//
//  HistorySelectedCC.h
//  Wits
//
//  Created by Mr on 10/11/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface HistorySelectedCC : UITableViewCell {

    IBOutlet UILabel *topicLbl;
    IBOutlet UILabel *messageLbl;
    IBOutlet AsyncImageView *opponentImageView;
    
    IBOutlet UIImageView *logo;

    
}

@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (nonatomic, strong) UILabel *topicLbl;
@property (nonatomic, strong) UILabel *messageLbl;
@property (nonatomic, strong) UIImageView *opponentImageView;
@property (strong, nonatomic) IBOutlet UILabel *resultBtnLbl;



@property (strong, nonatomic) IBOutlet UIButton *rankingBtn;
@property (strong, nonatomic) IBOutlet UIButton *resultBtn;

@end
