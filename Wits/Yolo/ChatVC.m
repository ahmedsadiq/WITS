//
//  ChatVC.m
//  Yolo
//
//  Created by Nisar Ahmad on 04/07/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "ChatVC.h"
#import "RightBarVC.h"
#import "Utils.h"
#import "MKNetworkKit.h"
#import "SharedManager.h"
#import "MKNetworkKit.h"
#import "AppDelegate.h"
#import "UIImageView+RoundImage.h"
#import "NavigationHandler.h"
#import "AlertMessage.h"



@interface ChatVC ()

@end

@implementation ChatVC

- (id)initWithUserProfile:(UserProfile *)_user andThread:(MessageThreads *)_receivedThread
{
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
          self = [super initWithNibName:@"ChatVC_iPad" bundle:nil];
     else
          self = [super initWithNibName:@"ChatVC" bundle:nil];
     
     if (self) {
          // Custom initialization
          
          
     }
     return self;
}
- (void)viewDidLoad
{
     [super viewDidLoad];
     // Do any additional setup after loading the view from its nib.
     [self setLanguageForScreen];
     AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     
     profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
     profileImage.layer.borderWidth = 4.0f;
     
     _currentPoints.text = [SharedManager getInstance]._userProfile.totalPoints;
     currentGems.text = [SharedManager getInstance]._userProfile.cashablePoints;
     titleLbl.text = [SharedManager getInstance]._userProfile.display_name;
     NSLog(@"Title %@",[SharedManager getInstance]._userProfile.display_name);
     
     NSString  *gems = [SharedManager getInstance]._userProfile.cashablePoints;
     int totalPoints = [gems intValue];
     if(totalPoints <= 200) {
          if (languageCode == 0) {
               
               userRankingStatus.text = @"Beginner";
               
          }else if (languageCode == 1){
               
               userRankingStatus.text = @"مبتدئ";
               
          }else if (languageCode == 2){
               
               userRankingStatus.text = @"Débutant";
               
          }else if (languageCode == 3){
               
               userRankingStatus.text = @"Debutante";
               
          }else if (languageCode == 4){
               
               userRankingStatus.text = @"Iniciante";
          }
     }
     else if(totalPoints >200 && totalPoints<=500) {
          
          if (languageCode == 0) {
               
               userRankingStatus.text = @"Expert";
               
          }else if (languageCode == 1){
               
               userRankingStatus.text = @"خبير";
               
          }else if (languageCode == 2){
               
               userRankingStatus.text = @"Expert";
               
          }else if (languageCode == 3){
               
               userRankingStatus.text =  @"Experto";
               
          }else if (languageCode == 4){
               
               userRankingStatus.text = @"Expert";
               
          }
          
     }
     else if(totalPoints >500 && totalPoints<=1000) {
          
          if (languageCode == 0) {
               
               userRankingStatus.text = @"Advance";
               
          }else if (languageCode == 1){
               
               userRankingStatus.text = @"متقدم";
               
          }else if (languageCode == 2){
               
               userRankingStatus.text = @"Avancé";
               
          }else if (languageCode == 3){
               
               userRankingStatus.text =  @"Avanzado ";
               
          }else if (languageCode == 4){
               
               userRankingStatus.text = @"Avançado";
          }
     }
     else {
          
          if (languageCode == 0) {
               
               userRankingStatus.text = @"Witty";
               
          }else if (languageCode == 1){
               
               userRankingStatus.text = @"ذكي";
               
          }else if (languageCode == 2){
               
               userRankingStatus.text = @"Intelligent";
               
          }else if (languageCode == 3){
               
               userRankingStatus.text =  @"Inteligente ";
               
          }else if (languageCode == 4){
               
               userRankingStatus.text = @"Gênio";
               
          }
     }
     
     if(delegate.profileImage) {
          [profileImage setImage:delegate.profileImage];
          [profileImage roundImageCorner];
          [coverImg setImage:delegate.profileImage];
          
     }
     else {
          NSString *imageStr = [SharedManager getInstance]._userProfile.profile_image;
          if([SharedManager getInstance]._userProfile.profile_image.length > 3) {
               MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
               MKNetworkOperation *op = [engine operationWithURLString:[SharedManager getInstance]._userProfile.profile_image params:Nil httpMethod:@"GET"];
               
               [op onCompletion:^(MKNetworkOperation *completedOperation) {
                    [profileImage setImage:[completedOperation responseImage]];
                    [profileImage roundImageCorner];
                    [coverImg setImage:[completedOperation responseImage]];
                    
               } onError:^(NSError* error) {
                    
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
                    [AlertMessage showAlertWithMessage:emailMsg andTitle:@"Image cannot be fetched" SingleBtn:YES cancelButton:cancel OtherButton:nil];
                    
                    /*     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Image cannot be fetched" message:emailMsg delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                     [alert show]; */
                    
               }];
               
               [engine enqueueOperation:op];
          }
     }
}
- (IBAction)myAccount:(id)sender {
     [[NavigationHandler getInstance] MoveToUpdateProfile];
}

