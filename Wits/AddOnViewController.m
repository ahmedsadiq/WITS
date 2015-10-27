//
//  AddOnViewController.m
//  Wits
//
//  Created by Ahmed Sadiq on 02/06/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import "AddOnViewController.h"
#import "AddOnObj.h"
#import "SharedManager.h"
#import "AddOnCell.h"
#import "AddOnViewSelected.h"
#import "Utils.h"
#import "AlertMessage.h"
#import "MKNetworkKit.h"
#import "NavigationHandler.h"
#import <QuartzCore/QuartzCore.h>
#import "StoreVC.h"

@interface AddOnViewController ()

@end

@implementation AddOnViewController


-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
     [self setLanguageForScreen];
     
     NSString *val = [SharedManager getInstance]._userProfile.cashablePoints;
     if ([val intValue] < 0) {
          [SharedManager getInstance]._userProfile.cashablePoints = @"0";
     }
     
     [_gemsLbl setText:[[SharedManager getInstance] _userProfile].cashablePoints];
     [_pointsLbl setText:[[SharedManager getInstance] _userProfile].totalPoints];
}

- (void)viewDidLoad {
     [super viewDidLoad];
     
     [self setLanguageForScreen];
     
     loadingView = [[LoadingView alloc] init];
     _gemsLbl.text = [[SharedManager getInstance] _userProfile].cashablePoints;
     _pointsLbl.text = [[SharedManager getInstance] _userProfile].totalPoints;
     int gems = [[[SharedManager getInstance] _userProfile].cashablePoints intValue];
     // Do any additional setup after loading the view from its nib.
     self.addOnsArray = [[NSMutableArray alloc] init];
     
     AddOnObj *Obj1st = [[AddOnObj alloc] init];
     if(gems >= 100) {
          Obj1st.isUnlocked = true;
     }
     Obj1st.isSelected = false;
     Obj1st.gemsRequired = @"100";
     Obj1st.productName = @"50/50";
     Obj1st.counter = counterStrfor2;
     Obj1st.productDescription = productDescStrfor2;
     
     [self.addOnsArray addObject:Obj1st];
     
     AddOnObj *Obj2nd = [[AddOnObj alloc] init];
     if(gems >= 200) {
          Obj2nd.isUnlocked = true;
     }
     
     Obj2nd.isSelected = false;
     Obj2nd.gemsRequired = @"200";
     Obj2nd.productName = @"50/50";
     Obj2nd.counter = counterStrfor5;
     Obj2nd.productDescription = productDescStrfor5;
     successMsg.font = [UIFont fontWithName:FONT_NAME size:17];
     
     lblYouUnlocked.font = [UIFont fontWithName:FONT_NAME size:17];
     lblCongratulations.font = [UIFont fontWithName:FONT_NAME size:24];
     
     addOnmainlabel.font = [UIFont fontWithName:FONT_NAME size:15];
     if(IS_IPAD){addOnmainlabel.font = [UIFont fontWithName:FONT_NAME size:20];
          successMsg.font = [UIFont fontWithName:FONT_NAME size:25];
          
          lblYouUnlocked.font = [UIFont fontWithName:FONT_NAME size:25];
          lblCongratulations.font = [UIFont fontWithName:FONT_NAME size:25];
     }
     [self.addOnsArray addObject:Obj2nd];
}

