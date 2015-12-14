//
//  SubTopicVC.m
//  Yolo
//
//  Created by Salman Khalid on 25/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "SubTopicVC.h"
#import "MKNetworkKit.h"
#import "SubTopicCC.h"
#import "Utils.h"
#import "SharedManager.h"
#import "RightBarVC.h"
#import "SubTopicSelectedCC.h"
#import "RankingVC.h"
#import "ChallengeFriendsVC.h"
#import "DiscussionVC.h"
#import "ChallengeVC.h"
#import "NavigationHandler.h"
#import "UIImageView+RoundImage.h"
#import "TopicModel.h"
#import "ThirdLayerVC.h"
#import "SocketIOPacket.h"
#import "HelperFunctions.h"
#import "AlertMessage.h"
#import "AppDelegate.h"
#import "HomeVC.h"
#import <QuartzCore/QuartzCore.h>

@implementation SubTopicVC
@synthesize subtopicsArray;
-(id)initWithParentTopic:(Topic *)_parentTopic
{
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
          self = [super initWithNibName:@"SubTopicVC_iPad" bundle:nil];
     else
          self = [super initWithNibName:@"SubTopicVC" bundle:nil];
     if (self) {
          // Custom initialization
          
          parentTopic = _parentTopic;
          [[SharedManager getInstance] ResetTopicSelectionValues];
          subtopicsArray = [[SharedManager getInstance] getSubTopicsOfParent:parentTopic];
     }
     return self;
}
-(id)initWithParentTopicModel:(CategoryModel *)_parentTopic
{
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
          self = [super initWithNibName:@"SubTopicVC_iPad" bundle:nil];
     else
          self = [super initWithNibName:@"SubTopicVC" bundle:nil];
     if (self) {
          // Custom initialization
          
          parentTopicModel = _parentTopic;
          [[SharedManager getInstance] ResetTopicSelectionValues];
          subtopicsArray = _parentTopic.topicsArray;
     }
     return self;
}
-(id)initWithAllTopics
{
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
          self = [super initWithNibName:@"SubTopicVC_iPad" bundle:nil];
     else
          self = [super initWithNibName:@"SubTopicVC" bundle:nil];
     if (self) {
          isAllTopics = true;
          subtopicsArray = [[SharedManager getInstance] getAllSubTopics];
     }
     return self;
}

- (void) viewWillDisappear:(BOOL)animated {
     
     [GemsDialogView removeFromSuperview];
     for(int i=0; i<subtopicsArray.count; i++) {
          TopicModel *tempToplic  = [subtopicsArray objectAtIndex:i];
          tempToplic.isSelected = false;
     }
}

- (void)viewDidLoad
{
     [super viewDidLoad];
     topicTblView.allowsMultipleSelection = NO;
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
     if(isAllTopics) {
          [mainTitlelbl setText:@"Topics"];
     }
     else {
          [mainTitlelbl setText:parentTopicModel.title];
          
     }
      imageNames = @[@"avatar1.png",@"avatar2.png",@"avatar3.png",@"avatar4.png",@"avatar5.png",@"avatar6.png"];
     
     [self setUpTutorial];
     [topicTblView reloadData];

     if(IS_IPHONE_4){
          searchBg.frame = CGRectMake(0, 0, 320, 480);
          GemsDialogView.frame = CGRectMake(0, 0, 320, 480);
     }else if (IS_IPHONE_5){
          GemsDialogView.frame = CGRectMake(0, 0, 320, 568);
     }else if (IS_IPHONE_6){
          GemsDialogView.frame = CGRectMake(0, 0, 375, 667);
     }
     
     appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     
     [self SendSelfImageView];
     NSString *val = [SharedManager getInstance]._userProfile.cashablePoints;
     if ([val intValue] < 0) {
          [SharedManager getInstance]._userProfile.cashablePoints = @"0";
          
     }
     [lblGemsPoints setText:[[SharedManager getInstance] _userProfile].cashablePoints];
     [lblStarsPoints setText:[[SharedManager getInstance] _userProfile].totalPoints];
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
     if(IS_IPAD)
     {
         PlayNowLabel.font = [UIFont fontWithName:FONT_NAME size:18];
          challengeAFriend.font = [UIFont fontWithName:FONT_NAME size:18];
          forGemsLable.font = [UIFont fontWithName:FONT_NAME size:18];
          forPointsLabel.font = [UIFont fontWithName:FONT_NAME size:18];
          
     }
     senderNameLbl.font = [UIFont fontWithName:FONT_NAME size:16];
     backBtn2.font = [UIFont fontWithName:FONT_NAME size:16];
     
     currentSelectedIndex = -1;
     
}
-(void) setUpTutorial {
     
     [self setLanguageForScreen];
     
     if (!sectionTitleArray) {
          sectionTitleArray = [NSMutableArray arrayWithObjects:@"", nil];
     }
     if (!arrayForBool) {
          arrayForBool    = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO] , nil];
     }
     if (!sectionContentDict) {
          sectionContentDict  = [[NSMutableDictionary alloc] init];
          NSArray *array1     = [NSArray arrayWithObjects:howtoPlay1, howtoPlay2,howtoPlay3, nil];
          [sectionContentDict setValue:array1 forKey:[sectionTitleArray objectAtIndex:0]];
          
          tutorialArray1 = [array1 copy];
     }
}
-(void)SendSelfImageView{
     if([SharedManager getInstance]._userProfile.profile_image.length > 3) {
          MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
          
          MKNetworkOperation *op = [engine operationWithURLString:[SharedManager getInstance]._userProfile.profile_image params:Nil httpMethod:@"GET"];
          
          [op onCompletion:^(MKNetworkOperation *completedOperation) {
               
               [senderProfileImageView setImage:[completedOperation responseImage]];
               [senderProfileImageView roundImageCorner];
               
          } onError:^(NSError* error) {
               
          }];
          
          [engine enqueueOperation:op];
     }
}
-(IBAction)ShowRightMenu:(id)sender{
     [self.view endEditing:YES];
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}

#pragma mark ----------------------
#pragma mark TableView Data Source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     if(tableView.tag == 5) {
          
          UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
          UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
          headerView.tag                  = section;
          headerView.backgroundColor      = [UIColor whiteColor];
          UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20-50, 50)];
          
          if(IS_IPAD) {
               headerView.frame = CGRectMake(0, 0, 597, 90);
               backgroundImage.frame = CGRectMake(0, 0, 597, 90);
               headerString.frame = CGRectMake(0, 0, 597, 90);
               
               
          }
          BOOL manyCells = [[arrayForBool objectAtIndex:section] boolValue];
          
          if(section == 0){
               if (!manyCells) {
                    headerString.text = HowtoPlay;
                    
               }else{
                    headerString.text = HowtoPlay;
               }
               backgroundImage.image = [UIImage imageNamed:@"blueBar.png"];
          }
          else if (section == 1){
               
               if (!manyCells) {
                    headerString.text = HowtoEarnPoints;
               }else{
                    headerString.text = HowtoEarnPoints;
               }
               backgroundImage.image = [UIImage imageNamed:@"pinkBar.png"];
               
               
          }
          
          [headerView addSubview:backgroundImage];
          headerString.textAlignment      = NSTextAlignmentCenter;
          headerString.textColor          = [UIColor whiteColor];
          [headerView addSubview:headerString];
          
          UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
          [headerView addGestureRecognizer:headerTapped];
          
          return headerView;
     }
     return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if(tableView.tag == 5) {
          if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
               if(IS_IPAD) {
                    return 70;
               }
               return 50;
          }
          return 1;
     }
     else {
          float returnValue;
          if ([[UIScreen mainScreen] bounds].size.height == iPad)
          {
               returnValue = 260.0f;
          }
          else
          {
               returnValue = 140.0f;
          }
          return returnValue;
     }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     
     if(tableView.tag == 5) {
          return [sectionTitleArray count];
     }
     return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     
     if(tableView.tag == 5) {
          if ([[arrayForBool objectAtIndex:section] boolValue]) {
               if(section == 0){
                    return tutorialArray1.count;
               }
               else if(section == 1){
                    return tutorialArray2.count;
               }
          }
          return 1;
     }
     else {
          int indexToBeReturned = (subtopicsArray.count/5)*3;
          if(subtopicsArray.count % 5 != 0){
               if(subtopicsArray.count %5 >2){
                    indexToBeReturned = indexToBeReturned+2;
               }
               else{
                    indexToBeReturned++;
               }
          }
          return indexToBeReturned;
     }
     
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     if(tableView.tag == 5) {
          if(IS_IPAD) {
               return 89;
          }
          return 49;
     }
     else return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     if(indexPath.row % 3 == 2)  {
          indexCounter = (indexPath.row/3)+1;
     }
     else if (indexPath.row % 3 == 1 || indexPath.row % 3 == 0) {
          if(indexPath>2){
               indexCounter = indexPath.row/3;
          }
     }
     
     if(tableView.tag == 5) {
          static NSString *CellIdentifier = @"Cell";
          UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
          if (cell == nil) {
               cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
               if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
               }
          }
          BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
          if (!manyCells) {
               cell.textLabel.text = @"click to enlarge";
          }
          else{
               
               int row = indexPath.section;
               if(row == 0){
                    cell.textLabel.text = [tutorialArray1 objectAtIndex:indexPath.row];
               }
               else if(row == 1){
                    cell.textLabel.text = [tutorialArray2 objectAtIndex:indexPath.row];
               }
               else if(row == 2){
                    cell.textLabel.text = [tutorialArray3 objectAtIndex:indexPath.row];
               }
               cell.textLabel.numberOfLines = 3;
               cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:13];
               cell.textLabel.textAlignment = NSTextAlignmentLeft;
               
               if (languageCode == 1) {
                    cell.textLabel.textAlignment = NSTextAlignmentRight;
               }
               if(IS_IPAD) {
                    cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:25];
               }
          }
          return cell;
     }
     else {
          if(indexPath.row == 0 || indexPath.row%2 != 0)
          {
               SubTopicCC *cell;
               if ([[UIScreen mainScreen] bounds].size.height == iPad) {
                    
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubTopicCC_iPad" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
               }
               else{
                    
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubTopicCC" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
               }
               
               // here
               
               int i = indexPath.row;
               int index= i+(i-indexCounter);
               
               TopicModel *tempTopic = [subtopicsArray objectAtIndex:index];
               cell.leftTitle.text = tempTopic.title;
            
               // here
               cell.leftTitle.font = [UIFont fontWithName:FONT_NAME size:15];
                cell.leftSubTitles.font = [UIFont fontWithName:FONT_NAME size:38];
               if(IS_IPAD)
               {
                    cell.leftTitle.font = [UIFont fontWithName:FONT_NAME size:25];
                    cell.leftSubTitles.font = [UIFont fontWithName:FONT_NAME size:45];
               }
               cell.leftOverLay.tag = index;
               //cell.rightOverLay.tag = index;
               [HelperFunctions setBackgroundColor:cell.leftOverLay];
               
               if(tempTopic.subTopicsArray.count > 0) {
                    cell.leftSubTitles.text = [NSString stringWithFormat:@"%lu",(unsigned long)tempTopic.subTopicsArray.count];
               }
               else {
                    cell.leftSubTitles.text = @"";
               }
               [cell.leftBtn addTarget:self action:@selector(leftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
               
               cell.leftBtn.tag = index;
               
               if([tempTopic.topic_id intValue] == 22) {
                    // Changes here
//                    NSString * tempId = tempTopic.topic_id;
//                    [self settingNameofImage:tempId];
                    NSString * tempId = tempTopic.topic_id;
                    [self settingNameofImage:tempId];
                    cell.leftImg.image = [UIImage imageNamed:[NSString stringWithFormat:subcatMaintempImgName]];
                    
                    if(!([subcatthumbnailtempName isEqualToString:@""] || subcatthumbnailtempName == nil)){
                     cell.leftImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:subcatthumbnailtempName]];
                    }
                    
//
//                    cell.leftImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Science.png",tempTopic.title]];
//                    cell.leftImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon.png",tempTopic.title]];
               }
               else {
                    
                    NSString * tempId = tempTopic.topic_id;
                    [self settingNameofImage:tempId];
                    cell.leftImg.image = [UIImage imageNamed:[NSString stringWithFormat:subcatMaintempImgName]];
                    
                  if(!([subcatthumbnailtempName isEqualToString:@""] || subcatthumbnailtempName == nil)){
                       
                                        cell.leftImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:subcatthumbnailtempName]];
                  }
                    
//                    cell.leftImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",tempTopic.title]];
//                    cell.leftImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon.png",tempTopic.title]];
               }
               
               //
               
               
               
               
               if(index+1 < subtopicsArray.count){
                    TopicModel *tempTopic = [subtopicsArray objectAtIndex:index+1];
                    cell.rightTitle.text = tempTopic.title;
                    
                    NSString * tempId = tempTopic.topic_id;
                    [self settingNameofImage:tempId];
                    
                    cell.rightImg.image = [UIImage imageNamed:[NSString stringWithFormat:subcatMaintempImgName]];
                      if(!([subcatthumbnailtempName isEqualToString:@""] || subcatthumbnailtempName == nil)){
                           
                           cell.rightImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:subcatthumbnailtempName]];
                      }
                    
                    
