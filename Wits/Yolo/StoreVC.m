//
//  StoreVC.m
//  Yolo
//
//  Created by Salman Khalid on 26/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#import "StoreVC.h"
#import "MKNetworkKit.h"
#import "CustomCell.h"
#import "Utils.h"
#import "SharedManager.h"
#import "RightBarVC.h"
#import "NavigationHandler.h"
#import "InAppPurchaseManager.h"
#import "AppDelegate.h"
#import "AddOnViewController.h"
#import "RewardsListVC.h"
#import "AlertMessage.h"


@interface StoreVC ()

@end

@implementation StoreVC

@synthesize pointslbl;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
     self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
     if (self) {
          // Custom initialization
     }
     return self;
}
- (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     [self.tabBarController.tabBar setHidden:false];
     [self setLanguage];
     
     NSString *val = [SharedManager getInstance]._userProfile.cashablePoints;
     if ([val intValue] < 0) {
          [SharedManager getInstance]._userProfile.cashablePoints = @"0";
     }
     
     [cashablePoints setText:[[SharedManager getInstance] _userProfile].cashablePoints];
     [nonCashablePoints setText:[[SharedManager getInstance] _userProfile].totalPoints];
}
- (void)viewDidLoad
{
     [super viewDidLoad];
     
    // self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     
     AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     appDelegate.isStore = true;
     
     [[NSNotificationCenter defaultCenter] addObserver:appDelegate selector:@selector(recieveInventoryUpdate:) name:@"kInAppPurchaseManagerTransactionSucceededNotification" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:appDelegate selector:@selector(recieveInventoryUpdateFailure:) name:@"kInAppPurchaseManagerProductsFetchedNotification" object:nil];
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIUpdaterFailure1:) name:@"kInAppPurchaseManagerTransactionFailedNotification" object:nil];
     
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIUpdaterSuccess:) name:@"kInAppPurchaseManagerTransactionSucceededNotification" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIUpdaterFailure:) name:@"kInAppPurchaseManagerProductsFetchedNotification" object:nil];
     _txtAgreemnt.textColor = [UIColor redColor];
     productsArray = [NSArray arrayWithObjects:@"Double",@"Triple",@"Quarduple",nil];
     
     UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
     numberToolbar.barStyle = UIBarStyleBlackTranslucent;
     numberToolbar.items = [NSArray arrayWithObjects:
                            [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                            nil];
     [numberToolbar sizeToFit];
     cashTxt.inputAccessoryView = numberToolbar;
     
     if(IS_IPHONE_4) {
          O1SendBtn.frame = CGRectMake(13, 290, 259, 42);
          O2sendBtn.frame = CGRectMake(13, 290, 259, 42);
     }
     NSString *pointScore = [[SharedManager getInstance] _userProfile].cashablePoints;
     if([pointScore intValue] < 601) {
          cashOutBtn.enabled = NO;
          [cashOutBtn setBackgroundImage:[UIImage imageNamed:@"disableBar.png"] forState:UIControlStateNormal];
     }
     cashablePoints.font = [UIFont fontWithName:STORE_FONT_NAME size:20];
     _ageemntTitle.font = [UIFont fontWithName:FONT_NAME size:21];
     _txtAgreemnt.font = [UIFont fontWithName:FONT_NAME size:17];
     _acceptBtn.font = [UIFont fontWithName:FONT_NAME size:16];
     _rejectBtn.font = [UIFont fontWithName:FONT_NAME size:16];
     _btnSelect.font = [UIFont fontWithName:FONT_NAME size:17];
     
     if(IS_IPAD)
     {
           cashablePoints.font = [UIFont fontWithName:STORE_FONT_NAME size:30];
     }
}