- (void)didReceiveMemoryWarning {
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(id)sender {
     
     [[NavigationHandler getInstance] MoveToStore];
}

- (IBAction)popUpCrossPressed:(id)sender {
     successPopUp.hidden = true;
}

#pragma mark ----------------------
#pragma mark TableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     AddOnObj *obj;
     if(indexPath.section == 0) {
          obj = (AddOnObj*)[self.addOnsArray objectAtIndex:0];
     }
     else{
          obj = (AddOnObj*)[self.addOnsArray objectAtIndex:1];
     }
     if(obj.isSelected == false) {
          if (IS_IPAD) {
               return 107;
          }else{
               
               return 65;
          }
     }
     if (IS_IPAD) {
          return 200;
     }
     return 125;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     
     return [self.addOnsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     AddOnObj *obj;
     if(indexPath.section == 0) {
          obj = (AddOnObj*)[self.addOnsArray objectAtIndex:0];
     }
     else{
          obj = (AddOnObj*)[self.addOnsArray objectAtIndex:1];
     }
     
     if(!obj.isSelected)
     {
          AddOnCell *cell;
          if ([[UIScreen mainScreen] bounds].size.height == iPad) {
               
               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddOnCell_iPad" owner:self options:nil];
               cell = [nib objectAtIndex:0];
          }
          else{
               
               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddOnCell" owner:self options:nil];
               cell = [nib objectAtIndex:0];
          }
          
          cell.addonCount.text = obj.counter;
          cell.addonCount.font = [UIFont fontWithName:FONT_NAME size:15];
          cell.addonCount.textColor = [UIColor whiteColor];
          if(!obj.isUnlocked) {
               cell.lockedImg.image = [UIImage imageNamed:@"locked.png"];
          }
          else {
               cell.lockedImg.image = [UIImage imageNamed:@""];
          }
          cell.price.text = [NSString stringWithFormat:@"%d",[obj.gemsRequired intValue]];
          
          
          [cell.downBtn setTag:indexPath.row];
          
          [cell.downBtn addTarget:self action:@selector(downbtnSelected:) forControlEvents:UIControlEventTouchUpInside];
          
          cell.selectionStyle = NAN;
          
          
          
          return cell;
     }
     else {
          AddOnViewSelected *cell;
          if ([[UIScreen mainScreen] bounds].size.height == iPad) {
               
               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddOnViewSelected_iPad" owner:self options:nil];
               cell = [nib objectAtIndex:0];
          }
          else{
               
               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddOnViewSelected" owner:self options:nil];
               cell = [nib objectAtIndex:0];
          }
          cell.addonCount.text = obj.counter;
          cell.addonCount.font = [UIFont fontWithName:FONT_NAME size:15];
          if(!obj.isUnlocked) {
               cell.lockedImg.image = [UIImage imageNamed:@"locked.png"];
          }
          else {
               cell.lockedImg.image = [UIImage imageNamed:@""];
          }
          
          cell.price.text = [NSString stringWithFormat:@"%d",[obj.gemsRequired intValue]];

          cell.addOnDesc.text = obj.productDescription;
          cell.addonCount.textColor = [UIColor whiteColor];
          cell.addOnDesc.textColor = [UIColor whiteColor];
          cell.selectionStyle = NAN;
          
          if(indexPath.section == 0) {
               cell.buyBtn.tag = 0;
          }
          else{
               cell.buyBtn.tag = 1;
          }

          [cell.buyBtn addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
          // cell.buyBtn.font = [UIFont systemFontOfSize:13];
          cell.buyBtn.font = [UIFont fontWithName:FONT_NAME size:15];
          [cell.buyBtn setTitle:buystr forState:UIControlStateNormal];
          if([obj.gemsRequired intValue] > [_gemsLbl.text intValue]) {
               [cell.buyBtn setEnabled:false];
          }
          
          return cell;
     }
}
#pragma mark - TableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     AddOnObj *obj;
     if(indexPath.section == 0) {
          obj = (AddOnObj*)[self.addOnsArray objectAtIndex:0];
     }
     else{
          obj = (AddOnObj*)[self.addOnsArray objectAtIndex:1];
     }
     if(obj.isSelected){
          obj.isSelected = false;
          
     }else{
          obj.isSelected = true;
          
     }
     
     [_mainTbl reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     
     index = indexPath;
     
     
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     UIView *v = [UIView new];
     [v setBackgroundColor:[UIColor clearColor]];
     return v;
}

-(void)downbtnSelected:(id)sender{
     AddOnObj *obj;
     UIButton *downBtn = (UIButton *)sender;
     currentSelectedIndex = downBtn.tag;
     
     if(currentSelectedIndex == 0) {
          obj = (AddOnObj*)[self.addOnsArray objectAtIndex:currentSelectedIndex];
     }
     else{
          obj = (AddOnObj*)[self.addOnsArray objectAtIndex:currentSelectedIndex];
     }
     if(obj.isSelected)
          obj.isSelected = false;
     else
          obj.isSelected = true;
     
     //[_mainTbl reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
     
}
-(void)buyBtnClicked:(UIButton*)sender
{

     UIButton *btn = (UIButton*)sender;
     int currentAddOns = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentAddOns"] intValue];
     NSString *successMessage;
     int pointsToBeDeducted = 0;
     if (sender.tag == 0)
     {
          currentAddOns = currentAddOns + 2;
          pointsToBeDeducted = 100;
          successMessage = productDescStrfor2;
     }else {
          currentAddOns = currentAddOns + 5;
          pointsToBeDeducted = 200;
          successMessage = productDescStrfor5;
     }
     [loadingView showInView:self.view withTitle:@"Purchase in Process"];
     NSString *pointDeducted = [NSString stringWithFormat:@"%d",pointsToBeDeducted];
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"updateConsumedGems" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParams setObject:pointDeducted forKey:@"consumed_gems"];
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          [loadingView hide];
          NSDictionary *responseDict = [completedOperation responseJSON];
          NSNumber *flag = [responseDict objectForKey:@"flag"];
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",currentAddOns] forKey:@"currentAddOns"];
               [[NSUserDefaults standardUserDefaults] synchronize];
               
               NSDictionary *data = (NSDictionary*)[responseDict objectForKey:@"data"];
               
               NSString *consumed_gems = (NSString*)[data objectForKey:@"consumed_gems"];
               NSString *currentPoints = (NSString*)[data objectForKey:@"current_points"];
               if(btn.tag == 0)
               {
                    counterLabel.text = @"2";
                    counterLabel.hidden = NO;
                    counterBg.hidden = NO;
               }else if(btn.tag == 1)
               {
                    counterLabel.text = @"5";
                    counterLabel.hidden = NO;
                    counterBg.hidden = NO;
               }

               
               [[SharedManager getInstance] _userProfile].cashablePoints = currentPoints;
               [[SharedManager getInstance] _userProfile].consumedGems = consumed_gems;
               
               _gemsLbl.text = [[SharedManager getInstance] _userProfile].cashablePoints;
               
               successPopUp.hidden = false;
               successMsg.text = successMessage;
          }
          else {
               [AlertMessage showAlertWithMessage:cannotPurchase andTitle:purchaseError SingleBtn:YES cancelButton:OKstr OtherButton:nil];
          }
          
     } onError:^(NSError* error) {
          
          
     }];
     
     [engine enqueueOperation:op];
}

