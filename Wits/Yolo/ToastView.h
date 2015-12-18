//
//  ToastView.h
//  Wits
//
//  Created by Apple on 16/12/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#ifndef Wits_ToastView_h
#define Wits_ToastView_h


#endif
#import <UIKit/UIKit.h>

@interface ToastView : UIView

@property (strong, nonatomic) NSString *text;

+ (void)showToastInParentView: (UIView *)parentView withText:(NSString *)text withDuaration:(float)duration;

@end