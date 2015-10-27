//
//  HistoryViewController.m
//  Wits
//
//  Created by Mr on 10/11/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "HistoryViewController.h"
#import "RightBarVC.h"
#import "MKNetworkEngine.h"
#import "SharedManager.h"
#import "MKNetworkKit.h"
#import "Utils.h"
#import "History.h"
#import "HistoryCC.h"
#import "HistorySelectedCC.h"
#import "UIImageView+RoundImage.h"
#import "RankingVC.h"
#import "RankingCC.h"
#import "AppDelegate.h"
#import "HelperFunctions.h"
#import "NavigationHandler.h"
#import "AlertMessage.h"
#import "AsyncImageView.h"


@interface HistoryViewController ()
@end

@implementation HistoryViewController
@synthesize isRanking;
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
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     imagesArr = [[NSMutableArray alloc]init];
     rankingBtn.font = [UIFont fontWithName:FONT_NAME size:15];
     historyBtn.font = [UIFont fontWithName:FONT_NAME size:15];
     
     
     NSString *val = [SharedManager getInstance]._userProfile.cashablePoints;
     if ([val intValue] < 0) {
          [SharedManager getInstance]._userProfile.cashablePoints = @"0";
          
     }
     searchPlayerName.text = [SharedManager getInstance]._userProfile.display_name;
     
     [self setLanguageForScreen];
     
     _RankingPinkLine.frame = CGRectMake(0, 88, 159, 5);
     _HistoryPinkLine.frame = CGRectMake(161, 91, 159, 1);
     
     if(IS_IPAD){
         // _RankingPinkLine.frame = CGRectMake(0,138, 384, 6);
          //_HistoryPinkLine.frame = CGRectMake(385, 142, 384, 2);
     }
     else if(IS_IPHONE_4){
          
     }
     if(isRanking) {
          loadView = [[LoadingView alloc] init];
          isRanking = true;
          [self getRanking];
     }
     else {
          [self historyPressed:nil];
     }
     
}
-(void) getRanking {
     
     [loadView showInView:self.view withTitle:loadingtitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"rankingByScore" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *compOperation){
          
          [loadView hide];
          NSDictionary *mainDict = [compOperation responseJSON];
          NSString *messageStr = [mainDict objectForKey:@"message"];
          rankingArray = [mainDict objectForKey:@"ranking"];
          if ([rankingArray count]>0) {
               [self FetchCountryFlagImage];
          }
          else{
               
               language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               languageCode = [language intValue];
               NoRecordLbl.hidden= false;
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
               
               [AlertMessage showAlertWithMessage:emailMsg andTitle:somethingtitle SingleBtn:YES cancelButton:cancel OtherButton:nil];
               /*
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to fetch" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                
                [alert show];*/
          }
          if(isRanking)
          {
               [resultTable reloadData];
          }
     }onError:^(NSError *error){
          
          
          [loadView hide];
          NoRecordLbl.hidden = false;
          language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          languageCode = [language intValue];
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
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:somethingtitle SingleBtn:YES cancelButton:cancel OtherButton:nil];
     }];
     
     [engine enqueueOperation:op];
}
-(void)FetchCountryFlagImage{
     
     for (int i=0; i<[rankingArray count]; i++) {
          
          NSDictionary *tempDict = [rankingArray objectAtIndex:i];
          
          Rank *_rankObj = [[Rank alloc] init];
          _rankObj.displayName = [tempDict objectForKey:@"display_name"];
          
          if ([[SharedManager getInstance] isDownloaded:_rankObj])
               continue;
          
          _rankObj.gender = [tempDict objectForKey:@"gender"];
          _rankObj.cityName = [tempDict objectForKey:@"city_name"];
          _rankObj.countryName = [tempDict objectForKey:@"country_name"];
          _rankObj.countryCode = [tempDict objectForKey:@"country_code"];
          _rankObj.scorePoints = [tempDict objectForKey:@"score_points"];
          _rankObj.profileImage_url = [tempDict objectForKey:@"profile_image"];
          _rankObj.countryImage_url = [tempDict objectForKey:@"country_image"];
          
          _rankObj.isProfileDownloaded = false;
          
          [[SharedManager getInstance].rankingArray addObject:_rankObj];
          
     }
     [resultTable reloadData];
     [[SharedManager getInstance] saveModel];
}
-(void) getHistory {
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParamas = [[NSMutableDictionary alloc] init];
     [postParamas setObject:@"showHistory" forKey:@"method"];
     [postParamas setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParamas setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     
     NSString* languageCode = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     [postParamas setObject:languageCode forKey:@"language"];
     [postParamas setObject:@"karachi/asia" forKey:@"time_zone"];
     [loadView showInView:self.view withTitle:loadingtitle];
     
     MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParamas httpMethod:@"POST"];
     
     [operation onCompletion:^(MKNetworkOperation *completedOper){
          
          [loadView hide];
          NSDictionary *mainDict = [completedOper responseJSON];
          
          NSNumber *flag = [mainDict objectForKey:@"flag"];
          if ([flag isEqualToNumber:[NSNumber numberWithInt:1]]) {
               historyArray = [[NSMutableArray alloc] init];
               
               NSUInteger index = [historyArray count];
               if (index == 0) {
                    NoRecordLbl.hidden = false;
               } else if(index > 0){
                    NoRecordLbl.hidden = true;
               }
               
               NSArray *recivedArray = [mainDict objectForKey:@"data"];
               for(int i=0; i<recivedArray.count; i++)
               {
                    NSDate* datetime = [NSDate date];
                    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; // Prevent adjustment to user's local time zone.
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:SS.SSS'Z'"];
                    NSString* dateTimeInIsoFormatForZuluTimeZone = [dateFormatter stringFromDate:datetime];
                    
                    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    currentServerDate = [[NSDate alloc] init];
                    currentServerDate = [dateFormatter dateFromString:dateTimeInIsoFormatForZuluTimeZone];
                    
                    NSDictionary *tempdict = (NSDictionary*)[recivedArray objectAtIndex:i];
                    History *temp_Obj = [[History alloc] init];
                    temp_Obj.isSelected = false;
                    temp_Obj.game_message = [tempdict objectForKey:@"game_message"];
                    int sizeofMsg = temp_Obj.game_message.length;
                    sizeofMsg = sizeofMsg - 24;
                    temp_Obj.game_message = [temp_Obj.game_message substringToIndex:sizeofMsg];
                    temp_Obj.sub_topic_title = [tempdict objectForKey:@"title"];
                    temp_Obj.opponent_image = [tempdict objectForKey:@"opponent_image"];
                    temp_Obj.opponent_id = [tempdict objectForKey:@"opponent_id"];
                    temp_Obj.contest_id = [tempdict objectForKey:@"contest_id"];
                    temp_Obj.history_date = [tempdict objectForKey:@"history_date"];
                    rematchType = [tempdict objectForKey:@"type"];
                    rematchTypeId = [tempdict objectForKey:@"type_id"];
                    
                    
                    [historyArray addObject:temp_Obj];
                    [imagesArr addObject:temp_Obj.opponent_image];
               }
               if(!isRanking)
               {
                    [resultTable reloadData];
               }
          }
          
     }onError:^(NSError *error){
          
          [loadView hide];
          language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          int languageCode = [language intValue];
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
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:somethingtitle SingleBtn:YES cancelButton:cancel OtherButton:nil];
          //
          /*
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to fetch" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
           
           [alert show];*/
          
     }];
     
     [engine enqueueOperation:operation];
}
- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