-(void) setLanguage {
     /*
      IBOutlet UILabel *titleLbl;
      IBOutlet UILabel *cashableTitle;
      IBOutlet UILabel *noncashableTitle;
      IBOutlet UILabel *buyTitle;
      IBOutlet UILabel *cashoutTitle;
      IBOutlet UILabel *currentPointTitle;
      IBOutlet UILabel *descLbl;
      IBOutlet UIButton *cashOutBtn;
      IBOutlet UIButton *buyBtn1;
      IBOutlet UIButton *buyBtn2;
      IBOutlet UIButton *buyBtn3;
      */
     
     
     NSString *language = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     languageCode = [language intValue];
     NSString *suffix = @"";
     if(languageCode == 0 ) {
          
          LblbuyButtonText.text = WITS_STORE_BUY_BUTTON_100;
          
          
          
          
          cashoutAmount.text = @"Cashout Amount";
          loadingTitle = Loading;
          titleLbl.text = WITS_STORE_TITLE;
          cashableTitle.text = CASHABLE_TITLE;
          noncashableTitle.text = NON_CASHABLE_TITLE;
          buyTitle.text = BUY_TITLE;
          cashoutTitle.text = CASHOUT_TITLE;
          currentPointTitle.text = CURRENT_POINT_TITLE;
          descLbl.text = STORE_DESC_LBL;
          _cashOutlbl.text = CASHOUT_TITLE;
          cashoutLbl.text = CASHOUT_TITLE;
          _cashoutLbl2.text = CASHOUT_TITLE;
          BuynowGemslbl.text = BUY_NOW;
          transferGemslbl.text = TRANSFER_POINTS_BTN;
          cashoutGemslbl.text = CASHOUT_TITLE;
          
          
          _ageemntTitle.text = @"WITS Agreement";
          _txtAgreemnt.text = @"We need the necessary information to send you the money safely. Without the required information, WITS can not send you money. WITS keeps all the information highly confidential and ensures the safety of users at highest priority.";
          
          [CancelBtn setTitle:CANCEL forState:UIControlStateNormal];
          [OKBtn setTitle:OK_BTN forState:UIControlStateNormal];
          [_acceptBtn setTitle:@"Accept" forState:UIControlStateNormal];
          [_rejectBtn setTitle:@"Reject" forState:UIControlStateNormal];
          ////////Paypal & Skrill//////
          
          _O1name.placeholder = @"Name";
          _O1emailAccount.placeholder = PAYPAL_EMAIL;
          _O1ContactAccount.placeholder = CONTACT_EMAIL;
          _O1ContactNumber.placeholder = CONTACT_NO;
          _O1Address.placeholder = BANK_ADDRESS;
          [O1SendBtn setTitle:SEND forState:UIControlStateNormal];
          
          /////////BankWire///////
          
          _O2BankTitle.placeholder = BANK_TITLE;
          _O2BankAcoount.placeholder = BANK_ACCOUNT_NO;
          _O2SwiftCode.placeholder = SWIFT_CODE;
          _O2IbanNumber.placeholder = @IBAN;
          _O2BankName.placeholder = BANK_NAME;
          _O2BankLoc.placeholder = BANK_LOCATION;
          
          [O2sendBtn setTitle:SEND forState:UIControlStateNormal];
          
          [backBtn1 setTitle:BACK_BTN forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN forState:UIControlStateNormal];
          [storeMainBack setTitle:BACK_BTN forState:UIControlStateNormal];
          //  [transferPointsBtn setTitle:TRANSFER_POINTS_BTN forState:UIControlStateNormal];
          
          
          // [cashOutBtn setTitle:CASHOUT_TITLE forState:UIControlStateNormal];
          //  [buyBtn1 setTitle:INAPP_BTN1 forState:UIControlStateNormal];
          [buyBtn2 setTitle:INAPP_BTN2 forState:UIControlStateNormal];
          [buyBtn3 setTitle:INAPP_BTN3 forState:UIControlStateNormal];
          
          
     }
     else if(languageCode == 1 ) {
          
          
          cashoutAmount.text = CASHOUT_BTN_TITLE_1;
          loadingTitle = Loading_1;
          RewardsbtnLbl.text = REWARDS_1;
          LblbuyButtonText.text = @"شراء 100 من الأحجار الكريمة";
          titleLbl.text = WITS_STORE_TITLE_1;
          cashableTitle.text = CASHABLE_TITLE_1;
          noncashableTitle.text = NON_CASHABLE_TITLE_1;
          buyTitle.text = BUY_TITLE_1;
          cashoutTitle.text = CASHOUT_TITLE_1;
          currentPointTitle.text = CURRENT_POINT_TITLE_1;
          cashableTitle.textAlignment = NSTextAlignmentRight;
          //cashablePoints.textAlignment = NSTextAlignmentLeft;
          
          cashoutAmount.textAlignment = NSTextAlignmentRight;
          cashoutDollarLbl.textAlignment = NSTextAlignmentRight;
          //   Dollar199.textAlignment = NSTextAlignmentLeft;
          BuynowGemslbl.text = BUY_NOW_1;
          transferGemslbl.text = TRANSFER_POINTS_BTN_1;
          cashoutGemslbl.text = CASHOUT_TITLE_1;
          
          _cashoutLbl2.text = CASHOUT_TITLE_1;
          descLbl.text = STORE_DESC_LBL_1;
          _cashOutlbl.text = CASHOUT_TITLE_1;
          cashoutLbl.text = CASHOUT_TITLE_1;
          _ageemntTitle.text = @"اتفاق WITS";
          _txtAgreemnt.text = @"نحن بحاجة إلى المعلومات اللازمة لنرسل لك المال بأمان. دون المعلومات المطلوبة، لا يمكن لإدارة WITS القيام بعملية التحويل. WITS يبقي على جميع المعلومات سرية للغاية، فضمان سلامة المستخدمين هي أولويتنا القصوى.";
          
          [CancelBtn setTitle:CANCEL_1 forState:UIControlStateNormal];
          [OKBtn setTitle:OK_BTN_1 forState:UIControlStateNormal];
          [_acceptBtn setTitle:@"تقبل" forState:UIControlStateNormal];
          [_rejectBtn setTitle:@"رفض" forState:UIControlStateNormal];
          ////////Paypal & Skrill//////
          
          _O1name.placeholder = @"اسم";
          _O1emailAccount.placeholder = PAYPAL_EMAIL_1;
          _O1ContactAccount.placeholder = CONTACT_EMAIL_1;
          _O1ContactNumber.placeholder = CONTACT_NO_1;
          _O1Address.placeholder = BANK_ADDRESS_1;
          [O1SendBtn setTitle:SEND_1 forState:UIControlStateNormal];
          _O1name.textAlignment = NSTextAlignmentRight;
          _O1emailAccount.textAlignment = NSTextAlignmentRight;
          _O1ContactAccount.textAlignment = NSTextAlignmentRight;
          _O1ContactNumber.textAlignment = NSTextAlignmentRight;
          _O1Address.textAlignment = NSTextAlignmentRight;
          
          /////////BankWire///////
          
          _O2BankTitle.placeholder = BANK_TITLE_1;
          _O2BankAcoount.placeholder = BANK_ACCOUNT_NO_1;
          _O2SwiftCode.placeholder = SWIFT_CODE_1;
          _O2IbanNumber.placeholder = @IBAN_1;
          _O2BankName.placeholder = BANK_NAME_1;
          _O2BankLoc.placeholder = BANK_LOCATION_1;
          
          _O2BankTitle.textAlignment = NSTextAlignmentRight;
          _O2BankAcoount.textAlignment = NSTextAlignmentRight;
          _O2SwiftCode.textAlignment = NSTextAlignmentRight;
          _O2IbanNumber.textAlignment = NSTextAlignmentRight;
          _O2BankName.textAlignment = NSTextAlignmentRight;
          _O2BankLoc.textAlignment = NSTextAlignmentRight;
          
          
          [O2sendBtn setTitle:SEND_1 forState:UIControlStateNormal];
          
          [backBtn1 setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          [storeMainBack setTitle:BACK_BTN_1 forState:UIControlStateNormal];
          //    [transferPointsBtn setTitle:@"نقل نقاط للأصدقاء" forState:UIControlStateNormal];
          
          //  [cashOutBtn setTitle:CASHOUT_TITLE_1 forState:UIControlStateNormal];
          //  [buyBtn1 setTitle:INAPP_BTN1_1 forState:UIControlStateNormal];
          [buyBtn2 setTitle:INAPP_BTN2_1 forState:UIControlStateNormal];
          [buyBtn3 setTitle:INAPP_BTN3_1 forState:UIControlStateNormal];
          
     }
     else if(languageCode == 2) {
          
           RewardsbtnLbl.text = REWARDS_2;
          cashoutAmount.text = CASHOUT_BTN_TITLE_2;
          loadingTitle = Loading_2;
          titleLbl.text = WITS_STORE_TITLE_2;
          LblbuyButtonText.text = @"Acheter 100 gems";
          cashableTitle.text = CASHABLE_TITLE_2;
          noncashableTitle.text = NON_CASHABLE_TITLE_2;
          buyTitle.text = BUY_TITLE_2;
          cashoutTitle.text = CASHOUT_TITLE_2;
          currentPointTitle.text = CURRENT_POINT_TITLE_2;
          descLbl.text = STORE_DESC_LBL_2;
          _cashOutlbl.text = CASHOUT_TITLE_2;
          cashoutLbl.text = CASHOUT_TITLE_2;
          _cashoutLbl2.text = CASHOUT_TITLE_2;
          BuynowGemslbl.text = BUY_NOW_2;
          transferGemslbl.text = TRANSFER_POINTS_BTN_2;
          cashoutGemslbl.text = CASHOUT_TITLE_2;
          
          _ageemntTitle.text = @"Les accords WITS";
          _txtAgreemnt.text = @"Nous avons besoin de cette information pour vous envoyer votre argent en toute sécurité. Sans les informations requises, WITS ne peut pas effectuer le transfert. Toutes les informations sont confidentielles et la sécurité de nos usagers est notre priorité.";
          
          [CancelBtn setTitle:CANCEL_2 forState:UIControlStateNormal];
          [OKBtn setTitle:OK_BTN_2 forState:UIControlStateNormal];
          [_acceptBtn setTitle:@"accepter" forState:UIControlStateNormal];
          [_rejectBtn setTitle:@"Refuser" forState:UIControlStateNormal];
          
          ////////Paypal & Skrill//////
          
          _O1name.placeholder = @"nom";
          _O1emailAccount.placeholder = PAYPAL_EMAIL_2;
          _O1ContactAccount.placeholder = CONTACT_EMAIL_2;
          _O1ContactNumber.placeholder = CONTACT_NO_2;
          _O1Address.placeholder = BANK_ADDRESS_2;
          [O1SendBtn setTitle:SEND_2 forState:UIControlStateNormal];
          
          /////////BankWire///////
          
          _O2BankTitle.placeholder = BANK_TITLE_2;
          _O2BankAcoount.placeholder = BANK_ACCOUNT_NO_2;
          _O2SwiftCode.placeholder = SWIFT_CODE_2;
          _O2IbanNumber.placeholder = @IBAN_2;
          _O2BankName.placeholder = BANK_NAME_2;
          _O2BankLoc.placeholder = BANK_LOCATION_2;
          
          [O2sendBtn setTitle:SEND_2 forState:UIControlStateNormal];
          
          [backBtn1 setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          [storeMainBack setTitle:BACK_BTN_2 forState:UIControlStateNormal];
          //  [transferPointsBtn setTitle:TRANSFER_POINTS_BTN_2 forState:UIControlStateNormal];
          
          //  [cashOutBtn setTitle:CASHOUT_TITLE_2 forState:UIControlStateNormal];
          //    [buyBtn1 setTitle:INAPP_BTN1_2 forState:UIControlStateNormal];
          [buyBtn2 setTitle:INAPP_BTN2_2 forState:UIControlStateNormal];
          [buyBtn3 setTitle:INAPP_BTN3_2 forState:UIControlStateNormal];
     }
     else if(languageCode == 3) {
          
           RewardsbtnLbl.text = @"Premios";
          cashoutAmount.text = @"Ingresa los Puntos";
          loadingTitle = Loading_3;
          LblbuyButtonText.text = @"100 Gemas";
          titleLbl.text = WITS_STORE_TITLE_3;
          cashableTitle.text = CASHABLE_TITLE_3;
          
          noncashableTitle.text = NON_CASHABLE_TITLE_3;
          buyTitle.text = BUY_TITLE_3;
          cashoutTitle.text = CASHOUT_TITLE_3;
          currentPointTitle.text = CURRENT_POINT_TITLE_3;
          descLbl.text = STORE_DESC_LBL_3;
          _cashOutlbl.text = CASHOUT_TITLE_3;
          cashoutLbl.text = CASHOUT_TITLE_3;
          _cashoutLbl2.text = CASHOUT_TITLE_3;
          BuynowGemslbl.text = BUY_NOW_3;
          transferGemslbl.text = TRANSFER_POINTS_BTN_3;
          cashoutGemslbl.text = CASHOUT_TITLE_3;
          
          _ageemntTitle.text = @"Los acuerdos WITS";
          _txtAgreemnt.text = @"Necesitamos esta información para enviarle su dinero con seguridad. Sin la información requerida, no podrá transferir el dinero. Toda la información es confidencial y la seguridad de los usuarios es la prioridad de Wits.";
          
          [CancelBtn setTitle:CANCEL_3 forState:UIControlStateNormal];
          [OKBtn setTitle:OK_BTN_3 forState:UIControlStateNormal];
          [_acceptBtn setTitle:@"aceptar" forState:UIControlStateNormal];
          [_rejectBtn setTitle:@"Rechazar" forState:UIControlStateNormal];
          ////////Paypal & Skrill//////
          
          _O1name.placeholder = @"nombre";
          _O1emailAccount.placeholder = PAYPAL_EMAIL_3;
          _O1ContactAccount.placeholder = CONTACT_EMAIL_3;
          _O1ContactNumber.placeholder = CONTACT_NO_3;
          _O1Address.placeholder = BANK_ADDRESS_3;
          [O1SendBtn setTitle:SEND_3 forState:UIControlStateNormal];
          
          /////////BankWire///////
          
          _O2BankTitle.placeholder = BANK_TITLE_3;
          _O2BankAcoount.placeholder = BANK_ACCOUNT_NO_3;
          _O2SwiftCode.placeholder = SWIFT_CODE_3;
          _O2IbanNumber.placeholder = @IBAN_3;
          _O2BankName.placeholder = BANK_NAME_3;
          _O2BankLoc.placeholder = BANK_LOCATION_3;
          
          [O2sendBtn setTitle:SEND_3 forState:UIControlStateNormal];
          
          [backBtn1 setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          [storeMainBack setTitle:BACK_BTN_3 forState:UIControlStateNormal];
          //  [transferPointsBtn setTitle:TRANSFER_POINTS_BTN_3 forState:UIControlStateNormal];
          //    [cashOutBtn setTitle:CASHOUT_TITLE_3 forState:UIControlStateNormal];
          //  [buyBtn1 setTitle:INAPP_BTN1_3 forState:UIControlStateNormal];
          [buyBtn2 setTitle:INAPP_BTN2_3 forState:UIControlStateNormal];
          [buyBtn3 setTitle:INAPP_BTN3_3 forState:UIControlStateNormal];
     }
     else if(languageCode == 4) {
           RewardsbtnLbl.text = @"Prêmios";
          cashoutAmount.text = CASHOUT_BTN_TITLE_4;
          loadingTitle = Loading_4;
          titleLbl.text = WITS_STORE_TITLE_4;
          cashableTitle.text = CASHABLE_TITLE_4;
          LblbuyButtonText.text = @"Comprar 100 Gems";
          noncashableTitle.text = NON_CASHABLE_TITLE_4;
          buyTitle.text = BUY_TITLE_4;
          cashoutTitle.text = CASHOUT_TITLE_4;
          currentPointTitle.text = CURRENT_POINT_TITLE_4;
          descLbl.text = STORE_DESC_LBL_4;
          _cashOutlbl.text = CASHOUT_TITLE_4;
          cashoutLbl.text = CASHOUT_TITLE_4;
          _cashoutLbl2.text = CASHOUT_TITLE_4;
          BuynowGemslbl.text = BUY_NOW_4;
          transferGemslbl.text = TRANSFER_POINTS_BTN_4;
          cashoutGemslbl.text = CASHOUT_TITLE_4;
          
          _ageemntTitle.text = @"Termo WITS";
          _txtAgreemnt.text = @"Precisamos das informações necessárias para enviar o dinheiro com segurança. Sem as informações exigidas, WITS não conseguirá lhe enviar o dinheiro. WITS mantém suas informações confidenciais e garantimos que a sua segurança é nossa prioridade.";
          
          [CancelBtn setTitle:CANCEL_4 forState:UIControlStateNormal];
          [OKBtn setTitle:OK_BTN_4 forState:UIControlStateNormal];
          [_acceptBtn setTitle:@"aceitar" forState:UIControlStateNormal];
          [_rejectBtn setTitle:@"Rejeitar" forState:UIControlStateNormal];
          ////////Paypal & Skrill//////
          _O1name.placeholder = @"nome";
          _O1emailAccount.placeholder = PAYPAL_EMAIL_4;
          _O1ContactAccount.placeholder = CONTACT_EMAIL_4;
          _O1ContactNumber.placeholder = CONTACT_NO_4;
          _O1Address.placeholder = BANK_ADDRESS_4;
          [O1SendBtn setTitle:SEND_4 forState:UIControlStateNormal];
          /////////BankWire///////
          _O2BankTitle.placeholder = BANK_TITLE_4;
          _O2BankAcoount.placeholder = BANK_ACCOUNT_NO_4;
          _O2SwiftCode.placeholder = SWIFT_CODE_4;
          _O2IbanNumber.placeholder = @IBAN_4;
          _O2BankName.placeholder = BANK_NAME_4;
          _O2BankLoc.placeholder = BANK_LOCATION_4;
          [O2sendBtn setTitle:SEND_4 forState:UIControlStateNormal];
          [backBtn1 setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [backBtn setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          [storeMainBack setTitle:BACK_BTN_4 forState:UIControlStateNormal];
          //  [transferPointsBtn setTitle:TRANSFER_POINTS_BTN_4 forState:UIControlStateNormal];
          //   [cashOutBtn setTitle:CASHOUT_TITLE_4 forState:UIControlStateNormal];
          //  [buyBtn1 setTitle:INAPP_BTN1_4 forState:UIControlStateNormal];
          [buyBtn2 setTitle:INAPP_BTN2_4 forState:UIControlStateNormal];
          [buyBtn3 setTitle:INAPP_BTN3_4 forState:UIControlStateNormal];
     }
     NSString *title;
     if (languageCode == 0 ) {
          title = @"Select option to Cashout ";
          
     } else if(languageCode == 1) {
          title = @"حدد الخيار لسحب المبلغ المالي";
          
     }else if (languageCode == 2){
          title = @"Sélectionnez l'option d'encaisser";
          
     }else if (languageCode == 3){
          title = @"Seleccione la opción de cobrar";
          
          
     }else if (languageCode == 4){
          title = @"Selecione a opção de sacar";
          
     }
     [_btnSelect setTitle:title forState:UIControlStateNormal];
     
}
#pragma mark ----------------------
#pragma mark TableView Data Source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     float returnValue;
     if ([[UIScreen mainScreen] bounds].size.height == iPad)
          returnValue = 72.0f;
     else
          returnValue = 29.0f;
     
     return returnValue;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     
     return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     
     return [productsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     CustomCell *cell ;
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell_iPad" owner:self options:nil];
          cell = [nib objectAtIndex:0];
     }
     else{
          
          NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
          cell = [nib objectAtIndex:0];
     }
     cell.titleLbl.text = [productsArray objectAtIndex:indexPath.row];
     cell.titleLbl.font = [UIFont fontWithName:FONT_NAME size:14];
     [cell.rightArrow setHidden:YES];
     [cell.pricelbl setHidden:NO];
     cell.pricelbl.font = [UIFont fontWithName:FONT_NAME size:14];
     
     if(indexPath.row == 0)
          [cell.pricelbl setText:@"$1.99"];
     
     else if(indexPath.row == 1)
          [cell.pricelbl setText:@"$3.99"];
     
     else if(indexPath.row == 2)
          [cell.pricelbl setText:@"$7.99"];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     return cell;
}
#pragma mark - TableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     
     /*
      Topic *tempTopic  =[topicsArray objectAtIndex:indexPath.row];
      SubTopicVC *tempVC = [[SubTopicVC alloc] initWithParentTopic:tempTopic];
      [self.navigationController pushViewController:tempVC animated:YES];
      */
     
}

- (IBAction)buy100Pressed:(id)sender {
     InAppPurchaseManager *shared = [InAppPurchaseManager sharedInstance];
     [shared loadStore];
     if([shared canMakePurchases]){
          loadView = [[LoadingView alloc] init];
          [loadView showInView:self.view withTitle:loadingTitle];
          pointForPurchase = 100;
          [shared purchase100Points];
     }
    
}

- (IBAction)buy500Pressed:(id)sender {
     InAppPurchaseManager *shared = [InAppPurchaseManager sharedInstance];
     [shared loadStore];
     if([shared canMakePurchases]){
          loadView = [[LoadingView alloc] init];
          [loadView showInView:self.view withTitle:loadingTitle];
          pointForPurchase = 500;
          [shared purchase500Points];
     }
}

- (IBAction)buy1000Points:(id)sender {
     InAppPurchaseManager *shared = [InAppPurchaseManager sharedInstance];
     [shared loadStore];
     if([shared canMakePurchases]){
          loadView = [[LoadingView alloc] init];
          [loadView showInView:self.view withTitle:loadingTitle];
          pointForPurchase = 220;
          [shared purchase1000Points];
     }
}

-(IBAction)ShowRightMenu:(id)sender{
     
     [[RightBarVC getInstance] AddInView:self.view];
     [[RightBarVC getInstance] ShowInView];
}

-(IBAction)purchaseApp:(id)sender{
     
     [[NavigationHandler getInstance] MoveToPurchaseController];
}

- (void)didReceiveMemoryWarning
{
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
     
     [textField resignFirstResponder];
     return YES;
}
- (IBAction)addPoints:(id)sender {
     
     int currentStr = [cashTxt.text intValue];
     currentStr++;
     
     cashTxt.text = [NSString stringWithFormat:@"%d",currentStr];
     float amount = (float) currentStr/100;
     cashoutDollarLbl.text = [NSString stringWithFormat:@"$%.1f",amount];
}

- (IBAction)deductPoints:(id)sender {
     int currentStr = [cashTxt.text intValue];
     currentStr--;
     
     cashTxt.text = [NSString stringWithFormat:@"%d",currentStr];
     float amount = (float) currentStr/100;
     cashoutDollarLbl.text = [NSString stringWithFormat:@"$%.1f",amount];
}

- (IBAction)cashOutPressed:(id)sender {
     isPriceEntered = true;
     overlayView.hidden = false;
     cashoutSmallView.hidden = false;
     
     int available = [[[SharedManager getInstance] _userProfile].cashablePoints intValue];
     int maximumCashOut =available  - 100;
     
     float amount = (float) maximumCashOut/100;
     
     cashoutDollarLbl.text = [NSString stringWithFormat:@"$%.1f",amount];
     
     cashTxt.text = [NSString stringWithFormat:@"%d",maximumCashOut];
     
     
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
     [self animateTextField: textField up: YES];
     if(textField.tag == 21) {
          isNumKeypad = true;
          
     }
     else {
          isNumKeypad = false;
     }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
     int currentStr = [cashTxt.text intValue];
     float amount = (float) currentStr/100;
     cashoutDollarLbl.text = [NSString stringWithFormat:@"$%.1f",amount];
     [self animateTextField: textField up: NO];
}


-(void) doneButton :(id) sender {
     if(isNumKeypad) {
          [self.view endEditing:true];
     }
     
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
     const int movementDistance = 150; // tweak as needed
     const float movementDuration = 0.3f; // tweak as needed
     
     int movement = (up ? -movementDistance : movementDistance);
     
     [UIView beginAnimations: @"anim" context: nil];
     [UIView setAnimationBeginsFromCurrentState: YES];
     [UIView setAnimationDuration: movementDuration];
     self.view.frame = CGRectOffset(self.view.frame, 0, movement);
     [UIView commitAnimations];
}

- (IBAction)selectClicked:(id)sender {
     NSArray * arr = [[NSArray alloc] init];
     arr = [NSArray arrayWithObjects:@"Paypal", @"Skrill", @"Bank Wire",nil];
     NSArray * arrImage = [[NSArray alloc] init];
     arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@""], [UIImage imageNamed:@""], nil];
     if(dropDown == nil) {
          CGFloat f = 120;
          dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrImage :@"down":false];
          dropDown.delegate = self;
     }
     else {
          [dropDown hideDropDown:sender];
          [self rel];
     }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
     
     _O1name.text = nil;
     _O1emailAccount.text = nil;
     _O1ContactAccount.text = nil;
     _O1ContactNumber.text = nil;
     _O1Address.text = nil;
     
     
     _O2BankTitle.text = nil;
     _O2BankAcoount.text = nil;
     _O2SwiftCode.text = nil;
     _O2IbanNumber.text = nil;
     _O2BankName.text = nil;
     _O2BankLoc.text = nil;
     
     if(sender.selectedIndex == 0) {
          _O2View.hidden = true;
          _O1View.hidden = false;
          paymentMethod = @"Paypal";
     }
     else if (sender.selectedIndex == 1) {
          _O2View.hidden = true;
          _O1View.hidden = false;
          paymentMethod = @"Skrill";
     }
     else if (sender.selectedIndex == 2) {
          _O1View.hidden = true;
          _O2View.hidden = false;
          paymentMethod = @"Bank Wire";
     }
     else {
          
          
          _O1View.hidden = true;
          _O2View.hidden = true;
          
          
     }
     [self rel];
}
-(void)rel{
     //    [dropDown release];
     dropDown = nil;
}

