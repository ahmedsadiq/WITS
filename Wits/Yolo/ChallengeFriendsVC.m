//
//  ChallengeFriendsVC.m
//  Yolo
//
//  Created by Nisar Ahmad on 30/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "ChallengeFriendsVC.h"
#import "MKNetworkKit.h"
#import "SharedManager.h"
#import "Utils.h"
#import "FriendsCC.h"
#import "RightBarVC.h"
#import "ChallengeVC.h"
#import "NavigationHandler.h"
#import "UIImageView+RoundImage.h"
#import "SocketIOPacket.h"
#import "AlertMessage.h"

@implementation ChallengeFriendsVC

- (id)initWithTopic_ID:(NSString *)_receivedID andSubTopic:(NSString *)_subTopic
{
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
          self = [super initWithNibName:@"ChallengeFriendsVC_iPad" bundle:nil];
     else
          self = [super initWithNibName:@"ChallengeFriendsVC" bundle:nil];
     
     
     if (self) {
          // Custom initialization
          
          topic_ID = _receivedID;
          subTopic = _subTopic;
     }
     return self;
}

- (IBAction)mainBack:(id)sender {
     
     [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark =======================


- (void)viewDidLoad
{
     [super viewDidLoad];
     currentIndex = 0;
     // Do any additional setup after loading the view from its nib.
     UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
     searchField.leftView = paddingView;
     searchField.leftViewMode = UITextFieldViewModeAlways;
     [self setLanguageForScreen];
     
     //     if (IS_IPAD) {
     //          if (languageCode== 1) {
     //               searchimg.frame = CGRectMake(122, 99, 617, 40);
     //               searchField.frame = CGRectMake(102, 67, 640, 56);
     //               GoBtn.frame = CGRectMake(20, 67, 101, 56);
     //          }else{
     //               searchField.frame= CGRectMake(20, 67, 630, 56);
     //               searchimg.frame = CGRectMake(20, 99, 728, 40);
     //               GoBtn.frame = CGRectMake(647, 67, 101, 56);
     //          }
     //     }else{
     //          if (languageCode== 1) {
     //               searchimg.frame= CGRectMake(70, 43, 240, 36);
     //               searchField.frame= CGRectMake(70, 43, 240, 36);
     //               GoBtn.frame = CGRectMake(14, 43, 60, 36);
     //          }else{
     //               searchimg.frame = CGRectMake(10, 43, 240, 36);
     //               searchField.frame= CGRectMake(14, 43, 240, 36);
     //               GoBtn.frame = CGRectMake(254, 43, 60, 36);
     //          }
     //     }
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
     loadView = [[LoadingView alloc] init];
     challengeArray = [[NSMutableArray alloc] init];
     
     NSUInteger index = [challengeArray count];
     if (index == 0) {
          noFriendsLbl.hidden = false;
     } else if(index > 0){
          noFriendsLbl.hidden = true;
     }
     
     
     if ([SharedManager getInstance].isFriendListSelected){
          
          [challengeArray addObject:[SharedManager getInstance].friendProfile];
          [challengeTbl reloadData];
     }
     else
          [self FetchChallenges];
     
     
}

-(IBAction)ShowRightMenu:(id)sender{
     
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}

-(IBAction)sendSearchCall:(id)sender{
     
     [searchField resignFirstResponder];
     if (searchField.text.length != 0) {
          NSLog(@"%@",challengeArray);
          NSPredicate * predicate = [NSPredicate predicateWithFormat:@"display_name contains[cd]%@", searchField.text];
          NSArray *results = [challengeArray filteredArrayUsingPredicate:predicate];
          challengeArray = [[NSMutableArray alloc] initWithArray:results];
          [challengeTbl reloadData];
     }
     
     else{
          if ([SharedManager getInstance].isFriendListSelected){
               
               if ([challengeArray count]>0)
                    [challengeArray removeAllObjects];
               
               [challengeArray addObject:[SharedManager getInstance].friendProfile];
               [challengeTbl reloadData];
               NSUInteger index = [challengeArray count];
               if (index == 0) {
                    noFriendsLbl.hidden = false;
               } else if(index > 0){
                    noFriendsLbl.hidden = true;
               }
          }
          else
               [self FetchChallenges];
     }
}

- (IBAction)quitGame:(id)sender {
     
     [loadView hide];
     
     NSString *requestType = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"requestType"];
     
     NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",challengeID,@"challenge_id",requestType,@"request_type", nil];
     [sharedManager sendEvent:@"cancelChallenge" andParameters:registerDictionary];
     [self.navigationController popToRootViewControllerAnimated:false];
}

- (IBAction)RefreshPressed:(id)sender {
     
     [self FetchChallenges];
}

#pragma mark ------------------------------------
#pragma mark Fetch Challenges

-(void)FetchChallenges{
     
     [loadView showInView:self.view withTitle:loadingTitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     
     [postParams setObject:@"showFriendsForChellenge" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
  

     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *compOperation){
          
          [loadView hide];
          
          NSDictionary *mainDict = [compOperation responseJSON];
          NSNumber *flag = [mainDict objectForKey:@"flag"];
          
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               
               if ([challengeArray count]>0)
                    [challengeArray removeAllObjects];
               
               
               NSArray *dataArray = [mainDict objectForKey:@"data"];
               for(NSDictionary *dict in dataArray)
               {
                    UserProfile *userProfile = [[UserProfile alloc] init];
                    [userProfile SetValuesFromDictionary:dict];
                    [challengeArray addObject:userProfile];
               }
               
               NSUInteger index = [challengeArray count];
               if (index == 0) {
                    noFriendsLbl.hidden = false;
               } else if(index > 0){
                    noFriendsLbl.hidden = true;
               }
               
               [challengeTbl reloadData];
               
          }
          else
          {
               NSString *messageStr = [mainDict objectForKey:@"message"];
               
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    
                    title = @"Error";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    
                    title = @"خطأ";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    
                    title = @"Erreur";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    
                    title = @"Error";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    
                    title = @"Erro";
                    cancel = CANCEL_4;
               }
               
               [AlertMessage showAlertWithMessage:messageStr  andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               /*
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:messageStr delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alert show];*/
               
          }
          
     }onError:^(NSError *error){
          [loadView hide];
          
          noFriendsLbl.hidden = false;
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
          
          [AlertMessage showAlertWithMessage:emailMsg  andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          /*
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network Unavailable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
           [alert show];*/
     }];
     
     [engine enqueueOperation:op];
     
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     float returnValue;
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
     {
          returnValue = 340.0f;
     }
     else
     {
          returnValue = 140.0f;
     }
     return returnValue;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     int rows = ([challengeArray count]/2);
     if([challengeArray count]%2  == 1) {
          rows++;
     }
     if([challengeArray count] == 1) {
          rows = 1;
     }
     return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     /*FriendsCC *cell;
     currentIndex = (indexPath.row*2);
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendsCC_iPad" owner:self options:nil];
          cell = [nib objectAtIndex:0];
     }
     else{
          NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FriendsCC" owner:self options:nil];
          cell = [nib objectAtIndex:0];
     }
     UserProfile *_user = [challengeArray objectAtIndex:currentIndex];
     cell.leftUserImg.imageURL = [NSURL URLWithString:_user.profile_image];
     NSURL *url = [NSURL URLWithString:_user.profile_image];
     [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
     cell.leftUserName.text = _user.display_name;
     
     if ([_user onlineStatusValue]== 1) {
          cell.leftUserFrndStatus.image = [UIImage imageNamed:@"online_icon.png"];
          cell.leftUserActionBtn.enabled = YES;
          
     }else if ([_user onlineStatusValue]== 0){
          
          cell.leftUserFrndStatus.image = [UIImage imageNamed:@"offline_icon.png"];
          cell.leftUserActionBtn.enabled = NO;
          [cell.rightUserActionBtn setBackgroundImage:[UIImage imageNamed:@"disableBar.png"] forState:UIControlStateNormal];
     }
     
     cell.leftUserActionBtn.tag = currentIndex;
     
     [cell.leftUserActionBtn addTarget:self action:@selector(PerformChallengeActions:) forControlEvents:UIControlEventTouchUpInside];
     
     currentIndex++;
     if(currentIndex < challengeArray.count) {
          UserProfile *_user2 = [challengeArray objectAtIndex:currentIndex];
          cell.rightUserImg.imageURL = [NSURL URLWithString:_user2.profile_image];
          NSURL *url2 = [NSURL URLWithString:_user2.profile_image];
          [[AsyncImageLoader sharedLoader] loadImageWithURL:url2];
          cell.rightUserName.text = _user2.display_name;
          
          cell.rightUserActionBtn.tag = currentIndex;
          
          [cell.rightUserActionBtn addTarget:self action:@selector(PerformChallengeActions:) forControlEvents:UIControlEventTouchUpInside];
          
          currentIndex++;
          
          if ([_user2 onlineStatusValue]== 1) {
               cell.rightUserFrndStatus.image = [UIImage imageNamed:@"online_icon.png"];
               
          }else if ([_user2 onlineStatusValue]== 0){
               
               cell.rightUserFrndStatus.image = [UIImage imageNamed:@"offline_icon.png"];
               cell.rightUserActionBtn.enabled = NO;
               [cell.rightUserActionBtn setBackgroundImage:[UIImage imageNamed:@"disableBar.png"] forState:UIControlStateNormal];
          }
     }
     else {
          cell.rightUserActionBtn.enabled = false;
          cell.rightUserFrndStatus.hidden = true;
          cell.rightUserImg.hidden = true;
          cell.rightUserName.hidden = true;
          cell.rightUserVerified.hidden = true;
          cell.rightOverlayView.hidden = true;
     }
     
     
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     return cell;*/
     
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
     UserProfile *_user = [challengeArray objectAtIndex:currentIndex];
     cell.leftUserImg.imageURL = [NSURL URLWithString:_user.profile_image];
     NSURL *url = [NSURL URLWithString:_user.profile_image];
     [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
     cell.leftUserName.text = _user.display_name;
     cell.leftUserActionBtn.tag = currentIndex;
     [cell.leftUserActionBtn addTarget:self action:@selector(PerformChallengeActions:) forControlEvents:UIControlEventTouchUpInside];
     
     if ([_user onlineStatusValue]== 1) {
          cell.leftUserActionBtn.enabled = YES;
          
     }else if ([_user onlineStatusValue]== 0){
          
          cell.leftUserActionBtn.enabled = NO;
     }
     NSString * stat = _user.RelationshipStatus ;
     int status = [[NSString stringWithFormat:@"%@",stat] intValue];
     if(status){
            [cell.leftUserVerified setImage:[UIImage imageNamed:@""]];
           [cell.rightUserVerified setImage:[UIImage imageNamed:@""]];
     }
     currentIndex++;
     if(currentIndex < challengeArray.count) {
          UserProfile *_user2 = [challengeArray objectAtIndex:currentIndex];
          cell.rightUserImg.imageURL = [NSURL URLWithString:_user2.profile_image];
          NSURL *url2 = [NSURL URLWithString:_user2.profile_image];
          [[AsyncImageLoader sharedLoader] loadImageWithURL:url2];
          cell.rightUserName.text = _user2.display_name;
          
          cell.rightUserActionBtn.tag = currentIndex;
          [cell.rightUserActionBtn addTarget:self action:@selector(PerformChallengeActions:) forControlEvents:UIControlEventTouchUpInside];
          
          if ([_user2 onlineStatusValue]== 1) {
               cell.rightUserActionBtn.enabled = YES;
               
          }else if ([_user2 onlineStatusValue]== 0){
               
               cell.rightUserActionBtn.enabled = NO;
          }
          
          currentIndex++;
     }
     else {
          cell.rightUserActionBtn.enabled = false;
          cell.rightUserFrndStatus.hidden = true;
          cell.rightUserImg.hidden = true;
          cell.rightUserName.hidden = true;
          cell.rightUserVerified.hidden = true;
          cell.rightOverlayView.hidden = true;
     }
     cell.selectionStyle = NAN;
     [cell setBackgroundColor:[UIColor clearColor]];
     [cell.contentView setBackgroundColor:[UIColor clearColor]];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
     return cell;
     
     
     
}



#pragma mark - TableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
}


#pragma mark TextFields
-(void)textFieldDidEndEditing:(UITextField *)textField
{
     [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     
     [searchField resignFirstResponder];
     return YES;
}
-(IBAction)ChangedEditing:(id)sender{
     if (searchField.text.length >= 3) {
          
          NSPredicate * predicate = [NSPredicate predicateWithFormat:@"display_name contains[cd]%@", searchField.text];
          
          NSArray *results = [challengeArray filteredArrayUsingPredicate:predicate];
          challengeArray = [[NSMutableArray alloc] initWithArray:results];
          [challengeTbl reloadData];
     }
     if (searchField.text.length <= 0) {
          [self FetchChallenges];
     }
     
}


#pragma mark -----------
#pragma mark Status Bg


-(UIImage *)SetStatusImage:(UserProfile *)_user{
     
     int status = [[NSString stringWithFormat:@"%@",_user.RelationshipStatus] intValue];
     UIImage *statusImage;
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          switch (status) {
               case 1:
                    statusImage = [UIImage imageNamed:@"btn_pink_iPad.png"];
                    statusStr = @"Challenge";
                    if (languageCode == 0) {
                         _user.status =@"Challenge";
                    }else if (languageCode == 1){
                         _user.status = @"تحدي صديق";
                    }else if (languageCode == 2){
                         _user.status = @"Défiez un ami";
                    }else if (languageCode == 3){
                         _user.status = @"esafio";
                    }else if (languageCode == 4){
                         _user.status = @"Desafie um amigo";
                    }
                    
                    
                    break;
               case 2:
                    statusStr = @"acceptChallenge";
                    statusImage = [UIImage imageNamed:@"btn_yellow_iPad.png"];
                    _user.status = @"Accept Challenge";
                    break;
               case 3:
                    statusStr = @"sendChallenge";
                    statusImage = [UIImage imageNamed:@"btn_blue_iPad.png"];
                    _user.status = @"Challenge Sent";
                    break;
               default:
                    break;
          }
     }
     else{
          
          switch (status) {
               case 1:
                    statusStr= @"Challenge";
                    statusImage = [UIImage imageNamed:@"btn_pink.png"];
                    if (languageCode == 0) {
                         _user.status =@"Challenge";
                    }else if (languageCode == 1){
                         _user.status = @"تحدي صديق";
                    }else if (languageCode == 2){
                         _user.status = @"Défiez un ami";
                    }else if (languageCode == 3){
                         _user.status = @"esafio";
                    }else if (languageCode == 4){
                         _user.status = @"Desafie um amigo";
                    }
                    
                    break;
               case 2:
                    statusImage = [UIImage imageNamed:@"btn_yellow.png"];
                    _user.status = @"Accept Challenge";
                    statusStr = @"acceptChallenge";
                    break;
               case 3:
                    statusImage = [UIImage imageNamed:@"btn_blue.png"];
                    _user.status = @"Challenge Sent";
                    statusStr = @"sendChallenge";
                    break;
               default:
                    break;
          }
     }
     return statusImage;
}

#pragma mark -
#pragma makr Challange Your Friend

-(void)PerformChallengeActions:(id)sender{
     
     UIButton *selectedBtn = (UIButton *)sender;
     currentSelectedIndex = (int)selectedBtn.tag;
     UserProfile *_tempUser = [challengeArray objectAtIndex:currentSelectedIndex];
     NSString *status = _tempUser.status;
     statusStr = @"Challenge";
     
     opponentProfileImageView.imageURL = [NSURL URLWithString:_tempUser.profile_image];
     NSURL *url = [NSURL URLWithString:_tempUser.profile_image];
     [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
     [opponentProfileImageView roundImageCorner];
     
     if ([statusStr isEqualToString:@"Challenge"]) {
          [statusView setImage:[UIImage imageNamed:@"online_icon.png"]];
          UserProfile *_tempUser = [challengeArray objectAtIndex:currentSelectedIndex];
          
          [self SendChallengeToYourFriend:_tempUser];
     }
}

#pragma mark ----------------
#pragma mark Send Challenge

-(void)SendChallengeToYourFriend:(UserProfile *)_user{
     eventId = 0;
     
     timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
     
     opponentProfileImageView.imageURL = [NSURL URLWithString:_user.profile_image];
     NSURL *url = [NSURL URLWithString:_user.profile_image];
     [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
     searchingTxt.text = _user.display_name;
     
     [opponentProfileImageView roundImageCorner];
     [loadView showInView:self.view withTitle:loadingTitle];
     _selectedUser = _user;
     
     [self connectToSocket];
}

- (void)increaseTimerCount
{
     if (!isOpponentFound){
          timeSinceTimer++;
          _loaderIndex++;
          if(_loaderIndex == 5) {
               _loaderIndex = 1;
          }
          for(int i = 1; i<5; i++) {
               UIImageView *dot = (UIImageView*)[_searchingLoaderView viewWithTag:i];
               if(i == _loaderIndex) {
                    dot.image = [UIImage imageNamed:@"dotglow.png"];
               }
               else {
                    dot.image = [UIImage imageNamed:@"dotblack.png"];
               }
          }
     }
     if(timeSinceTimer == 160) {
          if(!isOpponentFound) {
               [timer invalidate];
               timer = nil;
               
               [searchingView removeFromSuperview];
               [self.tabBarController.tabBar setHidden:false];
               [SocketManager getInstance].socketdelegate = nil;
               
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    emailMsg = @"Something went wrong.";
                    title = @"Error";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    emailMsg = @"لقد حصل خطأ ما";
                    title = @"خطأ";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    emailMsg = @"Erreur: Quelque chose s\'est mal passé!";
                    title = @"Erreur";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    emailMsg = @"Algo salió mal!";
                    title = @"Error";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    emailMsg = @"Alguma coisa deu errado!";
                    title = @"Erro";
                    cancel = CANCEL_4;
               }
               [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               
          }
          else {
               [timer invalidate];
               timer = nil;
          }
          timeSinceTimer = 0;
     }
     
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
     CABasicAnimation* rotationAnimation;
     rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
     rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
     rotationAnimation.duration = duration;
     rotationAnimation.cumulative = YES;
     rotationAnimation.repeatCount = repeat;
     
     [spinner.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)displayNameAndImage{
     
     if([SharedManager getInstance]._userProfile.profile_image.length > 3) {
          senderNameLbl.text = [SharedManager getInstance]._userProfile.display_name;
          
          MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
          
          MKNetworkOperation *op = [engine operationWithURLString:[SharedManager getInstance]._userProfile.profile_image params:Nil httpMethod:@"GET"];
          
          [op onCompletion:^(MKNetworkOperation *completedOperation) {
               
               [senderProfileImageView setImage:[completedOperation responseImage]];
               [senderProfileImageView roundImageCorner];
               
          } onError:^(NSError* error) {
               
               /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Cannot Fetch Image" message:@"Network Unreachable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];*/
               
          }];
          
          [engine enqueueOperation:op];
     }
     /*
      NSURL *imageURL = [NSURL URLWithString:[SharedManager getInstance]._userProfile.profile_image];
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      UIImage *_image = [UIImage imageWithData:imageData];
      [senderProfileImageView setImage:_image];
      [senderProfileImageView roundImageCorner];
      */
}

#pragma mark -
#pragma mark -

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

#pragma mark Socket Communication Methods
- (void) connectToSocket {
     
     sharedManager = [SocketManager getInstance];
     sharedManager.socketdelegate = nil;
     sharedManager.socketdelegate = self;
     [sharedManager openSockets];
}

#pragma mark Challenge
- (void) tick:(NSTimer *) timer {
     //[[NavigationHandler getInstance] MoveToChallenge:_challenge];
}
#pragma mark Socket Manager Delegate Methods
-(void)DataRevieved:(SocketIOPacket *)packet {
     
     NSString *requestType = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"requestType"];
     NSString *title;
     if([packet.name isEqualToString:@"connected"])
     {
          eventId = 0;
//          NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id", nil];
//          [sharedManager sendEvent:@"register" andParameters:registerDictionary];
          isSocketConnected = true;
          NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          int languageCode = [language intValue];
          
          NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",_selectedUser.friendID,@"friend_id",topic_ID,@"type",subTopic,@"type_id",language,@"language",requestType,@"challenge_type", nil];
          [sharedManager sendEvent:@"sendChallenge" andParameters:registerDictionary];

     }
     
     else if([packet.name isEqualToString:@"register"])
     {
          eventId = 1;
          NSArray* args = packet.args;
          NSDictionary* arg = args[0];
          
          NSString *isVerified = [arg objectForKey:@"msg"];
          if([isVerified isEqualToString:@"verified"] ){
               isSocketConnected = true;
               NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               int languageCode = [language intValue];
               
               NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",_selectedUser.friendID,@"friend_id",topic_ID,@"type",subTopic,@"type_id",language,@"language",requestType,@"challenge_type", nil];
               [sharedManager sendEvent:@"sendChallenge" andParameters:registerDictionary];
          }
     }
     else if([packet.name isEqualToString:@"sendChallenge"])
     {//test
          
          eventId = 2;
          [loadView hide];
          NSArray* args = packet.args;
          NSDictionary *json = args[0];
          
          NSDictionary *innerDictionary = [json objectForKey:[SharedManager getInstance].userID];
          NSString *message = [innerDictionary objectForKey:@"message"];
          int intChallengeID = [[innerDictionary objectForKey:@"challenge_id"] intValue];
          challengeID = [NSString stringWithFormat:@"%d",intChallengeID];
          
          opponentProfileImageView.imageURL = [NSURL URLWithString:_selectedUser.profile_image];
          NSURL *url = [NSURL URLWithString:_selectedUser.profile_image];
          [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
          [opponentProfileImageView roundImageCorner];
          
          int flag = [[innerDictionary objectForKey:@"flag"] intValue];
          if(flag == 1) {
               [self displayNameAndImage];
               if(IS_IPHONE_5) {
                    searchingView.frame = CGRectMake(0, 0, 320, 568);
               }
               else if(IS_IPHONE_4) {
                    searchingView.frame = CGRectMake(0, 0, 320, 480);
               }
              [self.tabBarController.tabBar setHidden:true];
               [self.view addSubview:searchingView];
               _loaderIndex = 1;
               
               for(int i = 1; i<5; i++) {
                    UIImageView *dot = (UIImageView*)[_searchingLoaderView viewWithTag:i];
                    if(i == _loaderIndex) {
                         dot.image = [UIImage imageNamed:@"dotglow.png"];
                    }
                    else {
                         dot.image = [UIImage imageNamed:@"dotblack.png"];
                    }
               }
          }
          else {
               
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               if (message == nil) {
                    
                    if (languageCode == 0 ) {
                         emailMsg = @"Check your internet connection setting.";
                         title = @"Error";
                         cancel = CANCEL;
                    } else if(languageCode == 1) {
                         emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
                         title = @"خطأ";
                         cancel = CANCEL_1;
                    }else if (languageCode == 2){
                         emailMsg = @"Quelque chose se est mal passé, réessayez plus tard";
                         title = @"Erreur";
                         cancel = CANCEL_2;
                    }else if (languageCode == 3){
                         emailMsg = @"Algo salió mal, inténtelo más tarde";
                         title = @"Error";
                         cancel = CANCEL_3;
                    }else if (languageCode == 4){
                         emailMsg = @"Algo deu errado, tente novamente mais tarde";
                         title = @"Erro";
                         cancel = CANCEL_4;
                    }
                    
                    [AlertMessage showAlertWithMessage:emailMsg  andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               }else{
                    if (languageCode == 0 ) {
                         emailMsg = @"Check your internet connection setting.";
                         title = @"Error";
                         cancel = CANCEL;
                    } else if(languageCode == 1) {
                         emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
                         title = @"خطأ";
                         cancel = CANCEL_1;
                    }else if (languageCode == 2){
                         emailMsg = @"Quelque chose se est mal passé, réessayez plus tard";
                         title = @"Erreur";
                         cancel = CANCEL_2;
                    }else if (languageCode == 3){
                         emailMsg = @"Algo salió mal, inténtelo más tarde";
                         title = @"Error";
                         cancel = CANCEL_3;
                    }else if (languageCode == 4){
                         emailMsg = @"Algo deu errado, tente novamente mais tarde";
                         title = @"Erro";
                         cancel = CANCEL_4;
                    }
                    
                    
                    [AlertMessage showAlertWithMessage:message  andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               }
               /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error .." message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                
                [alert show];*/
          }
     }
     else if([packet.name isEqualToString:@"acceptChallenge"])
     {
          spinner.hidden = YES;
          NSArray* args = packet.args;
          NSDictionary *json = args[0];
          
          NSDictionary *userDictInner = [json objectForKey:[SharedManager getInstance].userID];
          
          int flag = [[userDictInner objectForKey:@"flag"] intValue];
          if(flag == 1){
               
               [searchingView removeFromSuperview];
               [self.tabBarController.tabBar setHidden:false];
               [timer invalidate];
               timer = nil;
               Challenge *_challenge = [[Challenge alloc] initWithDictionary:userDictInner];
               _challenge.type = topic_ID;
               _challenge.type_ID = subTopic;
               _challenge.challengeID = challengeID;
               isOpponentFound = true;
               
               self.tabBarController.tabBar.hidden = true;
               
               ChallengeVC *challengeTemp = [[ChallengeVC alloc] initWithChallenge:_challenge];
               [self.navigationController pushViewController:challengeTemp animated:YES];
               
               
          }
          else {
               
          }
     }
     else if ([packet.name isEqualToString:@"cancelChallenge"]) {
          
          [sharedManager closeWebSocket];
          [searchingView removeFromSuperview];
          [self.tabBarController.tabBar setHidden:false];
     }
}
-(void)socketDisconnected:(SocketIO *)socket onError:(NSError *)error {
     
     [timer invalidate];
     timer = nil;
     [self.tabBarController.tabBar setHidden:false];
     [searchingView removeFromSuperview];
     [loadView hide];
}
-(void)socketError:(SocketIO *)socket disconnectedWithError:(NSError *)error {
     
     [timer invalidate];
     timer = nil;
     [self.tabBarController.tabBar setHidden:false];
     [searchingView removeFromSuperview];
     [loadView hide];
}
#pragma mark Set Language

-(void)setLanguageForScreen {
     NSString* language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     if (languageCode == 0) {
          
          loadingTitle = Loading;
          noFriendsLbl.text = @"You have no friend.";
          challengesLbl.text =@"Challenge" ;
          searchField.placeholder = @"Search For Challenges";
          [GoBtn setTitle:@"Search" forState:UIControlStateNormal];
          [mainback setTitle:BACK_BTN forState:UIControlStateNormal];
          
     }else if (languageCode == 1){
          
          loadingTitle = Loading_1;
          noFriendsLbl.text = @"لا يوجد لديك صديق.";
          
          challengesLbl.text =@"تحدي صديق";
          searchField.placeholder = @"بحث صديق";
          searchField.textAlignment = NSTextAlignmentRight;
          [GoBtn setTitle:GO_1 forState:UIControlStateNormal];
          [mainback setTitle:BACK_BTN_1 forState:UIControlStateNormal];
     }else if (languageCode == 2){
          
          loadingTitle = Loading_2;
          noFriendsLbl.text = @"No tienes amigo.";
          challengesLbl.text=@"Défiez un ami";
          searchField.placeholder = @"Rechercher un ami";
          [GoBtn setTitle:GO_2 forState:UIControlStateNormal];
          [mainback setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          
     }else if (languageCode == 3){
          
          loadingTitle = Loading_3;
          noFriendsLbl.text = @"Vous n'avez pas d'ami";
          challengesLbl.text =@"esafio";
          searchField.placeholder = @"Search For Challenges";
          [GoBtn setTitle:GO_3 forState:UIControlStateNormal];
          [mainback setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          
     }else if (languageCode == 4){
          
          loadingTitle = Loading_4;
          noFriendsLbl.text = @"Você não tem nenhum amigo";
          challengesLbl.text =@"Desafie um amigo";
          searchField.placeholder = @"desafio";
          [GoBtn setTitle:GO_4 forState:UIControlStateNormal];
          [mainback setTitle:BACK_BTN_4 forState:UIControlStateNormal];
     }
}

@end
