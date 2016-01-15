
#import "EarnFreePointsViewController.h"
#import "RightBarVC.h"
#import "SharedManager.h"
#import "MKNetworkKit.h"
#import "Utils.h"
#import <Social/Social.h>
#import "AlertMessage.h"

@interface EarnFreePointsViewController ()
@end
@implementation EarnFreePointsViewController

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
     [self setLanguage];
     // Do any additional setup after loading the view from its nib.
     //[self setUpTutorial];
     [self setLanguageForScreen];
     CGRect screenRect = [[UIScreen mainScreen] bounds];
     CGFloat screenWidth = screenRect.size.width;
     if(IS_IPAD){
          knowledgelbl.font = [UIFont fontWithName:FONT_NAME size:30];
          _shareLbl.font = [UIFont fontWithName:FONT_NAME size:25];
     }
     else{
          knowledgelbl.font = [UIFont fontWithName:FONT_NAME size:17];
          _shareLbl.font = [UIFont fontWithName:FONT_NAME size:14];
     }
     _tutorialScrollView.contentSize = CGSizeMake(screenWidth*7, screenRect.size.height);
}

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}
-(void) setUpTutorial {
     
     [self setLanguageForScreen];
     
     
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return [sectionTitleArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     
     UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
     UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
     headerView.tag                  = section;
     headerView.backgroundColor      = [UIColor whiteColor];
     UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20-50, 50)];
     
     if(IS_IPAD) {
          headerView.frame = CGRectMake(0, 0, 597, 90);
          backgroundImage.frame = CGRectMake(0, 0, 597, 90);
          headerString.frame = CGRectMake(0, 0, 597, 90);
          
          
     }
     BOOL manyCells                  = [[arrayForBool objectAtIndex:section] boolValue];
     
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
          backgroundImage.image = [UIImage imageNamed:@"greenBar.png"];
          
          
     }
     //              else if (section == 2){
     //              if (!manyCells) {
     //                   headerString.text = HowWitsStore;
     //              }else{
     //                   headerString.text = HowWitsStore;
     //              }
     //              backgroundImage.image = [UIImage imageNamed:@"greenBar.png"];
     //         }
     
     
     [headerView addSubview:backgroundImage];
     headerString.textAlignment      = NSTextAlignmentCenter;
     headerString.textColor          = [UIColor whiteColor];
     if(IS_IPAD) {
          headerString.font = [UIFont fontWithName:FONT_NAME size:20];
     }
     [headerView addSubview:headerString];
     
     UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
     [headerView addGestureRecognizer:headerTapped];
     
     //up or down arrow depending on the bool
     //    UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"upArrowBlack"] : [UIImage imageNamed:@"down_arow.png"]];
     //    upDownArrow.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
     //    upDownArrow.frame               = CGRectMake(55, 21, 10, 10);
     //     if(IS_IPAD) {
     //          upDownArrow.frame               = CGRectMake(15, 30, 15, 15);
     //     }
     //    [headerView addSubview:upDownArrow];
     //
     return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
     return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     if(IS_IPAD) {
          return 89;
     }
     return 49;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
          if(IS_IPAD) {
               return 90;
          }
          return 50;
     }
     return 1;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
          //          else if(row == 2){
          //               cell.textLabel.text = [tutorialArray3 objectAtIndex:indexPath.row];
          //          }
          cell.textLabel.numberOfLines = 3;
          cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
          cell.textLabel.textAlignment = NSTextAlignmentLeft;
          
          if (languageCode == 1) {
               cell.textLabel.textAlignment = NSTextAlignmentRight;
          }
          
          if(IS_IPAD) {
               cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
          }
     }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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


