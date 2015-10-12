//
//  RankingVC.h
//  Yolo
//
//  Created by Jawad Mahmood  on 26/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface RankingVC : UIViewController<UITableViewDataSource,UITextFieldDelegate>{
    
    __weak IBOutlet UITableView *rankTblView;
    
    __weak IBOutlet UIButton *allTimeBtn;
    __weak IBOutlet UIButton *thisWeekBtn;
    
    
    NSArray *rankingArray;
    int rankCounter;
    
    LoadingView *loadView;
}
- (IBAction)bckPressed:(id)sender;
-(IBAction)ShowRightMenu:(id)sender;
@end