- (IBAction)O1SendPressed:(id)sender {
     
     _O2View.hidden = YES;
     
     if(_O1name.text.length > 0 && _O1emailAccount.text.length > 0 && _O1ContactAccount.text.length > 0 && _O1ContactNumber.text.length > 0 && _O1Address.text.length > 0) {
          if([self NSStringIsValidEmail:_O1emailAccount.text] && [self NSStringIsValidEmail:_O1ContactAccount.text]) {
               if([MFMailComposeViewController canSendMail]) {
                    NSString *emailTitle = [NSString stringWithFormat:@"Cash Out Request [%@]",[[SharedManager getInstance] _userProfile].display_name];
                    // Email Content
                    
                    NSString *messageBody = [NSString stringWithFormat:@"Cash Out Request \n User : %@ \n Payment Method : %@ \n Amount : %@ \n Name : %@ \n User Email : %@ \n Contact Email : %@ \n Contact Number : %@ \n Address : %@ \n Note: This request will be processed within 5-10 working days.",[NSString stringWithFormat:@"%@",[[SharedManager getInstance] _userProfile].display_name], paymentMethod, cashTxt.text, _O1name.text, _O1emailAccount.text, _O1ContactAccount.text, _O1ContactNumber.text, _O1Address.text];
                    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                    mc.mailComposeDelegate = self;
                    
                    
                    [mc setSubject:emailTitle];
                    NSArray *usersTo = [NSArray arrayWithObject: @"wits.cashout@gmail.com"];
                    [mc setToRecipients:usersTo];
                    [mc setMessageBody:messageBody isHTML:NO];
                    
                    // Present mail view controller on screen
                    [self presentViewController:mc animated:YES completion:NULL];
               }
          }
          else {
               
               
               NSString *emailMsg;
               
               if (languageCode == 0 ) {
                    emailMsg = @"Email not in valid format";
                    
               } else if(languageCode == 1) {
                    emailMsg = @"الرجاء تقديم عنوان بريدك الإلكتروني الصحيح!";
                    
               }else if (languageCode == 2){
                    emailMsg = @"Veuillez fournir une adresse e-mail correcte!";
                    
               }else if (languageCode == 3){
                    emailMsg = @"Por favor ingrese un correo electrónico correcto!";
                    
               }else if (languageCode == 4){
                    emailMsg = @"Por favor, forneça um endereço de e-mail correto!";
                    
               }
               
               
               
               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                               message:emailMsg
                                                              delegate:nil
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:nil, nil];
               [toast show];
               
               int duration = 2; // duration in seconds
               
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [toast dismissWithClickedButtonIndex:0 animated:YES];
               });
          }
     }
     else {
          
          
          NSString *emptyfield;
          
          if (languageCode == 0) {
               emptyfield = @"Please fill all the fields!";
          }else if (languageCode == 1){
               emptyfield = @"يجب ملء هذا الحقل!";
          }else if (languageCode == 2){
               emptyfield = @"ce champ doit être rempli!";
          }else if(languageCode == 3){
               emptyfield = @"Este campo deve ser preenchido!";
          }else if (languageCode == 4){
               emptyfield = @"Este campo deve ser preenchido!";
          }
          
          
          UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                          message:emptyfield
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil, nil];
          [toast show];
          
          int duration = 2; // duration in seconds
          
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
               [toast dismissWithClickedButtonIndex:0 animated:YES];
          });
     }
}
- (IBAction)O2SendPressed:(id)sender {
     _O1View.hidden= true;
     
     if(_O2BankAcoount.text.length > 0 && _O2BankLoc.text.length > 0 && _O2BankName.text.length > 0 && _O2BankTitle.text.length > 0 && _O2SwiftCode.text.length > 0) {
          if([MFMailComposeViewController canSendMail]) {
               
               
               NSString *emailTitle = [NSString stringWithFormat:@"Cash Out Request [%@]",[[SharedManager getInstance] _userProfile].display_name];
               // Email Content
               NSString *messageBody = [NSString stringWithFormat:@"Cash Out Request \n User : %@ \n Payment Method : %@ \n Amount : %@ \n Bank Account : %@ \n Bank Location : %@ \n Bank Name : %@ \n Bank Title : %@ \n IBAN : %@ \n Swift Code : %@ \n Note: This request will be processed within 5-10 working days.",[NSString stringWithFormat:@"%@",[[SharedManager getInstance] _userProfile].display_name], paymentMethod, cashTxt.text, _O2BankAcoount.text, _O2BankLoc.text, _O2BankName.text, _O2BankTitle.text, _O2IbanNumber.text,_O2SwiftCode.text];
               MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
               mc.mailComposeDelegate = self;
               
               
               [mc setSubject:emailTitle];
               NSArray *usersTo = [NSArray arrayWithObject: @"wits.cashout@gmail.com"];
               [mc setToRecipients:usersTo];
               [mc setMessageBody:messageBody isHTML:NO];
               
               // Present mail view controller on screen
               [self presentViewController:mc animated:YES completion:NULL];
          }
          else {
               
               
               NSString *emailMsg;
               
               if (languageCode == 0 ) {
                    emailMsg = @"Email not in valid format";
                    
               } else if(languageCode == 1) {
                    emailMsg = @"الرجاء تقديم عنوان بريدك الإلكتروني الصحيح!";
                    
               }else if (languageCode == 2){
                    emailMsg = @"Veuillez fournir une adresse e-mail correcte!";
                    
               }else if (languageCode == 3){
                    emailMsg = @"Por favor ingrese un correo electrónico correcto!";
                    
               }else if (languageCode == 4){
                    emailMsg = @"Por favor, forneça um endereço de e-mail correto!";
                    
               }
               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                               message:emailMsg
                                                              delegate:nil
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:nil, nil];
               [toast show];
               int duration = 2; // duration in seconds
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [toast dismissWithClickedButtonIndex:0 animated:YES];
               });
          }
     }
     else {
          
          
          NSString *emptyfield;
          
          if (languageCode == 0) {
               emptyfield = @"Please fill all the fields!";
          }else if (languageCode == 1){
               emptyfield = @"يجب ملء هذا الحقل!";
          }else if (languageCode == 2){
               emptyfield = @"ce champ doit être rempli!";
          }else if(languageCode == 3){
               emptyfield = @"Este campo deve ser preenchido!";
          }else if (languageCode == 4){
               emptyfield = @"Este campo deve ser preenchido!";
          }
          
          
          UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                          message:emptyfield
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil, nil];
          [toast show];
          int duration = 2; // duration in seconds
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
               [toast dismissWithClickedButtonIndex:0 animated:YES];
          });
     }
}