- (IBAction)rankingPressed:(id)sender {
     if(languageCode == 0 ) {
          RankingTitleLbl.text = RANKING_BTN;
     }
     else if(languageCode == 1 ) {
          RankingTitleLbl.text = RANKING_BTN_1;
     }
     else if(languageCode == 2) {
          RankingTitleLbl.text = RANKING_BTN_2;
     }
     else if(languageCode == 3) {
          RankingTitleLbl.text = RANKING_BTN_3;
     }
     else if(languageCode == 4) {
          RankingTitleLbl.text = RANKING_BTN_4;
     }
     isRanking = true;
     
     [rankingBtn setBackgroundImage:[UIImage imageNamed:@"tabon.png"] forState:UIControlStateNormal];
     [historyBtn setBackgroundImage:[UIImage imageNamed:@"taboff.png"] forState:UIControlStateNormal];
     
     [rankingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     [historyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     
     if(!rankingArray) {
          [self getRanking];
     }
     else {
          [resultTable reloadData];
     }
}

- (IBAction)historyPressed:(id)sender {
     if(languageCode == 0 ) {
          RankingTitleLbl.text = HISTORY;
     }
     else if(languageCode == 1 ) {
          RankingTitleLbl.text = HISTORY_1;
     }
     else if(languageCode == 2) {
          RankingTitleLbl.text = HISTORY_2;
     }
     else if(languageCode == 3) {
          RankingTitleLbl.text = HISTORY_3;
     }
     else if(languageCode == 4) {
          RankingTitleLbl.text = HISTORY_4;
     }
     isRanking = false;
     
     [rankingBtn setBackgroundImage:[UIImage imageNamed:@"taboff.png"] forState:UIControlStateNormal];
     [historyBtn setBackgroundImage:[UIImage imageNamed:@"tabon.png"] forState:UIControlStateNormal];
     
     [rankingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [historyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     
     if(!historyArray) {
          [self getHistory];
     }
     else {
          [resultTable reloadData];
     }
     [resultTable reloadData];
}

- (IBAction)rightSliderPressed:(id)sender {
     [[RightBarVC getInstance] loadProfileImage];
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}

- (IBAction)backPressed:(id)sender {
     NSArray *viewsToRemove = [resultCard_View subviews];
     for (UIView *v in viewsToRemove) {
          if(v.tag == 20)
          {
               [v removeFromSuperview];
          }
          
     }
     [ResultsView removeFromSuperview];
}


- (IBAction)CloseGemsDialog:(id)sender {
     [GemsDialogView removeFromSuperview];
     
}

- (IBAction)ReturnHomePressed:(id)sender {
     [[NavigationHandler getInstance]NavigateToRoot];
     
}

- (IBAction)Rightbar:(id)sender {
     
     [[RightBarVC getInstance] loadProfileImage];
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}

- (IBAction)quitSearch:(id)sender {
     [GemsDialogView removeFromSuperview];
     [ResultsView removeFromSuperview];
     [searchingView removeFromSuperview];
}

#pragma mark ----------------------
#pragma mark TableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     float returnValue;
     if(!isRanking) {
          if ([[UIScreen mainScreen] bounds].size.height == iPad)
          {
               returnValue =320.0f;
          }
          else
          {
               returnValue = 140.0f;
          }
     }
     else {
          if ([[UIScreen mainScreen] bounds].size.height == iPad)
               returnValue = 320.0f;
          else
               returnValue = 140.0f;
     }
     
     return returnValue;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     
     return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     if(isRanking) {
          
          int rows = ([[SharedManager getInstance].rankingArray count]/2);
          if(rows%2 == 1) {
               rows++;
          }
          return rows;
     }
     else{
          
          int rows = ([historyArray count]/2);
          if(rows%2 == 1) {
               rows++;
          }
          return rows;
     }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     if(isRanking) {
          currentIndex = (indexPath.row*2);
          RankingCC *cell ;
          NoRecordLbl.hidden = true;
          if ([[UIScreen mainScreen] bounds].size.height == iPad) {
               
               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RankingCC_iPad" owner:self options:nil];
               cell = [nib objectAtIndex:0];
          }
          else{
               
               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RankingCC" owner:self options:nil];
               cell = [nib objectAtIndex:0];
          }
          [cell setBackgroundColor:[UIColor clearColor]];
          
          NoRecordLbl.hidden = YES;
          cell.leftTitle.font = [UIFont fontWithName:FONT_NAME size:13];
          

          Rank *_rank = (Rank*)[[SharedManager getInstance].rankingArray objectAtIndex:currentIndex];
          cell.leftTitle.text = [NSString stringWithFormat:@"%@ (%@)",_rank.displayName,_rank.scorePoints];
          NSString  *points = _rank.scorePoints;
          int totalPoints = [points intValue];
          cell.leftSubTitles.text = [self getStatusAccordingToPoints:totalPoints];
          [HelperFunctions setBackgroundColor:cell.leftOverLay];
          
          if(_rank.countryName.length > 1) {
               
               NSString *flag = [_rank.countryName substringToIndex:2];
               flag = [flag uppercaseString];
               if( [_rank.countryName caseInsensitiveCompare:@"Pakistan"] == NSOrderedSame ) {
                    flag = @"PK";
               }
               else if( [_rank.countryName caseInsensitiveCompare:@"Lebanon"] == NSOrderedSame ) {
                    flag = @"LB";
               }
               cell.leftImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",flag]];
               [cell.contentView setBackgroundColor:[UIColor clearColor]];
          }
          //          cell.leftOverLay.tag = currentIndex;
          
          
          MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
          
          MKNetworkOperation *op = [engine operationWithURLString:_rank.profileImage_url params:nil httpMethod:@"GET"];
          
          [op onCompletion:^(MKNetworkOperation *completedOperation) {
               
               [cell.leftImg setImage:[completedOperation responseImage]];
               
               
               
               
          } onError:^(NSError* error) {
          }];
          
          [engine enqueueOperation:op];
          
          currentIndex++;
          if(currentIndex < [SharedManager getInstance].rankingArray.count) {
               Rank *_rank = (Rank*)[[SharedManager getInstance].rankingArray objectAtIndex:currentIndex];
               cell.rightTitle.text = [NSString stringWithFormat:@"%@ (%@)",_rank.displayName,_rank.scorePoints];
               NSString  *points = _rank.scorePoints;
               int totalPoints = [points intValue];
               cell.rightSubTitles.text = [self getStatusAccordingToPoints:totalPoints];
               cell.rightTitle.font = [UIFont fontWithName:FONT_NAME size:13];
               cell.rightSubTitles.font = [UIFont fontWithName:FONT_NAME size:13];

               if(_rank.countryName.length > 1) {
                    
                    NSString *flag = [_rank.countryName substringToIndex:2];
                    flag = [flag uppercaseString];
                    if( [_rank.countryName caseInsensitiveCompare:@"Pakistan"] == NSOrderedSame ) {
                         flag = @"PK";
                    }
                    else if( [_rank.countryName caseInsensitiveCompare:@"Lebanon"] == NSOrderedSame ) {
                         flag = @"LB";
                    }
                    cell.rightImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",flag]];
                    //                    cell.rightOverLay.tag = currentIndex;
                    //                    [HelperFunctions setBackgroundColor:cell.rightOverLay];
                    [cell.contentView setBackgroundColor:[UIColor clearColor]];
               }
               
               MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
               MKNetworkOperation *op = [engine operationWithURLString:_rank.profileImage_url params:nil httpMethod:@"GET"];
               [op onCompletion:^(MKNetworkOperation *completedOperation) {
                    
                    [cell.rightImg setImage:[completedOperation responseImage]];
                    
               } onError:^(NSError* error) {
               }];
               [engine enqueueOperation:op];
               [HelperFunctions setBackgroundColor:cell.rightOverLay];
               currentIndex++;
          }
          else {
               cell.rightImg.hidden = true;
               cell.rightImgThumbnail.hidden = true;
               cell.rightSubTitles.hidden = true;
               cell.rightTitle.hidden = true;
               cell.rightOverLay.hidden = true;
          }
          
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          cell.userInteractionEnabled = true;
          
          [cell.contentView setBackgroundColor:[UIColor clearColor]];
          
          return cell;
     }
     else {
          currentIndexHistory = (indexPath.row*2);
          
          History *tempHistory = [historyArray objectAtIndex:currentIndexHistory];
          HistoryCC *cell ;
          
          if ([[UIScreen mainScreen] bounds].size.height == iPad) {
               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCC_iPad" owner:self options:nil];
               cell = [nib objectAtIndex:0];
          }
          else{
               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCC" owner:self options:nil];
               cell = [nib objectAtIndex:0];
          }
          [cell setBackgroundColor:[UIColor clearColor]];
          NSUInteger index = [historyArray count];
          if (index == 0) {
               NoRecordLbl.hidden = false;
          } else if(index > 0){
               NoRecordLbl.hidden = true;
          }
          
          cell.leftTitle.text = tempHistory.sub_topic_title;
          NSString *messageStr = [NSString stringWithFormat:@"%@%@ ", tempHistory.game_message,[self getTimeDifference:tempHistory.history_date]];
          cell.leftSubTitles.text = messageStr;
                          cell.leftTitle.font = [UIFont fontWithName:FONT_NAME size:13];
                          cell.leftSubTitles.font = [UIFont fontWithName:FONT_NAME size:13];
          
          [HelperFunctions setBackgroundColor:cell.leftOverLay];
          MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
          MKNetworkOperation *op = [engine operationWithURLString:tempHistory.opponent_image params:nil httpMethod:@"GET"];
          [op onCompletion:^(MKNetworkOperation *completedOperation) {
               
               [cell.leftImg setImage:[completedOperation responseImage]];
               
          } onError:^(NSError* error) {
          }];
          [engine enqueueOperation:op];
          currentIndexHistory++;
          
          if(currentIndexHistory < historyArray.count) {
               History *tempHistory = [historyArray objectAtIndex:currentIndexHistory];
               
               cell.rightTitle.text = tempHistory.sub_topic_title;
               NSString *messageStr = [NSString stringWithFormat:@"%@%@ ", tempHistory.game_message,[self getTimeDifference:tempHistory.history_date]];
               cell.rightSubTitles.text = messageStr;
                cell.rightTitle.font = [UIFont fontWithName:FONT_NAME size:13];
               cell.rightSubTitles.font = [UIFont fontWithName:FONT_NAME size:13];
               [HelperFunctions setBackgroundColor:cell.rightOverLay];
               MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
               MKNetworkOperation *op = [engine operationWithURLString:tempHistory.opponent_image params:nil httpMethod:@"GET"];
               [op onCompletion:^(MKNetworkOperation *completedOperation) {
                    
                    [cell.rightImg setImage:[completedOperation responseImage]];
                    
               } onError:^(NSError* error) {
               }];
               [engine enqueueOperation:op];
               currentIndexHistory++;
          }
          else {
               cell.rightImg.hidden = true;
               cell.rightBtn.enabled = false;
               cell.rightSubTitles.hidden = true;
               cell.rightTitle.hidden = true;
               cell.rightOverLay.hidden = true;
               
          }
          
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          cell.userInteractionEnabled = true;
          
          [cell.contentView setBackgroundColor:[UIColor clearColor]];
          return cell;
          
     }
     
     return nil;
}

#pragma mark - TableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
}

-(NSString *) getStatusAccordingToPoints :(int)totalPoints  {
     NSString *subTitle = @"";
     if(totalPoints <= 200) {
          if (languageCode == 0) {
               subTitle = @"Beginner";
          }else if (languageCode == 1){
               subTitle = @"مبتدئ";
          }else if (languageCode == 2){
               subTitle = @"Débutant";
          }else if (languageCode == 3){
               subTitle = @"Debutante";
          }else if (languageCode == 4){
               subTitle = @"Iniciante";
          }
     }
     else if(totalPoints >200 && totalPoints<=500) {
          if (languageCode == 0) {
               subTitle = @"Expert";
          }else if (languageCode == 1){
               subTitle = @"خبير";
          }else if (languageCode == 2){
               subTitle = @"Expert";
          }else if (languageCode == 3){
               subTitle =  @"Experto";
          }else if (languageCode == 4){
               subTitle = @"Expert";
          }
     }
     else if(totalPoints >500 && totalPoints<=1000) {
          if (languageCode == 0) {
               subTitle = @"Advance";
          }else if (languageCode == 1){
               subTitle = @"متقدم";
          }else if (languageCode == 2){
               subTitle = @"Avancé";
          }else if (languageCode == 3){
               subTitle =  @"Avanzado ";
          }else if (languageCode == 4){
               subTitle = @"Avançado";
          }
     }
     else {
          if (languageCode == 0) {
               subTitle = @"Witty";
          }else if (languageCode == 1){
               subTitle = @"ذكي";
          }else if (languageCode == 2){
               subTitle = @"Intelligent";
          }else if (languageCode == 3){
               subTitle =  @"Inteligente ";
          }else if (languageCode == 4){
               subTitle = @"Gênio";
          }
     }
     return subTitle;
}

-(NSString*) getTimeDifference :(NSString*) currentTime {
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     // this is imporant - we set our input date format to match our input string
     // if format doesn't match you'll get nil from your string, so be careful
     NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
     [dateFormatter setTimeZone:timeZone];
     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSDate *messageDate = [[NSDate alloc] init];
     // voila!
     messageDate = [dateFormatter dateFromString:currentTime];
     
     NSString *timeLeft;
     NSInteger seconds = [messageDate timeIntervalSinceDate:currentServerDate];
     
     NSInteger days = (int) (floor(seconds / (3600 * 24)));
     if(days) seconds -= days * 3600 * 24;
     
     NSInteger hours = (int) (floor(seconds / 3600));
     if(hours) seconds -= hours * 3600;
     
     NSInteger minutes = (int) (floor(seconds / 60));
     if(minutes) seconds -= minutes * 60;
     
     if(days) {
          if((long)days*-1 > 1) {
               timeLeft = [NSString stringWithFormat:@"%ld %@", (long)days*-1,days_ago];
          }
          else {
               timeLeft = [NSString stringWithFormat:@"%ld %@", (long)days*-1,days_ago];
          }
     }
     else if(hours) {
          if((long)hours*-1 > 1) {
               timeLeft = [NSString stringWithFormat: @"%ld %@", (long)hours*-1,hours_ago];
          }
          else {
               timeLeft = [NSString stringWithFormat: @"%ld %@", (long)hours*-1,hours_ago];
          }
     }
     else if(minutes) {
          if((long)minutes*-1 > 1) {
               timeLeft = [NSString stringWithFormat: @"%ld %@", (long)minutes*-1,minutes_ago];
          }
          else {
               timeLeft = [NSString stringWithFormat: @"%ld %@", (long)minutes*-1,minutes_ago];
          }
     }
     else if(seconds) {
          if((long)seconds*-1 > 1) {
               timeLeft = [NSString stringWithFormat: @"%ld %@", (long)seconds*-1,seconds_ago];
          }
          else {
               timeLeft = [NSString stringWithFormat: @"%ld %@", (long)seconds*-1,seconds_ago];
          }
     }
     return timeLeft;
}

-(void)resultSelected:(id)sender {
     UIButton *senderBtn = (UIButton*) sender;
     int tag = senderBtn.tag;
     History *historyObj = (History*)[historyArray objectAtIndex:tag];
     [opponent_resultImg setImage:[UIImage imageNamed:@""]];
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     MKNetworkOperation *op = [engine operationWithURLString:historyObj.opponent_image params:nil httpMethod:@"GET"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          [opponent_resultImg setImage:[completedOperation responseImage]];
          [opponent_resultImg roundImageCorner];
          
     } onError:^(NSError* error) {
          
     }];
     
     [engine enqueueOperation:op];
     [self fetchResults:historyObj.contest_id andOpponentID:historyObj.opponent_id];
}
-(void)rankingsSelected:(id)sender {
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          RankingVC *rank = [[RankingVC alloc] initWithNibName:@"RankingVC_iPad" bundle:nil];
          [self.navigationController pushViewController:rank animated:YES];
     }
     else{
          
          RankingVC *rank = [[RankingVC alloc] initWithNibName:@"RankingVC" bundle:nil];
          [self.navigationController pushViewController:rank animated:YES];
     }
}

