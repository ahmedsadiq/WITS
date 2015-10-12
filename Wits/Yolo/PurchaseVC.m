//
//  PurchaseVC.m
//  Wits
//
//  Created by Nisar Ahmad on 15/08/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "PurchaseVC.h"
#import "RightBarVC.h"
#import "SharedManager.h"
#import "Utils.h"

@interface PurchaseVC ()

@end

@implementation PurchaseVC

- (id)init
{
    if ([[UIScreen mainScreen] bounds].size.height == iPad) {
        
        self = [super initWithNibName:@"PurchaseVC_iPad" bundle:Nil];
    }
    
    else{
        self = [super initWithNibName:@"PurchaseVC" bundle:Nil];
    }
    
    return self;

}

-(IBAction)ShowRightMenu:(id)sender{
    
    [[RightBarVC getInstance] AddInView:self.view];
    [[RightBarVC getInstance] ShowInView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    loadView = [[LoadingView alloc] init];
    [self loadWebView];
}



-(void)loadWebView{
    
    [loadView showInView:self.view withTitle:@"Loading ..."];
//    NSString *urlString = [NSString stringWithFormat:@"http://quizapplication.faditekdev.com/paypal.php?user_id=%@",[SharedManager getInstance].userID];
    NSString *urlString = [NSString stringWithFormat:@"http://quizapplication.witsapplication.com/paypal.php?user_id=%@",[SharedManager getInstance].userID];

    
    NSURL *_url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    
    [_purchaseWebView loadRequest:request];
}


#pragma mark -
#pragma mark WebView Delegage

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
    
}



- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [loadView hide];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [loadView hide];
     
     
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error while loading" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
