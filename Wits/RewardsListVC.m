//
//  RewardsListVC.m
//  Wits
//
//  Created by Ahmed Sadiq on 05/06/2015.
//  Copyright (c) 2015 Xint Solutions. All rights reserved.
//

#import "RewardsListVC.h"
#import "RewardObj.h"
#import "AddOnCell.h"
#import "AddOnViewSelected.h"
#import "Utils.h"
#import "MKNetworkEngine.h"
#import "SharedManager.h"
#import "AlertMessage.h"
#import "NavigationHandler.h"

@interface RewardsListVC ()

@end
//another test commit by fiza najeeb
@implementation RewardsListVC



-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
     [self setLanguageForScreen];
     
     [gemsCountLbl setText:[[SharedManager getInstance] _userProfile].cashablePoints];
     [pointsCountLbl setText:[[SharedManager getInstance] _userProfile].totalPoints];
     
     consumedGems = [[[SharedManager getInstance] _userProfile].cashablePoints intValue];
}
- (void)viewDidLoad {
     [super viewDidLoad];
       self.tabBarController.tabBar.hidden = false;
     [self setLanguageForScreen];
     // Do any additional setup after loading the view from its nib.
     searchField.delegate = self;
     searchField.placeholder = @"Type here ";
     searchField.backgroundColor = [UIColor clearColor];
     searchField.textColor = [UIColor whiteColor];
     [self.view addSubview: searchField];
     [searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     firsttime = true;
     //here you set up the methods to search array and reloading the tableview
     _listFiles = [[NSMutableArray alloc]  init];
     
     _loadingView = [[LoadingView alloc] init];
     [_loadingView showInView:self.view withTitle:loadingTitle];
     currentIndex = 0;
     gemsCountLbl.text = [[SharedManager getInstance] _userProfile].cashablePoints;
     pointsCountLbl.text = [[SharedManager getInstance] _userProfile].totalPoints;
     
     consumedGems = [[[SharedManager getInstance] _userProfile].cashablePoints intValue];
     
     timeSort = 0;
     LblCograts.font = [UIFont fontWithName:FONT_NAME size:24];
     
     lblRewards.font = [UIFont fontWithName:FONT_NAME size:20];
     buyAddonLbl.font = [UIFont fontWithName:FONT_NAME size:15];
     if(IS_IPAD){
          LblCograts.font = [UIFont fontWithName:FONT_NAME size:25];
          
          lblRewards.font = [UIFont fontWithName:FONT_NAME size:25];
          buyAddonLbl.font = [UIFont fontWithName:FONT_NAME size:20];
     }
     
     
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     [postParams setObject:@"getRewardsList" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          [_loadingView hide];
          NSDictionary *mainDict = [completedOperation responseJSON];
          _addOnsArray = [[NSMutableArray alloc] init];
          NSDictionary *data = (NSDictionary*)[mainDict objectForKey:@"data"];
          NSArray *rewards = (NSArray*)[data objectForKey:@"rewards"];
          for(int i = 0; i<rewards.count; i++) {
               NSDictionary *rewardDict = (NSDictionary*)[rewards objectAtIndex:i];
               RewardObj *rewardObj = [[RewardObj alloc] init];
               
               rewardObj.productDescription = [rewardDict objectForKey:@"description"];
               rewardObj.available_store = [rewardDict objectForKey:@"available_store"];
               rewardObj.expired_at = [rewardDict objectForKey:@"expired_at"];
               rewardObj.reward_id = [rewardDict objectForKey:@"id"];
               rewardObj.image = [rewardDict objectForKey:@"image"];
               rewardObj.unlock_price = [rewardDict objectForKey:@"unlock_price"];
               rewardObj.productName = [rewardDict objectForKey:@"name"];
               
               [_addOnsArray addObject:rewardObj];
               NSLog(@"%@",rewardObj);
          }
          
          currentIndex = 0;
          [rewardsTableView reloadData];
     } onError:^(NSError* error) {
          [_loadingView hide];
     }];
     
     [engine enqueueOperation:op];
}