- (IBAction)backPressed:(id)sender {
     _O1View.hidden = true;
     _O2View.hidden = true;
     
     _O1name.text = nil;
     _O1emailAccount.text = nil;
     _O1ContactAccount.text = nil;
     _O1ContactNumber.text = nil;
     _O1Address.text = nil;
     
     
     _O2BankTitle.text = nil;
     _O2BankAcoount.text = nil;
     _O2SwiftCode.text = nil;
     _O2IbanNumber.text = nil;
     _O2BankName.text = nil;
     _O2BankLoc.text = nil;
     
     overlayView.hidden = true;
     cashoutSmallView.hidden = true;
     [_cashOutView removeFromSuperview];
     [_ViewAgreement removeFromSuperview];
     
}

- (IBAction)transferPoints:(id)sender {
     [[NavigationHandler getInstance] MoveToTransferPoints];
}

- (IBAction)pointsOkayPressed:(id)sender {
     
     _txtAgreemnt.layer.borderColor = [[UIColor lightGrayColor]CGColor];
     _txtAgreemnt.layer.borderWidth = 1.0f;
     
     //[self.view addSubview:_ViewAgreement];
     [self.view endEditing:true];
     if(isPriceEntered) {
          int price = [cashTxt.text intValue];
          NSString *availablePoints = [[SharedManager getInstance] _userProfile].cashablePoints;
          
          if(price >=100 && [availablePoints intValue]> 600 ) {
               if(price <= [availablePoints intValue]) {
                    int margin = [availablePoints intValue] - price;
                    if(margin >= 100) {
                         
                         _O1View.hidden = true;
                         _O2View.hidden = true;
                         
                         NSString *message;
                         
                         if (languageCode == 0 ) {
                              message = @"Select option to Cashout ";
                              
                         } else if(languageCode == 1) {
                              message = @"حدد الخيار لسحب المبلغ المالي";
                              
                         }else if (languageCode == 2){
                              message = @"Sélectionnez l'option d'encaisser";
                              
                         }else if (languageCode == 3){
                              message = @"Seleccione la opción de cobrar";
                              
                              
                         }else if (languageCode == 4){
                              message = @"Selecione a opção de sacar";
                              
                         }
                         [_btnSelect setTitle:message forState:UIControlStateNormal];
                         
                         [self.view addSubview:_ViewAgreement];
                         _ViewAgreement.hidden= false;
                         
                         _btnSelect.layer.borderWidth = 1;
                         _btnSelect.layer.cornerRadius = 5;
                    }
                    else {
                         
                         
                         NSString *emptyfield;
                         
                         if (languageCode == 0 ) {
                              emptyfield = @"Always leave 100 Gems in your balance to be able to Transfer";
                              
                         } else if(languageCode == 1) {
                              emptyfield = @"حاول دائماً أن تترك في رصيدك 100 جوهرة لتستطيع التحويل";
                              
                         }else if (languageCode == 2){
                              emptyfield = @"Pour pouvoir encaisser, vous devez laisser au moins 100 Gems sur votre compte.";
                              
                         }else if (languageCode == 3){
                              emptyfield = @"Siempre deja 100 gemas en tu cuenta para poder transferir";
                              
                         }else if (languageCode == 4){
                              emptyfield = @"Deixe sempre 100 Gemas na sua conta afim de poder efetuar transferências";
                              
                         }
                         UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                         message:emptyfield
                                                                        delegate:nil
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:nil, nil];
                         [toast show];
                         
                         int duration = 2; // duration in seconds
                         
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                              [toast dismissWithClickedButtonIndex:0 animated:YES];
                         });
                    }
                    
               }
               else {
                    NSString *message;
                    if (languageCode == 0 ) {
                         message = @"You dont have sufficient Gems";
                         
                    } else if(languageCode == 1) {
                         message = @"ليس لديك رصيد كافٍ من الجواهر";
                         
                    }else if (languageCode == 2){
                         message = @"Vous n'avez pas assez de Gems";
                         
                    }else if (languageCode == 3){
                         message = @"No tienes suficientes gemas";
                         
                    }else if (languageCode == 4){
                         message = @"Não tem Gemas suficientes";
                         
                    }
                    
                    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:nil, nil];
                    [toast show];
                    
                    int duration = 2; // duration in seconds
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                         [toast dismissWithClickedButtonIndex:0 animated:YES];
                    });
               }
          }
          else {
               NSString *message;
               if (languageCode == 0 ) {
                    message = @"Minimum cash out limit is 100 Gems";
                    
               } else if(languageCode == 1) {
                    message = @"الحد الأدنى للتمكن من نقد النقاط/اتمام عملية السحب هو 100 نقطة";
                    
               }else if (languageCode == 2){
                    message = @"Un mínimo de 100 Gems es necesario para convertir sus puntos";
                    
               }else if (languageCode == 3){
                    message = @"Un minimum de 100 Gems est nécessaire pour effectuer un retrait";
                    
               }else if (languageCode == 4){
                    message = @"O limite mínimo para descontar é 100 Gems";
                    
               }
               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                               message:message
                                                              delegate:nil
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:nil, nil];
               [toast show];
               
               int duration = 2; // duration in seconds
               
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [toast dismissWithClickedButtonIndex:0 animated:YES];
               });
          }
     }
     else {
          
          NSString *message;
          if (languageCode == 0 ) {
               message = @"Please enter cashable amount";
               
          } else if(languageCode == 1) {
               message = @"أدخل نقاطك";
               
          }else if (languageCode == 2){
               message = @"Ingresa los Gems";
               
          }else if (languageCode == 3){
               message = @"Ajoutez des Gems";
               
          }else if (languageCode == 4){
               message = @"Insira a quantidade de Gems";
               
          }
          
          
          UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil, nil];
          [toast show];
          
          int duration = 2; // duration in seconds
          
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
               [toast dismissWithClickedButtonIndex:0 animated:YES];
          });
     }
}

