//
//  AlertMessage.h
//  iSpye
//
//  Created by Kiryl Lishynski on 10/29/12.
//  Copyright (c) 2012 Exairo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"
#import "SocketManager.h"


@class LoginVC;

@protocol NotifAlertMessageDelegate
- (void)closeAlert:(NSString*)alertType;
- (void)Okbtn:(NSString*)type withDictionary:(NSDictionary*)dict;
@end

@interface NotifAlertMessage: UIView

{
     NotifAlertMessage *alertMessage;
     NSInteger currentSelectedIndex;
     
     UIView *challengeView;
     NSString *opponentsenderImage;
     NSString *opposenderName;
     UIImageView *sample;
     UILabel *searchLbl;
     BOOL isChallengeAccepted;
     NSString *type;
     NSString *type_id;
     int eventId;
     
     NSString *challengeID;
     NSDictionary *challengeDIctionary;
     UIImageView *searchingicon;

}

+(NotifAlertMessage *)getInstance;
@property (nonatomic, retain) id<NotifAlertMessageDelegate> delegate;

@property (strong, nonatomic) SocketManager *sharedManager;

@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) NSString *action;

@property (strong, nonatomic) IBOutlet UIImageView *ProfileImage;

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIView *messageView;

@property (strong,nonatomic) LoginVC *loginvcOBJ;
- (IBAction)closeAlert:(id)sender;
+ (void)showNotifAlertWithMessage:(NSString*)message andTitle: (NSString*)Title  cancelButton: (NSString*)CancelBtn OtherButton:(NSString*)Otherbuttons ActionNameForSecondBtn: (NSString*)ActionName ImageLink: (NSString*)imageLink initwithDict: (NSDictionary*)Dictionary;

- (IBAction)Okbtn:(id)sender;
+(void)hideOkBtn;

@property (nonatomic) NSInteger *tagNo;
@property (strong, nonatomic) IBOutlet UIButton *OutletOk;
@property (strong, nonatomic) IBOutlet UIButton *outletCancel;


@end