- (IBAction)fbBtnPressed:(id)sender {
     
     if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
          SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
          NSString *sharingStr = [NSString stringWithFormat:@"%@ %@",newShareString,@"https://goo.gl/WZE1kP"];
          [controller setInitialText:sharingStr];
          [self presentViewController:controller animated:YES completion:Nil];
     }
     else {
          
          NSString *message;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               message = @"Go to Device Settings and set up Facebook Account";
               title = @"Account Configuration Error";
               cancel = OK_BTN;
          } else if(languageCode == 1) {
               message = @"اذهب إلى إعدادات الجهاز وقم بإنشاء حساب فيسبوك";
               title = @"خطأ في تكوين الحساب";
               cancel = OK_BTN_1;
          }else if (languageCode == 2){
               message = @"Allez à paramètres et configurez votre compte Facebook";
               title = @"Erreur de configuration du compte";
               cancel = OK_BTN_2;
          }else if (languageCode == 3){
               message = @"Ir a configuraciones y configurar su cuenta Facebook";
               title = @"Error en la configuración de la cuenta";
               cancel = OK_BTN_3;
          }else if (languageCode == 4){
               message = @"Vá para Configurações e adicione a conta do Facebook";
               title = @"Erro de Configuração de Conta";
               cancel = OK_BTN_4;
          }
          
          [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
     }
}

- (IBAction)twitterBtnPressed:(id)sender {
     if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
     {
          
          NSString *sharingStr = [NSString stringWithFormat:@"%@ %@",newShareString,@"https://goo.gl/WZE1kP"];
          SLComposeViewController *tweetSheet = [SLComposeViewController
                                                 composeViewControllerForServiceType:SLServiceTypeTwitter];
          [tweetSheet setInitialText:sharingStr];
          [self presentViewController:tweetSheet animated:YES completion:nil];
     }
     else {
          
          
          NSString *message;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               message = @"Go to Device Settings and set up Twitter Account";
               title = @"Account Configuration Error";
               cancel = OK_BTN;
          } else if(languageCode == 1) {
               message = @"اذهب إلى إعدادات الجهاز وقم بإنشاء حساب تويتر";
               title = @"خطأ في تكوين الحساب";
               cancel = OK_BTN_1;
          }else if (languageCode == 2){
               message = @"Allez à paramètres et configurez votre compte Twitter";
               title = @"Erreur de configuration du compte";
               cancel = OK_BTN_2;
          }else if (languageCode == 3){
               message = @"Ir a configuraciones y configurar su cuenta Twitter";
               title = @"Error en la configuración de la cuenta";
               cancel = OK_BTN_3;
          }else if (languageCode == 4){
               message = @"Vá para Configurações e adicione a conta do Twitter";
               title = @"Erro de Configuração de Conta";
               cancel = OK_BTN_4;
          }
          
          [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          /* UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Account Configuration Error" message:@"Go to Device Settings and set up Twitter Account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [warningAlert show];*/
     }
}