- (IBAction)pointsCancelPressed:(id)sender {
     overlayView.hidden = true;
     
     cashoutSmallView.hidden = true;
     
     [self.view endEditing:true];
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
     BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
     NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
     NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
     NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
     return [emailTest evaluateWithObject:checkString];
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
          case MFMailComposeResultSent:{
               
               [loadView showInView:self.view withTitle:loadingTitle];
               MKNetworkEngine *engine=[[MKNetworkEngine alloc] initWithHostName:nil];
               NSMutableDictionary *postParams = [[NSMutableDictionary alloc] init];
               
               [postParams setObject:@"pointsDeduction" forKey:@"method"];
               
               [postParams setObject:[SharedManager getInstance].userID forKey:@"user_id"];
               [postParams setObject:[SharedManager getInstance].sessionID forKey:@"session_id"];
               [postParams setObject:cashTxt.text forKey:@"deducted_point"];
               [loadView showInView:self.view withTitle:loadingTitle];
               MKNetworkOperation *op = [engine operationWithURLString:SERVER_URL params:postParams httpMethod:@"POST"];
               
               [op onCompletion:^(MKNetworkOperation *completedOperation) {
                    
                    [loadView hide];
                    NSDictionary *responseDict = [completedOperation responseJSON];
                    NSNumber *flag = [responseDict objectForKey:@"flag"];
                    
                    if([flag isEqualToNumber:[NSNumber numberWithInt:SUCCESSFUL_LOGIN_FLAG]])
                    {
                         [loadView hide];
                         int remainingPoints = [[[SharedManager getInstance] _userProfile].cashablePoints intValue] - [cashTxt.text intValue];
                         [[SharedManager getInstance] _userProfile].cashablePoints = [NSString stringWithFormat:@"%d",remainingPoints];
                         cashablePoints.text = [[SharedManager getInstance] _userProfile].cashablePoints;
                         cashTxt.text = [[SharedManager getInstance] _userProfile].cashablePoints;
                         
                         NSString *message;
                         
                         if (languageCode == 0 ) {
                              message = @"Request sent Succesfully";
                              
                         } else if(languageCode == 1) {
                              message = @"أرسل طلب بنجاح";
                              
                         }else if (languageCode == 2){
                              message = @"Demande correctement envoyé";
                              
                         }else if (languageCode == 3){
                              message = @"Solicitud envió con éxito";
                              
                         }else if (languageCode == 4){
                              message = @"Solicitação enviada com sucesso";
                              
                         }
                         
                         
                         UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                         message:message
                                                                        delegate:nil
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:nil, nil];
                         [toast show];
                         
                         int duration = 2; // duration in seconds
                         
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                              [toast dismissWithClickedButtonIndex:0 animated:YES];
                              NSString *pointScore = [[SharedManager getInstance] _userProfile].cashablePoints;
                              if([pointScore intValue] < 601) {
                                   cashOutBtn.enabled = NO;
                                   [cashOutBtn setBackgroundImage:[UIImage imageNamed:@"disableBar.png"] forState:UIControlStateNormal];
                              }
                         });
                    }
                    else
                    {
                         NSString *message;
                         
                         
                         if (languageCode == 0 ) {
                              message = @"Something went wrong.";
                              
                         } else if(languageCode == 1) {
                              message = @"لقد حصل خطأ ما";
                              
                         }else if (languageCode == 2){
                              message = @"Erreur: Quelque chose s\'est mal passé!";
                              
                         }else if (languageCode == 3){
                              message = @"Algo salió mal!";
                              
                         }else if (languageCode == 4){
                              message = @"Alguma coisa deu errado!";
                              
                         }
                         
                         
                         
                         
                         UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                               
                                                                         message:message
                                                                        delegate:nil
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:nil, nil];
                         [toast show];
                         
                         int duration = 2; // duration in seconds
                         
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                              [toast dismissWithClickedButtonIndex:0 animated:YES];
                         });
                    }
               } onError:^(NSError* error) {
                    
                    
               }];
               
               [engine enqueueOperation:op];
          }
               break;
          case MFMailComposeResultFailed: {
               NSLog(@"Mail sent failure: %@", [error localizedDescription]);
               
               NSString *message;
               if (languageCode == 0 ) {
                    message = @"Something went wrong.";
                    
               } else if(languageCode == 1) {
                    message = @"لقد حصل خطأ ما";
                    
               }else if (languageCode == 2){
                    message = @"Erreur: Quelque chose s\'est mal passé!";
                    
               }else if (languageCode == 3){
                    message = @"Algo salió mal!";
                    
               }else if (languageCode == 4){
                    message = @"Alguma coisa deu errado!";
                    
               }
               
               
               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                               message:message
                                                              delegate:nil
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:nil, nil];
               [toast show];
               
               int duration = 2; // duration in seconds
               
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [toast dismissWithClickedButtonIndex:0 animated:YES];
               });
               break;
          }
          default:
               break;
     }
     [_cashOutView removeFromSuperview];
     // Close the Mail Interface
     [self dismissViewControllerAnimated:YES completion:NULL];
}


