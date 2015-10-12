//
//  LoadingView.h
//  IVillageToGo
//
//  Created by Jameel khan on 02/04/10.
//  Copyright 2010 LUMS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingView : UIView {
    
    UIActivityIndicatorView *spinner;
    UILabel *label;
}

@property(nonatomic,retain) UIActivityIndicatorView *spinner;

-(void)showInView:(UIView *)targetView withTitle:(NSString *)title; 
-(void)hide;

@end
