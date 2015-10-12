//
//  ConversationVC.h
//  Yolo
//
//  Created by Nisar Ahmad on 07/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageThreads.h"
#import "LoadingView.h"
#import "AlertMessage.h"

@interface ConversationVC : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>{
    
    __weak IBOutlet UIView *chatView;
    IBOutlet UITextField *chatField;

    __weak IBOutlet UIScrollView *conversationWindow;
    __weak IBOutlet UILabel *headelLbl;
     UILabel *receiverLbl;
    IBOutlet UILabel *titleName;
    IBOutlet UIImageView *profileImg;
    NSMutableArray *conversationArray;
    int messageCounter;
    int indexToDelete;
     
    IBOutlet UIButton *backBtn;
     NSString *emailMsg;
     NSString *title;
     NSString *cancel;
     NSString *language;
     int languageCode;
       UIGestureRecognizer *tapper;
     NSString *days_ago;
     NSString *hours_ago;
     NSString *minutes_ago;
     NSString *seconds_ago;
     NSString *a_second_ago;
     
    CGSize chatLblSize;
    CGPoint chatLblPostition;
    
    MessageThreads *_thread;
    LoadingView *_loadView;
     NSString *loadingTitle;
     NSDate *currentServerTime;
     
     int recievedMsgsY;
}

@property (weak, nonatomic) NSString *headerTitle;

- (id)initWithThread:(MessageThreads *)_received;

-(IBAction)ShowRightMenu:(id)sender;
-(IBAction)sendChatMessage:(id)sender;
- (IBAction)backBtnPressed:(id)sender;

@end
