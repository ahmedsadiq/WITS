//
//  FriendsVC.m
//  Yolo
//
//  Created by Salman Khalid on 27/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "FriendsVC.h"
#import "MKNetworkKit.h"
#import "Utils.h"
#import "SharedManager.h"
#import "RightBarVC.h"
#import "Rank.h"
#import "FriendsCC.h"
#import "FriendsSelectedCC.h"
#import "ChatVC.h"
#import "GetTopicsVC.h"
#import "UIImageView+RoundImage.h"
#import "ConversationVC.h"
#import "NavigationHandler.h"
#import "AppDelegate.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "HelperFunctions.h"
@interface FriendsVC ()

@end

@implementation FriendsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
     self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
     if (self) {
          // Custom initialization
     }
     return self;
}

- (void)viewDidLoad
{
     [super viewDidLoad];
     
     [self setupRefreshControl];
     
     // Do any additional setup after loading the view from its nib.
     self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
     currentIndex = 0;
     UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
     searchField.leftView = paddingView;
     searchField.leftViewMode = UITextFieldViewModeAlways;
     
     _loadingView = [[LoadingView alloc] init];
     arrFriendImage = [[NSMutableArray alloc]init];
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     friendsList = [[NSMutableArray alloc] init];
     if (IS_IPAD) {
          if (languageCode== 1) {
               searchimg.frame = CGRectMake(122, 99, 617, 40);
               searchField.frame = CGRectMake(102, 67, 630, 56);
               GoBtn.frame = CGRectMake(20, 67, 101, 56);
          }else{
               searchField.frame= CGRectMake(20, 67, 630, 56);
               searchimg.frame = CGRectMake(20, 99, 728, 40);
               GoBtn.frame = CGRectMake(647, 67, 101, 56);
          }
     }
     
     
     _friendActionAcceptBtn.font = [UIFont fontWithName:FONT_NAME size:14];
     _friendActionRejectBtn.font = [UIFont fontWithName:FONT_NAME size:14];
     _friendActionText.font = [UIFont fontWithName:FONT_NAME size:16];
     _friendActionTitle.font = [UIFont fontWithName:FONT_NAME size:16];
     searchField.font = [UIFont fontWithName:FONT_NAME size:19];
     
     
     NSUInteger index = [friendsList count];
     if (index == 0) {
          noFriendLbl.hidden = false;
     } else if(index > 0){
          noFriendLbl.hidden = true;
     }
     
     [self FetchFriendList];
     
}

-(IBAction)sendSearcgCall:(id)sender{
     
     [searchField resignFirstResponder];
     [arrFriendImage removeAllObjects];
     if (searchField.text.length >= 3) {
          [self FetchFriendList];
     }
     
}

-(void)FetchFriendList{
     
     [arrFriendImage removeAllObjects];
     [_loadingView showInView:self.view withTitle:loadingTitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     
     if([searchField.text isEqualToString:@""] || searchField.text == NULL){
          [postParams setObject:@"showFriends" forKey:@"method"];
          isSearched = false;
     }
     else
     {
          [postParams setObject:@"searchFriends" forKey:@"method"];
          [postParams setObject:searchField.text forKey:@"search_keyword"];
          isSearched = true;
     }
     
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *compOperation){
          
          [_loadingView hide];
          [_refreshControl endRefreshing];
          NSDictionary *mainDict = [compOperation responseJSON];
          NSLog(@"%@",mainDict);
          NSNumber *flag = [mainDict objectForKey:@"flag"];
          
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               //
               [friendsList removeAllObjects];
               NSArray *dataArray = [mainDict objectForKey:@"data"];
               for(NSDictionary *dict in dataArray)
               {
                    UserProfile *userProfile = [[UserProfile alloc] init];
                    [userProfile SetValuesFromDictionary:dict];
                    [friendsList addObject:userProfile];
                    [arrFriendImage addObject:userProfile.profile_image];
                    
                    NSUInteger index = [friendsList count];
                    if (index == 0) {
                         noFriendLbl.hidden = false;
                    } else if(index > 0){
                         noFriendLbl.hidden = true;
                    }
               }
               currentIndex = 0;
               [friendsTable reloadData];
          }
          else
          {
               NSString *messageStr = [mainDict objectForKey:@"message"];
               [AlertMessage showAlertWithMessage:messageStr andTitle:@"Error" SingleBtn:YES cancelButton:CANCEL OtherButton:nil];
          }
          
     }onError:^(NSError *error){
          [_refreshControl endRefreshing];
          [_loadingView hide];
          noFriendLbl.hidden = false;
          NSString *emailMsg;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               emailMsg = @"Check your internet connection setting.";
               title = @"Error";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = @"Revise su configuración de conexión a Internet.";
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = @"Verifique sua configuração de conexão à Internet";
               title = @"Erro";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          /*
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:emailMsg delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
           [alert show]; */
          
     }];
     
     [engine enqueueOperation:op];
     
}

-(IBAction)ShowRightMenu:(id)sender{
     
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}