-(void)cancelNumberPad{
     [cashTxt resignFirstResponder];
}

-(void)doneWithNumberPad{
     [cashTxt resignFirstResponder];
}
- (IBAction)AcceptAgremnt:(id)sender {
     
     [self.view addSubview:_cashOutView];
     
     /*  [self.view endEditing:true];
      if(isPriceEntered) {
      int price = [cashTxt.text intValue];
      NSString *availablePoints = [[SharedManager getInstance] _userProfile].cashablePoints;
      if(price >= 601) {
      if(price <= [availablePoints intValue]) {
      int margin = [availablePoints intValue] - price;
      if(margin >= 100) {
      
      _O1View.hidden = true;
      _O2View.hidden = true;
      paymentMethod = @"Select Options";
      
      [self.view addSubview:_cashOutView];
      btnSelect.layer.borderWidth = 1;
      btnSelect.layer.borderColor = [[UIColor blackColor] CGColor];
      btnSelect.layer.cornerRadius = 5;
      }
      else {
      NSString *message = @"Always leave 100 points in your balance to be able to cash out";
      
      UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
      message:message
      delegate:nil
      cancelButtonTitle:nil
      otherButtonTitles:nil, nil];
      [toast show];
      
      int duration = 2; // duration in seconds
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      [toast dismissWithClickedButtonIndex:0 animated:YES];
      });
      }
      
      }
      else {
      NSString *message = @"Amount exceeding your balance";
      
      UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
      message:message
      delegate:nil
      cancelButtonTitle:nil
      otherButtonTitles:nil, nil];
      [toast show];
      
      int duration = 2; // duration in seconds
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      [toast dismissWithClickedButtonIndex:0 animated:YES];
      });
      }
      }
      else {
      NSString *message = @"Amount should be greater than 600";
      
      UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
      message:message
      delegate:nil
      cancelButtonTitle:nil
      otherButtonTitles:nil, nil];
      [toast show];
      
      int duration = 2; // duration in seconds
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      [toast dismissWithClickedButtonIndex:0 animated:YES];
      });
      }
      }
      else {
      NSString *message = @"Please enter cashable amount";
      
      UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
      message:message
      delegate:nil
      cancelButtonTitle:nil
      otherButtonTitles:nil, nil];
      [toast show];
      
      int duration = 2; // duration in seconds
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      [toast dismissWithClickedButtonIndex:0 animated:YES];
      });
      }*/
}

