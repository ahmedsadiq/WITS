//
//  AlertMessage.m
//  iSpye
//
//  Created by Kiryl Lishynski on 10/29/12.
//  Copyright (c) 2012 Exairo. All rights reserved.
//

#import "AlertMessage.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"

@implementation AlertMessage

@synthesize textView = _textView;
@synthesize messageView = _messageView;
//@synthesize TitleView = _titleLbl;


static BOOL showing;


+(void)hideOkBtn {
     AlertMessage *alertMessage = [[[NSBundle mainBundle] loadNibNamed:@"AlertMessage" owner:nil options:nil] objectAtIndex:0];
     alertMessage.outletCancel.frame = CGRectMake(72, 200, 142, 38);
     [alertMessage.outletCancel setTitle:@"OK" forState:UIControlStateNormal];
     
     alertMessage.OutletOk.hidden = YES;
     [alertMessage show];
     
}

+ (void)showAlertWithMessage:(NSString*)message andTitle: (NSString*)Title SingleBtn:(BOOL)Bool cancelButton: (NSString*)CancelBtn OtherButton:(NSString*)Otherbuttons;
{
     
     
     
     if(showing) {
          return;
     }
     
     AlertMessage *alertMessage = [[[NSBundle mainBundle] loadNibNamed:@"AlertMessage" owner:nil options:nil] objectAtIndex:0];
     alertMessage.textView.text = message;
     
     alertMessage.titleLbl.font = [UIFont fontWithName:FONT_NAME size:16];
          alertMessage.outletCancel.font = [UIFont fontWithName:FONT_NAME size:14];
          alertMessage.OutletOk.font = [UIFont fontWithName:FONT_NAME size:14];
               alertMessage.textView.font = [UIFont fontWithName:FONT_NAME size:15];
     
     alertMessage.titleLbl.text = Title;
     [alertMessage.outletCancel setTitle:CancelBtn forState:UIControlStateNormal];
     [alertMessage.OutletOk setTitle:Otherbuttons forState:UIControlStateNormal];
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     int languageCode = [language intValue];
     
     
     NSString *emailMsg;
     NSString *okTitle;
     NSString *cancelTitle;
     if (languageCode == 0 ) {
          
          okTitle = OK_BTN;
          cancelTitle = CANCEL;
     } else if(languageCode == 1) {
          
          okTitle = OK_BTN_1;
          cancelTitle = CANCEL_1;
     }else if (languageCode == 2){
          
          okTitle = OK_BTN_2;
          cancelTitle = CANCEL_2;
     }else if (languageCode == 3){
          
          okTitle = OK_BTN_3;
          cancelTitle = CANCEL_3;
     }else if (languageCode == 4){
          
          okTitle = OK_BTN_4;
          cancelTitle = CANCEL_4;
     }
     
     if (Bool == YES) {
          
          
          [alertMessage.outletCancel setTitle:cancelTitle forState:UIControlStateNormal];
          alertMessage.outletCancel.frame = CGRectMake(72, 200, 142, 38);
          if(IS_IPAD){
               alertMessage.outletCancel.frame = CGRectMake(75, 200, 142, 38);
               
          }
          
          alertMessage.OutletOk.hidden = YES;
          [alertMessage show];
          
     }else{
          [alertMessage.outletCancel setTitle:CancelBtn forState:UIControlStateNormal];
          [alertMessage.OutletOk setTitle:Otherbuttons forState:UIControlStateNormal];
          
     }
     
     
}

- (IBAction)Okbtn:(id)sender {
     showing = NO;
     [self removeFromSuperview];
}



- (void)show {
     showing = YES;
     
     CGRect messageViewFrame = _messageView.frame;
     messageViewFrame.size.height = _outletCancel.frame.origin.y + _outletCancel.frame.size.height-30;
     _messageView.frame = messageViewFrame;
     
     if(IS_IPAD){
          
          
          CGSize sizeBtnWeb = [_textView sizeThatFits:CGSizeMake(280,FLT_MAX)];
          
          _textView.frame = CGRectMake(5, 76, 280, sizeBtnWeb.height+10);
          
          _messageView.frame= CGRectMake(112, 280, 400, 400);
          
          [_messageView setCenter:CGPointMake(200 , 300)];
          
          CGRect btnFrame = _outletCancel.frame;
          btnFrame.origin.y = _textView.frame.origin.y + _textView.frame.size.height + 40;
          _outletCancel.frame = btnFrame;
          
          CGRect messageViewFrame = _messageView.frame;
          messageViewFrame.size.height = _outletCancel.frame.origin.y + _outletCancel.frame.size.height-30;
          _messageView.frame = messageViewFrame;
          
          
     }else if(IS_IPHONE_4){
          
          
          
          CGSize sizeBtnWeb = [_textView sizeThatFits:CGSizeMake(280,FLT_MAX)];
          
          _textView.frame = CGRectMake(5, 76, 280, sizeBtnWeb.height+10);
          
          CGRect btnFrame = _outletCancel.frame;
          btnFrame.origin.y = _textView.frame.origin.y + _textView.frame.size.height + 10;
          _outletCancel.frame = btnFrame;
          
          [_messageView setCenter:CGPointMake(160, 240)];
          
          [_messageView setAutoresizingMask:UIViewAutoresizingNone];
          
          CGRect messageViewFrame = _messageView.frame;
          messageViewFrame.size.height = _outletCancel.frame.origin.y + _outletCancel.frame.size.height + 10;
          _messageView.frame = messageViewFrame;
          
          
     }
     
     UIWindow *window =  [[UIApplication sharedApplication].delegate window];
     self.frame = window.frame;
     [window addSubview:self];
     self.center = window.center;
     
     self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:_containerView];
     
     UIGravityBehavior* gravityBehavior =
     [[UIGravityBehavior alloc] initWithItems:@[self.messageView]];
     gravityBehavior.magnitude = 4.0;
     [self.animator addBehavior:gravityBehavior];
     
     UICollisionBehavior* collisionBehavior =
     [[UICollisionBehavior alloc] initWithItems:@[self.messageView]];
     collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
     
     [self.animator addBehavior:collisionBehavior];
     
     UIDynamicItemBehavior *elasticityBehavior =
     [[UIDynamicItemBehavior alloc] initWithItems:@[self.messageView]];
     elasticityBehavior.elasticity = 0.6f;
     [elasticityBehavior addAngularVelocity:-M_PI_4 forItem:self.messageView];
     [self.animator addBehavior:elasticityBehavior];
     
     
}

- (IBAction)closeAlert:(id)sender {
     showing = NO;
     [self removeFromSuperview];
}

- (void)dealloc {
     
     
}

@end