//                    cell.rightImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",tempTopic.title]];
//                    // changes here
//                    cell.rightImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon.png",tempTopic.title]];
                   
                    
                    //                    cell.rightImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon.png",tempTopic.title]];
                    //                    cell.rightImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",tempTopic.title]];
                    //                    cell.rightImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon.png",tempTopic.title]];
                    
                    
                    
                     cell.rightTitle.font = [UIFont fontWithName:FONT_NAME size:15];
                     cell.rightSubTitles.font = [UIFont fontWithName:FONT_NAME size:38];
                    if(IS_IPAD)
                    {
                         cell.rightTitle.font = [UIFont fontWithName:FONT_NAME size:25];
                         cell.rightSubTitles.font = [UIFont fontWithName:FONT_NAME size:45];
                         
                    }
                   
                    if(tempTopic.subTopicsArray.count > 0) {
                         cell.rightSubTitles.text = [NSString stringWithFormat:@"%lu",(unsigned long)tempTopic.subTopicsArray.count];
                    }
                    else {
                         cell.rightSubTitles.text = @"";
                    }
                    [cell.rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    cell.rightBtn.tag = index+1;
                    cell.rightOverLay.tag = index+1;
                    //               cell.rightOverLay.tag = index;
                    [HelperFunctions setBackgroundColor:cell.rightOverLay];
                    
               }
               else {
                    cell.rightBtn.enabled = false;
                    cell.rightImg.hidden = true;
                    cell.rightImgThumbnail.hidden = true;
                    cell.rightSubTitles.hidden = true;
                    cell.rightTitle.hidden = true;
               }
               cell.selectionStyle = NAN;
               [cell setBackgroundColor:[UIColor clearColor]];
               [cell.contentView setBackgroundColor:[UIColor clearColor]];
               return cell;
          }
          else
          {
               SubTopicSelectedCC *cell ;
               if ([[UIScreen mainScreen] bounds].size.height == iPad) {
                    
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubTopicSelectedCC_iPad" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
               }
               else{
                    
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubTopicSelectedCC" owner:self options:nil];
                    cell = [nib objectAtIndex:0];
               }
               int i = indexPath.row;
               int index= (i+(i-indexCounter))+1;
               cell.OverLayMain.tag = index;
               //               cell.rightOverLay.tag = index;
               [HelperFunctions setBackgroundColor:cell.OverLayMain];
               
               TopicModel *tempTopic = [subtopicsArray objectAtIndex:index];
               cell.mainTitle.text = tempTopic.title;
                cell.mainTitle.font = [UIFont fontWithName:FONT_NAME size:15];
               cell.mainSubTitle.font = [UIFont fontWithName:FONT_NAME size:38];
               if(IS_IPAD)
               {
                    cell.mainTitle.font = [UIFont fontWithName:FONT_NAME size:25];
                    cell.mainSubTitle.font = [UIFont fontWithName:FONT_NAME size:45];
               }
               if(tempTopic.subTopicsArray.count > 0) {
                    cell.mainSubTitle.text = [NSString stringWithFormat:@"%lu",(unsigned long)tempTopic.subTopicsArray.count];
               }
               else {
                    cell.mainSubTitle.text = @"";
               }
               ///Changes here
               
               
               NSString * tempId = tempTopic.topic_id;
               [self settingNameofImage:tempId];

                              cell.mainImg.image = [UIImage imageNamed:[NSString stringWithFormat:subcatMaintempImgName]];
                if(!([subcatthumbnailtempName isEqualToString:@""] || subcatthumbnailtempName == nil)){
                              cell.mainImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:subcatthumbnailtempName]];
                }
               
               
//               cell.mainImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",tempTopic.title]];
//               cell.mainImgThumbnail.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon.png",tempTopic.title]];
               [cell.mainBtn addTarget:self action:@selector(mainBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
               cell.mainBtn.tag = index;
               [cell setBackgroundColor:[UIColor clearColor]];
               [cell.contentView setBackgroundColor:[UIColor clearColor]];
               return cell;
               
          }
     }
     
}

//

#pragma mark - TableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
     
}

-(void)PlayNowSlected:(id)sender{
     
     isChallenge = false;
     if (languageCode == 1) {
          
          willhelpinRanking.textAlignment = UIControlContentHorizontalAlignmentRight;
          willHelpinEarnMoney.textAlignment = UIControlContentHorizontalAlignmentRight;
          
          if (IS_IPAD) {
               starImage.hidden = YES;
               gemImage.hidden = YES;
               
               starimg2.hidden = NO;
               gemimg2.hidden = NO;
               
          }else{
               starImage.frame = CGRectMake(265, starImage.frame.origin.y+2, 35, 32);
               gemImage.frame = CGRectMake(270, gemImage.frame.origin.y+2, 25, 25);
               
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
               gemImage.frame = CGRectMake(13, gemImage.frame.origin.y+2, 25, 25);
               
          }
          
     }
     
     UIButton *playBtn = (UIButton *)sender;
     currentSelectedIndex = playBtn.tag;
     
     [self.view addSubview:GemsDialogView];
     
}

-(void)discussionSelected:(id)sender{
     
     UIButton *tempBtn = (UIButton *)sender;
     Topic *tempTopic = [subtopicsArray objectAtIndex:tempBtn.tag];
     
     DiscussionVC *diss = [[DiscussionVC alloc] initWithSub_Topic:tempTopic];
     diss.isNewDiscussion = YES;
     [self.navigationController pushViewController:diss animated:YES];
}

-(void)challengeSelected:(id)sender{
     
     isChallenge = true;
     
     [self setLanguageForScreen];
     if (languageCode == 1) {
          
          willhelpinRanking.textAlignment = UIControlContentHorizontalAlignmentRight;
          willHelpinEarnMoney.textAlignment = UIControlContentHorizontalAlignmentRight;
          
          if (IS_IPAD) {
               starImage.hidden = YES;
               gemImage.hidden = YES;
               
               starimg2.hidden = NO;
               gemimg2.hidden = NO;
               
          }else{
               starImage.frame = CGRectMake(265, starImage.frame.origin.y +2, 35, 32);
               gemImage.frame = CGRectMake(270,  gemImage.frame.origin.y +2, 25, 25);
               
          }
          
     }else{
          willhelpinRanking.textAlignment = UIControlContentHorizontalAlignmentLeft;
          willHelpinEarnMoney.textAlignment = UIControlContentHorizontalAlignmentLeft;
          
          if (IS_IPAD) {
               starImage.autoresizingMask = UIViewAutoresizingNone;
               starImage.frame = CGRectMake(32, 246, 60, 53);
               gemImage.frame = CGRectMake(37, 309, 51, 53);
          }else{
               starImage.frame = CGRectMake(8,  starImage.frame.origin.y +2, 35, 32);
               gemImage.frame = CGRectMake(13,  gemImage.frame.origin.y +2, 25, 25);
          }
     }
     [self setLanguageForScreen];
     
     UIButton *playBtn = (UIButton *)sender;
     currentSelectedIndex = playBtn.tag;
     
     [self.view addSubview:GemsDialogView];
     
}
-(void)rankingsSelected:(id)sender{
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          RankingVC *rank = [[RankingVC alloc] initWithNibName:@"RankingVC_iPad" bundle:nil];
          [self.navigationController pushViewController:rank animated:YES];
     }
     else{
          
          RankingVC *rank = [[RankingVC alloc] initWithNibName:@"RankingVC" bundle:nil];
          [self.navigationController pushViewController:rank animated:YES];
     }
     
     
}

- (IBAction)homePressed:(id)sender {
     for (UIViewController *controller in self.navigationController.viewControllers) {
          
          if ([controller isKindOfClass:[HomeVC class]]) {
               
               [self.navigationController popToViewController:controller animated:YES];
               break;
          }
     }
}

- (IBAction)topicsPressed:(id)sender {
     
     [addQuestion removeFromSuperview];
     ThirdLayerVC *tempVC = [[ThirdLayerVC alloc] initWithAllSubTopics];
     [self.navigationController pushViewController:tempVC animated:NO];
     
}

- (IBAction)newContentPressed:(id)sender {
     [self.view addSubview:addQuestion];
     addQuestion.hidden = NO;
}

- (IBAction)guidelinesPressed:(id)sender {
     [expandView reloadData];
     [self.view addSubview:tutorialView];
}