#pragma mark ----------------------
#pragma mark TableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     float returnValue;
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
     {
          returnValue = 220.0f;
     }
     else
     {
          returnValue = 220.0f;
     }
     return returnValue;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     int rows = ([friendsList count]/2);
     if([friendsList count]%2 == 1) {
          rows++;
     }
     
     if([friendsList count] == 1) {
          rows = 1;
     }
     return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     FriendsCC *cell;
     currentIndex = (indexPath.row*2);
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendsCC_iPad" owner:self options:nil];
          cell = [nib objectAtIndex:0];
          
     }
     else{
          NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendsCC" owner:self options:nil];
          cell = [nib objectAtIndex:0];
     }
     
     UserProfile *_user = [friendsList objectAtIndex:currentIndex];
     cell.leftUserImg.imageURL = [NSURL URLWithString:_user.profile_image];
     NSURL *url = [NSURL URLWithString:_user.profile_image];
     [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
     cell.leftUserName.text = _user.display_name;
     cell.leftUserName.font = [UIFont fontWithName:FONT_NAME size:15];
     NSString * stat = _user.RelationshipStatus ;
     int status = [[NSString stringWithFormat:@"%@",stat] intValue];
     // here
     if(status == 1)
     {
          
          [cell.leftUserVerified setImage:[UIImage imageNamed:@"friendstick.png"]];
          
     }else
     {
          [cell.leftUserVerified setImage:[UIImage imageNamed:@"friendspending.png"]];
     }
     
     cell.leftUserActionBtn.tag = currentIndex;
     [cell.leftUserActionBtn addTarget:self action:@selector(PerformLeftUserAction:) forControlEvents:UIControlEventTouchUpInside];
     
     currentIndex++;
     
     if(currentIndex < friendsList.count) {
          UserProfile *_user2 = [friendsList objectAtIndex:currentIndex];
          cell.rightUserImg.imageURL = [NSURL URLWithString:_user2.profile_image];
          NSURL *url2 = [NSURL URLWithString:_user2.profile_image];
          [[AsyncImageLoader sharedLoader] loadImageWithURL:url2];
          cell.rightUserName.text = _user2.display_name;
          cell.rightUserName.font = [UIFont fontWithName:FONT_NAME size:15];
          //          cell.rightOverlayView.tag = currentIndex;
          //          [HelperFunctions setBackgroundColor:cell.rightOverlayView];
          cell.rightUserActionBtn.tag = currentIndex;
          if(status == 1)
          {
               
               [cell.rightUserVerified setImage:[UIImage imageNamed:@"friendstick.png"]];
               
          }else
          {
               [cell.rightUserVerified setImage:[UIImage imageNamed:@"friendspending.png"]];
          }
          
          [cell.rightUserActionBtn addTarget:self action:@selector(PerformLeftUserAction:) forControlEvents:UIControlEventTouchUpInside];
          currentIndex++;
          
     }
     else {
          cell.rightUserActionBtn.enabled = NO;
          cell.rightUserFrndStatus.hidden = true;
          cell.rightUserImg.hidden = true;
          cell.rightUserName.hidden = true;
          cell.rightUserVerified.hidden = true;
          cell.rightOverlayView.hidden = true;
     }
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
     return cell;
}
-(BOOL) isFriendAcceptRequest :(UserProfile*) userProfile {
     
     int status = [[NSString stringWithFormat:@"%@",userProfile.RelationshipStatus] intValue];
     if(status == 2)
     {
          return true;
     }
     return false;
}

- (IBAction)largeImageBackPressed:(id)sender {
     friendImageView.hidden = true;
}
#pragma mark - TableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
     
     
}



#pragma mark -------------------
#pragma mark Status Actions


-(UIImage *)SetStatusImage:(UserProfile *)_user{
     
     int status = [[NSString stringWithFormat:@"%@",_user.RelationshipStatus] intValue];
     UIImage *statusImage;
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          switch (status) {
               case 0:
                    statusStr = @"Add Friend";
                    statusImage = [UIImage imageNamed:@"btn_blue_iPad.png"];
                    if (languageCode == 0) {
                         _user.status = ADD_FRIEND;
                    }else if (languageCode == 1){
                         _user.status = ADD_FRIEND_1;
                    }else if (languageCode == 2){
                         _user.status = ADD_FRIEND_2;
                         
                    }else if (languageCode == 3){
                         _user.status = ADD_FRIEND_3;
                    }else if (languageCode == 4){
                         _user.status = ADD_FRIEND_4;
                    }
                    
                    
                    break;
               case 1:
                    statusStr = @"";
                    statusImage = [UIImage imageNamed:@"friendblue.png"];
                    _user.status = @"";
                    break;
               case 2:
                    //statusImage = [UIImage imageNamed:@"btn_green_iPad.png"];
                    //_user.status = @"Accept";
                    break;
               case 3:
                    statusStr = @"Pending";
                    statusImage = [UIImage imageNamed:@"btn_pink.png"];
                    if (languageCode == 0){
                         _user.status = PENDING;
                    }else if (languageCode == 1){
                         _user.status = PENDING_1;
                    }else if (languageCode == 2){
                         _user.status = PENDING_2;
                    }else if (languageCode == 3){
                         _user.status = PENDING_3;
                    }else if (languageCode == 4){
                         _user.status = PENDING_4;
                    }
                    
                    break;
               default:
                    break;
          }
     }
     else{
          switch (status) {
               case 0:
                    
                    statusStr = @"Add Friend";
                    statusImage = [UIImage imageNamed:@"btn_blue.png"];
                    if (languageCode == 0) {
                         _user.status = ADD_FRIEND;
                    }else if (languageCode == 1){
                         _user.status = ADD_FRIEND_1;
                    }else if (languageCode == 2){
                         _user.status = ADD_FRIEND_2;
                    }else if (languageCode == 3){
                         _user.status = ADD_FRIEND_3;
                    }else if (languageCode == 4){
                         _user.status = ADD_FRIEND_4;
                    }
                    
                    break;
               case 1:
                    statusStr = @"";
                    statusImage = [UIImage imageNamed:@"friendblue.png"];
                    _user.status = @"";
                    break;
               case 2:
                    //statusImage = [UIImage imageNamed:@"btn_green.png"];
                    //_user.status = @"Accept";
                    break;
               case 3:
                    
                    statusStr = @"Pending";
                    statusImage = [UIImage imageNamed:@"btn_pink.png"];
                    if (languageCode == 0){
                         _user.status = PENDING;
                    }else if (languageCode == 1){
                         _user.status = PENDING_1;
                    }else if (languageCode == 2){
                         _user.status = PENDING_2;
                    }else if (languageCode == 3){
                         _user.status = PENDING_3;
                    }else if (languageCode == 4){
                         _user.status = PENDING_4;
                    }
                    break;
               default:
                    break;
          }
     }
     return statusImage;
}
-(void)PerformProfileImageAction:(id)sender{
     
     [searchField resignFirstResponder];
     [friendLargeImage setImage:[UIImage imageNamed:@"loadlarge.png"]];
     UIButton *selectedBtn = (UIButton *)sender;
     UserProfile *_tempUser = [friendsList objectAtIndex:selectedBtn.tag];
     
     friendImageView.hidden = false;
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     NSString *link = _tempUser.profile_image;
     
     MKNetworkOperation *op = [engine operationWithURLString:link params:nil httpMethod:@"GET"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          [friendLargeImage setImage:[completedOperation responseImage]];
          
     } onError:^(NSError* error) {
     }];
     [engine enqueueOperation:op];
}
-(void)PerformSomeAction:(id)sender{
     
     UIButton *selectedBtn = (UIButton *)sender;
     UserProfile *_tempUser = [friendsList objectAtIndex:selectedBtn.tag];
     NSString *status = _tempUser.status;
     
     if ([statusStr isEqualToString:@"Add Friend"]) {
          
          //[self SendFriendRequest:_tempUser];
     }
     else{
          if ([statusStr isEqualToString:@""]) {
               
               NSString *message;
               NSString *title;
               NSString *ok;
               NSString *cancel;
               if (languageCode == 0) {
                    message = UNFRIEND_CONFIRM;
                    title = @"Confirmation!";
                    ok = OK_BTN;
                    cancel = CANCEL;
               }else if (languageCode == 1){
                    message = UNFRIEND_CONFIRM_1;
                    title = @"!التأكيد";
                    ok = OK_BTN_1;
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    message = UNFRIEND_CONFIRM_2;
                    title = @"Confirmation!";
                    ok = OK_BTN_2;
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    message = UNFRIEND_CONFIRM_3;
                    title = @"Confirmación!";
                    ok = OK_BTN_3;
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    message = UNFRIEND_CONFIRM_4;
                    title = @"Confirmação!";
                    ok = OK_BTN_4;
                    cancel = CANCEL_4;
               }
               
               [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:NO cancelButton:OK_BTN OtherButton:CANCEL];
               
               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                   message:message
                                                                  delegate:self
                                                         cancelButtonTitle:ok
                                                         otherButtonTitles:cancel, nil];
               alertView.tag = selectedBtn.tag;
               [alertView show];
               
          }
          else{
               if ([status isEqualToString:@"Accept"]) {
                    
                    [self AcceptFriendRequest];
               }
               else{
                    
               }
          }
     }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex              {
     if(buttonIndex == 0)//OK button pressed
     {
          //[self DeleteFriend:alertView.tag];
     }
     else if(buttonIndex == 1)
     {
          //do something
     }
}
-(void)PerformAcceptAction:(id)sender{
     
     UIButton *selectedBtn = (UIButton *)sender;
     [self AcceptFriendRequest];
     
}
-(void)PerformRejectAction:(id)sender{
     
     UIButton *selectedBtn = (UIButton *)sender;
     [self AcceptRejectRequest];
     
}

