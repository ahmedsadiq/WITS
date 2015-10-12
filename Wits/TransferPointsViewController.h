//
//  TransferPointsViewController.h
//  Wits
//
//  Created by Mr on 19/11/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
@interface TransferPointsViewController : UIViewController<UITextFieldDelegate> {
    LoadingView *_loadView;
    
    IBOutlet UILabel *TransferPoints;
    IBOutlet UIButton *backBtn;
    IBOutlet UIButton *SendPoint;
     int languageCode;
     NSString *loadingTitle;
     
}
@property (strong, nonatomic) IBOutlet UITextField *recieverEmail;
@property (strong, nonatomic) IBOutlet UITextField *amount;
- (IBAction)sendBtn:(id)sender;
- (IBAction)sliderBar:(id)sender;

@end