- (void)didReceiveMemoryWarning {
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(id)sender {
     // [self.navigationController popViewControllerAnimated:YES];
     AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     if (appDelegate.isStore == true) {
          [[NavigationHandler getInstance]MoveToStore];
     }else{
          
          [self.navigationController popViewControllerAnimated:true];
     }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     //self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
     [searchField resignFirstResponder];
     return YES;
}
-(void)textFieldDidChange:(UITextField *)txtFld {
     NSString * match = txtFld.text;
     
     NSPredicate *sPredicate = [NSPredicate predicateWithFormat:
                                @"productName CONTAINS[cd] %@", match];
     
     if(firsttime){
          for (int i=0; i< _addOnsArray.count; i++) {
               [_listFiles addObject:[_addOnsArray objectAtIndex:i]];
          }
          firsttime = false;
     }
     if([searchField.text isEqualToString:@""] || searchField.text == NULL){
          //  _addOnsArray = [listFiles mutableCopy];
          [_addOnsArray removeAllObjects];
          for (int i=0; i< _listFiles.count; i++) {
               [_addOnsArray addObject:[_listFiles objectAtIndex:i]];
          }
          
     }else{
          _addOnsArray = [NSMutableArray arrayWithArray:[_addOnsArray filteredArrayUsingPredicate:sPredicate]];
     }
     
     
     
     NSLog(@"%lu",(unsigned long)_addOnsArray.count);
     [rewardsTableView reloadData];
}
- (IBAction)popupBackBtn:(id)sender {
     popupView.hidden = true;
}

- (IBAction)Crossbtn:(id)sender {
     rewardDetailView.hidden = true;
}

- (IBAction)sortBtn:(id)sender {
     timeSort++;
  
     if(timeSort == 3){
          timeSort =0;
          [sortbtn setBackgroundImage:[UIImage imageNamed:@"sortunlock.png"] forState:UIControlStateNormal ];
     }
     [rewardsTableView reloadData];
     
}



#pragma mark ----------------------
#pragma mark TableView Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     RewardObj *obj;
     obj = (RewardObj*)[self.addOnsArray objectAtIndex:indexPath.section];
     if(obj.isSelected == false) {
          if (IS_IPAD) {
               return 107;
          }else{
               return 240;
          }
     }
     if (IS_IPAD) {
          return 200;
     }
     return 240;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 1;//[self.addOnsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     //return 1;
     int rows = ([_addOnsArray count]/2);
     if([_addOnsArray count]%2 == 1) {
          rows++;
     }
     
     if([_addOnsArray count] == 1) {
          rows = 1;
     }
     return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     //int indexS = indexPath.section;
     currentIndex = (indexPath.row*2);
      RewardObj *obj = [_addOnsArray objectAtIndex:currentIndex];
     
    
     if(timeSort == 0){
           //[sortbtn setBackgroundImage:[UIImage imageNamed:@"sortunlcok.png"] forState:UIControlStateNormal ];
          _addOnsArray = [_addOnsArray sortedArrayUsingComparator:^NSComparisonResult(RewardObj *p1, RewardObj *p2){
               
               return [p1.productName compare:p2.productName];
               
          }];
          
     }
     
     
     else if(timeSort == 1){
          [sortbtn setBackgroundImage:[UIImage imageNamed:@"sortalpha.png"] forState:UIControlStateNormal ];
          _addOnsArray = [_addOnsArray sortedArrayUsingComparator:^NSComparisonResult(RewardObj *p1, RewardObj *p2){
               
               return [p1.productName compare:p2.productName];
               
          }];
          
     }
     else if(timeSort == 2)
     {
          //timeSort = 0;
          [sortbtn setBackgroundImage:[UIImage imageNamed:@"sortgem.png"] forState:UIControlStateNormal ];
                    _addOnsArray = [_addOnsArray sortedArrayUsingComparator:^NSComparisonResult(RewardObj *p1, RewardObj *p2){
          
                         return [p1.unlock_price compare:p2.unlock_price];
          
                    }];
          
     }
     
    // RewardObj *obj = [_addOnsArray objectAtIndex:currentIndex];
     //
     //     if(!obj.isSelected)
     //     {
     AddOnCell *cell;
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddOnCell_iPad" owner:self options:nil];
          cell = [nib objectAtIndex:0];
     }
     else{
          NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddOnCell" owner:self options:nil];
          cell = [nib objectAtIndex:0];
     }
     cell.title.text = obj.productName;
     // [cell.title setFont:[UIFont systemFontOfSize:17]];
     cell.title.font = [UIFont fontWithName:FONT_NAME size:17];
     cell.leftDiscription.text = obj.productDescription;
     cell.addonCount.text = @"";
     int unlockPrice = [obj.unlock_price intValue];
     
     if(unlockPrice <= consumedGems) {
          cell.lockedImg.image = [UIImage imageNamed:@""];
          cell.buybtnleft.enabled = true;
          cell.buybtnleft.hidden = false;
     }
     else {
          cell.lockedImg.image = [UIImage imageNamed:@"lock.png"];
          cell.buybtnleft.enabled = false;
          cell.buybtnleft.hidden = true;
     }
     //cell.gemsImgView.hidden = true;
     cell.price.text = [NSString stringWithFormat:@"%d",[obj.unlock_price intValue]];
     cell.iconImgView.image = [UIImage imageNamed:@"rewardsicon.png"];
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     
     MKNetworkOperation *op = [engine operationWithURLString:obj.image params:nil httpMethod:@"GET"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          
          [cell.iconImgView setImage:[completedOperation responseImage]];
          //[cell.iconImgView roundImageCorner];
          obj.cellimage = completedOperation.responseImage;
          
     } onError:^(NSError* error) {
     }];
     [engine enqueueOperation:op];
     //[_addOnsArray addObject:obj];
     product_id = obj.reward_id;
     cell.buybtnleft.tag = currentIndex;
     [cell.buybtnleft setTitle:claim forState:UIControlStateNormal];
     [cell.buybtnleft addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
     //selectedRewardImage = cell.iconImgView.image;
     cell.leftBtn.tag = currentIndex;
     [cell.leftBtn addTarget:self action:@selector(rewardDetailedPressed:) forControlEvents:UIControlEventTouchUpInside];
     
     
     currentIndex++;
     if(currentIndex < _addOnsArray.count)
     {
          RewardObj *obj = [_addOnsArray objectAtIndex:currentIndex];
          
          cell.rightTitle.text = obj.productName;
          //          [cell.title setFont:[UIFont systemFontOfSize:17]];
          cell.rightTitle.font = [UIFont fontWithName:FONT_NAME size:17];
          cell.rightDiscription.text = obj.productDescription;
          cell.addonCount.text = @"";
          int unlockPrice = [obj.unlock_price intValue];
          
          if(unlockPrice <= consumedGems) {
               cell.rightlockedimg.image = [UIImage imageNamed:@""];
               cell.buybtnright.enabled = true;
               cell.buybtnright.hidden = false;
          }
          else {
               cell.rightlockedimg.image = [UIImage imageNamed:@"lock.png"];
               cell.buybtnright.enabled = false;
               cell.buybtnright.hidden = true;
          }
          //cell.gemsImgView.hidden = true;
          cell.rightPrice.text = [NSString stringWithFormat:@"%d",[obj.unlock_price intValue]];
          cell.rightIconImgView.image = [UIImage imageNamed:@"rewardsicon.png"];
          MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
          
          MKNetworkOperation *op = [engine operationWithURLString:obj.image params:nil httpMethod:@"GET"];
          
          [op onCompletion:^(MKNetworkOperation *completedOperation) {
               
               [cell.rightIconImgView setImage:[completedOperation responseImage]];
               obj.cellimage = completedOperation.responseImage;
               
          } onError:^(NSError* error) {
          }];
          
          [engine enqueueOperation:op];
          //[_addOnsArray addObject:obj];
          product_id = obj.reward_id;
          cell.buybtnright.tag = currentIndex;
          [cell.buybtnright setTitle:claim forState:UIControlStateNormal];
          [cell.buybtnright addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
          
          cell.rightBtn.tag = currentIndex;
          [cell.rightBtn addTarget:self action:@selector(rewardDetailedPressed:) forControlEvents:UIControlEventTouchUpInside];
          
          currentIndex++;
     }
     else {
          cell.rightBtn.enabled = NO;
          cell.rightPrice.hidden = true;
          cell.rightDiscription.hidden = true;
          cell.rightTitle.hidden = true;
          cell.rightIconImgView.hidden = true;
          cell.rightGemlogo.hidden = true;
          cell.leftcellbg.hidden = true;
          cell.buybtnright.hidden = true;
          cell.rightlockedimg.hidden = true;
     }
     
     cell.selectionStyle = NAN;
     [cell.downBtn setTag:indexPath.row];
     
     [cell.downBtn addTarget:self action:@selector(downbtnSelected:) forControlEvents:UIControlEventTouchUpInside];
     
     return cell;
     //     }
     //     else {
     //          AddOnViewSelected *cell;
     //          if ([[UIScreen mainScreen] bounds].size.height == iPad) {
     //               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddOnViewSelected_iPad" owner:self options:nil];
     //               cell = [nib objectAtIndex:0];
     //          }
     //          else{
     //               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddOnViewSelected" owner:self options:nil];
     //               cell = [nib objectAtIndex:0];
     //          }
     //          //[cell.title setFont:[UIFont systemFontOfSize:17]];
     //          cell.title.font = [UIFont fontWithName:FONT_NAME size:17];
     //
     //          cell.title.text = obj.productName;
     //          cell.addonCount.text = @"";
     //          int unlockPrice = [obj.unlock_price intValue];
     //
     //          if(unlockPrice <= consumedGems) {
     //               cell.lockedImg.image = [UIImage imageNamed:@""];
     //
     //          }
     //          else {
     //               cell.lockedImg.image = [UIImage imageNamed:@"locked.png"];
     //               cell.buyBtn.enabled = false;
     //          }
     //         // cell.gemsImgView.hidden = true;
     //          cell.iconImgView.image = [UIImage imageNamed:@"rewardsicon.png"];
     //          MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     //
     //          MKNetworkOperation *op = [engine operationWithURLString:obj.image params:nil httpMethod:@"GET"];
     //
     //          [op onCompletion:^(MKNetworkOperation *completedOperation) {
     //
     //               [cell.iconImgView setImage:[completedOperation responseImage]];
     //               //[cell.iconImgView roundImageCorner];
     //               cell.iconImgView.layer.cornerRadius = 10;
     //
     //          } onError:^(NSError* error) {
     //          }];
     //
     //          [engine enqueueOperation:op];
     //
     //          //cell.price.text = [NSString stringWithFormat:@"%d",[obj.unlock_price intValue]];
     //          cell.addOnDesc.text = obj.productDescription;
     //          cell.selectionStyle = NAN;
     //
     //          cell.buyBtn.tag = indexPath.section;
     //          //           cell.buyBtn.font = [UIFont systemFontOfSize:13];
     //          cell.buyBtn.font = [UIFont fontWithName:FONT_NAME size:13];
     //
     //          [cell.buyBtn setTitle:claim forState:UIControlStateNormal];
     //          [cell.buyBtn addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
     //
     //          return cell;
     //     }
}
#pragma mark - TableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     int indexS = indexPath.section;
     RewardObj *obj = (RewardObj*)[self.addOnsArray objectAtIndex:indexS];
     
     if(obj.isSelected){
          obj.isSelected = false;
          
     }else{
          obj.isSelected = true;
          
     }
     //
     //     [rewardsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//     //return 15;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     UIView *v = [UIView new];
     [v setBackgroundColor:[UIColor clearColor]];
     return v;
}
-(void)rewardDetailedPressed:(id)sender{
     UIButton *downBtn = (UIButton *)sender;
     currentSelectedIndex = downBtn.tag;
     
     int indexS = indexPath.section;
     RewardObj *obj = [_addOnsArray objectAtIndex:currentSelectedIndex];
     rewardDetailView.hidden = false;
     discriptionlbl.text = obj.productDescription;
     titlelbl.text = obj.productName;
     gemsAmountlbl.text = [NSString stringWithFormat:@"%d",[obj.unlock_price intValue]];
     if(obj.cellimage){
          rewardsiconimgview.image = obj.cellimage;}
     else
          rewardsiconimgview.image = [UIImage imageNamed:@"rewardsicon.png"];
     //rewardsiconimgview.image = selectedRewardImage;
}
-(void)downbtnSelected:(id)sender{
     
     
     UIButton *downBtn = (UIButton *)sender;
     currentSelectedIndex = downBtn.tag;
     
     int indexS = indexPath.section;
     RewardObj *obj = (RewardObj*)[self.addOnsArray objectAtIndex:indexS];
     if(obj.isSelected)
          obj.isSelected = false;
     else
          obj.isSelected = true;
     
     //[rewardsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:currentSelectedIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
     
}