#pragma mark -
#pragma mark Send Friend Request

-(void)SendFriendRequest{
     
     [_loadingView showInView:self.view withTitle:loadingTitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"sendFriendRequest" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParams setObject:selectedUser.friendID forKey:@"friend_id"];
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *compOp){
          
          [_loadingView hide];
          NSDictionary *mainDict = [compOp responseJSON];
          NSLog(@"main Dictionary :%@",[compOp responseString]);
          NSNumber *flag = [mainDict objectForKey:@"flag"];
          
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               selectedUser.RelationshipStatus = @"3";
               
          }
          
          
     }onError:^(NSError *error){
          
          [_loadingView hide];
          
          NSString *emailMsg;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               emailMsg = @"Check your internet connection setting.";
               title = @"Error";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
               title = @"خطأ";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               emailMsg = @"Vérifiez vos paramètres de connexion Internet.";
               title = @"Erreur";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               emailMsg = @"Revise su configuración de conexión a Internet.";
               title = @"Error";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               emailMsg = @"Verifique sua configuração de conexão à Internet";
               title = @"Erro";
               cancel = CANCEL_4;
          }
          
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
     }];
     
     [engine enqueueOperation:op];
}

#pragma mark -
#pragma mark Accept Friend Request

-(void)AcceptFriendRequest{
     
     
     [_loadingView showInView:self.view withTitle:loadingTitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"acceptFriendRequest" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParams setObject:selectedUser.friendID forKey:@"friend_id"];
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *compOp){
          
          [_loadingView hide];
          NSDictionary *mainDict = [compOp responseJSON];
          NSNumber *flag = [mainDict objectForKey:@"flag"];
          
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               selectedUser.RelationshipStatus = @"1";
               [self FetchFriendList];
          }
          
     }onError:^(NSError *error){
          
     }];
     
     [engine enqueueOperation:op];
}
-(void)AcceptRejectRequest{
     
     [_loadingView showInView:self.view withTitle:loadingTitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"rejectFriendRequest" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParams setObject:selectedUser.friendID forKey:@"friend_id"];
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *compOp){
          
          [_loadingView hide];
          NSDictionary *mainDict = [compOp responseJSON];
          NSLog(@"main Dictionary :%@",mainDict);
          NSNumber *flag = [mainDict objectForKey:@"flag"];
          
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               selectedUser.RelationshipStatus = @"0";
               [self FetchFriendList];
          }
          
     }onError:^(NSError *error){
          
     }];
     [engine enqueueOperation:op];
}

#pragma mark TextFields
-(void)textFieldDidEndEditing:(UITextField *)textField
{
     [searchField resignFirstResponder];
}
-(IBAction)ChangedEditing:(id)sender{
     [arrFriendImage removeAllObjects];
     
     if (searchField.text.length <= 0) {
          [self FetchFriendList];
     }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     [searchField resignFirstResponder];
     return YES;
}

#pragma mark -
#pragma mark Chating

-(void)ChatWithFriend:(id)sender{
     
     UIButton *chatBtn = (UIButton *)sender;
     UserProfile *tempUser = [friendsList objectAtIndex:chatBtn.tag];
     
     MessageThreads *tempThread = [[MessageThreads alloc] init];
     tempThread.displayName = tempUser.display_name;
     tempThread.profileImage = tempUser.profile_image;
     tempThread.userId = tempUser.friendID;
     tempThread.threadId = tempUser.chat_threadID;
     
     ConversationVC *conver = [[ConversationVC alloc] initWithThread:tempThread];
     conver.headerTitle = @"Messages";
     [self.navigationController pushViewController:conver animated:YES];
}

#pragma mark -
#pragma mark UnFriend

-(void) transferPoints :(id)sender{
     UIButton *tempBtn = (UIButton *)sender;
     UserProfile *tempUser = [friendsList objectAtIndex:tempBtn.tag];
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     delegate.transferPointsEmail = tempUser.email;
     [[NavigationHandler getInstance] MoveToTransferPoints];
}

-(void)DeleteFriend{
     
     
     [_loadingView showInView:self.view withTitle:loadingTitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"deleteFriend" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParams setObject:selectedUser.friendID forKey:@"friend_id"];
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *compOp){
          
          [_loadingView hide];
          NSDictionary *mainDict = [compOp responseJSON];
          NSLog(@"main Dictionary :%@",[compOp responseString]);
          NSNumber *flag = [mainDict objectForKey:@"flag"];
          
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               selectedUser.RelationshipStatus = @"0";
               selectedUser.isSelected = false;
               
               [self FetchFriendList];
               [friendsTable reloadData];
               
               NSUInteger index = [friendsList count];
               if (index == 0) {
                    noFriendLbl.hidden = false;
               } else if(index > 0){
                    noFriendLbl.hidden = true;
               }
          }
          
          
     }onError:^(NSError *error){
          
     }];
     
     [engine enqueueOperation:op];
}

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

