//
//  HistoryVC.h
//  Yolo
//
//  Created by Salman Khalid on 25/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"


@interface HistoryVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
 
    IBOutlet UITableView *table_View;
    
     NSString *language;
     int languageCode;
     
    LoadingView *_loadingView;
    NSMutableArray *historyArray;
}

-(IBAction)ShowRightMenu:(id)sender;

@end
