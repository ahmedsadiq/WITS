//
//  HomeVC.h
//  Yolo
//
//  Created by Salman Khalid on 16/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "AppDelegate.h"

@interface HomeVC : UIViewController{
    

    IBOutlet UIScrollView *homeScrollView;
    LoadingView *_loadingView;
     AppDelegate *emailOBj;
     UIView *parentView;
     
     NSString *verified;
     BOOL gAudioSessionInited;
     
    IBOutlet UILabel *verifyTitle;
    IBOutlet UIView *verificationView;
    IBOutlet UILabel *myMsgLbl;
    IBOutlet UILabel *myFriendsLbl;
    IBOutlet UILabel *rankingLbl;
    IBOutlet UILabel *settingLbl;
    IBOutlet UILabel *playNowLbl;
    IBOutlet UILabel *witsStoreLbl;
    IBOutlet UILabel *earnFreePointsLbl;
    
    IBOutlet UITextView *verifyTxt;
    IBOutlet UILabel *emailVerfiyLbl;
     NSString *loadingTitle;
     
     NSString *Ok;
     int languageCode;
     
    IBOutlet UILabel *titleLbl;
     
     NSArray *tempArray;
     NSArray *topicsArray;
     AppDelegate *delegate ;
    
    IBOutlet UIView *dialogView;
    
    IBOutlet UIButton *dialogbtn;
    IBOutlet UILabel *dialogMsgLbl;
    IBOutlet UILabel *dialogTitlelbl;
}
- (IBAction)dialogbtnPressed:(id)sender;

- (id)init;

-(IBAction)ShowRightMenu:(id)sender;

-(IBAction)getTopics:(id)sender;
-(IBAction)getPoint:(id)sender;
-(IBAction)ShowHistory:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *okverifyView;

- (IBAction)okVerfiyPressed:(id)sender;

-(IBAction)showStore:(id)sender;
-(IBAction)showFriends:(id)sender;
-(IBAction)ShowMessages:(id)sender;
-(IBAction)ShowDiscussion:(id)sender;
- (IBAction)showRanking:(id)sender;
- (NSData*)encodeDictionary:(NSDictionary*)dictionary;

@end