-(void)setLanguageForScreen {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          
          
          // Frnd Mode PopUp Settings
          
          [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlow.png"] forState:UIControlStateNormal];
          [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowEnglish.png"] forState:UIControlStateNormal];
          [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlow.png"] forState:UIControlStateNormal];
          [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlow.png"] forState:UIControlStateNormal];
          
          
          _friendsLbl.text = FRIENDS_BTN;
          loadingTitle = Loading;
          noFriendLbl.text = @"You have no friend.";
          
          UIColor *color = [UIColor whiteColor];
          searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search a Friends" attributes:@{NSForegroundColorAttributeName: color}];
          [backbtn setTitle:BACK_BTN forState:UIControlStateNormal];
          [GoBtn setTitle:@"Search" forState:UIControlStateNormal];
          [mainBackBtn setTitle:BACK_BTN forState:UIControlStateNormal];
     }
     else if(languageCode == 1 ) {
          
          _friendsLbl.text = FRIENDS_BTN_1;
          loadingTitle = Loading_1;
          noFriendLbl.text = @"لا يوجد لديك صديق.      ";
          [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlowArabic.png"] forState:UIControlStateNormal];
          [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowArabic.png"] forState:UIControlStateNormal];
          [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlowarabic.png"] forState:UIControlStateNormal];
          [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowarabic.png"] forState:UIControlStateNormal];
          UIColor *color = [UIColor whiteColor];
          searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"بحث صديق" attributes:@{NSForegroundColorAttributeName: color}];
          searchField.textAlignment = NSTextAlignmentRight;
          [backbtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [GoBtn setTitle:GO_1 forState:UIControlStateNormal];
          [mainBackBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
     }
     
     
     
     else if(languageCode == 2) {
          
          [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlowSpanish.png"] forState:UIControlStateNormal];
          [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowSpanish.png"] forState:UIControlStateNormal];
          [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlowSpanish.png"] forState:UIControlStateNormal];
          [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowSpanish.png"] forState:UIControlStateNormal];
          
          
          _friendsLbl.text = FRIENDS_BTN_2;
          loadingTitle = Loading_2;
          noFriendLbl.text = @"No tienes amigo.";
          
          UIColor *color = [UIColor whiteColor];
          searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Rechercher un ami" attributes:@{NSForegroundColorAttributeName: color}];
          [backbtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [GoBtn setTitle:GO_2 forState:UIControlStateNormal];
          [mainBackBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
     }
     
     
     else if(languageCode == 3) {
          
          [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlowFrench.png"] forState:UIControlStateNormal];
          [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowFrench.png"] forState:UIControlStateNormal];
          [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlowFrench.png"] forState:UIControlStateNormal];
          [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowFrench.png"] forState:UIControlStateNormal];
          
          
          _friendsLbl.text = FRIENDS_BTN_3;
          loadingTitle = Loading_3;
          noFriendLbl.text = @"Vous n'avez pas d'ami";
          UIColor *color = [UIColor whiteColor];
          searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search For Friends" attributes:@{NSForegroundColorAttributeName: color}];
          
          [backbtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [GoBtn setTitle:GO_3 forState:UIControlStateNormal];
          [mainBackBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
     }
     
     else if(languageCode == 4) {
          
          
          [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlowPortuguese.png"] forState:UIControlStateNormal];
          [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowPortuguese.png"] forState:UIControlStateNormal];
          [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlowportuguese.png"] forState:UIControlStateNormal];
          [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowportuguese.png"] forState:UIControlStateNormal];
          _friendsLbl.text = FRIENDS_BTN_4;
          loadingTitle = Loading_4;
          noFriendLbl.text = @"Você não tem nenhum amigo";
          UIColor *color = [UIColor whiteColor];
          searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"desafio" attributes:@{NSForegroundColorAttributeName: color}];
          [backbtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [GoBtn setTitle:GO_4 forState:UIControlStateNormal];
          [mainBackBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
     }
     
}
- (IBAction)mainBackPressed:(id)sender {
     [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark -
#pragma mark New UI

- (IBAction)PerformLeftUserAction:(id)sender {
     CGRect btnFrame = _fmFriendButton.frame;
     UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
     UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
     blurEffectView.frame = self.view.frame;
     blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     blurEffectView.tag = 499;
     [self.view addSubview:blurEffectView];
     
     if(isSearched)
     {
//          NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
//          languageCode = [language intValue];
//          NSString *suffix = @"";
//          if(languageCode == 0 ) {
//               
//               [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGems.png"] forState:UIControlStateNormal];
//               [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsEnglish.png"] forState:UIControlStateNormal];
//               [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chat.png"] forState:UIControlStateNormal];
//               [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowEnglish.png"] forState:UIControlStateNormal];
//               
//          }else if(languageCode == 1 ) {
//               [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsArabic.png"] forState:UIControlStateNormal];
//               [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsArabic.png"] forState:UIControlStateNormal];
//               [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chatarabic.png"] forState:UIControlStateNormal];
//               [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowArabic.png"] forState:UIControlStateNormal];
//               
//               
//          }else if(languageCode == 2 ) {
//               
//               [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsSpanish.png"] forState:UIControlStateNormal];
//               [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsSpanish.png"] forState:UIControlStateNormal];
//               [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatSpanish.png"] forState:UIControlStateNormal];
//               [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowSpanish.png"] forState:UIControlStateNormal];
//               
//          }else if(languageCode == 3 ) {
//               [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsFrench.png"] forState:UIControlStateNormal];
//               [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsFrench.png"] forState:UIControlStateNormal];
//               [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatFrench.png"] forState:UIControlStateNormal];
//                              [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowFrench.png"] forState:UIControlStateNormal];
//               
//               
//          }else if(languageCode == 4 ) {
//               [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsPortuguese.png"] forState:UIControlStateNormal];
//               [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsPortuguese.png"] forState:UIControlStateNormal];
//               [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatPortuguese.png"] forState:UIControlStateNormal];
//                [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowportuguese.png"] forState:UIControlStateNormal];
//               
//               
//          }
          
          
          
          
          
          
          //          [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGems.png"] forState:UIControlStateNormal];
          //          [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsEnglish.png"] forState:UIControlStateNormal];
          //          [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chat.png"] forState:UIControlStateNormal];
          _challengeForGems.enabled = NO;
          _challengeForPoints.enabled = NO;
          _fmChatBtn.enabled = NO;
          //         _challengeForGems.hidden = YES;
          //         _challengeForPoints.hidden = YES;
          //          _fmChatBtn.hidden = YES;
     }
     else
     {
          
          
//          NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
//          languageCode = [language intValue];
//          NSString *suffix = @"";
//          if(languageCode == 0 ) {
//               
//               [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlow.png"] forState:UIControlStateNormal];
//               [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowEnglish.png"] forState:UIControlStateNormal];
//               [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlow.png"] forState:UIControlStateNormal];
//               
//          }else if(languageCode == 1 ) {
//               [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlowArabic.png"] forState:UIControlStateNormal];
//               [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowArabic.png"] forState:UIControlStateNormal];
//               [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlowarabic.png"] forState:UIControlStateNormal];
//               
//               
//               
//          }else if(languageCode == 2 ) {
//               
//               [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlowSpanish.png"] forState:UIControlStateNormal];
//               [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowSpanish.png"] forState:UIControlStateNormal];
//               [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlowSpanish.png"] forState:UIControlStateNormal];
//               
//          }else if(languageCode == 3 ) {
//               [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlowFrench.png"] forState:UIControlStateNormal];
//               [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowFrench.png"] forState:UIControlStateNormal];
//               [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlowFrench.png"] forState:UIControlStateNormal];
//               
//               
//          }else if(languageCode == 4 ) {
//               [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlowPortuguese.png"] forState:UIControlStateNormal];
//               [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowPortuguese.png"] forState:UIControlStateNormal];
//               [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlowportuguese.png"] forState:UIControlStateNormal];
//               
//               
//          }
          
          
          
          
          _challengeForGems.enabled = YES;
          _challengeForPoints.enabled = YES;
          _fmChatBtn.enabled = YES;
          //          _challengeForGems.hidden = NO;
          //          _challengeForPoints.hidden = NO;
          //          _fmChatBtn.hidden = NO;
     }
     CATransition *transition = [CATransition animation];
     transition.duration = 0.3;
     transition.type = kCATransitionPush; //choose your animation
     transition.subtype = kCATransitionFromBottom;
     [_friendModView.layer addAnimation:transition forKey:nil];
     _friendModView.hidden = false;
     [self.view addSubview:_friendModView];
     
     UIButton *senderBtn = (UIButton*)sender;
     
     selectedUser = [friendsList objectAtIndex:senderBtn.tag];
     
     _friendPopUpImg.image = [UIImage imageNamed:@""];
     _friendPopUpImg.imageURL = [NSURL URLWithString:selectedUser.profile_image];
     NSURL *url = [NSURL URLWithString:selectedUser.profile_image];
     [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
     
     [_friendPopUpImg roundImageCorner];
     _friendPopUpImg.layer.borderColor = [[UIColor whiteColor] CGColor];
     _friendPopUpImg.layer.borderWidth = 2.0;
     _friendPopUpImg.layer.masksToBounds = YES;
     
     _friendNamePopUp.text = selectedUser.display_name;
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     int status = [[NSString stringWithFormat:@"%@",selectedUser.RelationshipStatus] intValue];
     // Changes below done by obaid
     switch (status) {
          // Case 0 : for add friend
          case 0:
               if(languageCode == 0 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chat.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGems.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsEnglish.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"Add.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
               }else if(languageCode == 1 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chatarabic.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsArabic.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsArabic.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"AddArabic.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
               }else if(languageCode == 2 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatSpanish.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsSpanish.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsSpanish.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"AddSpanish.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
               }else if(languageCode == 3 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatFrench.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsFrench.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsFrench.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"AddFrench.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
               }else if(languageCode == 4 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chatportuguese.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsPortuguese.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsPortuguese.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"AddPortuguese.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
               }
               
               break;
               
               //case 1 : for already friend
          case 1:
               if(languageCode == 0 ) {
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlow.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowEnglish.png"] forState:UIControlStateNormal];
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlow.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlow.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = YES;
                    _challengeForPoints.enabled = YES;
                    _fmChatBtn.enabled = YES;
                    _fmFriendButton.enabled = YES;
               }else if(languageCode == 1 ) {
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlowArabic.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowArabic.png"] forState:UIControlStateNormal];
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlowarabic.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowarabic.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = YES;
                    _challengeForPoints.enabled = YES;
                    _fmChatBtn.enabled = YES;
                    _fmFriendButton.enabled = YES;
                    
               }else if(languageCode == 2 ) {
                    
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlowSpanish.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowSpanish.png"] forState:UIControlStateNormal];
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlowSpanish.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowSpanish.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = YES;
                    _challengeForPoints.enabled = YES;
                    _fmChatBtn.enabled = YES;
                    _fmFriendButton.enabled = YES;
                    
               }else if(languageCode == 3 ) {
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlowFrench.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowFrench.png"] forState:UIControlStateNormal];
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlowFrench.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowFrench.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = YES;
                    _challengeForPoints.enabled = YES;
                    _fmChatBtn.enabled = YES;
                    _fmFriendButton.enabled = YES;

               }else if(languageCode == 4 ) {
                    
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsGlowPortuguese.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsGlowPortuguese.png"] forState:UIControlStateNormal];
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlowportuguese.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowportuguese.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = YES;
                    _challengeForPoints.enabled = YES;
                    _fmChatBtn.enabled = YES;
                    _fmFriendButton.enabled = YES;
                    
               }
               break;
               // case 2: friend request received
          case 2:
               if(languageCode == 0 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chat.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGems.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsEnglish.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendRequest.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
                    _fmFriendButton.enabled = YES;
               }else if(languageCode == 1 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chatarabic.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsArabic.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsArabic.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendRequestArabic.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
                    _fmFriendButton.enabled = YES;
               }else if(languageCode == 2 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatSpanish.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsSpanish.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsSpanish.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendRequestSpanish.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
                    _fmFriendButton.enabled = YES;
               }else if(languageCode == 3 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatFrench.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsFrench.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsFrench.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendRequestFrench.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
                    _fmFriendButton.enabled = YES;
               }else if(languageCode == 4 ) {
                    
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chatportuguese.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsPortuguese.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsPortuguese.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendRequestPortuguese.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
                    _fmFriendButton.enabled = YES;
                    
               }
               
               break;
               // case 3: friend request sent
          case 3:
               
               if(languageCode == 0 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chat.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGems.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsEnglish.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"RequestSentEnglish.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
                    _fmFriendButton.enabled = NO;
               }else if(languageCode == 1 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chatarabic.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsArabic.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsArabic.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"RequestSentArabic.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
                    _fmFriendButton.enabled = NO;
               }else if(languageCode == 2 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatSpanish.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsSpanish.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsSpanish.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"RequestSentSpanish.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
                    _fmFriendButton.enabled = NO;
               }else if(languageCode == 3 ) {
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatFrench.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsFrench.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsFrench.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"RequestSentFrench.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
                    _fmFriendButton.enabled = NO;
               }else if(languageCode == 4 ) {
                    
                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chatportuguese.png"] forState:UIControlStateNormal];
                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsPortuguese.png"] forState:UIControlStateNormal];
                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsPortuguese.png"] forState:UIControlStateNormal];
                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"RequestSentPortuguese.png"] forState:UIControlStateNormal];
                    _challengeForGems.enabled = NO;
                    _challengeForPoints.enabled = NO;
                    _fmChatBtn.enabled = NO;
                    _fmFriendButton.enabled = NO;
                    
               }
            


               break;
          default:
                              break;
               
               
               
     }
//          case 0:
//                 if(languageCode == 0 ) {
//                 }else if(languageCode == 1 ) {
//                 }else if(languageCode == 2 ) {
//                 }else if(languageCode == 3 ) {
//                 }else if(languageCode == 4 ) {
//                 }
//               
////               if(languageCode == 0 ) {
////                    
////                    //add friends
////                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chat.png"] forState:UIControlStateNormal];
////                    _fmChatBtn.enabled = false;
////                    //
////                    //                    [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
////                    _fmChallengeNowBtn.enabled = false;
////                    
////                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"Add.png"] forState:UIControlStateNormal];
////                    _fmFriendButton.enabled = true;
////                    
////                    btnFrame.size.width = 85;
////                    _fmFriendButton.frame = btnFrame;
////                    
////                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGems.png"] forState:UIControlStateNormal];
////                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsEnglish.png"] forState:UIControlStateNormal];
////                    _challengeForGems.enabled = NO;
////                    _challengeForPoints.enabled = NO;
////                    _fmChatBtn.enabled = NO;
////                    
////               }else if(languageCode == 1 ) {
////                    
////                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chatarabic.png"] forState:UIControlStateNormal];
////                    _fmChatBtn.enabled = false;
////                    //
////                    //                    [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
////                    _fmChallengeNowBtn.enabled = false;
////                    
////                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"AddArabic.png"] forState:UIControlStateNormal];
////                    _fmFriendButton.enabled = true;
////                    btnFrame.size.width = 85;
////                    _fmFriendButton.frame = btnFrame;
////                    
////                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsArabic.png"] forState:UIControlStateNormal];
////                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsArabic.png"] forState:UIControlStateNormal];
////                    _challengeForGems.enabled = NO;
////                    _challengeForPoints.enabled = NO;
////                    _fmChatBtn.enabled = NO;
////               }else if(languageCode == 2 ) {
////                    
////                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatSpanish.png"] forState:UIControlStateNormal];
////                    _fmChatBtn.enabled = false;
////                    //
//////                                        [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
////                    _fmChallengeNowBtn.enabled = false;
////                    
////                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"AddSpanish.png"] forState:UIControlStateNormal];
////                    _fmFriendButton.enabled = true;
////                    
////                    btnFrame.size.width = 85;
////                    _fmFriendButton.frame = btnFrame;
////                    
////                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsSpanish.png"] forState:UIControlStateNormal];
////                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsSpanish.png"] forState:UIControlStateNormal];
////                    _challengeForGems.enabled = NO;
////                    _challengeForPoints.enabled = NO;
////                    _fmChatBtn.enabled = NO;
////                    
////               }else if(languageCode == 3 ) {
////                    
////                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatFrench.png"] forState:UIControlStateNormal];
////                    _fmChatBtn.enabled = false;
////                    //
////                    //                    [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
////                    _fmChallengeNowBtn.enabled = false;
////                    
////                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"AddFrench.png"] forState:UIControlStateNormal];
////                    _fmFriendButton.enabled = true;
////                    
////                    btnFrame.size.width = 85;
////                    _fmFriendButton.frame = btnFrame;
////                    
////                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsFrench.png"] forState:UIControlStateNormal];
////                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsFrench.png"] forState:UIControlStateNormal];
////                    _challengeForGems.enabled = NO;
////                    _challengeForPoints.enabled = NO;
////                    _fmChatBtn.enabled = NO;
////                    
////               }else if(languageCode == 4 ) {
////                    
////                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chatportuguese.png"] forState:UIControlStateNormal];
////                    _fmChatBtn.enabled = false;
////                    //
////                    //                    [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
////                    _fmChallengeNowBtn.enabled = false;
////                    
////                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"AddPortuguese.png"] forState:UIControlStateNormal];
////                    _fmFriendButton.enabled = true;
////                    
////                    btnFrame.size.width = 85;
////                    _fmFriendButton.frame = btnFrame;
////                    
////                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsPortuguese.png"] forState:UIControlStateNormal];
////                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsPortuguese.png"] forState:UIControlStateNormal];
////                    _challengeForGems.enabled = NO;
////                    _challengeForPoints.enabled = NO;
////                    _fmChatBtn.enabled = NO;
////                    
////               }
//               
//              break;
//          case 2:
//               
//               if(languageCode == 0 ) {
//                    
//                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chat.png"] forState:UIControlStateNormal];
//                    _fmChatBtn.enabled = false;
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendRequest.png"] forState:UIControlStateNormal];
//                    _fmFriendButton.enabled = true;
//                    _challengeForGems.enabled = NO;
//                    _challengeForPoints.enabled = NO;
//                    _fmChatBtn.enabled = NO;
//                    //add friends
//                    
//               }else if(languageCode == 1 ) {
//                    
//                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatArabic.png"] forState:UIControlStateNormal];
//                    _fmChatBtn.enabled = false;
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendRequestArabic.png"] forState:UIControlStateNormal];
//                    _fmFriendButton.enabled = true;
//                    _challengeForGems.enabled = NO;
//                    _challengeForPoints.enabled = NO;
//                    _fmChatBtn.enabled = NO;
//                    
//                    
//               }else if(languageCode == 2 ) {
//                    
//                    
//                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatSpanish.png"] forState:UIControlStateNormal];
//                    _fmChatBtn.enabled = false;
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendRequestSpanish.png"] forState:UIControlStateNormal];
//                    _fmFriendButton.enabled = true;
//                    _challengeForGems.enabled = NO;
//                    _challengeForPoints.enabled = NO;
//                    _fmChatBtn.enabled = NO;
//                    
//               }else if(languageCode == 3 ) {
//                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatFrench.png"] forState:UIControlStateNormal];
//                    _fmChatBtn.enabled = false;
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendRequestFrench.png"] forState:UIControlStateNormal];
//                    _fmFriendButton.enabled = true;
//                    _challengeForGems.enabled = NO;
//                    _challengeForPoints.enabled = NO;
//                    _fmChatBtn.enabled = NO;
//                    
//               }else if(languageCode == 4 ) {
//                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chatportuguese.png"] forState:UIControlStateNormal];
//                    _fmChatBtn.enabled = false;
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendRequestPortuguese.png"] forState:UIControlStateNormal];
//                    _fmFriendButton.enabled = true;
//                    _challengeForGems.enabled = NO;
//                    _challengeForPoints.enabled = NO;
//                    _fmChatBtn.enabled = NO;
//                    
//                    
//               }
//               
//               
//               
//               
//               
//               
//               // add or reject Friend
//               
//               
//               //               [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
//               //               _fmChallengeNowBtn.enabled = false;
//               
//               btnFrame.size.width = 95;
//               _fmFriendButton.frame = btnFrame;
//             
//               
//               break;
//          case 1:
//               
//               
//               
//               if(languageCode == 0 ) {
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"AddedFriendsGlow.png"] forState:UIControlStateNormal];
//                    
//                    
//                    
//                    //add friends
//                    
//               }else if(languageCode == 1 ) {
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowArabic.png"] forState:UIControlStateNormal];
//                    
//                    
//                    
//               }else if(languageCode == 2 ) {
//                    
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowSpanish.png"] forState:UIControlStateNormal];
//                    
//               }else if(languageCode == 3 ) {
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowFrench.png"] forState:UIControlStateNormal];
//                    
//               }else if(languageCode == 4 ) {
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"FriendsGlowportuguese.png"] forState:UIControlStateNormal];
//                    
//               }
//               
//               
//               
//               
//               // Friend
//               //               [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatGlow.png"] forState:UIControlStateNormal];
//               //               _fmChatBtn.enabled = true;
//               
//               //               [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenowglow.png"] forState:UIControlStateNormal];
//               //               _fmChallengeNowBtn.enabled = true;
//               //
//               
//               _fmFriendButton.enabled = true;
//               
//               btnFrame.size.width = 75;
//               _fmFriendButton.frame = btnFrame;
//               
//               
//               break;
//          case 3:
//               
//               
//               
//               // last commit here
//               
//               
//               
//               if(languageCode == 0 ) {
//                    
//                    //add friends
//                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chat.png"] forState:UIControlStateNormal];
//                    _fmChatBtn.enabled = false;
//                    //
//                    //                    [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
//                    _fmChallengeNowBtn.enabled = false;
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"RequestSent.png"] forState:UIControlStateNormal];
//                    _fmFriendButton.enabled = false;
//                    
//                    btnFrame.size.width = 95;
//                    _fmFriendButton.frame = btnFrame;
//                    
//                    
//                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGems.png"] forState:UIControlStateNormal];
//                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsEnglish.png"] forState:UIControlStateNormal];
//                    _challengeForGems.enabled = NO;
//                    _challengeForPoints.enabled = NO;
//                    _fmChatBtn.enabled = NO;
//                    
//               }else if(languageCode == 1 ) {
//                    
//                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chatarabic.png"] forState:UIControlStateNormal];
//                    _fmChatBtn.enabled = false;
//                    //
//                    //                    [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
//                    _fmChallengeNowBtn.enabled = false;
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"RequestSentArabic.png"] forState:UIControlStateNormal];
//                    _fmFriendButton.enabled = false;
//                    
//                    btnFrame.size.width = 95;
//                    _fmFriendButton.frame = btnFrame;
//                    
//                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsArabic.png"] forState:UIControlStateNormal];
//                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsArabic.png"] forState:UIControlStateNormal];
//                    _challengeForGems.enabled = NO;
//                    _challengeForPoints.enabled = NO;
//                    _fmChatBtn.enabled = NO;
//                    
//               }else if(languageCode == 2 ) {
//                    
//                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatSpanish.png"] forState:UIControlStateNormal];
//                    _fmChatBtn.enabled = false;
//                    //
//                    //                    [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
//                    _fmChallengeNowBtn.enabled = false;
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"RequestSentSpanish.png"] forState:UIControlStateNormal];
//                    _fmFriendButton.enabled = false;
//                    
//                    btnFrame.size.width = 95;
//                    _fmFriendButton.frame = btnFrame;
//                    
//                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsSpanish.png"] forState:UIControlStateNormal];
//                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsSpanish.png"] forState:UIControlStateNormal];
//                    _challengeForGems.enabled = NO;
//                    _challengeForPoints.enabled = NO;
//                    _fmChatBtn.enabled = NO;
//                    
//               }else if(languageCode == 3 ) {
//                    
//                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"ChatFrench.png"] forState:UIControlStateNormal];
//                    _fmChatBtn.enabled = false;
//                    //
//                    //                    [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
//                    _fmChallengeNowBtn.enabled = false;
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"RequestSentFrench.png"] forState:UIControlStateNormal];
//                    _fmFriendButton.enabled = false;
//                    
//                    btnFrame.size.width = 95;
//                    _fmFriendButton.frame = btnFrame;
//                    
//                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsFrench.png"] forState:UIControlStateNormal];
//                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsFrench.png"] forState:UIControlStateNormal];
//                    _challengeForGems.enabled = NO;
//                    _challengeForPoints.enabled = NO;
//                    _fmChatBtn.enabled = NO;
//                    
//               }else if(languageCode == 4 ) {
//                    
//                    [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chatportuguese.png"] forState:UIControlStateNormal];
//                    _fmChatBtn.enabled = false;
//                    //
//                    //                    [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
//                    _fmChallengeNowBtn.enabled = false;
//                    
//                    [_fmFriendButton setBackgroundImage:[UIImage imageNamed:@"RequestSentPortuguese.png"] forState:UIControlStateNormal];
//                    _fmFriendButton.enabled = false;
//                    
//                    btnFrame.size.width = 95;
//                    _fmFriendButton.frame = btnFrame;
//                    
//                    [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGemsPortuguese.png"] forState:UIControlStateNormal];
//                    [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsPortuguese.png"] forState:UIControlStateNormal];
//                    _challengeForGems.enabled = NO;
//                    _challengeForPoints.enabled = NO;
//                    _fmChatBtn.enabled = NO;
//               }
//               
//               
//               
//               
//               
//               
//               
//               
//               
//               
//               
//               
//               
//               //               [_fmChallengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
//               //               _fmChallengeNowBtn.enabled = false;
//               //request sent
//               
//               //               [_fmChatBtn setBackgroundImage:[UIImage imageNamed:@"Chat.png"] forState:UIControlStateNormal];
//               //               _fmChatBtn.enabled = false;
//               //
//               //
//               //
//               //
//               //               [_challengeForGems setBackgroundImage:[UIImage imageNamed:@"ForGems.png"] forState:UIControlStateNormal];
//               //               [_challengeForPoints setBackgroundImage:[UIImage imageNamed:@"ForPointsEnglish.png"] forState:UIControlStateNormal];
//               
//          
//               
//               break;
//               
//          default:
//               break;
//     }
}



- (IBAction)fmchallengepointspressed:(id)sender {
     
     [[NSUserDefaults standardUserDefaults] setObject:@"points" forKey:@"requestType"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
     del.friendToBeChalleneged = selectedUser;
     del.requestType = @"points";
     [self.tabBarController setSelectedIndex:0];
}

- (IBAction)fmChatBtnPressed:(id)sender {
     MessageThreads *tempThread = [[MessageThreads alloc] init];
     tempThread.displayName = selectedUser.display_name;
     tempThread.profileImage = selectedUser.profile_image;
     tempThread.userId = selectedUser.friendID;
     int chatThreadID = [selectedUser.chat_threadID intValue];
     tempThread.threadId = [NSString stringWithFormat:@"%d",chatThreadID];
     ConversationVC *conver = [[ConversationVC alloc] initWithThread:tempThread];
     conver.headerTitle = @"Messages";
     [self.tabBarController.tabBar setHidden:true];
     [self.navigationController pushViewController:conver animated:YES];
     
}

- (IBAction)fmChallenegeGemsPressed:(id)sender {
     
     [[NSUserDefaults standardUserDefaults] setObject:@"gems" forKey:@"requestType"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
     del.friendToBeChalleneged = selectedUser;
     del.requestType = @"gems";
     [self.tabBarController setSelectedIndex:0];
     
     
}
- (IBAction)fmChallengeNowBtnPressed:(id)sender {
     
     AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
     del.friendToBeChalleneged = selectedUser;
     
     [self.tabBarController setSelectedIndex:0];
     
}
- (IBAction)fmFriendButtonPressed:(id)sender {
     
     int status = [[NSString stringWithFormat:@"%@",selectedUser.RelationshipStatus] intValue];
     
     if(status == 0) {
          [self SendFriendRequest];
     }
     else if(status == 2){
          [self.view addSubview:_friendActionView];
          NSString *friendActionStr = [NSString stringWithFormat:@"%@ sent you friend request.",selectedUser.display_name];
          _friendActionText.text = friendActionStr;
          _friendActionTitle.text = @"Friend Request";
          
          [_friendActionAcceptBtn setTitle:@"Accept" forState:UIControlStateNormal];
          [_friendActionRejectBtn setTitle:@"Reject" forState:UIControlStateNormal];
          
          _friendActionImg.imageURL = [NSURL URLWithString:selectedUser.profile_image];
          NSURL *url = [NSURL URLWithString:selectedUser.profile_image];
          [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
     }
     else if(status == 1) {
          [self.view addSubview:_friendActionView];
          NSString *friendActionStr = [NSString stringWithFormat:@"Are you sure you want to unfriend %@?",selectedUser.display_name];
          _friendActionText.text = friendActionStr;
          _friendActionTitle.text = @"Delete Friend";
          
          [_friendActionAcceptBtn setTitle:@"Delete" forState:UIControlStateNormal];
          [_friendActionRejectBtn setTitle:@"Cancel" forState:UIControlStateNormal];
          
          _friendActionImg.imageURL = [NSURL URLWithString:selectedUser.profile_image];
          NSURL *url = [NSURL URLWithString:selectedUser.profile_image];
          [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
          
     }
     
}
- (IBAction)friendModCanelBtnPressed:(id)sender {
     
     UIView *effectView = [self.view viewWithTag:499];
     [effectView removeFromSuperview];
     
     CATransition *transition = [CATransition animation];
     transition.duration = 0.3;
     transition.type = kCATransitionPush; //choose your animation
     transition.subtype = kCATransitionFromTop;
     [_friendModView.layer addAnimation:transition forKey:nil];
     _friendModView.hidden = true;
     [_friendModView removeFromSuperview];
}
- (IBAction)friendActionRejectBtnPressed:(id)sender {
     [self friendModCanelBtnPressed:nil];
     [_friendActionView removeFromSuperview];
     
     int status = [[NSString stringWithFormat:@"%@",selectedUser.RelationshipStatus] intValue];
     
     if(status == 2) {
          [self AcceptRejectRequest];
     }
     else if(status == 1) {
          [self DeleteFriend];
     }
}

- (IBAction)friendActionAcceptBtnPressed:(id)sender {
     [self friendModCanelBtnPressed:nil];
     [_friendActionView removeFromSuperview];
     
     int status = [[NSString stringWithFormat:@"%@",selectedUser.RelationshipStatus] intValue];
     
     if(status == 2) {
          [self AcceptFriendRequest];
     }
     else if(status == 1) {
          [self DeleteFriend];
     }
}

- (IBAction)friendActionQuit:(id)sender {
     [_friendActionView removeFromSuperview];
}

#pragma mark -
#pragma pull to refresh

- (void)setupRefreshControl
{
     
     UITableViewController *tableViewController = [[UITableViewController alloc] init];
     tableViewController.tableView = friendsTable;
     
     self.refreshControl = [[UIRefreshControl alloc] init];
     [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
     tableViewController.refreshControl = self.refreshControl;
}

- (void)refresh:(id)sender
{
     [self FetchFriendList];
}

- (void)viewWillAppear:(BOOL)animated {
     
     
     [super viewWillAppear:animated];
     
     tapper = [[UITapGestureRecognizer alloc]
               initWithTarget:self action:@selector(handleSingleTap:)];
     
     tapper.cancelsTouchesInView = NO;
     [self setLanguageForScreen];
     [self.tabBarController.tabBar setHidden:false];
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     if(delegate.isFriendRequest) {
          delegate.isFriendRequest = true;
          [self FetchFriendList];
     }
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender

{
     
     [self.view endEditing:YES];
     
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
     if ([touch.view isDescendantOfView:friendsTable]) {
          
          // Don't let selections of auto-complete entries fire the
          // gesture recognizer
          return YES;
     }
     
     return YES;
}

@end