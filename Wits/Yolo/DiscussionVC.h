//
//  DiscussionVC.h
//  Yolo
//
//  Created by Nisar Ahmad on 08/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "Topic.h"

@interface DiscussionVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    
    
    __weak IBOutlet UITableView *discussionTbl;
    __weak IBOutlet UIButton *newDiscussionBtn;
    __weak IBOutlet UIView *seperator;
    
     NSString *language;
     int languageCode;
     
     NSString *loadingTitle;
    NSMutableArray *discussionArray;
    int indexToDelete;
    
    LoadingView *_loadView;
    Topic *subTopic;
}

@property BOOL isNewDiscussion;


- (id)initWithSub_Topic:(Topic *)_subTopic;


-(IBAction)CreateNewDiscussion:(id)sender;
-(IBAction)ShowRightMenu:(id)sender;
@end