-(void)buyBtnClicked:(UIButton*)sender
{
     UIButton *btn = (UIButton*)sender;
     RewardObj *rObj = (RewardObj*)[_addOnsArray objectAtIndex:btn.tag];
     MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     int languageCode = [language intValue];
     [_loadingView showInView:self.view withTitle:@"Sending Request"];
     
     NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
     
     [postParams setObject:@"claimRewardLatest" forKey:@"method"];
     [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
     [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
     [postParams setObject:[NSString stringWithFormat:@"%d",[rObj.reward_id intValue]] forKey:@"reward_id"];
     [postParams setObject:language forKey:@"language"];
     MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
     
     [op onCompletion:^(MKNetworkOperation *completedOperation) {
          [_loadingView hide];
          NSDictionary *responseDict = [completedOperation responseJSON];
          
          NSNumber *flag = [responseDict objectForKey:@"flag"];
          if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
          {
               
               
               NSDictionary *data = [responseDict objectForKey:@"data"];
               NSString *consumed_gems = [data objectForKey:@"Gems"];
               consumedGems = [consumed_gems intValue];
               
               [[SharedManager getInstance] _userProfile].cashablePoints = [NSString stringWithFormat:@"%d",consumedGems];
               [gemsCountLbl setText:[[SharedManager getInstance] _userProfile].cashablePoints];
               [rewardsTableView reloadData];
               
               popupView.hidden = false;
          }
          else {
               [AlertMessage showAlertWithMessage:cannotPurchase andTitle:purchaseError SingleBtn:YES cancelButton:OKstr OtherButton:nil];
          }
          
     } onError:^(NSError* error) {
          
          
     }];
     
     [engine enqueueOperation:op];
}

#pragma mark Language
-(void)setLanguageForScreen {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     int languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          lblRewards.text = REWARDS;
          buyAddonLbl.text = REWARD_INSTRUCTION;
          LblCograts.text = COMGRATULATIONS;
          lblRequestRecieved.text = REQUEST_RECIEVED;
          ourTeamMsg.text = OUR_TEAM_WILL_VERIFY;
          [backBtn setTitle:BACK_BTN forState:UIControlStateNormal];
          cannotPurchase = CANNOT_PURCHASE;
          purchaseError = PURCHASE_ERROR;
          OKstr = @"Okay";
          
          loadingTitle = Loading;
          claim = CLAIM;
     }
     else if(languageCode == 1 ) {
          lblRewards.text = REWARDS_1;
          LblCograts.text = COMGRATULATIONS_1;
          buyAddonLbl.text = REWARD_INSTRUCTION_1;
          lblRequestRecieved.text = REQUEST_RECIEVED_1;
          ourTeamMsg.text = OUR_TEAM_WILL_VERIFY_1;
          [backBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          
          cannotPurchase = CANNOT_PURCHASE_1;
          purchaseError = PURCHASE_ERROR_1;
          OKstr = OK_BTN_1;
          loadingTitle = Loading_1;
          claim = CLAIM_1;
     }
     else if(languageCode == 2) {
          lblRewards.text = REWARDS_2;
          LblCograts.text = COMGRATULATIONS_2;
          buyAddonLbl.text = REWARD_INSTRUCTION_2;
          lblRequestRecieved.text = REQUEST_RECIEVED_2;
          ourTeamMsg.text = OUR_TEAM_WILL_VERIFY_2;
          [backBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          cannotPurchase = CANNOT_PURCHASE_2;
          purchaseError = PURCHASE_ERROR_2;
          OKstr = OK_BTN_2;
          
          loadingTitle = Loading_2;
          claim = CLAIM_2;
     }
     else if(languageCode == 3) {
          lblRewards.text = REWARDS_3;
          buyAddonLbl.text = REWARD_INSTRUCTION_3;
          LblCograts.text = COMGRATULATIONS_3;
          lblRequestRecieved.text = REQUEST_RECIEVED_3;
          ourTeamMsg.text = OUR_TEAM_WILL_VERIFY_3;
          [backBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          cannotPurchase = CANNOT_PURCHASE_3;
          purchaseError = PURCHASE_ERROR_3;
          OKstr = OK_BTN_3;
          loadingTitle = Loading_3;
          claim = CLAIM_3;
     }
     else if(languageCode == 4) {
          lblRewards.text = REWARDS_4;
          LblCograts.text = COMGRATULATIONS_4;
          lblRequestRecieved.text = REQUEST_RECIEVED_4;
          ourTeamMsg.text = OUR_TEAM_WILL_VERIFY_4;
          buyAddonLbl.text = REWARD_INSTRUCTION_4;
          [backBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          cannotPurchase = CANNOT_PURCHASE_4;
          purchaseError = PURCHASE_ERROR_4;
          OKstr = OK_BTN_4;
          loadingTitle = Loading_4;
          claim = CLAIM_4;
     }
     
     if (languageCode == 1) {
          
          
     }else{
          
     }
}

@end