- (IBAction)smsBtnPressed:(id)sender {
     if(![MFMessageComposeViewController canSendText]) {
          
          NSString *message;
          NSString *title;
          NSString *cancel;
          if (languageCode == 0 ) {
               message = @"Your device does not support this feature!";
               title = @"Error";
               cancel = OK_BTN;
          } else if(languageCode == 1) {
               message = @"!لا يدعم جهازك هذه الميزة";
               title = @"خطأ";
               cancel = OK_BTN_1;
          }else if (languageCode == 2){
               message = @"Su dispositivo no admite esta característica!";
               title = @"Erreur";
               cancel = OK_BTN_2;
          }else if (languageCode == 3){
               message = @"Votre appareil ne prend pas en charge cette fonctionnalité!";
               title = @"Error";
               cancel = OK_BTN_3;
          }else if (languageCode == 4){
               message = @"O dispositivo não suporta esta função!";
               title = @"Erro";
               cancel = OK_BTN_4;
          }
          [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
          
          /*   UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [warningAlert show];
           return;*/
     }
     else {
          NSArray *recipents = @[@""];
          NSString *sharingStr = [NSString stringWithFormat:@"%@ %@",newShareString,@"https://goo.gl/WZE1kP"];
          
          
          MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
          messageController.messageComposeDelegate = self;
          [messageController setRecipients:nil];
          [messageController setBody:sharingStr];
          
          // Present message view controller on screen
          [self presentViewController:messageController animated:YES completion:nil];
     }
}
- (IBAction)emailBtnPressed:(id)sender {
     UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
     [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
     UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     if([MFMailComposeViewController canSendMail]) {
          NSString *emailTitle = @"WITS Referal Code ";
          // Email Content
          NSString *messageBody = [NSString stringWithFormat:@"%@ \n%@",referalStr,[SharedManager getInstance]._userProfile.referral_code];
          MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
          mc.mailComposeDelegate = self;
          [mc setSubject:emailTitle];
          [mc setMessageBody:messageBody isHTML:NO];
          
          // Present mail view controller on screen
          [self presentViewController:mc animated:YES completion:NULL];
     }
     else
     {
          //Do something like show an alert
     }
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
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
     
     [self dismissModalViewControllerAnimated:YES];
     
     if (result == MessageComposeResultCancelled) {
          
          NSLog(@"Message cancelled");
          
     } else if (result == MessageComposeResultSent) {
          
          NSLog(@"Message sent");
     }
     
}
-(IBAction)ShowRightMenu:(id)sender{
     
     [[RightBarVC getInstance] loadProfileImage];
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}
- (IBAction)sendPressed:(id)sender {
     if(_referralText.text.length > 0) {
          if( [_referralText.text caseInsensitiveCompare:[SharedManager getInstance]._userProfile.referral_code] == NSOrderedSame )
          {
               NSString *message;
               if (languageCode == 0 ) {
                    message = @"Not a valid referral code";
               }else if (languageCode == 1){
                    message = @"Not a valid referral code";
               }else if (languageCode == 2){
                    message = @"Not a valid referral code";
               }else if (languageCode == 3){
                    message = @"Not a valid referral code";
               }else if (languageCode == 4){
                    message = @"Not a valid referral code";
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
          }
          else {
               loadView = [[LoadingView alloc] init];
               [loadView showInView:self.view withTitle:@"Sending..."];
               MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:nil];
               
               NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
               [postParams setObject:@"accept_referral" forKey:@"method"];
               [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
               [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
               [postParams setObject:_referralText.text forKey:@"referral_code"];
               
               MKNetworkOperation *operation = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
               
               [operation onCompletion:^(MKNetworkOperation *completedOperation){
                    
                    [loadView hide];
                    NSDictionary *mainDict = [completedOperation responseJSON];
                    NSLog(@"main dict %@",mainDict);
                    
                    NSString *msgStr = [mainDict objectForKey:@"message"];
                    if ([msgStr isEqualToString:@"success"]) {
                         NSString *message;
                         NSString *cancel;
                         NSString *title;
                         if (languageCode == 0 ) {
                              message = @"Referral Code posted Successfully.";
                              title = REFERAL_CODE_LBL;
                              cancel = OK_BTN;
                         }else if (languageCode == 1){
                              message = @"تم نشر رمز الإحالة بنجاح";
                              title = REFERAL_CODE_LBL_1;
                              cancel = OK_BTN_1;
                         }else if (languageCode == 2){
                              message = @"Le code de référence publié avec succès";
                              title = REFERAL_CODE_LBL_2;
                              cancel = OK_BTN_2;
                         }else if (languageCode == 3){
                              message = @"Código de referencia publicado con éxito";
                              title = REFERAL_CODE_LBL_3;
                              cancel = OK_BTN_3;
                         }else if (languageCode == 4){
                              message = @"Código de Referência postado com sucesso";
                              title = REFERAL_CODE_LBL_4;
                              cancel = OK_BTN_4;
                              [AlertMessage showAlertWithMessage:message andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
                         }
                    }
                    else{
                         
                         NSString *emailMsg;
                         NSString *title;
                         NSString *cancel;
                         if (languageCode == 0 ) {
                              emailMsg = ERR_REFERAL_CODE;
                              title = @"Error";
                              cancel = CANCEL;
                         } else if(languageCode == 1) {
                              emailMsg = ERR_REFERAL_CODE_1;
                              title = @"خطأ";
                              cancel = CANCEL_1;
                         }else if (languageCode == 2){
                              emailMsg = ERR_REFERAL_CODE_2;
                              title = @"Erreur";
                              cancel = CANCEL_2;
                         }else if (languageCode == 3){
                              emailMsg = ERR_REFERAL_CODE_3;
                              title = @"Error";
                              cancel = CANCEL_3;
                         }else if (languageCode == 4){
                              emailMsg = ERR_REFERAL_CODE_4;
                              title = @"Erro";
                              cancel = CANCEL_4;
                         }
                         [AlertMessage showAlertWithMessage:emailMsg andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];
                         
                         /*   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error !" message:@"Referral Code does not match!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                          
                          [alert show]; */
                    }
                    
               }
                               onError:^(NSError *error){
                                    
                                    [loadView hide];
                                    
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
               
               [engine enqueueOperation:operation];
          }
          
     }
     
     
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
     [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
     [self animateTextField: textField up: NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [textField resignFirstResponder];
     return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
     const int movementDistance = 145; // tweak as needed
     const float movementDuration = 0.3f; // tweak as needed
     
     int movement = (up ? -movementDistance : movementDistance);
     
     [UIView beginAnimations: @"anim" context: nil];
     [UIView setAnimationBeginsFromCurrentState: YES];
     [UIView setAnimationDuration: movementDuration];
     self.view.frame = CGRectOffset(self.view.frame, 0, movement);
     [UIView commitAnimations];
}

-(void)setLanguageForScreen {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          newShareString = @"WITS is an award winning multiplayer trivia game and fan community. Now you can also earn cash and real prizes on WITS! Click here : ";
          referalStr = @"Hi, My referral Code is";
          referalStr2 = @". Help me Earn Free Points. Lets play Wits together.";
          _knowlegdeLbl.text = KNOWLEDGE_LBL;
          //_shareLbl.text = SHARE_WITS_LBL;
          _EarnfreePointLbl.text = INVITE_FRIENDS;
          howtoPlay1 = @"Embark on a 1-1 challenge against anyone in the world.";
          howtoPlay2 = @"The faster you answer the more Gems you\'ll collect.";
          howtoPlay3 = @"Claim your rewards.";
         [_SkipBtn setTitle:@"Skip" forState:UIControlStateNormal];
          HowtoPlay = @"How to Play";
          HowWitsStore = @"How to Use WITS Store";
          HowtoEarnPoints = @"How to Earn Free Points";
          _lblTutorial.text = screenOne;
         
          howtouseStoreDesc = @"Sign up now and get your hands on 100 free Gems.";
          howtoEarnPointDesc = @"You can always earn free Points simply by inviting your friends and sharing the app on Facebook or Twitter.";
          // [_tutorialPressed setTitle:TUTORIAL_BTN forState:UIControlStateNormal];
          [_tutorialBacklbl setTitle:BACK_BTN forState:UIControlStateNormal];
          [mainBack setTitle:BACK_BTN forState:UIControlStateNormal];
          
     }
     else if(languageCode == 1 ) {
          referalStr = @". استخدم هذا الرقم لإحالة";
          referalStr2 = @". ساعدني لأحصل على النقاط مجانية. دعنا نلعب Wits سوياً.";
          newShareString =@"الآن يمكنك أيضا أن تحصل على النقود والجوائز الحقيقية مع ويتس! اضغط هنا.ويتس هي جائزة الفوز متعددة لعبة التوافه والمجتمع مروحة";
          _knowlegdeLbl.text = KNOWLEDGE_LBL_1;
          //_shareLbl.text = SHARE_WITS_LBL_1;
          _EarnfreePointLbl.text = INVITE_FRIENDS_1;
          [_SkipBtn setTitle:@"تخطي" forState:UIControlStateNormal];
          knowledgelbl.text = KNOWLEDGE_LBL_1;
          tutorialDescLbl.text = TUTORIAL_DESC_LBL_1;
          tutorialDescLbl2.text = TUTORIAL_DESC_LBL2_1;
          tutorialDescLbl.textAlignment = NSTextAlignmentRight;
          tutorialDescLbl2.textAlignment = NSTextAlignmentRight;
          
          _lblTutorial.text = screenOne1;
          
          howtoPlay1 = @"أسرع في دخول تحدي ضد أي شخص في العالم ";
          howtoPlay2 = @"اسرع في الاجابة للحصول على نقاط اكثر";
          howtoPlay3 = @"قم باستبدال جواهرك بنقود حقيقية.";
          
          howtouseStoreDesc = @"اشترك الآن و احصل على 1000 نقطة مجانا.";
          howtoEarnPointDesc = @"يمكنك أن تحصل دائماً على النقاط مجانية بمجرد دعوة اصدقائك للعب و بمشاركة تطبيق اللعبة على الفيس بوك أو تويتر";
          HowtoPlay = @"كيفية اللعب";
          HowWitsStore = @"كيفية استخدام مخزن ويتس";
          HowtoEarnPoints = @"كيف تحصل على النقاط مجاناً؟";
          
          //[_tutorialPressed setTitle:TUTORIAL_BTN_1 forState:UIControlStateNormal];
          [_tutorialBacklbl setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [mainBack setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          
          
     }
     else if(languageCode == 2) {
          newShareString = @"WITS est un jeu primé multijoueur de trivia  et une communauté de fans. Maintenant vous pouvez également gagner de l\'argent et prix réel sur WITS! Cliquez ici : ";
          referalStr = @"Salut, Mon code de référence est";
          referalStr2 = @". Aidez-moi à gagner des Gems. Rejoignez-moi sur Wits.";
          _knowlegdeLbl.text = KNOWLEDGE_LBL_2;
          _lblTutorial.text = screenOne2;
         
          knowledgelbl.text = KNOWLEDGE_LBL_2;
          tutorialDescLbl.text = TUTORIAL_DESC_LBL_2;
          tutorialDescLbl2.text = TUTORIAL_DESC_LBL2_2;
          [_SkipBtn setTitle:@"PASSER" forState:UIControlStateNormal];
          HowtoPlay = @"Comment jouer";
          HowWitsStore = @"Comment utiliser ESPRITS magasin";
          HowtoEarnPoints = @"Comment gagner des Gems";
          howtoPlay1 = @"Défiez à 1-1 n\'importe qui dans le monde.";
          howtoPlay2 = @"Plus vite vous répondez, plus vous cumulez de Gems.";
          howtoPlay3 = @"Echangez vos Gems contre de l'argent.";
          
          
          howtouseStoreDesc = @"Inscrivez-vous maintenant et gagnez 100 Gems gratuits.";
          howtoEarnPointDesc = @"Vous pouvez toujours gagner des Points en invitant vos amis et en partageant notre application sur Facebook et Twitter.";
          
          
          //_shareLbl.text = SHARE_WITS_LBL_2;
          _EarnfreePointLbl.text = INVITE_FRIENDS_2;
          
          ////[_tutorialPressed setTitle:TUTORIAL_BTN_2 forState:UIControlStateNormal];
          [_tutorialBacklbl setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [mainBack setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          
          
     }
     else if(languageCode == 3) {
          newShareString = @"WITS es el galardonado juego de trivia multijugador y una comunidad de fans. ¡Ahora puedes ganar Premios reales y dinero en WITS! Clic aquí : ";
          referalStr = @"Hola, Mi Código de Referencia es";
          referalStr2 = @". Ayudame a ganar gemas gratis. Jueguemos Wits juntos.";
          _knowlegdeLbl.text = KNOWLEDGE_LBL_3;
          // _shareLbl.text = SHARE_WITS_LBL_3;
          _EarnfreePointLbl.text = INVITE_FRIENDS_3;
          
          knowledgelbl.text = KNOWLEDGE_LBL_3;
          tutorialDescLbl.text = TUTORIAL_DESC_LBL_3;
          tutorialDescLbl2.text = TUTORIAL_DESC_LBL2_3;
          [_SkipBtn setTitle:@"SALTAR" forState:UIControlStateNormal];
          _lblTutorial.text = screenOne3;
        
          HowtoPlay = @"Cómo jugar";
          HowWitsStore = @"Cómo utilizar WITS tienda";
          HowtoEarnPoints = @"Cómo ganar gemas.";
          
          howtoPlay1 = @" Inicie un reto 1-1 contra a cualquiera en el mundo.";
          howtoPlay2 = @"En cuanto más rápido responde más puntos podrá recoger.";
          howtoPlay3 = @"Cambia tus gemas por dinero real.";
          
          howtouseStoreDesc = @"Registrase ahora y gane 1000 puntos gratis";
          howtoEarnPointDesc = @"Puedes ganar pontus gratis invitando a tus amigos y compartiendo la aplicación en Facebook or Twitter.";
          
          //[_tutorialPressed setTitle:TUTORIAL_BTN_3 forState:UIControlStateNormal];
          [_tutorialBacklbl setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [mainBack setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          
     }
     else if(languageCode == 4) {
          referalStr = @"Olá, Meu código de referência é ";
          referalStr2 = @". Ajude me Ganhar Gemas Grátis. Jogue Wits comigo.";
          newShareString = @"WITS é um premiado jogo de trivia multiplayer e uma comunidade de fãs. Agora você pode também ganhar dinheiro e prêmios reais no WITS! Clique aqui : ";
          howtoPlay1 = @"Inicie um desafio de 1-1 contra qualquer pessoa no mundo.";
          howtoPlay2 = @"Quanto mais rápido você responder, mais pontos você vai acumular.";
          howtoPlay3 = @"Troque as suas Gemas por dinheiro verdadeiro.";
          
          howtouseStoreDesc = @"Inscreva-se gratuitamente e ganhe 1000 pontos";
          howtoEarnPointDesc = @"Poderá receber pontus Grátis a todo momento ao convidar os seus amigos ou ao partilhar a App no Facebook ou Twitter.";
          HowtoPlay = @"Como Jogar";
          HowWitsStore = @"Como usar WITS loja";
          HowtoEarnPoints = @"Como ganhar Gemas grátis";
          knowledgelbl.text = KNOWLEDGE_LBL_4;
          tutorialDescLbl.text = TUTORIAL_DESC_LBL_4;
          tutorialDescLbl2.text = TUTORIAL_DESC_LBL2_4;
            _lblTutorial.text = screenOne4;
          _knowlegdeLbl.text = KNOWLEDGE_LBL_4;
          //_shareLbl.text = SHARE_WITS_LBL_4;
          _EarnfreePointLbl.text = INVITE_FRIENDS_4;
             [_SkipBtn setTitle:@"Pular" forState:UIControlStateNormal];
          //[_tutorialPressed setTitle:TUTORIAL_BTN_4 forState:UIControlStateNormal];
          [_tutorialBacklbl setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [mainBack setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          
     }
}





-(void)setLanguage {
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          
          _knowlegdeLbl.text = REFER_YOUR_FRIENDS;
          //_shareLbl.text = EARN_POINT_TEXT;
          
     }
     else if(languageCode == 1 ) {
          
          _knowlegdeLbl.text = REFER_YOUR_FRIENDS_1;
          // _shareLbl.text = EARN_POINT_TEXT_1;
          
     }
     else if(languageCode == 2) {
          
          
          _knowlegdeLbl.text = REFER_YOUR_FRIENDS_2;
          //_shareLbl.text = EARN_POINT_TEXT_2;
          
     }
     else if(languageCode == 3) {
          
          _knowlegdeLbl.text = REFER_YOUR_FRIENDS_3;
          // _shareLbl.text = EARN_POINT_TEXT_3;
          
     }
     else if(languageCode == 4) {
          _knowlegdeLbl.text = REFER_YOUR_FRIENDS_4;
          //_shareLbl.text = EARN_POINT_TEXT_4;
          
     }
}

- (IBAction)tutorialpressed:(id)sender {
     self.tabBarController.tabBar.hidden = true;
     [self.view addSubview:tutorialView];
     
}

- (IBAction)tutorialBackPressed:(id)sender {
     
     [tutorialView removeFromSuperview];
}
- (IBAction)mainBackPressed:(id)sender {
     [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)tutorialSkipPressed:(id)sender {
     self.tabBarController.tabBar.hidden = false;
     [tutorialView removeFromSuperview];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
     
     int indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
     NSString *textToBeShown = @"";
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     //     if(languageCode == 0 ) {
     //     }
     //     else if(languageCode == 1) {
     //     }
     //     else if(languageCode == 2 ) {
     //     }else if(languageCode == 3 ) {
     //     }else if(languageCode == 4 ) {
     //     }
     
     switch (indexOfPage) {
          case 0:
               
               //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
               if(languageCode == 0 ) {
                    textToBeShown = screenOne;
               }
               else if(languageCode == 1) {
                    textToBeShown = screenOne1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screenOne2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screenOne3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screenOne4;
               }
               
               break;
          case 1:
               //   textToBeShown = @"Sign In your preferred method in order to start playing and winning!";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screenTwo;
               }
               else if(languageCode == 1) {
                    textToBeShown = screenTwo1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screenTwo2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screenTwo3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screenTwo4;
               }
               break;
          case 2:
               // textToBeShown = @"Choose a topic out of different categories provided. Choose your favorite one to gain advantage over others!";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screenThree;
               }
               else if(languageCode == 1) {
                    textToBeShown = screenThree1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screenThree2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screenThree3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screenThree4;
               }
               break;
          case 3:
               //               textToBeShown = @"Choose how you want to play! Against a friend or a random opponent from around the globe! The choice is yours!";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screenfour;
               }
               else if(languageCode == 1) {
                    textToBeShown = screenfour1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screenfour2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screenfour3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screenfour4;
               }
               break;
          case 4:
               //textToBeShown = @"Choose what you want to play for Gems - to earn actual Real Rewards OR Points - to improve your ranking in the leaderboards!";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screenfive;
               }
               else if(languageCode == 1) {
                    textToBeShown = screenfive1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screenfive2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screenfive3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screenfive4;
               }
               break;
          case 5:
               // textToBeShown = @"Don't Panic! Just read the question and choose the right answer before your opponent does!";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screensix;
               }
               else if(languageCode == 1) {
                    textToBeShown = screensix1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screensix2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screensix3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screensix4;
               }
               break;
          case 6:
               //textToBeShown = @"Addons are there to help you! Use them to make the competition easier for you!";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screeneight;
               }
               else if(languageCode == 1) {
                    textToBeShown = screeneight1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screeneight2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screeneight3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screeneight4;
               }
               break;
          case 7:
               //               textToBeShown = @"Play more, Earn More Claim your unlocked rewards";
               if(languageCode == 0 ) {
                    //                    textToBeShown = @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!";
                    
                    textToBeShown = screeneight;
               }
               else if(languageCode == 1) {
                    textToBeShown = screeneight1;
               }
               else if(languageCode == 2 ) {
                    textToBeShown = screeneight2;
               }else if(languageCode == 3 ) {
                    textToBeShown = screeneight3;
               }else if(languageCode == 4 ) {
                    textToBeShown = screeneight4;
               }
               break;
               
               
          default:
               break;
     }
     _lblTutorial.text = textToBeShown;
}
@end