#pragma mark Language

-(void)viewDidDisappear:(BOOL)animated
{
     [super viewDidDisappear:animated];
     counterLabel.hidden = YES;
     counterBg.hidden = YES;

}
-(void)setLanguageForScreen {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          
          addOnmainlabel.text = ADDON_INSTRUCTION;
          lblAddons.text = ADDONS;
          lblCongratulations.text = COMGRATULATIONS;
          Msgfor2Ques = TWO_CONSECUTIVE;
          Msgfor5Ques = FIVE_CONSECUTIVE;
          lblYouUnlocked.text = YOU_UNLOCKED_50_50;
          counterStrfor2 = UNLOCK_TWO_QUESTIONS;
          counterStrfor5 = UNLOCK_FIVE_QUESTIONS;
          
          productDescStrfor2 = TWO_CONSECUTIVE;
          productDescStrfor5 = FIVE_CONSECUTIVE;
          buystr = @"Buy";
          cannotPurchase = CANNOT_PURCHASE;
          purchaseError = PURCHASE_ERROR;
          OKstr = @"Okay";
          
          [backBtn setTitle:BACK_BTN forState:UIControlStateNormal];
          loadingTitle = Loading;
          
     }
     else if(languageCode == 1 ) {
          
          lblAddons.text = ADDONS_1;
          addOnmainlabel.text = ADDON_INSTRUCTION_1;
          lblCongratulations.text = COMGRATULATIONS_1;
          Msgfor2Ques = TWO_CONSECUTIVE_1;
          Msgfor5Ques = FIVE_CONSECUTIVE_1;
          lblYouUnlocked.text = YOU_UNLOCKED_50_50_1;
          
          counterStrfor2 = UNLOCK_TWO_QUESTIONS_1;
          counterStrfor5 = UNLOCK_FIVE_QUESTIONS_1;
          
          productDescStrfor2 = TWO_CONSECUTIVE_1;
          productDescStrfor5 = FIVE_CONSECUTIVE_1;
          buystr = @"اشتري";
          cannotPurchase = CANNOT_PURCHASE_1;
          purchaseError = PURCHASE_ERROR_1;
          OKstr = OK_BTN_1;
          
          [backBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          loadingTitle = Loading_1;
          
     }
     else if(languageCode == 2) {
          lblAddons.text = ADDONS_2;
          lblCongratulations.text = COMGRATULATIONS_2;
          Msgfor2Ques = TWO_CONSECUTIVE_2;
          Msgfor5Ques = FIVE_CONSECUTIVE_2;
          lblYouUnlocked.text = YOU_UNLOCKED_50_50_2;
          counterStrfor2 = UNLOCK_TWO_QUESTIONS_2;
          counterStrfor5 = UNLOCK_FIVE_QUESTIONS_2;
          addOnmainlabel.text = ADDON_INSTRUCTION_2;
          
          productDescStrfor2 = TWO_CONSECUTIVE_2;
          productDescStrfor5 = FIVE_CONSECUTIVE_2;
          buystr = @"acheter";
          cannotPurchase = CANNOT_PURCHASE_2;
          purchaseError = PURCHASE_ERROR_2;
          OKstr = OK_BTN_2;
          
          [backBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          loadingTitle = Loading_2;
          
     }
     else if(languageCode == 3) {
          lblAddons.text = ADDONS_3;
          lblCongratulations.text = COMGRATULATIONS_3;
          Msgfor2Ques = TWO_CONSECUTIVE_3;
          Msgfor5Ques = FIVE_CONSECUTIVE_3;
          lblYouUnlocked.text = YOU_UNLOCKED_50_50_3;
          counterStrfor2 = UNLOCK_TWO_QUESTIONS_3;
          counterStrfor5 = UNLOCK_FIVE_QUESTIONS_3;
          
          productDescStrfor2 = TWO_CONSECUTIVE_3;
          addOnmainlabel.text = ADDON_INSTRUCTION_3;
          productDescStrfor5 = FIVE_CONSECUTIVE_3;
          buystr = @"comprar";
          cannotPurchase = CANNOT_PURCHASE_3;
          purchaseError = PURCHASE_ERROR_3;
          OKstr = OK_BTN_3;
          
          [backBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          loadingTitle = Loading_3;
          
     }
     else if(languageCode == 4) {
          lblAddons.text = ADDONS_4;
          lblCongratulations.text = COMGRATULATIONS_4;
          Msgfor2Ques = TWO_CONSECUTIVE_4;
          Msgfor5Ques = FIVE_CONSECUTIVE_4;
          lblYouUnlocked.text = YOU_UNLOCKED_50_50_4;
          counterStrfor2 = UNLOCK_TWO_QUESTIONS_4;
          addOnmainlabel.text = ADDON_INSTRUCTION_4;
          counterStrfor5 = UNLOCK_FIVE_QUESTIONS_4;
          
          productDescStrfor2 = TWO_CONSECUTIVE_4;
          productDescStrfor5 = FIVE_CONSECUTIVE_4;
          buystr = @"comprar";
          cannotPurchase = CANNOT_PURCHASE_4;
          purchaseError = PURCHASE_ERROR_4;
          OKstr = OK_BTN_4;
          
          [backBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          loadingTitle = Loading_4;
          
     }
}


@end