- (IBAction)gameQuit:(id)sender {
     [self.tabBarController.tabBar setHidden:NO];
     isGameStarted = true;
     [timer invalidate];
     [opponentProfileImageView stopAnimating];
     [animationTimer invalidate];
     timer = nil;
     _gmGemsSelected = false;
     _gmChallengeSelected = false;
     UIView *effectView = [self.view viewWithTag:499];
     [effectView removeFromSuperview];
     
    
     /////
     AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
     del.friendToBeChalleneged = nil;
     del.requestType = nil;
   
     
     _gameModView.hidden = true;
     [_gameModView removeFromSuperview];
     [searchingView removeFromSuperview];
     [sharedManager closeWebSocket];
}


- (IBAction)addQuestionView:(id)sender {
     addQuestion.hidden = true;
}
- (IBAction)sendQuestion:(id)sender {
     
     
     if (answerTxt.text.length < 1) {
          NSString *message;
          if (languageCode == 0 ) {
               message = ENTER_ANSWER;
          }else if (languageCode == 1){
               message = ENTER_ANSWER_1;
          }else if (languageCode == 2){
               message = ENTER_ANSWER_2;
          }else if (languageCode == 3){
               message = ENTER_ANSWER_3;
          }else if (languageCode == 4){
               message = ENTER_ANSWER_4;
          }
          
          
          UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil, nil];
          [toast show];
          
          int duration = 1; // duration in seconds
          
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
               [toast dismissWithClickedButtonIndex:0 animated:YES];
          });
     }else if (questionTxt.text.length<1){
          NSString *message;
          if (languageCode == 0 ) {
               message = @"Enter Question!";
          }else if (languageCode == 1){
               message = @"ادخل السؤال";
          }else if (languageCode == 2){
               message = @"Entrez question";
          }else if (languageCode == 3){
               message = @"Introduzca pregunta";
          }else if (languageCode == 4){
               message = @"Digite Pergunta";
          }
          
          
          UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil, nil];
          [toast show];
          
          int duration = 1; // duration in seconds
          
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
               [toast dismissWithClickedButtonIndex:0 animated:YES];
          });
          
     }else{
          
          
          NSString *emailTitle = @"User Choice Question";
          // Email Content
          NSString *messageBody = [NSString stringWithFormat:@"Question: %@ \nAnswer: %@",questionTxt.text,answerTxt.text];
          // To address
          NSArray *toRecipents = [NSArray arrayWithObject:@"wits.addnewcontent@gmail.com"];
          
          MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
          mc.mailComposeDelegate = self;
          [mc setSubject:emailTitle];
          [mc setMessageBody:messageBody isHTML:NO];
          [mc setToRecipients:toRecipents];
          
          // Present mail view controller on screen
          [self presentViewController:mc animated:YES completion:NULL];
     }
     [questionTxt resignFirstResponder];
     [answerTxt resignFirstResponder];
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
     switch (result)
     {
          case MFMailComposeResultCancelled:
               NSLog(@"Mail cancelled");
               break;
          case MFMailComposeResultSaved:
               NSLog(@"Mail saved");
               break;
          case MFMailComposeResultSent:
               NSLog(@"Mail sent");
               break;
          case MFMailComposeResultFailed:
               NSLog(@"Mail sent failure: %@", [error localizedDescription]);
               break;
          default:
               break;
     }
     // Close the Mail Interface
     [self dismissViewControllerAnimated:YES completion:NULL];
     
     addQuestion.hidden = YES;
}

-(void)TimeUp{
     
     TopicModel *tempSubTopic = [subtopicsArray objectAtIndex:currentSelectedIndex];
     //[[SocketManager getInstance] StartPlayingWithOponent:@"2" ndParentTopicId:tempSubTopic.topic_id];
}