#pragma mark -
#pragma mark Show Results


-(void)fetchResults :(NSString*) contestID andOpponentID:(NSString*)opponentID{
     [loadView showInView:self.view withTitle:loadingtitle];
     
     MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParamas = [[NSMutableDictionary alloc] init];
     [postParamas setObject:@"gameContestResult" forKey:@"method"];
     [postParamas setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParamas setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParamas setObject:contestID forKey:@"contest_id"];
     [postParamas setObject:opponentID forKey:@"opponent_id"];
     
     contest = contestID;
     MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParamas httpMethod:@"POST"];
     
     [operation onCompletion:^(MKNetworkOperation *completedOper){
          
          [loadView hide];
          [self setUserProfileImage];
          NSDictionary *mainDict = [completedOper responseJSON];
          
          
          NSNumber *flag = [mainDict objectForKey:@"flag"];
          if ([flag isEqualToNumber:[NSNumber numberWithInt:1]]) {
               
               if ([[mainDict objectForKey:@"request_type"] isEqualToString:@"gems"]) {
                    NSString *val = [SharedManager getInstance]._userProfile.cashablePoints;
                    
                    [SharedManager getInstance]._userProfile.cashablePoints = [mainDict objectForKey:@"gems"];
                    if ([val intValue] < 0) {
                         [SharedManager getInstance]._userProfile.cashablePoints = @"0";
                         
                    }
                    resultGameTypeimg.image = [UIImage imageNamed:@"ame1.png"];
                    
               }else if ([[mainDict objectForKey:@"request_type"] isEqualToString:@"points"]){
                    [SharedManager getInstance]._userProfile.totalPoints = [mainDict objectForKey:@"points"];
                    resultGameTypeimg.image = [UIImage imageNamed:@"starg1.png"];
               }
               senderPointsArray = [mainDict objectForKey:opponentID];
               selfPointsArray = [mainDict objectForKey:[SharedManager getInstance].userID];
               
               
               
               if([senderPointsArray count] > [selfPointsArray count])
                    tempVar = (int)[senderPointsArray count];
               else
                    tempVar = (int)[selfPointsArray count];
               
               [self.view addSubview:ResultsView];
               if(IS_IPHONE_4) {
                    ResultsView.frame = CGRectMake(0, 0, 320, 480);
               }
               else if (IS_IPHONE_5) {
                    ResultsView.frame = CGRectMake(0, 0, 320, 568);
               }
               
               [self showResults];
               [self setResultantView];
          }
          
     }onError:^(NSError *error){
          
          [loadView hide];
          
          NSString *emailMsg;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               emailMsg = @"Check your internet connection setting.";
               title = somethingtitle;
               cancel = CANCEL;
          } else if(languageCode == 1) {
               emailMsg = @"يرجى التحقق من إعدادات اتصال الإنترنت الخاصة بك.";
               title = somethingtitle;
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
          
          [AlertMessage showAlertWithMessage:emailMsg andTitle:somethingtitle SingleBtn:YES cancelButton:cancel OtherButton:nil];
     }];
     
     [engine enqueueOperation:operation];
     
}
-(void) setUserProfileImage {
     UIImage *profileImg = [self loadImage];
     if(profileImg) {
          [self_resultImg setImage:profileImg];
          [self_resultImg roundImageCorner];
          self_resultImg.layer.borderColor = [[UIColor blueColor]CGColor];
          self_resultImg.layer.borderWidth = 1.0f;
     }
     else {
          AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
          
          if(delegate.profileImage) {
               [self_resultImg setImage:delegate.profileImage];
               [self_resultImg roundImageCorner];
               //               self_resultImg.layer.borderColor = [[UIColor blueColor]CGColor];
               //               self_resultImg.layer.borderWidth = 1.0f;
               
          }
          else {
               
               MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
               NSString *link = [SharedManager getInstance]._userProfile.profile_image;
               
               MKNetworkOperation *op = [engine operationWithURLString:link params:nil httpMethod:@"GET"];
               
               [op onCompletion:^(MKNetworkOperation *completedOperation) {
                    
                    [self_resultImg setImage:[completedOperation responseImage]];
                    [self_resultImg roundImageCorner];
                    [selfSearchingImage setImage:[completedOperation responseImage]];
                    [selfSearchingImage roundImageCorner];
                    
                    self_resultImg.layer.borderColor = [[UIColor blueColor]CGColor];
                    self_resultImg.layer.borderWidth = 1.0f;
                    delegate.profileImage = [completedOperation responseImage];
                    
               } onError:^(NSError* error) {
                    
                    selfSearchingImage.image =  [UIImage imageNamed:@"Icon_152.png"];
                    self_resultImg.image =  [UIImage imageNamed:@"Icon_152.png"];
                    [self_resultImg roundImageCorner];
                    self_resultImg.layer.borderColor = [[UIColor blueColor]CGColor];
                    self_resultImg.layer.borderWidth = 1.0f;
                    
                    
               }];
               
               [engine enqueueOperation:op];
          }
     }
     
}
-(void)setResultantView{
     
     //    float height = ([receiverPointsArray count]+2)*25;
     float height = (tempVar+2)*25;
     height = 336;
     [resultCard_View setFrame:CGRectMake(resultCard_View.frame.origin.x, resultCard_View.frame.origin.y, resultCard_View.frame.size.width, height)];
     if(IS_IPHONE_4) {
          rescultScrollView.contentSize = CGSizeMake(310, 467);
          resultCard_View.frame = CGRectMake(resultCard_View.frame.origin.x, resultCard_View.frame.origin.y, resultCard_View.frame.size.width, resultCard_View.frame.size.height+36);
     }
     else if (IS_IPAD) {
          [resultCard_View setFrame:CGRectMake(resultCard_View.frame.origin.x, resultCard_View.frame.origin.y, resultCard_View.frame.size.width, height+40)];
     }
}

