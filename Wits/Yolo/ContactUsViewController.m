//
//  ContactUsViewController.m
//  Wits
//
//  Created by Mr on 18/12/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "ContactUsViewController.h"
#import "RightBarVC.h"
#import "Utils.h"
#import "AlertMessage.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     isGeneralFeedBack = false;
     isTechnicalFeedback = true;
     [self setLanguageForScreen];
      [self addDoneToolBarToKeyboard:textView];
}
-(void)addDoneToolBarToKeyboard:(UITextView *)textViewN
{
     UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
     doneToolbar.barStyle = UIBarStyleBlackTranslucent;
     doneToolbar.items = [NSArray arrayWithObjects:
                          [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                          nil];
     [doneToolbar sizeToFit];
     textViewN.inputAccessoryView = doneToolbar;
}

//remember to set your text view delegate
//but if you only have 1 text view in your view controller
//you can simply change currentTextField to the name of your text view
//and ignore this textViewDidBeginEditing delegate method
- (void)textViewDidBeginEditing:(UITextView *)NtextView
{
     textView = NtextView;
}

-(void)doneButtonClickedDismissKeyboard
{
     [textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)technicalPressed:(id)sender {
     if(isTechnicalFeedback) {
          isTechnicalFeedback = false;
          isGeneralFeedBack = true;
          [technicalIssue setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
          [generalBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
     }
     else {
          isTechnicalFeedback = true;
          isGeneralFeedBack = false;
          
          [technicalIssue setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
          [generalBtn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
     }
     
}

- (IBAction)generalPressed:(id)sender {
     if(isGeneralFeedBack) {
          isTechnicalFeedback = true;
          isGeneralFeedBack = false;
          [technicalIssue setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
          [generalBtn setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
     }
     else {
          isTechnicalFeedback = false;
          isGeneralFeedBack = true;
          
          [technicalIssue setBackgroundImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
          [generalBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
     }
}

- (IBAction)sendPressed:(id)sender {
     UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
     [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
     UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     if([MFMailComposeViewController canSendMail]) {
          NSString *emailTitle = @"Contact Us";
          // Email Content
          NSString *messageBody = [NSString stringWithFormat:@"Feedback Email \n%@",textView.text];
          MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
          mc.mailComposeDelegate = self;
          [mc setSubject:emailTitle];
          [mc setMessageBody:messageBody isHTML:NO];
          
          // Present mail view controller on screen
          [self presentViewController:mc animated:YES completion:NULL];
     }
     else
     {
          //Do something like show an alert
          
          [AlertMessage showAlertWithMessage:@"Email not configured in Phone Settings" andTitle:@"Error" SingleBtn:YES cancelButton:@"Cancel" OtherButton:nil];
        /*
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email not configured in Phone Settings" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
          
          [alert show];*/
     }
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
     switch (result)
     {
          case MFMailComposeResultCancelled:
               NSLog(@"Mail cancelled");
               break;
          case MFMailComposeResultSaved:
               NSLog(@"Mail saved");
               break;
          case MFMailComposeResultSent:
               NSLog(@"Mail sent");
               break;
          case MFMailComposeResultFailed:
               NSLog(@"Mail sent failure: %@", [error localizedDescription]);
               break;
          default:
               break;
     }
     
     // Close the Mail Interface
     [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)rightMenuPressed:(id)sender {
     [[RightBarVC getInstance] loadProfileImage];
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}

-(void)setLanguageForScreen {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     int languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          contactUsTitle.text = @"Contact Us";
          GeneralFeedbackLbl.text =GENERAL_FEEDBACK;
          TechIssueLbl.text = TECH_ISSUE;
          [sendBtn setTitle:SEND_BTN forState:UIControlStateNormal];
          
     }
     else if(languageCode == 1 ) {
          contactUsTitle.text = @"اتصل بنا";
          GeneralFeedbackLbl.text = GENERAL_FEEDBACK_1;
          TechIssueLbl.text = TECH_ISSUE_1;
          [sendBtn setTitle:SEND_BTN_1 forState:UIControlStateNormal];
     }
     else if(languageCode == 2) {
          contactUsTitle.text = @"contactez-nous";
          GeneralFeedbackLbl.text = GENERAL_FEEDBACK_2;
          TechIssueLbl.text = TECH_ISSUE_2;
          [sendBtn setTitle:SEND_BTN_2 forState:UIControlStateNormal];
     }
     else if(languageCode == 3) {
          contactUsTitle.text = @"contáctenos";
          GeneralFeedbackLbl.text = GENERAL_FEEDBACK_3;
          TechIssueLbl.text = TECH_ISSUE_3;
          [sendBtn setTitle:SEND_BTN_3 forState:UIControlStateNormal];
     }
     else if(languageCode == 4) {
          contactUsTitle.text = @"entre em contato conosco";
          GeneralFeedbackLbl.text = GENERAL_FEEDBACK_4;
          TechIssueLbl.text = TECH_ISSUE_4;
          [sendBtn setTitle:SEND_BTN_4 forState:UIControlStateNormal];
     }
}

@end
