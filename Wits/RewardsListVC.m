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
     self.tabBarController.tabBar.hidden = false;
     if(_addOnsArray.count == 0)
          [self fetchRewards];
     [gemsCountLbl setText:[[SharedManager getInstance] _userProfile].cashablePoints];
     [pointsCountLbl setText:[[SharedManager getInstance] _userProfile].totalPoints];
     [self Crossbtn:nil];
     consumedGems = [[[SharedManager getInstance] _userProfile].cashablePoints intValue];
     [rewardsTableView reloadData];
}
- (void)viewDidLoad {
     [super viewDidLoad];
     self.tabBarController.tabBar.hidden = false;
      _addOnsArraySorted = [[NSMutableArray alloc] init];
     [self setLanguageForScreen];
     // Do any additional setup after loading the view from its nib.
     searchField.delegate = self;
     searchField.placeholder = @"Type  ";
     searchField.backgroundColor = [UIColor clearColor];
     searchField.textColor = [UIColor whiteColor];
     [self.view addSubview: searchField];
     [searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
     [searchField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
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
     
     lblRewards.font = [UIFont fontWithName:FONT_NAME size:16];
     buyAddonLbl.font = [UIFont fontWithName:FONT_NAME size:15];
     if(IS_IPAD){
          LblCograts.font = [UIFont fontWithName:FONT_NAME size:25];
          
          lblRewards.font = [UIFont fontWithName:FONT_NAME size:22];
          buyAddonLbl.font = [UIFont fontWithName:FONT_NAME size:20];
     }
     [self fetchRewards];
}
-(void)fetchRewards{
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
               NSString *newString = [rewardObj.productName stringByReplacingOccurrencesOfString:@" " withString:@""];
               NSString *newString2 = [rewardObj.unlock_price stringByReplacingOccurrencesOfString:@" " withString:@""];
              newString = [newString lowercaseString];
               rewardObj.unlock_price = newString2;
               rewardObj.price = [ rewardObj.unlock_price intValue];
               rewardObj.productName = newString;
               [_addOnsArray addObject:rewardObj];
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
-(void)textFieldDidEndEditing:(UITextField *)textField
{
     //     _addOnsArray = [_listFiles mutableCopy];
     //     [_addOnsArray removeAllObjects];
     //     for (int i=0; i< _listFiles.count; i++) {
     //          [_addOnsArray addObject:[_listFiles objectAtIndex:i]];
     //     }
     [searchField resignFirstResponder];
     // [rewardsTableView reloadData];
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
     if(![searchField hasText]){
          //[self.view endEditing:YES];
          _addOnsArray = [_listFiles mutableCopy];
          [_addOnsArray removeAllObjects];
          for (int i=0; i< _listFiles.count; i++) {
               [_addOnsArray addObject:[_listFiles objectAtIndex:i]];
          }
          
     }else{
          
          _addOnsArray = [NSMutableArray arrayWithArray:[_addOnsArray filteredArrayUsingPredicate:sPredicate]];
     }
     
     [rewardsTableView reloadData];
}
- (IBAction)popupBackBtn:(id)sender {
     popupView.hidden = true;
}

- (IBAction)Crossbtn:(id)sender {
     searchField.hidden = false;
     rewardDetailView.hidden = true;
}

- (IBAction)sortBtn:(id)sender {
     timeSort++;
     if(timeSort == 1){
          _addOnsArraySorted = [_addOnsArray mutableCopy];
          [_addOnsArray removeAllObjects];
          [sortbtn setBackgroundImage:[UIImage imageNamed:@"sortalpha.png"] forState:UIControlStateNormal];
          NSSortDescriptor *sortDescriptor;
          sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_productName" ascending:YES];
          NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
          [_addOnsArraySorted sortUsingDescriptors:sortDescriptors];
          
          _addOnsArray = [_addOnsArraySorted mutableCopy];
     }
     else if(timeSort == 2)
     {
          _addOnsArraySorted = [_addOnsArray mutableCopy];
          [sortbtn setBackgroundImage:[UIImage imageNamed:@"sortgem.png"] forState:UIControlStateNormal ];
          NSSortDescriptor *sortDescriptor;
          sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
          NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
          [_addOnsArraySorted sortUsingDescriptors:sortDescriptors];
          [_addOnsArray removeAllObjects];
          _addOnsArray = [_addOnsArraySorted mutableCopy];
          
     }
     else if(timeSort == 3){
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
               return 310;
          }else{
               return 240;
          }
     }
     if (IS_IPAD) {
          return 310;
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
     
     else if([_addOnsArray count] == 1) {
          rows = 1;
     }
     return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     //int indexS = indexPath.section;
     currentIndex = (indexPath.row*2);
     if(timeSort == 0){
          NSSortDescriptor *sortDescriptor;
          sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
          NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
          [_addOnsArray sortUsingDescriptors:sortDescriptors];
     }
     RewardObj *obj = [_addOnsArray objectAtIndex:currentIndex];
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
     cell.title.font = [UIFont fontWithName:FONT_NAME size:10];
     if(IS_IPAD)
          cell.title.font = [UIFont fontWithName:FONT_NAME size:17];
     cell.leftDiscription.text = obj.productDescription;
     cell.addonCount.text = @"";
     int unlockPrice = [obj.unlock_price intValue];
     
     if(unlockPrice <= consumedGems && consumedGems>= 500) {
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
     NSURL *url = [NSURL URLWithString:[obj.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
          if (succeeded) {
               // change the image in the cell
               cell.iconImgView.image = image;
               // cache the image for use later (when scrolling up)
               obj.cellimage = image;
          }
     }];
     
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
          cell.rightTitle.font = [UIFont fontWithName:FONT_NAME size:10];
          if(IS_IPAD)
               cell.rightTitle.font = [UIFont fontWithName:FONT_NAME size:17];
          cell.rightDiscription.text = obj.productDescription;
          cell.addonCount.text = @"";
          int unlockPrice = [obj.unlock_price intValue];
          
          if(unlockPrice <= consumedGems && consumedGems >= 500) {
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
          
          NSURL *url = [NSURL URLWithString:[obj.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
          [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
               if (succeeded) {
                    // change the image in the cell
                    cell.rightIconImgView.image = image;
                    // cache the image for use later (when scrolling up)
                    obj.cellimage = image;
               }
          }];
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
     
     
     [cell.downBtn setTag:indexPath.row];
     
     [cell.downBtn addTarget:self action:@selector(downbtnSelected:) forControlEvents:UIControlEventTouchUpInside];
     [cell setBackgroundColor:[UIColor clearColor]];
     [cell.contentView setBackgroundColor:[UIColor clearColor]];
     cell.selectionStyle = NAN;
     return cell;

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
     
          [rewardsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
     searchField.hidden = true;
     UIButton *downBtn = (UIButton *)sender;
     currentSelectedIndex = downBtn.tag;
     RewardObj *obj = [_addOnsArray objectAtIndex:currentSelectedIndex];
     rewardDetailView.hidden = false;
     discriptionlbl.text = obj.productDescription;
     titlelbl.text = obj.productName;
     gemsAmountlbl.text = [NSString stringWithFormat:@"%d",[obj.unlock_price intValue]];
     if(obj.cellimage){
          rewardsiconimgview.image = obj.cellimage;
     }
     else
     {
          rewardsiconimgview.image = [UIImage imageNamed:@"rewardsicon.png"];
          NSURL *url = [NSURL URLWithString:[obj.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
          [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
               if (succeeded) {
                    // change the image in the cell
                    rewardsiconimgview.image = image;
                    // cache the image for use later (when scrolling up)
                    obj.cellimage = image;
               }
          }];
     }
     
     //rewardsiconimgview.image = selectedRewardImage;
}
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     [NSURLConnection sendAsynchronousRequest:request
                                        queue:[NSOperationQueue mainQueue]
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                 if ( !error )
                                 {
                                      UIImage *image = [[UIImage alloc] initWithData:data];
                                      completionBlock(YES,image);
                                 } else{
                                      completionBlock(NO,nil);
                                        //rewardsiconimgview.image = [UIImage imageNamed:@"rewardsicon.png"];
                                 }
                            }];
}
-(void)downbtnSelected:(id)sender{
     
     
     UIButton *downBtn = (UIButton *)sender;
     currentSelectedIndex = downBtn.tag;
     
     int indexS = indexPath.section;
     RewardObj *obj = (RewardObj*)[self.addOnsArray objectAtIndex:currentSelectedIndex];
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
            claim = CLAIM;
          lblRewards.text = REWARDS;
          buyAddonLbl.text = REWARD_INSTRUCTION;
          LblCograts.text = COMGRATULATIONS;
          lblRequestRecieved.text = REQUEST_RECIEVED;
          ourTeamMsg.text = OUR_TEAM_WILL_VERIFY;
          [backBtn setTitle:BACK_BTN forState:UIControlStateNormal];
          cannotPurchase = CANNOT_PURCHASE;
          purchaseError = PURCHASE_ERROR;
          OKstr = @"Okay";
          [searchField setTextAlignment:NSTextAlignmentLeft];
          UIColor *color = [UIColor whiteColor];
          searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search Reward" attributes:@{NSForegroundColorAttributeName: color}];
          loadingTitle = Loading;
        
     }
     else if(languageCode == 1 ) {
          //searchField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
           claim = @"استرداد";
          lblRewards.text = REWARDS_1;
          
          LblCograts.text = COMGRATULATIONS_1;
          buyAddonLbl.text = REWARD_INSTRUCTION_1;
          lblRequestRecieved.text = REQUEST_RECIEVED_1;
          ourTeamMsg.text = OUR_TEAM_WILL_VERIFY_1;
          [backBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          UIColor *color = [UIColor whiteColor];
          [searchField setTextAlignment:NSTextAlignmentRight];
          searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"البحث عن المكافأة" attributes:@{NSForegroundColorAttributeName: color}];
          cannotPurchase = CANNOT_PURCHASE_1;
          purchaseError = PURCHASE_ERROR_1;
          OKstr = OK_BTN_1;
          loadingTitle = Loading_1;
         
     }
     else if(languageCode == 2) {
          claim = @"Rembourser";
          [lblRewards setText:[@"Récompenses" uppercaseString]];
          LblCograts.text = COMGRATULATIONS_2;
          buyAddonLbl.text = REWARD_INSTRUCTION_2;
          lblRequestRecieved.text = REQUEST_RECIEVED_2;
          ourTeamMsg.text = OUR_TEAM_WILL_VERIFY_2;
          [backBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          cannotPurchase = CANNOT_PURCHASE_2;
          purchaseError = PURCHASE_ERROR_2;
          OKstr = OK_BTN_2;
          [searchField setTextAlignment:NSTextAlignmentLeft];
          UIColor *color = [UIColor whiteColor];
          searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Cherche récompense"attributes:@{NSForegroundColorAttributeName: color}];
          loadingTitle = Loading_2;
          
     }
     else if(languageCode == 3) {
          claim = @"Liberar";
          [lblRewards setText:[@"Premios" uppercaseString]];
          buyAddonLbl.text = REWARD_INSTRUCTION_3;
          LblCograts.text = COMGRATULATIONS_3;
          lblRequestRecieved.text = REQUEST_RECIEVED_3;
          ourTeamMsg.text = OUR_TEAM_WILL_VERIFY_3;
          [backBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          cannotPurchase = CANNOT_PURCHASE_3;
          purchaseError = PURCHASE_ERROR_3;
          OKstr = OK_BTN_3;
          [searchField setTextAlignment:NSTextAlignmentLeft];
          loadingTitle = Loading_3;
          
          UIColor *color = [UIColor whiteColor];
          searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Buscar recompensa"attributes:@{NSForegroundColorAttributeName: color}];
          
     }
     else if(languageCode == 4) {
          claim = @"Resgatar";
         
          [lblRewards setText:[@"Prêmios" uppercaseString]];
          LblCograts.text = COMGRATULATIONS_4;
          lblRequestRecieved.text = REQUEST_RECIEVED_4;
          ourTeamMsg.text = OUR_TEAM_WILL_VERIFY_4;
          buyAddonLbl.text = REWARD_INSTRUCTION_4;
          [searchField setTextAlignment:NSTextAlignmentLeft];;
          [backBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          cannotPurchase = CANNOT_PURCHASE_4;
          purchaseError = PURCHASE_ERROR_4;
          OKstr = OK_BTN_4;
          loadingTitle = Loading_4;
          UIColor *color = [UIColor whiteColor];
          searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Pesquisar Recompensas"attributes:@{NSForegroundColorAttributeName: color}];
     }
     
}

@end