-(void)showResults{
     if(IS_IPHONE_4) {
          CGRect rect = resultCard_View.frame;
          rescultScrollView.contentSize = CGSizeMake(310, 407);
          resultCard_View.frame = CGRectMake(resultCard_View.frame.origin.x, resultCard_View.frame.origin.y, resultCard_View.frame.size.width, resultCard_View.frame.size.height+30);
          
     }
     int senderTotalPoints = 0;
     int receiverTotalPoints = 0;
     
     int currentY = 0;
     [resultCard_View addSubview:resultTopBar];
     resultTopBar.frame = CGRectMake(0, currentY, 280, 26);
     
     if(IS_IPAD) {
          resultTopBar.frame = CGRectMake(0, currentY, 400, 40);
          currentY = currentY + 40;
     }
     else {
          currentY = currentY + 26;
     }
     
     UIView *horizontalBar = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, 280, 2)];
     if(IS_IPAD) {
          horizontalBar.frame = CGRectMake(0, currentY, 400, 40);
     }
     horizontalBar.backgroundColor = [UIColor whiteColor];
     [resultCard_View addSubview:horizontalBar];
     currentY = currentY + 2;
     [resultCard_View addSubview:resulltSecondLayer];
     if(IS_IPAD) {
          resulltSecondLayer.frame = CGRectMake(0, currentY, 400, 40);
          currentY = currentY+40;
     }
     else {
          resulltSecondLayer.frame = CGRectMake(0, currentY, 280, 26);
          currentY = currentY+26;
     }
     
     UIView *horizontalBar1 = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, 280, 2)];
     horizontalBar1.backgroundColor = [UIColor whiteColor];
     [resultCard_View addSubview:horizontalBar1];
     if (IS_IPAD) {
          horizontalBar1.frame = CGRectMake(0, currentY, 480, 2);
     }
     currentY = currentY+2;
     
     for(int i=0; i<10; i++) {
          
          UIView *roundRow = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, 280, 26)];
          
          roundRow.backgroundColor = [UIColor clearColor];
          if(IS_IPAD) {
               roundRow.frame = CGRectMake(0, currentY, 400, 40);
          }
          
          UILabel *roundNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 26)];
          roundNumber.text = [NSString stringWithFormat:@"%d",i+1];
          roundNumber.textAlignment = NSTextAlignmentCenter;
          roundNumber.textColor = [UIColor whiteColor];
          roundNumber.font = [UIFont fontWithName:FONT_NAME size:16.0f];
          [roundRow addSubview:roundNumber];
          //           cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:13];
          if(IS_IPAD) {
               roundNumber.frame = CGRectMake(0, 0, 133, 40);
               roundNumber.font = [UIFont fontWithName:FONT_NAME size:19.0f];
          }
          
          UIView *verticalBar1 = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 2, 26)];
          verticalBar1.backgroundColor = [UIColor whiteColor];
          [roundRow addSubview:verticalBar1];
          
          if(IS_IPAD) {
               verticalBar1.frame = CGRectMake(133, 0, 2, 40);
          }
          
          UILabel *userWinResult = [[UILabel alloc] initWithFrame:CGRectMake(83, 0, 33, 26)];
          userWinResult.text = @"-";
          userWinResult.textColor = [UIColor whiteColor];
          userWinResult.textAlignment = NSTextAlignmentCenter;
          userWinResult.font = [UIFont fontWithName:FONT_NAME size:16.0f];
          [roundRow addSubview:userWinResult];
          
          if(IS_IPAD) {
               userWinResult.frame = CGRectMake(137, 7, 36, 26);
               userWinResult.font = [UIFont fontWithName:FONT_NAME size:16.0f];
          }
          
          UIView *verticalBar2 = [[UIView alloc] initWithFrame:CGRectMake(113, 0, 2, 26)];
          if(IS_IPAD) {
               verticalBar2.frame = CGRectMake(177, 0, 2, 40);
          }
          verticalBar2.backgroundColor = [UIColor whiteColor];
          [roundRow addSubview:verticalBar2];
          
          NSString *rTime;
          if(i<=selfPointsArray.count-1 ) {
               if(selfPointsArray.count == 0) {
                    rTime = @"-";
               }
               else {
                    rTime= [[selfPointsArray objectAtIndex:i] objectForKey:@"ans_in_seconds"];
               }
               
          }
          else {
               rTime = @"-";
          }
          
          UILabel *userTime = [[UILabel alloc] initWithFrame:CGRectMake(114, 0, 33, 26)];
          userTime.text = rTime;
          userTime.textColor = [UIColor whiteColor];
          userTime.textAlignment = NSTextAlignmentCenter;
          userTime.font = [UIFont fontWithName:FONT_NAME size:16.0f];
          [roundRow addSubview:userTime];
          
          if(IS_IPAD) {
               userTime.frame = CGRectMake(181, 7, 39, 26);
               userTime.font = [UIFont fontWithName:FONT_NAME size:16.0f];
          }
          
          UIView *verticalBar3 = [[UIView alloc] initWithFrame:CGRectMake(147, 0, 2, 26)];
          verticalBar3.backgroundColor = [UIColor whiteColor];
          [roundRow addSubview:verticalBar3];
          
          if(IS_IPAD) {
               verticalBar3.frame = CGRectMake(221, 0, 2, 40);
          }
          
          NSString *rPoints;
          if(i<=selfPointsArray.count-1 ) {
               if(selfPointsArray.count == 0) {
                    userWinResult.text = @"-";
               }
               else {
                    rPoints= [[selfPointsArray objectAtIndex:i] objectForKey:@"earned_points"];
                    if([rPoints intValue] > 0 ) {
                         
                         userWinResult.text = @"✅";
                    }
                    else {
                         UIImageView *cross = [[UIImageView alloc] initWithFrame:CGRectMake(userWinResult.frame.origin.x+5, userWinResult.frame.origin.y+5, userWinResult.frame.size.width-13, userWinResult.frame.size.height-9)];
                         cross.image = [UIImage imageNamed:@"crossred.png"];
                         [roundRow addSubview:cross];
                         //userWinResult.text = @"❎";
                    }
                    receiverTotalPoints += [rPoints intValue];
               }
               
          }
          else {
               rPoints = @"-";
          }
          
          UILabel *userPoints = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 33, 26)];
          userPoints.text = rPoints;
          userPoints.textColor = [UIColor whiteColor];
          userPoints.textAlignment = NSTextAlignmentCenter;
          userPoints.font = [UIFont fontWithName:FONT_NAME size:16.0f];
          [roundRow addSubview:userPoints];
          
          if(IS_IPAD) {
               userPoints.frame = CGRectMake(222, 7, 45, 26);
          }
          
          UIView *verticalBar4 = [[UIView alloc] initWithFrame:CGRectMake(180, 0, 2, 26)];
          verticalBar4.backgroundColor = [UIColor whiteColor];
          [roundRow addSubview:verticalBar4];
          if(IS_IPAD) {
               verticalBar4.frame = CGRectMake(266, 0, 2, 40);
          }
          
          UILabel *opponentWinResult = [[UILabel alloc] initWithFrame:CGRectMake(184, 0, 31, 26)];
          opponentWinResult.text = @"-";
          opponentWinResult.textColor = [UIColor whiteColor];
          opponentWinResult.textAlignment = NSTextAlignmentCenter;
          opponentWinResult.font = [UIFont fontWithName:FONT_NAME size:16.0f];
          [roundRow addSubview:opponentWinResult];
          
          if(IS_IPAD) {
               opponentWinResult.frame = CGRectMake(273, 7, 31, 26);
          }
          
          UIView *verticalBar5 = [[UIView alloc] initWithFrame:CGRectMake(215, 0, 2, 26)];
          verticalBar5.backgroundColor = [UIColor whiteColor];
          [roundRow addSubview:verticalBar5];
          
          if(IS_IPAD) {
               verticalBar5.frame = CGRectMake(310, 0, 2, 40);
          }
          
          NSString *oTime;
          if(i<=senderPointsArray.count-1 ) {
               if(senderPointsArray.count ==0 ){
                    oTime = @"-";
               }
               else {
                    oTime= [[senderPointsArray objectAtIndex:i] objectForKey:@"ans_in_seconds"];
               }
               
          }
          else {
               oTime = @"-";
          }
          
          UILabel *opponentTime = [[UILabel alloc] initWithFrame:CGRectMake(215, 0, 32, 26)];
          opponentTime.text = oTime;
          opponentTime.textColor = [UIColor whiteColor];
          opponentTime.textAlignment = NSTextAlignmentCenter;
          opponentTime.font = [UIFont fontWithName:FONT_NAME size:16.0f];
          [roundRow addSubview:opponentTime];
          
          if(IS_IPAD) {
               opponentTime.frame = CGRectMake(313, 7, 40, 26);
          }
          
          UIView *verticalBar6 = [[UIView alloc] initWithFrame:CGRectMake(247, 0, 2, 26)];
          verticalBar6.backgroundColor = [UIColor whiteColor];
          [roundRow addSubview:verticalBar6];
          
          if(IS_IPAD) {
               verticalBar6.frame = CGRectMake(354, 0, 2, 40);
          }
          
          NSString *oPoints;
          if(i<=senderPointsArray.count-1) {
               if(senderPointsArray.count == 0) {
                    oPoints = @"-";
               }
               else {
                    oPoints= [[senderPointsArray objectAtIndex:i] objectForKey:@"earned_points"];
                    if([oPoints intValue] > 0 ) {
                         opponentWinResult.text = @"✅";
                    }
                    else {
                         UIImageView *cross = [[UIImageView alloc] initWithFrame:CGRectMake(opponentWinResult.frame.origin.x+5, opponentWinResult.frame.origin.y+5, opponentWinResult.frame.size.width-13, opponentWinResult.frame.size.height-9)];
                         cross.image = [UIImage imageNamed:@"crossred.png"];
                         [roundRow addSubview:cross];
                    }
                    senderTotalPoints += [oPoints intValue];
               }
               
          }
          else {
               oPoints = @"-";
          }
          
          UILabel *opponentpoints = [[UILabel alloc] initWithFrame:CGRectMake(249, 0, 30, 26)];
          opponentpoints.text = oPoints;
          opponentpoints.textColor = [UIColor whiteColor];
          opponentpoints.textAlignment = NSTextAlignmentCenter;
          opponentpoints.font = [UIFont fontWithName:FONT_NAME size:16.0f];
          [roundRow addSubview:opponentpoints];
          
          if(IS_IPAD) {
               opponentpoints.frame = CGRectMake(358, 7, 40, 26);
          }
          
          [resultCard_View addSubview:roundRow];
          if(IS_IPAD) {
               currentY=currentY+40;
          }
          else {
               currentY=currentY+26;
          }
          
          UIView *horizontalBar = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, 280, 2)];
          if(IS_IPAD) {
               horizontalBar.frame = CGRectMake(0, currentY, 400, 2);
          }
          horizontalBar.backgroundColor = [UIColor whiteColor];
          [resultCard_View addSubview:horizontalBar];
          currentY = currentY + 2;
     }
     
     [resultCard_View addSubview:resultBottomBar];
     resultBottomBar.frame = CGRectMake(0, currentY, 280, 26);
     if(IS_IPAD) {
          resultBottomBar.frame = CGRectMake(0, currentY, 400, 40);
     }
     
     userTotal.text = [NSString stringWithFormat:@"%i",receiverTotalPoints];
     opponentTotal.text = [NSString stringWithFormat:@"%i",senderTotalPoints];
     
     if (receiverTotalPoints>senderTotalPoints)
     {
          if (languageCode == 0) {
               
               resultLbl.text = YOU_WIN;
          }else if (languageCode == 1){
               
               resultLbl.text = YOU_WIN_1;
               
          }else if (languageCode == 2){
               
               resultLbl.text = YOU_WIN_2;
               
          }else if (languageCode == 3){
               
               resultLbl.text = YOU_WIN_3;
               
          }else if (languageCode == 4){
               
               resultLbl.text = YOU_WIN_4;
               
          }
     }
     else{
          if (receiverTotalPoints<senderTotalPoints)
          {
               if (languageCode == 0) {
                    
                    resultLbl.text = BETTER_LUCK;
                    
               }else if (languageCode == 1){
                    
                    resultLbl.text = BETTER_LUCK_1;
                    
               }else if (languageCode == 2){
                    
                    resultLbl.text = BETTER_LUCK_2;
                    
               }else if (languageCode == 3){
                    
                    resultLbl.text = BETTER_LUCK_3;
                    
               }else if (languageCode == 4){
                    
                    resultLbl.text = BETTER_LUCK_4;
                    
               }
               
          }
          else {
               
               
               if (languageCode == 0) {
                    
                    resultLbl.text = ITS_TIE;
                    
               }else if (languageCode == 1){
                    
                    resultLbl.text = ITS_TIE_1;
                    
               }else if (languageCode == 2){
                    
                    resultLbl.text = ITS_TIE_2;
                    
               }else if (languageCode == 3){
                    
                    resultLbl.text = ITS_TIE_3;
                    
               }else if (languageCode == 4){
                    
                    resultLbl.text = ITS_TIE_4;
                    
               }
               
          }
     }
     
     [resultCard_View addSubview:resultBottomBar];
     resultBottomBar.frame = CGRectMake(0, currentY, 280, 26);
     if(IS_IPAD) {
          resultBottomBar.frame = CGRectMake(0, currentY, 400, 40);
     }
     resultCard_View.hidden = false;
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