-(void)displayNameAndImage{
     
     if([SharedManager getInstance]._userProfile.profile_image.length > 3) {
          senderNameLbl.text = [SharedManager getInstance]._userProfile.display_name;
          AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
          if(delegate.profileImage) {
               [senderProfileImageView setImage:delegate.profileImage];
               [senderProfileImageView roundImageCorner];
          }
          else {
               MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
               MKNetworkOperation *op = [engine operationWithURLString:[SharedManager getInstance]._userProfile.profile_image params:Nil httpMethod:@"GET"];
               
               [op onCompletion:^(MKNetworkOperation *completedOperation) {
                    [senderProfileImageView setImage:[completedOperation responseImage]];
                    [senderProfileImageView roundImageCorner];
                    
               } onError:^(NSError* error) {
                    senderProfileImageView.image = [UIImage imageNamed:@"personal.png"];
                    
                    /*UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Cannot Fetch Image" message:@"Network Unreachable" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                     [alert show];*/
                    
               }];
               
               [engine enqueueOperation:op];
          }
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
     
     [spinnerImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}

- (IBAction)tutorialBackPressed:(id)sender {
     [tutorialView removeFromSuperview];
}

#pragma mark - TextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [textField resignFirstResponder];
     return YES;
}

#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
     if (indexPath.row == 0) {
          BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
          collapsed       = !collapsed;
          [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
          
          //reload specific section animated
          NSRange range   = NSMakeRange(indexPath.section, 1);
          NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
          [expandView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
     }
}

- (IBAction)mainBackPressed:(id)sender {
     
     [timer invalidate];
     timer = nil;
     [topicTblView reloadData];
     
     [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
     [self filterContentForSearchText:searchString];
     
     // Return YES to cause the search result table view to be reloaded.
     return YES;
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView  {
     
     tableView.frame = topicTblView.frame;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
     self.navigationController.navigationBar.hidden = YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
     self.navigationController.navigationBar.hidden = YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)filterContentForSearchText:(NSString*)str{
     // for inCaseSensitive search
     str = [str uppercaseString];
     
     NSMutableArray *ar=[NSMutableArray array];
     //     for (CategoryModel *d in [SharedManager getInstance].categoryArray) {
     //          NSString *strOriginal = d.title;
     //          //          // for inCaseSensitive search
     //          strOriginal = [strOriginal uppercaseString];
     //
     //          if([strOriginal hasPrefix:str]) {
     //               [ar addObject:d];
     //
     //          }
     //
     //     }
     for (TopicModel *t in subtopicsArray) {
          NSString *  strOriginal = t.title;
          //          // for inCaseSensitive search
          strOriginal = [strOriginal uppercaseString];
          
          if([strOriginal hasPrefix:str]) {
               
               [ar addObject:t];
          }
          
     }
     //     for (SubTopicsModel *s in [SharedManager getInstance].subTopicsArray) {
     //          NSString * strOriginal = s.title;
     //          //          // for inCaseSensitive search
     //          strOriginal = [strOriginal uppercaseString];
     //          if([strOriginal hasPrefix:str]) {
     //
     //               [ar addObject:s];
     //          }
     //
     //     }
     
     topicsArrayForSearch = ar;
}

#pragma mark Socket Communication Methods
- (void) connectToSocket {
     
     //UI for Socket connection and User searching
     [self displayNameAndImage];
     if(IS_IPHONE_5) {
          searchingView.frame = CGRectMake(0, 0, 320, 568);
     }
     else if(IS_IPHONE_4) {
          searchBg.frame = CGRectMake(0, 0, 320, 480);
          searchingView.frame = CGRectMake(0, 0, 320, 480);
     }
     [self.view addSubview:searchingView];
     _loaderIndex = 1;
     timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
   
     NSMutableArray *images = [[NSMutableArray alloc] init];
     for (int i = 0; i < imageNames.count; i++) {
          [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
     }
     
     opponentProfileImageView.animationImages = images;
     opponentProfileImageView.animationDuration = 6.0f;
     [opponentProfileImageView startAnimating];
     animationTimer= [NSTimer timerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(onTimer)
                                            userInfo:nil
                                             repeats:YES];
     
     [[NSRunLoop currentRunLoop] addTimer:animationTimer forMode:NSDefaultRunLoopMode];
     [animationTimer fire];
     for(int i = 1; i<5; i++) {
          UIImageView *dot = (UIImageView*)[_searchingLoaderView viewWithTag:i];
          
          if(i == _loaderIndex) {
               dot.image = [UIImage imageNamed:@"dotglow.png"];
          }
          else {
               dot.image = [UIImage imageNamed:@"dotblack.png"];
          }
    
     }
     //Socket Connection Code
     sharedManager = [SocketManager getInstance];
     sharedManager.socketdelegate = nil;
     sharedManager.socketdelegate = self;
     [sharedManager openSockets];
}
-(void)onTimer{
     [UIView animateWithDuration:1.0 animations:^{
          opponentProfileImageView.alpha = 0.0;
     }];
     [UIView animateWithDuration:1.0 animations:^{
          opponentProfileImageView.alpha = 1.0;
     }];
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
     if(timeSinceTimer == 180) {
          if(!isOpponentFound) {
               [timer invalidate];
               timer = nil;
               
               [searchingView removeFromSuperview];
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

#pragma mark Challenge
- (void) tick:(NSTimer *) timer {
     if(sharedManager.socketIO.isConnected) {
          NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          languageCode = [language intValue];
          _searchOppLbl.textAlignment = NSTextAlignmentCenter;
         _searchOppLbl.textColor = [UIColor colorWithRed:(255/255.f) green:(228/255.f) blue:(1/255.f) alpha:1];
          if (languageCode == 0) {
               _searchOppLbl.text = @"VS";
          }else if(languageCode == 1){
               _searchOppLbl.text = VS_1;
          }else if (languageCode == 2 ){
               _searchOppLbl.text =VS_2;
          }else if (languageCode == 3){
               _searchOppLbl.text = VS_3;
          }else if (languageCode == 4){
               _searchOppLbl.text = VS_4;
          }
          [searchingView removeFromSuperview];
          appDelegate.friendToBeChalleneged = nil;
          UIView *effectView = [self.view viewWithTag:499];
          [effectView removeFromSuperview];
          _gmGemsSelected = false;
          _gmChallengeSelected = false;
          _gameModView.hidden = true;
          [_gameModView removeFromSuperview];
          isOpponentFound = true;
          ChallengeVC *_challengeVC = [[ChallengeVC alloc] initWithChallenge:_challenge andRecieved:true];
          [self.navigationController pushViewController:_challengeVC animated:YES];
     }
     
}
- (void) tickForChallenege:(NSTimer *) timer {
     if(sharedManager.socketIO.isConnected) {
          NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          languageCode = [language intValue];
          _searchOppLbl.textAlignment = NSTextAlignmentCenter;
           _searchOppLbl.textColor = [UIColor colorWithRed:(255/255.f) green:(228/255.f) blue:(1/255.f) alpha:1];
          
          if (languageCode == 0) {
               _searchOppLbl.text = @"VS";
          }else if(languageCode == 1){
               _searchOppLbl.text = VS_1;
          }else if (languageCode == 2 ){
               _searchOppLbl.text =VS_2;
          }else if (languageCode == 3){
               _searchOppLbl.text = VS_3;
          }else if (languageCode == 4){
               _searchOppLbl.text = VS_4;
          }
          [searchingView removeFromSuperview];
          
          appDelegate.friendToBeChalleneged = nil;
          UIView *effectView = [self.view viewWithTag:499];
          [effectView removeFromSuperview];
          _gmGemsSelected = false;
          _gmChallengeSelected = false;
          _gameModView.hidden = true;
          [_gameModView removeFromSuperview];
          
          isOpponentFound = true;
          ChallengeVC *challengeTemp = [[ChallengeVC alloc] initWithChallenge:_challenge];
          [self.navigationController pushViewController:challengeTemp animated:YES];
     }
}


#pragma mark Socket Manager Delegate Methods
-(void)DataRevieved:(SocketIOPacket *)packet {
     
     TopicModel *tempToplic = [subtopicsArray objectAtIndex:currentSelectedIndex];
     if([packet.name isEqualToString:@"connected"])
     {
          NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id", nil];
          [sharedManager sendEvent:@"register" andParameters:registerDictionary];
         NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          languageCode = [language intValue];
          
          NSArray* args = packet.args;
          NSDictionary* arg = args[0];
          
          NSString *isVerified = [arg objectForKey:@"msg"];
          if([isVerified isEqualToString:@"verified"] ){
               NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               languageCode = [language intValue];
               
               if(appDelegate.friendToBeChalleneged) {
                    NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",appDelegate.friendToBeChalleneged.friendID,@"friend_id",@"2",@"type",tempToplic.topic_id,@"type_id",language,@"language",requestType,@"challenge_type", nil];
                    [sharedManager sendEvent:@"sendChallenge" andParameters:registerDictionary];
                    
               }
               else {
                    NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",@"2",@"type",tempToplic.topic_id,@"type_id",language,@"language",@"false",@"is_cancel",requestType, @"request_type", nil];
                    [sharedManager sendEvent:@"findPlayerOpponent" andParameters:registerDictionary];
               }
          }

          if(!(_gmChallengeSelected))
          {
               if (languageCode == 0) {
                    _searchOppLbl.text = @"Searching opponent...";
               }else if(languageCode == 1){
                    _searchOppLbl.text = @"االبحث عن الخصم...";
               }else if (languageCode == 2 ){
                    _searchOppLbl.text = @"Recherche d\'un adversaire...";
               }else if (languageCode == 3){
                    _searchOppLbl.text = @"La búsqueda de un oponente...";
               }else if (languageCode == 4){
                    _searchOppLbl.text = @"Procurando um adversário...";
               }
          }else
          {
               if (languageCode == 0) {
                    _searchOppLbl.text = @"Waiting for opponent...";
               }else if(languageCode == 1){
                    _searchOppLbl.text = @"في انتظار الخصم.....";
               }else if (languageCode == 2 ){
                    _searchOppLbl.text = @"Recherche d\'un adversaire...";
               }else if (languageCode == 3){
                    _searchOppLbl.text = @"La búsqueda de un oponente...";
               }else if (languageCode == 4){
                    _searchOppLbl.text = @"Procurando um adversário...";
               }
               
               
          }
     }
     else if([packet.name isEqualToString:@"register"])
     {
          NSArray* args = packet.args;
          NSDictionary* arg = args[0];
          
          NSString *isVerified = [arg objectForKey:@"msg"];
          if([isVerified isEqualToString:@"verified"] ){
               NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               languageCode = [language intValue];
               
               if(appDelegate.friendToBeChalleneged) {
                    NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",appDelegate.friendToBeChalleneged.friendID,@"friend_id",@"2",@"type",tempToplic.topic_id,@"type_id",language,@"language",requestType,@"challenge_type", nil];
                    [sharedManager sendEvent:@"sendChallenge" andParameters:registerDictionary];
                    
               }
               else {
                    NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",@"2",@"type",tempToplic.topic_id,@"type_id",language,@"language",@"false",@"is_cancel",requestType, @"request_type", nil];
                    [sharedManager sendEvent:@"findPlayerOpponent" andParameters:registerDictionary];
               }
          }
     }
     else if([packet.name isEqualToString:@"sendChallenge"])
     {//test
          
          [loadView hide];
          NSArray* args = packet.args;
          NSDictionary *json = args[0];
          
          NSDictionary *innerDictionary = [json objectForKey:[SharedManager getInstance].userID];
          NSString *message = [innerDictionary objectForKey:@"message"];
          int intChallengeID = [[innerDictionary objectForKey:@"challenge_id"] intValue];
          challengeID = [NSString stringWithFormat:@"%d",intChallengeID];
          NSLog(@"challengeid ::::::::%@",challengeID);
          
          opponentProfileImageView.imageURL = [NSURL URLWithString:appDelegate.friendToBeChalleneged.profile_image];
          NSURL *url = [NSURL URLWithString:appDelegate.friendToBeChalleneged.profile_image];
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
               [self.view addSubview:searchingView];
               _loaderIndex = 1;
               
//               for(int i = 1; i<5; i++) {
//                    UIImageView *dot = (UIImageView*)[_searchingLoaderView viewWithTag:i];
//                    if(i == _loaderIndex) {
//                         dot.image = [UIImage imageNamed:@"dotglow.png"];
//                    }
//                    else {
//                         dot.image = [UIImage imageNamed:@"dotblack.png"];
//                    }
  //             }
               
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
                     self.tabBarController.tabBar.hidden = false;
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
                    [timer invalidate];
                    timer = nil;
                    [sharedManager closeWebSocket];
                    [searchingView removeFromSuperview];
                     self.tabBarController.tabBar.hidden = false;
               }
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
               _challenge = [[Challenge alloc] initWithDictionary:userDictInner];
               _challenge.type = @"2";
               _challenge.type_ID = tempToplic.topic_id;
               _challenge.challengeID = challengeID;
               isOpponentFound = true;
               
               [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(tickForChallenege:) userInfo:nil repeats:NO];
          }
          else {
               
          }
     }
     else if ([packet.name isEqualToString:@"cancelChallenge"]) {
          
          [sharedManager closeWebSocket];
          [searchingView removeFromSuperview];
     }
     else if([packet.name isEqualToString:@"findPlayerOpponent"])
     {
          NSArray* args = packet.args;
          NSDictionary *json = (NSDictionary*)args[0] ;
          int flag = [[json objectForKey:@"flag"] intValue];
          if(flag == 3) {
               
               NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               languageCode = [language intValue];
               
               if(!(_gmChallengeSelected))
               {
                    if (languageCode == 0) {
                         _searchOppLbl.text = @"Searching opponent...";
                    }else if(languageCode == 1){
                         _searchOppLbl.text = @"االبحث عن الخصم...";
                    }else if (languageCode == 2 ){
                         _searchOppLbl.text = @"Recherche d\'un adversaire...";
                    }else if (languageCode == 3){
                         _searchOppLbl.text = @"La búsqueda de un oponente...";
                    }else if (languageCode == 4){
                         _searchOppLbl.text = @"Procurando um adversário...";
                    }
               }else
               {
                    if (languageCode == 0) {
                         _searchOppLbl.text = @"Waiting for opponent...";
                    }else if(languageCode == 1){
                         _searchOppLbl.text = @"االبحث عن الخصم...";
                    }else if (languageCode == 2 ){
                         _searchOppLbl.text = @"Recherche d\'un adversaire...";
                    }else if (languageCode == 3){
                         _searchOppLbl.text = @"La búsqueda de un oponente...";
                    }else if (languageCode == 4){
                         _searchOppLbl.text = @"Procurando um adversário...";
                    }
                    
                    
               }
               //Oponent is still searching
               
               NSDictionary *registerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[SharedManager getInstance].userID,@"user_id",@"2",@"type",tempToplic.topic_id,@"type_id",language,@"language",@"false",@"is_cancel",requestType, @"request_type", nil];
               [sharedManager sendEvent:@"findPlayerOpponent" andParameters:registerDictionary];
               
          }
          else if(flag == 1){
               //Oponent Found
               _searchingLoaderView.hidden = true;
               [opponentProfileImageView stopAnimating];
               [animationTimer invalidate
                ];
                
                _searchOppLbl.textColor = [UIColor colorWithRed:(255/255.f) green:(228/255.f) blue:(1/255.f) alpha:1];
          

               //_searchOppLbl.text = @"VS";
               if (languageCode == 0) {
                    _searchOppLbl.text = @"VS";
               }else if(languageCode == 1){
                    _searchOppLbl.text = VS_1;
               }else if (languageCode == 2 ){
                    _searchOppLbl.text =VS_2;
               }else if (languageCode == 3){
                    _searchOppLbl.text = VS_3;
               }else if (languageCode == 4){
                    _searchOppLbl.text = VS_4;
               }

               [timer invalidate];
               timer = nil;
               
               isGameStarted = true;
               
               NSString *oppName = [json objectForKey:@"displayName"];
               opponent.text = oppName;
               NSString *image = [json objectForKey:@"profileImage"];
               
               opponentProfileImageView.imageURL = [NSURL URLWithString:_challenge.opponent_profileImage];
               NSURL *url = [NSURL URLWithString:_challenge.opponent_profileImage];
               [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
               opponentProfileImageView.image = [UIImage imageNamed:@"personal.png"];
               [opponentProfileImageView roundImageCorner];
               _challenge = [[Challenge alloc] initWithDictionary:json];
               _challenge.type = @"2";
               _challenge.type_ID = tempToplic.topic_id;
               
               
               [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(tick:) userInfo:nil repeats:NO];
               
          }
          
          else if(flag == 0){
               
               [searchingView removeFromSuperview];
               NSString *emailMsg;
               NSString *title;
               NSString *cancel;
               if (languageCode == 0 ) {
                    emailMsg = @"You don't have sufficient Gems in your account.";
                    title = @"Error";
                    cancel = CANCEL;
               } else if(languageCode == 1) {
                    emailMsg = @"ليس لديك رصيد كافٍ من الجواهر";
                    title = @"خطأ";
                    cancel = CANCEL_1;
               }else if (languageCode == 2){
                    emailMsg = @"Vous n'avez pas assez de Gems";
                    title = @"Erreur";
                    cancel = CANCEL_2;
               }else if (languageCode == 3){
                    emailMsg = @"YNo tienes suficientes gemas";
                    title = @"Error";
                    cancel = CANCEL_3;
               }else if (languageCode == 4){
                    emailMsg = @"Não tem Gemas suficientes";
                    title = @"erro";
                    cancel = CANCEL_4;
               }
               
               [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
               
               
          }
          
     }
}

-(void)socketDisconnected:(SocketIO *)socket onError:(NSError *)error {
     
     if(!isGameStarted) {
          ////Msg changed by Fiza/////
          NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          languageCode = [language intValue];
          
          if (languageCode == 0) {
               _searchOppLbl.text = @"Something went wrong..";
          }else if(languageCode == 1){
               _searchOppLbl.text = @"لقد حصل خطأ ما";
          }else if (languageCode == 2 ){
               _searchOppLbl.text = @"Erreur: Quelque chose s\'est mal passé";
          }else if (languageCode == 3){
               _searchOppLbl.text = @"Algo salió mal";
          }else if (languageCode == 4){
               _searchOppLbl.text = @"Alguma coisa deu errado";
          }
          
          
          [timer invalidate];
          timer = nil;
          
          [searchingView removeFromSuperview];
          [SocketManager getInstance].socketdelegate = nil;
          
          NSString *message;
          
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               message = @"Sorry, your request cannot be completed.";
               title = @"Something went wrong.";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               message = @"عذرا، لا يمكن إكمال طلبك.";
               title = @"لقد حصل خطأ ما";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               message = @"Désolée, votre demande ne peut être traitée.";
               title = @"Erreur: Quelque chose s\'est mal passé!";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               message = @"Lo sentimos, no podremos procesar su solicitud.";
               title = @"Algo salió mal!";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               message = @"Desculpe, sua solicitação não pode ser atendida.";
               title = @"Alguma coisa deu errado!";
               cancel = CANCEL_4;
          }
          
          
          
          [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
     }
}
-(void)socketError:(SocketIO *)socket disconnectedWithError:(NSError *)error {
     ////Msg changed by Fiza/////
     
     if(!isGameStarted) {
          ////Msg changed by Fiza/////
          NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          languageCode = [language intValue];
          
          if (languageCode == 0) {
               _searchOppLbl.text = @"Something went wrong..";
          }else if(languageCode == 1){
               _searchOppLbl.text = @"لقد حصل خطأ ما";
          }else if (languageCode == 2 ){
               _searchOppLbl.text = @"Erreur: Quelque chose s\'est mal passé";
          }else if (languageCode == 3){
               _searchOppLbl.text = @"Algo salió mal";
          }else if (languageCode == 4){
               _searchOppLbl.text = @"Alguma coisa deu errado";
          }
          [timer invalidate];
          timer = nil;
          
          [searchingView removeFromSuperview];
          [SocketManager getInstance].socketdelegate = nil;
          
          
          NSString *message;
          
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               message = @"Sorry, your request cannot be completed.";
               title = @"Something went wrong.";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               message = @"عذرا، لا يمكن إكمال طلبك.";
               title = @"لقد حصل خطأ ما";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               message = @"Désolée, votre demande ne peut être traitée.";
               title = @"Erreur: Quelque chose s\'est mal passé!";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               message = @"Lo sentimos, no podremos procesar su solicitud.";
               title = @"Algo salió mal!";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               message = @"Desculpe, sua solicitação não pode ser atendida.";
               title = @"Alguma coisa deu errado!";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
     }
}


- (IBAction)PlaywitStars:(id)sender {
     
     requestType = @"points";
     [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     if(IS_IPHONE_4){
          searchBg.frame = CGRectMake(0, 0, 320, 480);
     }
     
     if([SharedManager getInstance]._userProfile.isVerifiedBool) {
          int totalPoints = [[SharedManager getInstance]._userProfile.totalPoints intValue];
          
          NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          int languageCode = [language intValue];
          
          
          if(!(_gmChallengeSelected))
          {
               if (languageCode == 0) {
                    _searchOppLbl.text = @"Searching opponent...";
               }else if(languageCode == 1){
                    _searchOppLbl.text = @"االبحث عن الخصم...";
               }else if (languageCode == 2 ){
                    _searchOppLbl.text = @"Recherche d\'un adversaire...";
               }else if (languageCode == 3){
                    _searchOppLbl.text = @"La búsqueda de un oponente...";
               }else if (languageCode == 4){
                    _searchOppLbl.text = @"Procurando um adversário...";
               }
          }else
          {
               if (languageCode == 0) {
                    _searchOppLbl.text = @"Waiting for opponent...";
               }else if(languageCode == 1){
                    _searchOppLbl.text = @"االبحث عن الخصم...";
               }else if (languageCode == 2 ){
                    _searchOppLbl.text = @"Recherche d\'un adversaire...";
               }else if (languageCode == 3){
                    _searchOppLbl.text = @"La búsqueda de un oponente...";
               }else if (languageCode == 4){
                    _searchOppLbl.text = @"Procurando um adversário...";
               }
               
               
          }
          
          
          if(isChallenge == true){
               
               [self gameModCanelBtnPressed:nil];
               
               TopicModel *tempToplic = [subtopicsArray objectAtIndex:currentSelectedIndex];
               ChallengeFriendsVC *challenge = [[ChallengeFriendsVC alloc] initWithTopic_ID:@"2" andSubTopic:tempToplic.topic_id];
               [self.navigationController pushViewController:challenge animated:YES];
               AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
               del.friendToBeChalleneged = false;
               _gmGemsSelected = false;
               _gmChallengeSelected = false;
          }else{
               
               timeSinceTimer = 0;
               [self connectToSocket];
          }
     }
     else {
          
          
          NSString *message;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               message = @"Please verify your account to play game";
               title = @"Verification Required";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               message = @"يرجى التحقق من حسابك للعب";
               title = @"مطلوب التحقق";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               message = @"Se il vous plaît vérifier votre compte pour jouer";
               title = @"Vérification demandée";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               message = @"Por favor, verifique su cuenta para jugar";
               title = @"Comprobación solicitada";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               message = @"Por favor, verifique sua conta para jogar";
               title = @"Verificação requerida";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:CANCEL OtherButton:nil];
          
     }
     
     
}

- (IBAction)PlaywithGems:(id)sender {
     
     requestType = @"gems";
     [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     if(IS_IPHONE_4){
          searchBg.frame = CGRectMake(0, 0, 320, 480);
     }
     
     if([SharedManager getInstance]._userProfile.isVerifiedBool) {
          int totalPoints = [[SharedManager getInstance]._userProfile.cashablePoints intValue];
          if (totalPoints < 10) {
               // not enough gems to pay game, show dialog and on ok take user to store
               UIView *effectView = [self.view viewWithTag:499];
               [effectView removeFromSuperview];
               _gameModView.hidden = true;
               [_gameModView removeFromSuperview];
              // self.tabBarController.selectedIndex = 2;
               buyGemsView.hidden = false;
               [self.view addSubview:buyGemsView];
               
               buygemsdesc.text = @"You do not have enough Gems to continue. Do you want to purchase Gems now?";
               buygemsHeading.text = @"Confirmation";
               
               [_acceptbuygems setTitle:@"Buy Now" forState:UIControlStateNormal];
               [_rejectbuygems setTitle:@"Cancel" forState:UIControlStateNormal];
               if(languageCode == 1){
                    
                    buygemsdesc.text = @"لم يكن لديك ما يكفي من الأحجار الكريمة للمتابعة. هل ترغب في شراء الأحجار الكريمة الآن؟";
                    buygemsHeading.text = @"!التأكيد";
                    
                    [_acceptbuygems setTitle:@"اشتري الآن" forState:UIControlStateNormal];
                    [_rejectbuygems setTitle:@"إلغاء" forState:UIControlStateNormal];
                    
               }
               else if (languageCode == 2){
                    
                    buygemsdesc.text = @"Vous ne disposez pas de suffisamment de gemmes pour continuer. Vous voulez acheter Gems maintenant?";
                    buygemsHeading.text = @"Confirmation!";
                    
                    [_acceptbuygems setTitle:@"Achetez maintenant" forState:UIControlStateNormal];
                    [_rejectbuygems setTitle:@"Annuler" forState:UIControlStateNormal];
               }
               else if (languageCode == 3){
                   
                    buygemsdesc.text = @">No tienes suficientes Gemas para continuar. ¿Quieres comprar Gemas ahora?";
                    buygemsHeading.text = @"¡Confirmación!";
                    
                    [_acceptbuygems setTitle:@"Comprar" forState:UIControlStateNormal];
                    [_rejectbuygems setTitle:@"Cancelar" forState:UIControlStateNormal];
               }
               else if (languageCode == 4){
                  
                    buygemsdesc.text = @"Você não tem Gems suficientes para continuar. Você deseja comprar mais Gems agora?";
                    buygemsHeading.text = @"Confirmação!";
                    
                    [_acceptbuygems setTitle:@"Compre Agora" forState:UIControlStateNormal];
                    [_rejectbuygems setTitle:@"Cancelar" forState:UIControlStateNormal];               }
          }
          else {
               NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
               int languageCode = [language intValue];
               
               if(!(_gmChallengeSelected))
               {
                    if (languageCode == 0) {
                         _searchOppLbl.text = @"Searching opponent...";
                    }else if(languageCode == 1){
                         _searchOppLbl.text = @"االبحث عن الخصم...";
                    }else if (languageCode == 2 ){
                         _searchOppLbl.text = @"Recherche d\'un adversaire...";
                    }else if (languageCode == 3){
                         _searchOppLbl.text = @"La búsqueda de un oponente...";
                    }else if (languageCode == 4){
                         _searchOppLbl.text = @"Procurando um adversário...";
                    }
               }else
               {
                    if (languageCode == 0) {
                         _searchOppLbl.text = @"Waiting for opponent...";
                    }else if(languageCode == 1){
                         _searchOppLbl.text = @"في انتظار الخصم.....";
                    }else if (languageCode == 2 ){
                         _searchOppLbl.text = @"Recherche d\'un adversaire...";
                    }else if (languageCode == 3){
                         _searchOppLbl.text = @"La búsqueda de un oponente...";
                    }else if (languageCode == 4){
                         _searchOppLbl.text = @"Procurando um adversário...";
                    }
                    
                    
               }
               
               if(isChallenge == true){
                    
                    [self gameModCanelBtnPressed:nil];
                    TopicModel *tempToplic = [subtopicsArray objectAtIndex:currentSelectedIndex];
                    ChallengeFriendsVC *challenge = [[ChallengeFriendsVC alloc] initWithTopic_ID:@"2" andSubTopic:tempToplic.topic_id];
                    [self.navigationController pushViewController:challenge animated:YES];
                    AppDelegate *del = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    del.friendToBeChalleneged = false;
                    _gmGemsSelected = false;
                    _gmChallengeSelected = false;
                    
               }else{
                    timeSinceTimer = 0;
                    [self connectToSocket];
               }
          }
     }
     else {
          
          
          NSString *message;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               message = @"Please verify your account to play game";
               title = @"Verification Required";
               cancel = CANCEL;
          } else if(languageCode == 1) {
               message = @"يرجى التحقق من حسابك للعب";
               title = @"مطلوب التحقق";
               cancel = CANCEL_1;
          }else if (languageCode == 2){
               message = @"Se il vous plaît vérifier votre compte pour jouer";
               title = @"Vérification demandée";
               cancel = CANCEL_2;
          }else if (languageCode == 3){
               message = @"Por favor, verifique su cuenta para jugar";
               title = @"Comprobación solicitada";
               cancel = CANCEL_3;
          }else if (languageCode == 4){
               message = @"Por favor, verifique sua conta para jogar";
               title = @"Verificação requerida";
               cancel = CANCEL_4;
          }
          
          [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:CANCEL OtherButton:nil];
          
          /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Verification Required" message:@"Please verify your account to play game" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
           [alertView show];*/
     }
     
}

- (IBAction)CloseGemsDialog:(id)sender {
     [GemsDialogView removeFromSuperview];
     
}


#pragma mark Set Language

-(void)setLanguageForScreen {
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     PlayNowLabel.textColor=[UIColor colorWithRed:183.0/255.0f green:216.0/255.0f blue:255.0/255.0f alpha:1.0];
     challengeAFriend.textColor = [UIColor whiteColor];
     forPointsLabel.textColor=[UIColor colorWithRed:183.0/255.0f green:216.0/255.0f blue:255.0/255.0f alpha:1.0];
     forGemsLable.textColor = [UIColor whiteColor];
     [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsNew.png"] forState:UIControlStateNormal];
     [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsglowNew.png"] forState:UIControlStateNormal];
     [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"Newplaynowglow.png"] forState:UIControlStateNormal];
     [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"Newchallengenow.png"] forState:UIControlStateNormal];
     if(languageCode == 0 ) {
          loadingTitle = Loading;
          searchBar.placeholder = SEARCH_CATEGORY;
          
          
          
          knowledgeLbl.text = KNOWLEDGE_LBL;
          tutoDesc1.text = TUTORIAL_DESC_LBL;
          tutoDesc2.text = TUTORIAL_DESC_LBL2;
          
          howtoPlay1 = @"Embark on a 1-1 challenge against anyone in the world.";
          howtoPlay2 = @"The faster you answer the more Gems you'll collect.";
          howtoPlay3 = @"Claim your rewards.";
          
          howtouseStoreDesc = @"Sign up now and get your hands on 1000 free Gems.";
          howtoEarnPointDesc = @"You can always earn free Points simply by inviting your friends and sharing the app on Facebook or Twitter.";
          HowtoPlay = @"How to Play";
          HowWitsStore = @"How to Use WITS Store";
          HowtoEarnPoints = @"How to Earn Free Points";
          
          lblPlayforPoints.text = PLAY_NOW;
          lblplayforGems.text = Challenge_a_friend;
          PlayNowLabel.text =PLAY_NOW;
          challengeAFriend.text = Challenge_a_friend;
          forGemsLable.text = For_Gems;
          forPointsLabel.text = For_Points;
          
          willhelpinRanking.text = WILL_HELP_IN_RANKING;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY;
          
          AddaQuestion.text = ADD_QUESTION;
          answerTxt.placeholder = ENTER_ANSWER;
          questionTxt.placeholder = @"Enter a Question";
          
          homeLbl.text = HOME_BTN;
          CategoriesLbl.text = @"Sub Topics";
          adContentLbl.text = ADD_CONTENT;
          guidelineLbl.text = GUIDELINES;
          
          [backBtn2 setTitle:@"Cancel" forState:UIControlStateNormal];
          [sendQuestion setTitle:SEND forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN forState:UIControlStateNormal];
     }
     else if(languageCode == 1 ) {
          
          loadingTitle = Loading_1;
          searchBar.placeholder = SEARCH_CATEGORY_1;
          forGemsLable.text = For_Gems1;
          forPointsLabel.text = For_Points1;
          howtoPlay1 = @"أسرع في دخول تحدي ضد أي شخص في العالم ";
          howtoPlay2 = @"اسرع في الاجابة للحصول على نقاط اكثر";
          howtoPlay3 = @"قم باستبدال جواهرك بنقود حقيقية.";
          howtouseStoreDesc = @"اشترك الآن و احصل على 1000 نقطة مجانا.";
          howtoEarnPointDesc = @"يمكنك أن تحصل دائماً على النقاط مجانية بمجرد دعوة اصدقائك للعب و بمشاركة تطبيق اللعبة على الفيس بوك أو تويتر";
          HowtoPlay = @"كيفية اللعب";
          HowWitsStore = @"كيفية استخدام مخزن ويتس";
          HowtoEarnPoints = @"كيف تحصل على النقاط مجاناً؟";
          
          
          lblPlayforPoints.text = PLAY_NOW_1;
          lblplayforGems.text = Challenge_a_friend1;
          PlayNowLabel.text =PLAY_NOW_1;
          challengeAFriend.text = Challenge_a_friend1;
          
          willhelpinRanking.text = WILL_HELP_IN_RANKING_1;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY_1;
          knowledgeLbl.text = KNOWLEDGE_LBL_1;
          tutoDesc1.text = TUTORIAL_DESC_LBL_1;
          tutoDesc2.text = TUTORIAL_DESC_LBL2_1;
          tutoDesc1.textAlignment = NSTextAlignmentRight;
          tutoDesc2.textAlignment = NSTextAlignmentRight;
          vsLbl.text = VS_1;
          AddaQuestion.text = ADD_QUESTION_1;
          answerTxt.placeholder = ENTER_ANSWER_1;
          questionTxt.placeholder = @"ادخل السؤال";
          
          questionTxt.textAlignment = NSTextAlignmentRight;
          answerTxt.textAlignment = NSTextAlignmentRight;
          
          
          homeLbl.text = HOME_BTN_1;
          CategoriesLbl.text = @"مواضيع فرعية";
          adContentLbl.text = ADD_CONTENT_1;
          guidelineLbl.text = GUIDELINES_1;
          
          [backBtn3 setTitle:BACK_BTN_1 forState:UIControlStateNormal];
     
          [backBtn2 setTitle:@"إلغاء" forState:UIControlStateNormal];
          [sendQuestion setTitle:SEND_1 forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
     }
     else if(languageCode == 2) {
          
          searchBar.placeholder = SEARCH_CATEGORY_2;
          HowtoPlay = @"Comment jouer";
          HowWitsStore = @"Comment utiliser ESPRITS magasin";
          HowtoEarnPoints = @"Comment gagner des Points";
          howtoPlay1 = @"Défiez à 1-1 n\'importe qui dans le monde.";
          howtoPlay2 = @"Plus vite vous répondez, plus vous cumulez de Gems.";
          howtoPlay3 = @"Echangez vos Gems contre de l'argent.";
          forGemsLable.text = For_Gems2;
          forPointsLabel.text = For_Points2;
          
         

          
          
          howtouseStoreDesc = @"Inscrivez-vous maintenant et gagnez 1000 Gems gratuits.";
          howtoEarnPointDesc = @"Vous pouvez toujours gagner des Points en invitant vos amis et en partageant notre application sur Facebook et Twitter.";
          knowledgeLbl.text = KNOWLEDGE_LBL_2;
          tutoDesc1.text = TUTORIAL_DESC_LBL_2;
          tutoDesc2.text = TUTORIAL_DESC_LBL2_2;
          
          AddaQuestion.text = ADD_QUESTION_2;
          answerTxt.placeholder = ENTER_ANSWER_2;
          questionTxt.placeholder = @"Entrez question";
          
          lblPlayforPoints.text = PLAY_NOW_2;
          lblplayforGems.text = Challenge_a_friend2;
          willhelpinRanking.text = WILL_HELP_IN_RANKING_2;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY_2;
          
          PlayNowLabel.text =PLAY_NOW_2;
          challengeAFriend.text = Challenge_a_friend2;
          
          homeLbl.text = HOME_BTN_2;
          CategoriesLbl.text = @"Subcategoría";
          adContentLbl.text = ADD_CONTENT_2;
          guidelineLbl.text = GUIDELINES_2;
          loadingTitle = Loading_2;
          
          [backBtn3 setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [backBtn2 setTitle:@"Cancelar" forState:UIControlStateNormal];
          [sendQuestion setTitle:SEND_2 forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
     }
     else if(languageCode == 3) {
          
          searchBar.placeholder = SEARCH_CATEGORY_3;
          loadingTitle = Loading_3;
          
          PlayNowLabel.text =PLAY_NOW_3;
          challengeAFriend.text = Challenge_a_friend3;
          
          forGemsLable.text = For_Gems3;
          forPointsLabel.text = For_Points3;
          
          knowledgeLbl.text = KNOWLEDGE_LBL_3;
          tutoDesc1.text = TUTORIAL_DESC_LBL_3;
          tutoDesc2.text = TUTORIAL_DESC_LBL2_3;
          
          AddaQuestion.text = ADD_QUESTION_3;
          answerTxt.placeholder = ENTER_ANSWER_3;
          questionTxt.placeholder = @"Introduzca pregunta";
          
          HowtoPlay = @"Cómo jugar";
          HowWitsStore = @"Cómo utilizar WITS tienda";
          HowtoEarnPoints = @"Cómo ganar pontus.";
          
          howtoPlay1 = @" Inicie un reto 1-1 contra a cualquiera en el mundo.";
          howtoPlay2 = @"En cuanto más rápido responde más puntos podrá recoger.";
          howtoPlay3 = @"Cambia tus gemas por dinero real.";
          
          howtouseStoreDesc = @"Registrase ahora y gane 1000 puntos gratis";
          howtoEarnPointDesc = @"Puedes ganar pontus gratis invitando a tus amigos y compartiendo la aplicación en Facebook or Twitter.";
          lblPlayforPoints.text = PLAY_NOW_3;
          lblplayforGems.text = Challenge_a_friend3;
          
          willhelpinRanking.text = WILL_HELP_IN_RANKING_3;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY_3;
          
          homeLbl.text = HOME_BTN_3;
          CategoriesLbl.text = @"sous catégories";
          adContentLbl.text = ADD_CONTENT_3;
          guidelineLbl.text = GUIDELINES_3;
          
          [backBtn2 setTitle:@"Annuler" forState:UIControlStateNormal];
          [sendQuestion setTitle:SEND_3 forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [backBtn3 setTitle:BACK_BTN_3 forState:UIControlStateNormal];
     }
     else if(languageCode == 4) {
          
          searchBar.placeholder = SEARCH_CATEGORY_4;
          loadingTitle = Loading_4;
          howtoPlay1 = @"Inicie um desafio de 1-1 contra qualquer pessoa no mundo.";
          howtoPlay2 = @"Quanto mais rápido você responder, mais pontos você vai acumular.";
          howtoPlay3 = @"Troque as suas Gemas por dinheiro verdadeiro.";
          PlayNowLabel.text =PLAY_NOW_4;
          challengeAFriend.text = Challenge_a_friend4;
          howtouseStoreDesc = @"Inscreva-se gratuitamente e ganhe 1000 gemas";
          howtoEarnPointDesc = @"Poderá receber pontus Grátis a todo momento ao convidar os seus amigos ou ao partilhar a App no Facebook ou Twitter.";
          HowtoPlay = @"Como Jogar";
          HowWitsStore = @"Como usar WITS loja";
          HowtoEarnPoints = @"Convide amigos e desafiá-los";
          
          knowledgeLbl.text = KNOWLEDGE_LBL_4;
          forGemsLable.text = For_Gems4;
          forPointsLabel.text = For_Points4;
        
          
          
          
          lblPlayforPoints.text = PLAY_NOW_4;
          lblplayforGems.text = Challenge_a_friend4;
          willhelpinRanking.text = WILL_HELP_IN_RANKING_4;
          willHelpinEarnMoney.text = WILL_HELP_EARN_MONEY_4;
          
          tutoDesc1.text = TUTORIAL_DESC_LBL_4;
          tutoDesc2.text = TUTORIAL_DESC_LBL2_4;
          
          AddaQuestion.text = ADD_QUESTION_4;
          answerTxt.placeholder = ENTER_ANSWER_4;
          questionTxt.placeholder = @"Digite Pergunta";
          
          homeLbl.text = HOME_BTN_4;
          CategoriesLbl.text = @"sub-tópicos";
          adContentLbl.text = ADD_CONTENT_4;
          guidelineLbl.text = GUIDELINES_4;
          
          [backBtn3 setTitle:BACK_BTN_4 forState:UIControlStateNormal];
           [backBtn2 setTitle:@"Cancelar" forState:UIControlStateNormal];
          [sendQuestion setTitle:SEND_4 forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
     }
     if (!languageCode == 0) {
          self.searchDisplayController.searchBar.userInteractionEnabled = NO;
          self.searchDisplayController.searchBar.alpha = .5;
     }else{
          
          self.searchDisplayController.searchBar.userInteractionEnabled = YES;
          self.searchDisplayController.searchBar.alpha = 1.0;
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
               starImage.hidden = NO;
               gemImage.hidden = NO;
               
               starimg2.hidden = YES;
               gemimg2.hidden = YES;
          }else{
               starImage.frame = CGRectMake(8, starImage.frame.origin.y+2, 35, 32);
               gemImage.frame = CGRectMake(13, gemImage.frame.origin.y+2 , 25, 25);
               
          }
          
     }
}

-(void)leftBtnPressed :(id) sender {
     
     UIButton *senderBtn = (UIButton*)sender;
     
     TopicModel *tempTopic = [subtopicsArray objectAtIndex:senderBtn.tag];
     
     if(tempTopic.subTopicsArray.count > 0) {
          ThirdLayerVC *tempVC = [[ThirdLayerVC alloc] initWithParentTopic:tempTopic];
          [self.navigationController pushViewController:tempVC animated:YES];
     }
     else{
          //play now module
          
          
          if(appDelegate.friendToBeChalleneged) {
               NSString * req = [[NSUserDefaults standardUserDefaults]objectForKey:@"requestType"];
               if([req isEqualToString:@"gems"])
               {
                    currentSelectedIndex = senderBtn.tag;
                    _gmChallengeSelected = true;
                    _gmGemsSelected = true;
                    [self PlayNowLogic];
               }else
               {
                    currentSelectedIndex = senderBtn.tag;
                    _gmChallengeSelected = true;
                    _gmGemsSelected = false;
                    [self PlayNowLogic];
               }
               
          }else
          {
               _gmGemsSelected = false;
               _gmChallengeSelected = false;
               currentSelectedIndex = senderBtn.tag;
               [self setUpGameModScreen];
          }
          
          
          
          
          
     }
}
-(void)rightBtnPressed :(id) sender {
     UIButton *senderBtn = (UIButton*)sender;
     
     TopicModel *tempTopic = [subtopicsArray objectAtIndex:senderBtn.tag];
     
     if(tempTopic.subTopicsArray.count > 0) {
          ThirdLayerVC *tempVC = [[ThirdLayerVC alloc] initWithParentTopic:tempTopic];
          [self.navigationController pushViewController:tempVC animated:YES];
     }
     else{
          
          if(appDelegate.friendToBeChalleneged) {
               
               NSString * req = [[NSUserDefaults standardUserDefaults]objectForKey:@"requestType"];
               
               if([req isEqualToString:@"gems"])
               {
                    _gmGemsSelected = true;
                    [self PlayNowLogic];
               }else
               {
                    _gmGemsSelected = false;
                    [self PlayNowLogic];
               }
               
               
               
               
          }else
          {
               _gmGemsSelected = false;
               _gmChallengeSelected = false;
               currentSelectedIndex = senderBtn.tag;
               [self setUpGameModScreen];
          }
          
          
     }
     
}
-(void)mainBtnPressed :(id) sender {
     UIButton *senderBtn = (UIButton*)sender;
     
     TopicModel *tempTopic = [subtopicsArray objectAtIndex:senderBtn.tag];
     
     if(tempTopic.subTopicsArray.count > 0) {
          ThirdLayerVC *tempVC = [[ThirdLayerVC alloc] initWithParentTopic:tempTopic];
          [self.navigationController pushViewController:tempVC animated:YES];
     }
     else{
          if(appDelegate.friendToBeChalleneged) {
               NSString * req = [[NSUserDefaults standardUserDefaults]objectForKey:@"requestType"];
               if([req isEqualToString:@"gems"])
               {
                    currentSelectedIndex = senderBtn.tag;
                    _gmChallengeSelected = true;
                    _gmGemsSelected = true;
                    [self PlayNowLogic];
               }else
               {
                    currentSelectedIndex = senderBtn.tag;
                    _gmChallengeSelected = true;
                    _gmGemsSelected = false;
                    [self PlayNowLogic];
               }
               
          }else
          {
               _gmGemsSelected = false;
               _gmChallengeSelected = false;
               currentSelectedIndex = senderBtn.tag;
               [self setUpGameModScreen];
          }
          
          
          
          //play now module
          //          _gmGemsSelected = false;
          //          _gmChallengeSelected = false;
          //          currentSelectedIndex = senderBtn.tag;
          //          [self setUpGameModScreen];
     }
     
}
#pragma GameModeScreen

-(void) setUpGameModScreen {
     
     UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
     UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
     blurEffectView.frame = self.view.frame;
     blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     blurEffectView.tag = 499;
     //[self.view addSubview:blurEffectView];
     // popup settings
     
     [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     requestType = @"points";
     isChallenge = false;
     //
     CATransition *transition = [CATransition animation];
     transition.duration = 0.6;
     transition.type = kCATransitionPush; //choose your animation
     transition.subtype = kCATransitionFromBottom;
     [_gameModView.layer addAnimation:transition forKey:nil];
     _gameModView.hidden = false;
     
     [self.view addSubview:_gameModView];
     [self.tabBarController.tabBar setHidden:true];
     _searchingLoaderView.hidden = false;
     
         [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsNew.png"] forState:UIControlStateNormal];
     //     [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"starglow.png"] forState:UIControlStateNormal];
//     if(appDelegate.friendToBeChalleneged) {
//          //          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"playNow.png"] forState:UIControlStateNormal];
//          //          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenowglow.png"] forState:UIControlStateNormal];
//     }
//     else {
//          //          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"swordglow.png"] forState:UIControlStateNormal];
//          //          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
//     }
}

- (IBAction)gameModCanelBtnPressed:(id)sender {
     self.tabBarController.tabBar.hidden = false;
     appDelegate.friendToBeChalleneged = nil;
     UIView *effectView = [self.view viewWithTag:499];
     [effectView removeFromSuperview];
     _gmGemsSelected = false;
     _gmChallengeSelected = false;
     _gameModView.hidden = true;
     [_gameModView removeFromSuperview];
     [self gmStarsPressed:nil];
}

- (IBAction)gmPlayNowPressed:(id)sender {
     //     if(_gmChallengeSelected) {
     _gmChallengeSelected = false;
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     PlayNowLabel.textColor=[UIColor colorWithRed:183.0/255.0f green:216.0/255.0f blue:255.0/255.0f alpha:1.0];
     challengeAFriend.textColor = [UIColor whiteColor];
     [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"Newplaynowglow.png"] forState:UIControlStateNormal];
     [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"Newchallengenow.png"] forState:UIControlStateNormal];
//     if(languageCode == 0 ) {
//        
//          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"Newplaynowglow.png"] forState:UIControlStateNormal];
//          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"Newchallengenow.png"] forState:UIControlStateNormal];
//         
//          
//     }else      if(languageCode == 1 ) {
//          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"PlayNowGlowArabic.png"] forState:UIControlStateNormal];
//          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"ChallengeArabic.png"] forState:UIControlStateNormal];
//          
//     }else      if(languageCode == 2 ) {
//          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"PlayNowGlowSpanish.png"] forState:UIControlStateNormal];
//          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"ChallengeSpanish.png"] forState:UIControlStateNormal];
//          
//     }else      if(languageCode == 3 ) {
//          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"PlayNowGlowFrench.png"] forState:UIControlStateNormal];
//          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"ChallengeFrench.png"] forState:UIControlStateNormal];
//          
//     }else      if(languageCode == 4 ) {
//          
//          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"PlayNowGlowPortuguese.png"] forState:UIControlStateNormal];
//          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"ChallengePortuguese.png"] forState:UIControlStateNormal];
//          
//     }
     
     
     
   
     //     }
     //     else {
     //          _gmChallengeSelected = true;
     //
     //          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"playNow.png"] forState:UIControlStateNormal];
     //          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenowglow.png"] forState:UIControlStateNormal];
     //     }
     
}

- (IBAction)challengeNowPressed:(id)sender {
     //     if(_gmChallengeSelected) {
     //          _gmChallengeSelected = false;
     //
     //          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"swordglow.png"] forState:UIControlStateNormal];
     //          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"challengenow.png"] forState:UIControlStateNormal];
     //     }
     //     else {
     _gmChallengeSelected = true;
     
     
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     challengeAFriend.textColor=[UIColor colorWithRed:183.0/255.0f green:216.0/255.0f blue:255.0/255.0f alpha:1.0];
     PlayNowLabel.textColor = [UIColor whiteColor];
     [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"Newplaynow.png"] forState:UIControlStateNormal];
     [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"Newchallengenowglow.png"] forState:UIControlStateNormal];
//     if(languageCode == 0 ) {
//          
//          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"PlayNowEnglish.png"] forState:UIControlStateNormal];
//          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"ChallengeglowEnglish.png"] forState:UIControlStateNormal];
//          
//          
//          
//     }else      if(languageCode == 1 ) {
//          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"PlayNowArabic.png"] forState:UIControlStateNormal];
//          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"ChallengeglowArabic.png"] forState:UIControlStateNormal];
//          
//     }else      if(languageCode == 2 ) {
//          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"PlayNowSpanish.png"] forState:UIControlStateNormal];
//          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"ChallengeglowSpanish.png"] forState:UIControlStateNormal];
//          
//     }else      if(languageCode == 3 ) {
//          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"PlayNowFrench.png"] forState:UIControlStateNormal];
//          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"ChallengeglowFrench.png"] forState:UIControlStateNormal];
//          
//     }else      if(languageCode == 4 ) {
//          
//          [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"PlayNowPortuguese.png"] forState:UIControlStateNormal];
//          [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"ChallengeglowPortuguese.png"] forState:UIControlStateNormal];
//          
//     }
     
     
     
//     [_playNowBtn setBackgroundImage:[UIImage imageNamed:@"PlayNowEnglish.png"] forState:UIControlStateNormal];
//     [_challengeNowBtn setBackgroundImage:[UIImage imageNamed:@"ChallengeglowEnglish.png"] forState:UIControlStateNormal];
     //     }
}

- (IBAction)gmGemsPressed:(id)sender {
     //     if(_gmGemsSelected) {
     //          _gmGemsSelected = false;
     //
     //          [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"gem.png"] forState:UIControlStateNormal];
     //          [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"starglow.png"] forState:UIControlStateNormal];
     //     }
     //     else {
     _gmGemsSelected = true;
     
     
     forGemsLable.textColor=[UIColor colorWithRed:183.0/255.0f green:216.0/255.0f blue:255.0/255.0f alpha:1.0];
     forPointsLabel.textColor = [UIColor whiteColor];
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsglowNew.png"] forState:UIControlStateNormal ];
     
     [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsNew.png"] forState:UIControlStateNormal ];
     

//     if(languageCode == 0 ) {
//          
//          [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsGlowNew.png"] forState:UIControlStateNormal];
//          [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsNew.png"] forState:UIControlStateNormal];

//
//          
//          
//     }else      if(languageCode == 1 ) {
//          [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsGlowNew.png"] forState:UIControlStateNormal];
//          [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsNew.png"] forState:UIControlStateNormal];
//
//
//          
//     }else      if(languageCode == 2 ) {
//          [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsGlowNew.png"] forState:UIControlStateNormal];
//          [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsNew.png"] forState:UIControlStateNormal];
//
//          
//     }else      if(languageCode == 3 ) {
//          [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsGlowNew.png"] forState:UIControlStateNormal];
//          [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsNew.png"] forState:UIControlStateNormal];
//
//          
//     }else      if(languageCode == 4 ) {
//          
//          [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsGlowNew.png"] forState:UIControlStateNormal];
//          [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsNew.png"] forState:UIControlStateNormal];
//
//
//          
//     }
     
     
         //     }
}



- (IBAction)gmStarsPressed:(id)sender {
     //     if(_gmGemsSelected) {
     _gmGemsSelected = false;
     
//     [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"gem.png"] forState:UIControlStateNormal];
//     [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"starglow.png"] forState:UIControlStateNormal];
//     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     forGemsLable.textColor = [UIColor whiteColor];
     forPointsLabel.textColor=[UIColor colorWithRed:183.0/255.0f green:216.0/255.0f blue:255.0/255.0f alpha:1.0];
     languageCode = [language intValue];
     
     [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsNew.png"] forState:UIControlStateNormal];
     [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsglowNew.png"] forState:UIControlStateNormal];
     
//
//     if(languageCode == 0 ) {
//          
//          [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsNew.png"] forState:UIControlStateNormal];
//          [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsglowNew.png"] forState:UIControlStateNormal];
//          
//          
//          
//          
//     }else      if(languageCode == 1 ) {
//          [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsNew.png"] forState:UIControlStateNormal];
//          [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsglowNew.png"] forState:UIControlStateNormal];
//          
//          
//          
//     }else      if(languageCode == 2 ) {
//          [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsNew.png"] forState:UIControlStateNormal];
//          [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsglowNew.png"] forState:UIControlStateNormal];
//          
//          
//          
//     }else      if(languageCode == 3 ) {
//          [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsNew.png"] forState:UIControlStateNormal];
//          [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsglowNew.png"] forState:UIControlStateNormal];
//          
//          
//          
//     }else      if(languageCode == 4 ) {
//          
//          [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"forgemsNew.png"] forState:UIControlStateNormal];
//          [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"forpintsglowNew.png"] forState:UIControlStateNormal];
//          
//          
//          
//     }
     
     
     
     
     
     
     
     //     }
     //     else {
     //          _gmGemsSelected = true;
     //
     //          [_gmGemButton setBackgroundImage:[UIImage imageNamed:@"gemglow.png"] forState:UIControlStateNormal];
     //          [_gmStarsBtn setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
     //     }
}



- (void)PlayNowLogic
{
     // HERE
     
     [self.tabBarController.tabBar setHidden:YES];
     isOpponentFound = false;
     //     _searchOppLbl.hidden = false;
     opponent.text = @"";
     opponentProfileImageView.image = [UIImage imageNamed:@"personal.png"];
     [opponentProfileImageView roundImageCorner];
     if(_gmChallengeSelected) {
          if(appDelegate.friendToBeChalleneged) {
               if(_gmGemsSelected) {
                    [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    requestType = @"gems";
               }
               else {
                    [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    requestType = @"points";
               }
               [self SendChallengeToYourFriend:appDelegate.friendToBeChalleneged];
          }
          else {
               isChallenge = true;
               if(_gmGemsSelected) {
                    requestType = @"gems";
                    [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self PlaywithGems:nil];
               }
               else{
                    requestType = @"points";
                    [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self PlaywitStars:nil];
               }
          }
     }
     else {
          isChallenge= false;
          if(_gmGemsSelected) {
               [self PlaywithGems:nil];
          }
          else{
               [self PlaywitStars:nil];
          }
     }
     
     
}


- (IBAction)rejectGemsBuyPressed:(id)sender {
     appDelegate.friendToBeChalleneged = nil;
     appDelegate.requestType = nil;
     [self gameModCanelBtnPressed:nil];

    buyGemsView.hidden = true;
     [buyGemsView removeFromSuperview];
}

- (IBAction)acceptGemsBuyPressed:(id)sender {
    buyGemsView.hidden = true;
     [buyGemsView removeFromSuperview]; [self gmStarsPressed:self];
     self.tabBarController.selectedIndex = 2;
     
}

- (IBAction)gmGoPressed:(id)sender {
     [self.tabBarController.tabBar setHidden:YES];
     isOpponentFound = false;
     //     _searchOppLbl.hidden = false;
     opponent.text = @"";
     opponentProfileImageView.image = [UIImage imageNamed:@"personal.png"];
     [opponentProfileImageView roundImageCorner];
     if(_gmChallengeSelected) {
          if(appDelegate.friendToBeChalleneged) {
               if(_gmGemsSelected) {
                    [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    requestType = @"gems";
               }
               else {
                    [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    requestType = @"points";
               }
               [self SendChallengeToYourFriend:appDelegate.friendToBeChalleneged];
          }
          else {
               isChallenge = true;
               if(_gmGemsSelected) {
                    requestType = @"gems";
                    [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self PlaywithGems:nil];
               }
               else{
                    requestType = @"points";
                    [[NSUserDefaults standardUserDefaults] setObject:requestType forKey:@"requestType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self PlaywitStars:nil];
               }
          }
     }
     else {
          isChallenge= false;
          if(_gmGemsSelected) {
               [self PlaywithGems:nil];
          }
          else{
               [self PlaywitStars:nil];
          }
     }
     
}




-(void)SendChallengeToYourFriend:(UserProfile *)_user{
     
   //  timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(increaseTimerCount) userInfo:nil repeats:YES];
     opponentProfileImageView.imageURL = [NSURL URLWithString:_user.profile_image];
     NSURL *url = [NSURL URLWithString:_user.profile_image];
     [[AsyncImageLoader sharedLoader] loadImageWithURL:url];
     [opponentProfileImageView roundImageCorner];
     searchingTxt.text = _user.display_name;
     [loadView showInView:self.view withTitle:loadingTitle];
     [self connectToSocket];
}

- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
          [self setLanguageForScreen];
     self.tabBarController.tabBar.hidden = false;
 
}




-(void) settingNameofImage:(NSString *)idOfCat
{
     
     // here
     
     if([idOfCat isEqualToString:@"5"])
     {
          subcatMaintempImgName = @"Football.png";
          subcatthumbnailtempName = @"football_icon.png";
          
     }else  if([idOfCat isEqualToString:@"6"])
     {
          subcatMaintempImgName = @"Basketball.png";
          subcatthumbnailtempName = @"Basketballicon.png";
          
          
     }else  if([idOfCat isEqualToString:@"1"])
     {
          subcatMaintempImgName = @"World News.png";
          subcatthumbnailtempName = @"";
          
          
     }else  if([idOfCat isEqualToString:@"2"])
     {
          subcatMaintempImgName = @"Logos.png";
          subcatthumbnailtempName = @"";
          
          
     }else  if([idOfCat isEqualToString:@"3"])
     {
          subcatMaintempImgName = @"Cars.png";
          subcatthumbnailtempName = @"";
          
          
     }else  if([idOfCat isEqualToString:@"7"])
     {
          subcatMaintempImgName = @"Olympic Games.png";
          subcatthumbnailtempName = @"";
          
          
     }else  if([idOfCat isEqualToString:@"8"])
     {
          
          subcatMaintempImgName = @"Boxing.png";
          subcatthumbnailtempName = @"Boxingicon.png";
          
     }else  if([idOfCat isEqualToString:@"9"])
     {
          subcatMaintempImgName = @"Formula one.png";
          subcatthumbnailtempName = @"";
          
          
     }else  if([idOfCat isEqualToString:@"10"])
     {
          subcatMaintempImgName = @"Tennis.png";
          subcatthumbnailtempName = @"";
          
          
     }else  if([idOfCat isEqualToString:@"11"])
     {
          subcatMaintempImgName = @"Ancient History.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"12"])
     {
          subcatMaintempImgName = @"Modern History.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"13"])
     {
          subcatMaintempImgName = @"General";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"15"])
     {
          subcatMaintempImgName = @"Capitals.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"16"])
     {
          subcatMaintempImgName = @"Cities of the World.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"17"])
     {
          subcatMaintempImgName = @"Math.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"18"])
     {
          subcatMaintempImgName = @"World of Warcraft.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"19"])
     {
          subcatMaintempImgName = @"Pokemon.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"20"])
     {
          subcatMaintempImgName = @"League of Legends";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"21"])
     {
          subcatMaintempImgName = @"Valve.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"22"])
     {
          subcatMaintempImgName = @"GeneralScience.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"23"])
     {
          subcatMaintempImgName = @"Hollywood.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"24"])
     {
          subcatMaintempImgName = @"Music.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"25"])
     {
          subcatMaintempImgName = @"Bollywood";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"26"])
     {
          subcatMaintempImgName = @"Celebrities.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"27"])
     {
          subcatMaintempImgName = @"Fashion.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"28"])
     {
          subcatMaintempImgName = @"TV.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"30"])
     {
          subcatMaintempImgName = @"Islam.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"31"])
     {
          subcatMaintempImgName = @"Judaism.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     
     else  if([idOfCat isEqualToString:@"32"])
     {
          subcatMaintempImgName = @"Christianity.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"33"])
     {
          subcatMaintempImgName = @"Others.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     else  if([idOfCat isEqualToString:@"34"])
     {
          subcatMaintempImgName = @"Cricket.png";
                    subcatthumbnailtempName = @"";
          
          
     }
     

     
     
     
     
     
}





@end