- (IBAction)RejectAgreemnt:(id)sender {
     
     overlayView.hidden = true;
     
     cashoutSmallView.hidden = true;
     
     [self.view endEditing:true];
     [_ViewAgreement removeFromSuperview];
     
}

- (IBAction)AgreemntBackPress:(id)sender {
     
     overlayView.hidden = true;
     
     cashoutSmallView.hidden = true;
     
     [self.view endEditing:true];
     [_ViewAgreement removeFromSuperview];
}

- (void)UIUpdaterSuccess:(NSNotification *)notification {
     
     int points = [cashablePoints.text intValue];
     points = points+100;
     
     NSString *totalPoints = [NSString stringWithFormat:@"%d",points];
     [cashablePoints setText:totalPoints];
     
}
- (void)UIUpdaterFailure:(NSNotification *)notification {
     //[loadView hide];
}
- (void)UIUpdaterFailure1:(NSNotification *)notification {
     [loadView hide];
     NSString *messageStr = @"";
     
     NSString *title;
     NSString *cancel;
     if (languageCode == 0 ) {
          messageStr = @"Something went wrong, Try again Later";
          title = @"Error";
          cancel = CANCEL;
     } else if(languageCode == 1) {
          messageStr = @"وقع خطأ ما، حاول مرة أخرى في وقت لاحق";
          title = @"خطأ";
          cancel = CANCEL_1;
     }else if (languageCode == 2){
          messageStr = @"Quelque chose se est mal passé, réessayez plus tard";
          title = @"Erreur";
          cancel = CANCEL_2;
     }else if (languageCode == 3){
          messageStr = @"Ha ocurrido un error, inténtalo más tarde";
          title = @"Error";
          cancel = CANCEL_3;
     }else if (languageCode == 4){
          messageStr = @"Algo deu errado, tente novamente mais tarde";
          title = @"Erro";
          cancel = CANCEL_4;
     }
     
     [AlertMessage showAlertWithMessage:messageStr  andTitle:title SingleBtn:YES cancelButton:cancel OtherButton:nil];

}

- (IBAction)addOnsPressed:(id)sender {
     
     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
          
          AddOnViewController *update = [[AddOnViewController alloc] initWithNibName:@"AddOnViewController_iPad" bundle:nil];
          [self.navigationController pushViewController:update animated:YES];
     }
     else{
          
          AddOnViewController *update = [[AddOnViewController alloc] initWithNibName:@"AddOnViewController" bundle:nil];
          [self.navigationController pushViewController:update animated:YES];
     }
}

- (IBAction)rewardsPressed:(id)sender {
//     if ([[UIScreen mainScreen] bounds].size.height == iPad) {
//          
//          RewardsListVC *update = [[RewardsListVC alloc] initWithNibName:@"RewardsListVC_iPad" bundle:nil];
//          [self.navigationController pushViewController:update animated:YES];
//     }
//     else{
//          
//          RewardsListVC *update = [[RewardsListVC alloc] initWithNibName:@"RewardsListVC" bundle:nil];
//          [self.navigationController pushViewController:update animated:YES];
//     }
     [self.tabBarController setSelectedIndex:3];
}

- (IBAction)StoreMainBackPressed:(id)sender {
     [self.navigationController popViewControllerAnimated:NO];
}
@end