- (IBAction)PlayAgainPressed:(id)sender {
     [lblGemsPoints setText:[[SharedManager getInstance] _userProfile].cashablePoints];
     [lblStarsPoints setText:[[SharedManager getInstance] _userProfile].totalPoints];
     
     
     
     if(IS_IPHONE_4){
          GemsDialogView.frame = CGRectMake(0, 0, 320, 480);
     }else if (IS_IPHONE_5){
          GemsDialogView.frame = CGRectMake(0, 0, 320, 568);
     }else if (IS_IPHONE_6){
          GemsDialogView.frame = CGRectMake(0, 0, 375, 667);
     }
     
     if (languageCode == 1) {
          
          willhelpinRanking.textAlignment = UIControlContentHorizontalAlignmentRight;
          willHelpinEarnMoney.textAlignment = UIControlContentHorizontalAlignmentRight;
          
          if (IS_IPAD) {
               
               //               starImage.frame = CGRectMake(439, 246, 60, 53);
               //               gemImage.frame = CGRectMake(447, 309, 51, 53);
               starImage.hidden = YES;
               gemImage.hidden = YES;
               
               starimg2.hidden = NO;
               gemimg2.hidden = NO;
               
          }else{
               starImage.frame = CGRectMake(265, starImage.frame.origin.y+2, 35, 32);
               gemImage.frame = CGRectMake(270, gemImage.frame.origin.y+2 , 25, 25);
               
          }
          
     }else{
          willhelpinRanking.textAlignment = UIControlContentHorizontalAlignmentLeft;
          willHelpinEarnMoney.textAlignment = UIControlContentHorizontalAlignmentLeft;
          
          if (IS_IPAD) {
               starImage.autoresizingMask = UIViewAutoresizingNone;
               starImage.frame = CGRectMake(32, 246, 60, 53);
               gemImage.frame = CGRectMake(37, 309, 51, 53);
          }else{
               starImage.frame = CGRectMake(8, starImage.frame.origin.y+2, 35, 32);
               gemImage.frame = CGRectMake(13, gemImage.frame.origin.y+2 , 25, 25);
               
          }
          
     }
     
     [self.view addSubview:GemsDialogView];
     
     requestType = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"requestType"];
     
     int totalPoints = [[SharedManager getInstance]._userProfile.cashablePoints intValue];
     if (totalPoints <10) {
          buynowlabel.hidden = NO;
          [playwithGemsbtn setBackgroundImage:[UIImage imageNamed:@"disableBar.png"] forState:UIControlStateNormal];
          isDisabled = true;
          
     }else{
          buynowlabel.hidden = YES;
          [playwithGemsbtn setBackgroundImage:[UIImage imageNamed:@"pinkBar.png"] forState:UIControlStateNormal];
          isDisabled = false;
          
     }
     
     
     /*
      NSString *message;
      NSString *title;
      
      NSString *cancel;
      if (languageCode == 0 ) {
      title = Friend_Not_Available;
      message = @"Unfortunately, your friend can't be reached at the moment. Please try later.";
      cancel = CANCEL;
      }else if (languageCode == 1){
      title = Friend_Not_Availabl_1;
      message = @"لسوء الحظ، لا يمكن أن يتم التوصل صديقك في الوقت الراهن. يرجى المحاولة لاحقا.";
      cancel = CANCEL_1;
      }else if (languageCode == 2){
      title = Friend_Not_Availabl_2;
      message = @"Malheureusement, votre ami ne peut pas être atteint pour le moment. Se il vous plaît réessayer plus tard.";
      cancel = CANCEL_2;
      }else if (languageCode == 3){
      title = Friend_Not_Availabl_3;
      message = @"Por desgracia, su amigo no puede ser alcanzado por el momento. Por favor, intente más tarde.";
      cancel = CANCEL_3;
      }else if (languageCode == 4){
      title = Friend_Not_Availabl_4;
      message = @"Infelizmente, o seu amigo não pode ser alcançado no momento. Por favor, tente mais tarde.";
      cancel = CANCEL_4;
      }
      
      [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
      [[NavigationHandler getInstance]NavigateToRoot]; */
}


