//
//  ContactUsViewController.h
//  Wits
//
//  Created by Mr on 18/12/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface ContactUsViewController : UIViewController<UITextViewDelegate,MFMailComposeViewControllerDelegate> {
    
    IBOutlet UIButton *technicalIssue;
    IBOutlet UIButton *generalBtn;
    IBOutlet UITextView *textView;
     BOOL isGeneralFeedBack;
     BOOL isTechnicalFeedback;
    
    IBOutlet UILabel *contactUsTitle;
    
    IBOutlet UILabel *GeneralFeedbackLbl;
    IBOutlet UILabel *TechIssueLbl;
    IBOutlet UIButton *sendBtn;
    
}
- (IBAction)technicalPressed:(id)sender;
- (IBAction)generalPressed:(id)sender;
- (IBAction)sendPressed:(id)sender;
- (IBAction)rightMenuPressed:(id)sender;

@end
