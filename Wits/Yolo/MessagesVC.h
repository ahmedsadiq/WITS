//
//  MessagesVC.h
//  Yolo
//
//  Created by Nisar Ahmad on 07/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface MessagesVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    __weak IBOutlet UITableView *threadTbl;
    
    NSMutableArray *threadList;
    int indexToDelete;
     NSString* loadingTitle;
     int languageCode;
    
     NSString *days_ago;
     NSString *hours_ago;
     NSString *minutes_ago;
     NSString *seconds_ago;
     
    IBOutlet UIButton *sendNewMsg;
    IBOutlet UILabel *messagesLbl;
    IBOutlet UILabel *noMsgfoundLbl;
    LoadingView *_loadView;
     NSDate *currentServerTime;
    IBOutlet UIButton *mainBackbtn;
}
- (IBAction)SendNewMsg:(id)sender;
- (IBAction)mainBack:(id)sender;

-(IBAction)ShowRightMenu:(id)sender;
- (id)init;
@end