- (IBAction)PlaywitStars:(id)sender {
     
     requestType = @"points";
     [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     [loadView showInView:self.view withTitle:loadingtitle];
     
     [self connectToSocket];
     
     //     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     //     languageCode = [language intValue];
     //
     //     NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",_challenge.contest_ID,@"contest_id",language,@"language",requestType,@"challenge_type", nil];
     //
     //     [sharedManager sendEvent:@"reMatch" andParameters:registerDictionary];
     
     
}

- (IBAction)PlaywithGems:(id)sender {
     
     requestType = @"gems";
     [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     int totalPoints = [[SharedManager getInstance]._userProfile.cashablePoints intValue];
     if (totalPoints < 10) {
          [[NavigationHandler getInstance]MoveToStore];
     }else{
          
          [loadView showInView:self.view withTitle:loadingtitle];
          [self connectToSocket];
          
          //
          //          language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          //          languageCode = [language intValue];
          //
          //          NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",contest,@"contest_id",language,@"language",requestType,@"challenge_type", nil];
          //
          //
          //          [sharedManager sendEvent:@"reMatch" andParameters:registerDictionary];
     }
}



#pragma mark Socket Communication Methods
- (void) connectToSocket {
     sharedManager = [SocketManager getInstance];
     sharedManager.socketdelegate = nil;
     sharedManager.socketdelegate = self;
     [sharedManager openSockets];
}

#pragma mark Socket Manager Delegate Methods
-(void)DataRevieved:(SocketIOPacket *)packet {
     
     requestType = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"requestType"];
     if([packet.name isEqualToString:@"connected"])
     {
          // NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id", nil];
          
          NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",contest,@"contest_id",language,@"language",requestType, @"challenge_type", nil];
          
          [sharedManager sendEvent:@"reMatch" andParameters:registerDictionary];
          
     }
     else if([packet.name isEqualToString:@"reMatch"])
     {
          NSArray* args = packet.args;
          NSDictionary *json = args[0];
          
          NSDictionary *userDictInner = [json objectForKey:[SharedManager getInstance].userID];
          
          NSString *chId =[userDictInner objectForKey:@"challenge_id"];
          
          [[NSUserDefaults standardUserDefaults] setObject:chId forKey:@"ChallengeId"];
          [[NSUserDefaults standardUserDefaults] synchronize];
          
          
          int flag = [[userDictInner objectForKey:@"flag"] intValue];
          if(flag == 0){
               //opponent gone away
               [loadView hide];
               
               NSString *message;
               NSString *title;
               
               if (languageCode == 0 ) {
                    title = Friend_Not_Available;
                    message = @"Unfortunately, your friend can't be reached at the moment. Please try later.";
               }else if (languageCode == 1){
                    title = Friend_Not_Availabl_1;
                    message = @"لسوء الحظ، لا يمكن أن يتم التوصل صديقك في الوقت الراهن. يرجى المحاولة لاحقا.";
               }else if (languageCode == 2){
                    title = Friend_Not_Availabl_2;
                    message = @"Malheureusement, votre ami ne peut pas être atteint pour le moment. Se il vous plaît réessayer plus tard.";
               }else if (languageCode == 3){
                    title = Friend_Not_Availabl_3;
                    message = @"Por desgracia, su amigo no puede ser alcanzado por el momento. Por favor, intente más tarde.";
               }else if (languageCode == 4){
                    title = Friend_Not_Availabl_4;
                    message = @"Infelizmente, o seu amigo não pode ser alcançado no momento. Por favor, tente mais tarde.";
               }
               
               [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:@"Cancel" OtherButton:nil];
               
               [resultCard_View removeFromSuperview];
          }
          else{
               if(IS_IPHONE_5) {
                    searchingView.frame = CGRectMake(0, 0, 320, 568);
               }
               else if(IS_IPHONE_4) {
                    searchingView.frame = CGRectMake(0, 0, 320, 480);
               }
               
               if (languageCode == 0) {
                    searchOpponentName.text = @"Searching opponent...";
               }else if(languageCode == 1){
                    searchOpponentName.text = @"االبحث عن الخصم...";
               }else if (languageCode == 2 ){
                    searchOpponentName.text = @"Recherche d\'un adversaire...";
               }else if (languageCode == 3){
                    searchOpponentName.text = @"La búsqueda de un oponente...";
               }else if (languageCode == 4){
                    searchOpponentName.text = @"Procurando um adversário...";
               }
               [loadView hide];
               
               [self.view addSubview:searchingView];
               [self runSpinAnimationOnView:spinner duration:3600 rotations:0.5 repeat:0];
               
               
          }
          
     }
     else if([packet.name isEqualToString:@"acceptChallenge"])
     {
          
          NSArray* args = packet.args;
          NSDictionary *json = args[0];
          
          NSDictionary *userDictInner = [json objectForKey:[SharedManager getInstance].userID];
          
          int flag = [[userDictInner objectForKey:@"flag"] intValue];
          if(flag == 1){
               
               [searchingView removeFromSuperview];
               Challenge *_challenge1 = [[Challenge alloc] initWithDictionary:userDictInner];
               _challenge1.type = rematchType;
               _challenge1.type_ID = rematchTypeId;
               
               _challenge.opponent_ID = [userDictInner objectForKey:@"oId"];
               _challenge.opponent_points = [userDictInner objectForKey:@"points"];
               _challenge.contest_ID = [userDictInner objectForKey:@"contestId"];
               
               [[NSUserDefaults standardUserDefaults] setObject:rematchType forKey:@"rematchType"];
               [[NSUserDefaults standardUserDefaults] synchronize];
               
               
               [[NSUserDefaults standardUserDefaults] setObject:rematchTypeId forKey:@"rematchTypeId"];
               [[NSUserDefaults standardUserDefaults] synchronize];
               
               [[NavigationHandler getInstance] MoveToChallenge:_challenge1];
          }
          else if(flag == 5) {
               
               [loadView hide];
               
               NSString *message;
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    message = @"Sorry, your friend is not interested in the challenge request at the moment. Retry later.";
                    title = @"Challenge Not Accepted";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    message = @"عذرا، صديقك ليست مهتمة في الطلب تحديا في الوقت الراهن. إعادة المحاولة في وقت لاحق!";
                    title = @"لا تحدى مقبول";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    message = @"Désolé, votre ami ne est pas intéressé par la demande au moment de défi. Réessayez plus tard!";
                    title = @"Ne contestera pas acceptés";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    message = @"Lo sentimos, tu amigo no está interesado en la solicitud de desafío en este momento. Vuelva a intentarlo más tarde!";
                    title = @"Desafía No Aceptada";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    message = @"Desculpe, seu amigo não está interessado no pedido desafio no momento. Tente novamente mais tarde!";
                    title = @"Desafie Não Aceite";
                    cancel = CANCEL_4;
               }
               
               
               [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          }
          else {
               [loadView hide];
               NSString *title;
               NSString *message;
               
               if (languageCode == 0 ) {
                    title = Friend_Not_Available;
                    message = @"Unfortunately, your friend can't be reached at the moment. Please try later.";
               }else if (languageCode == 1){
                    title = Friend_Not_Availabl_1;
                    message = @"لسوء الحظ، لا يمكن أن يتم التوصل صديقك في الوقت الراهن. يرجى المحاولة لاحقا.";
               }else if (languageCode == 2){
                    title = Friend_Not_Availabl_2;
                    message = @"Malheureusement, votre ami ne peut pas être atteint pour le moment. Se il vous plaît réessayer plus tard.";
               }else if (languageCode == 3){
                    title = Friend_Not_Availabl_3;
                    message = @"Por desgracia, su amigo no puede ser alcanzado por el momento. Por favor, intente más tarde.";
               }else if (languageCode == 4){
                    title = Friend_Not_Availabl_4;
                    message = @"Infelizmente, o seu amigo não pode ser alcançado no momento. Por favor, tente mais tarde.";
               }
               
               [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:@"Cancel" OtherButton:nil];
          }
          
     }
}
//}
#pragma mark Challenge
- (void) tick:(NSTimer *) timer {
     if(sharedManager.socketIO.isConnected) {
          language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          languageCode = [language intValue];
          
          [[NavigationHandler getInstance] MoveToChallenge:_challenge];
     }
     
}


-(void)socketDisconnected:(SocketIO *)socket onError:(NSError *)error {
     //   [searchingView removeFromSuperview];
     [loadView hide];
}
-(void)socketError:(SocketIO *)socket disconnectedWithError:(NSError *)error {
     // [searchingView removeFromSuperview];
     [loadView hide];
}

#pragma mark Set Language

-(void)setLanguageForScreen {
     language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          
          days_ago = DAYS_AGO;
          hours_ago = @"hours ago";
          minutes_ago = @"minutes ago";
          seconds_ago = @"seconds ago";
          loadingtitle = Loading;
          
          lblPlayforPoints.text = PLAY_FOR_POINTS;
          lblplayforGems.text = PLAY_FOR_GEMS;
          willhelpinRanking.text = WILL_HELP_IN_RANKING;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY;
          
          NoRecordLbl.text = @"No record found!";
          RankingTitleLbl.text = RANKING_BTN;
          resultsTitle.text = RESULTS_LBL;
          [playAgain setTitle:PLAY_AGAIN forState:UIControlStateNormal];
          [ReturnHome setTitle:@"Return Home" forState:UIControlStateNormal];
          [rankingBtn setTitle:RANKING_BTN forState:UIControlStateNormal];
          [historyBtn setTitle:@"HISTORY" forState:UIControlStateNormal];
          [quitsearch setTitle:QUIT_GAME forState:UIControlStateNormal];
          [mainBack setTitle:BACK_BTN forState:UIControlStateNormal];
     }
     
     else if(languageCode == 1 ) {
          
          
          loadingtitle = Loading_1;
          
          days_ago = DAYS_AGO_1;
          hours_ago = @"قبل ساعة";
          minutes_ago = @"قبل دقيقة";
          seconds_ago = @"قبل الثانية";
          
          
          lblPlayforPoints.text = PLAY_FOR_POINTS_1;
          lblplayforGems.text = PLAY_FOR_GEMS_1;
          willhelpinRanking.text = WILL_HELP_IN_RANKING_1;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY_1;
          
          NoRecordLbl.text =@"لا يوجد سجل!";
          RankingTitleLbl.text = RANKING_BTN_1;
          resultsTitle.text = RESULTS_LBL_1;
          [playAgain setTitle:PLAY_AGAIN_1 forState:UIControlStateNormal];
          [ReturnHome setTitle:@"العودة إلى الصفحة الرئيسية" forState:UIControlStateNormal];
          [rankingBtn setTitle:@"الترتيب" forState:UIControlStateNormal];
          [historyBtn setTitle:HISTORY_1 forState:UIControlStateNormal];
          [quitsearch setTitle:QUIT_GAME_1 forState:UIControlStateNormal];
          [mainBack setTitle:BACK_BTN_1 forState:UIControlStateNormal];
     }
     
     
     else if(languageCode == 2) {
          
          loadingtitle = Loading_2;
          days_ago = DAYS_AGO_2;
          hours_ago = @"Il ya heures";
          minutes_ago = @"il ya minutes";
          seconds_ago = @"il ya secondes";
          
          
          lblPlayforPoints.text = PLAY_FOR_POINTS_2;
          lblplayforGems.text = PLAY_FOR_GEMS_2;
          willhelpinRanking.text = WILL_HELP_IN_RANKING_2;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY_2;
          
          NoRecordLbl.text = @"No se han encontrado registros!";
          RankingTitleLbl.text = RANKING_BTN_2;
          resultsTitle.text = RESULTS_LBL_2;
          [playAgain setTitle:PLAY_AGAIN_2 forState:UIControlStateNormal];
          [ReturnHome setTitle:HOME_BTN_2 forState:UIControlStateNormal];
          [rankingBtn setTitle:RANKING_BTN_2 forState:UIControlStateNormal];
          [historyBtn setTitle:HISTORY_2 forState:UIControlStateNormal];
          [quitsearch setTitle:QUIT_GAME_2 forState:UIControlStateNormal];
          [mainBack setTitle:BACK_BTN_2 forState:UIControlStateNormal];
     }
     
     
     
     else if(languageCode == 3) {
          
          loadingtitle = Loading_3;
          days_ago = DAYS_AGO_3;
          hours_ago = @"hace horas";
          minutes_ago = @"hace minutos";
          seconds_ago = @"hace segundos";
          NoRecordLbl.text = @"Aucun enregistrement trouvé!";
          
          
          lblPlayforPoints.text = PLAY_FOR_POINTS_3;
          lblplayforGems.text = PLAY_FOR_GEMS_3;
          willhelpinRanking.text = WILL_HELP_IN_RANKING_3;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY_3;
          
          RankingTitleLbl.text = RANKING_BTN_3;
          resultsTitle.text = RESULTS_LBL_3;
          [playAgain setTitle:PLAY_AGAIN_3 forState:UIControlStateNormal];
          [ReturnHome setTitle:HOME_BTN_3 forState:UIControlStateNormal];
          [rankingBtn setTitle:RANKING_BTN_3 forState:UIControlStateNormal];
          [historyBtn setTitle:HISTORY_3 forState:UIControlStateNormal];
          [quitsearch setTitle:QUIT_GAME_3 forState:UIControlStateNormal];
          [mainBack setTitle:BACK_BTN_3 forState:UIControlStateNormal];
     }
     else if(languageCode == 4) {
          
          
          loadingtitle = Loading_4;
          days_ago = DAYS_AGO_4;
          
          hours_ago = @"hora atrás";
          minutes_ago = @"minuto atrás";
          seconds_ago = @"segundo atrás";
          
          lblPlayforPoints.text = PLAY_FOR_POINTS_4;
          lblplayforGems.text = PLAY_FOR_GEMS_4;
          willhelpinRanking.text = WILL_HELP_IN_RANKING_4;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY_4;
          
          NoRecordLbl.text = @"Nenhum registro encontrado!";
          RankingTitleLbl.text = RANKING_BTN_4;
          resultsTitle.text = RESULTS_LBL_4;
          [playAgain setTitle:PLAY_AGAIN_4 forState:UIControlStateNormal];
          [ReturnHome setTitle:HOME_BTN_4 forState:UIControlStateNormal];
          [rankingBtn setTitle:RANKING_BTN_4 forState:UIControlStateNormal];
          [historyBtn setTitle:HISTORY_4 forState:UIControlStateNormal];
          [quitsearch setTitle:QUIT_GAME_4 forState:UIControlStateNormal];
          [mainBack setTitle:BACK_BTN_4 forState:UIControlStateNormal];
     }
     
     if (languageCode == 0 ) {
          somethingtitle = @"Something went wrong.";
          
     } else if(languageCode == 1) {
          somethingtitle = @"لقد حصل خطأ ما";
          
     }else if (languageCode == 2){
          somethingtitle = @"Erreur: Quelque chose s\'est mal passé!";
          
     }else if (languageCode == 3){
          somethingtitle = @"Algo salió mal!";
          
     }else if (languageCode == 4){
          somethingtitle = @"Alguma coisa deu errado!";
          
     }
     
}
- (UIImage*)loadImage
{
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                          NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString* path = [documentsDirectory stringByAppendingPathComponent:
                       @"test.png" ];
     UIImage* image = [UIImage imageWithContentsOfFile:path];
     return image;
}
- (IBAction)MainBackPressed:(id)sender {
     [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)resultBack:(id)sender {
     
     [resultCard_View removeFromSuperview];
}
@end
