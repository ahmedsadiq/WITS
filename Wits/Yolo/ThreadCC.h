//
//  ThreadCC.h
//  Yolo
//
//  Created by Nisar Ahmad on 07/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadCC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *messageLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;
@property (strong, nonatomic) IBOutlet UIImageView *imgFrme;

@end