- (IBAction)backPressed:(id)sender {
     [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}
#pragma mark Set Language

-(void)setLanguageForScreen {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          _profileLbl.text = PROFILE;
          _statusLbl.text = STATUS;
          _pointsLbl.text = POINTS;
          _OnlineLbl.text = ONLINE_LBL;
          gemLbl.text = GEMS;
          _myaccountLbl.text = @"My Account";
          [_backOutlet setTitle:BACK_BTN forState:UIControlStateNormal];
     }
     else if(languageCode == 1 ) {
          _profileLbl.text = PROFILE_1;
          _statusLbl.text = STATUS_1;
          _pointsLbl.text = POINTS_1;
          _OnlineLbl.text = ONLINE_LBL_1;
          gemLbl.text = GEMS_1;
          _myaccountLbl.text = @"حسابي";
          
          [_backOutlet setTitle:BACK_BTN_1 forState:UIControlStateNormal];
     }
     else if(languageCode == 2) {
          _profileLbl.text = PROFILE_2;
          _statusLbl.text = STATUS_2;
          _myaccountLbl.text = @"Mon Compte";
          _pointsLbl.text = POINTS_2;
          gemLbl.text = GEMS_2;
          _OnlineLbl.text = ONLINE_LBL_2;
          [_backOutlet setTitle:BACK_BTN_2 forState:UIControlStateNormal];
     }
     else if(languageCode == 3) {
          _profileLbl.text = PROFILE_3;
          _statusLbl.text = STATUS_3;
          _pointsLbl.text = POINTS_3;
          gemLbl.text = GEMS_3;
          _OnlineLbl.text = ONLINE_LBL_3;
          _myaccountLbl.text = @"Mi Cuenta";
          [_backOutlet setTitle:BACK_BTN_3 forState:UIControlStateNormal];
     }
     else if(languageCode == 4) {
          _profileLbl.text = PROFILE_4;
          _statusLbl.text = STATUS_4;
          _pointsLbl.text = POINTS_4;
          gemLbl.text = GEMS_4;
          _OnlineLbl.text = ONLINE_LBL_4;
          _myaccountLbl.text = @"Minha Conta";
          [_backOutlet setTitle:BACK_BTN_4 forState:UIControlStateNormal];
     }
     
     if(IS_IPAD){
          if (languageCode == 1) {
               _pointsLbl.textAlignment = NSTextAlignmentRight;
               _profileLbl.textAlignment = NSTextAlignmentRight;
               _pointsLbl.textAlignment = NSTextAlignmentRight;
               _statusLbl.textAlignment = NSTextAlignmentRight;
               _OnlineLbl.textAlignment = NSTextAlignmentLeft;
               _myaccountLbl.textAlignment = NSTextAlignmentRight;
               _currentPoints.textAlignment = NSTextAlignmentLeft;
               gemLbl.textAlignment = NSTextAlignmentRight;
               currentGems.textAlignment = NSTextAlignmentLeft;
               greenImg.frame = CGRectMake(30, 707, 20, 20);
               star_icon.frame = CGRectMake(15, 868, 41, 44);
               gem_icon.frame = CGRectMake(17, 777, 51, 46);
               
          }else{
               
               
          }
          
          
     }else{
          if (languageCode == 1) {
               _currentPoints.textAlignment = NSTextAlignmentLeft;
               _pointsLbl.textAlignment = NSTextAlignmentRight;
               _profileLbl.textAlignment = NSTextAlignmentRight;
               _pointsLbl.textAlignment = NSTextAlignmentRight;
               gemLbl.textAlignment = NSTextAlignmentRight;
               currentGems.textAlignment = NSTextAlignmentLeft;
               _statusLbl.textAlignment = NSTextAlignmentRight;
               _OnlineLbl.textAlignment = NSTextAlignmentLeft;
               _myaccountLbl.textAlignment = NSTextAlignmentRight;
               greenImg.frame = CGRectMake(12, 360, 15, 15);
               star_icon.frame = CGRectMake(5, 466, 29, 29);
               gem_icon.frame = CGRectMake(7, 412, 25, 25);
          }else{
          }
     }
     
}


@end
