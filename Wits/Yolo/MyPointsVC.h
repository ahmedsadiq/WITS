//
//  MyPointsVC.h
//  Yolo
//
//  Created by Jawad Mahmood  on 24/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPointsVC : UIViewController{
    
    __weak IBOutlet UITableView *pointsTblView;
    
    __weak IBOutlet UILabel *pointsLbl;
}


-(IBAction)ShowRightMenu:(id)sender;

@end
