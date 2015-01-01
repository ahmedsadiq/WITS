//
//  AlertMessage.h
//  iSpye
//
//  Created by Kiryl Lishynski on 10/29/12.
//  Copyright (c) 2012 Exairo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"

@class LoginVC;
@interface AlertMessage : UIView {
    
}
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;

@property (nonatomic, retain) UIDynamicAnimator *animator;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIView *messageView;

@property (strong,nonatomic) LoginVC *loginvcOBJ;
- (IBAction)closeAlert:(id)sender;
+ (void)showAlertWithMessage:(NSString*)message andTitle: (NSString*)Title SingleBtn:(BOOL)Bool cancelButton: (NSString*)CancelBtn OtherButton:(NSString*)Otherbuttons;
- (IBAction)Okbtn:(id)sender;
+(void)hideOkBtn;

@property (nonatomic) NSInteger *tagNo;
@property (strong, nonatomic) IBOutlet UIButton *OutletOk;
@property (strong, nonatomic) IBOutlet UIButton *outletCancel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
