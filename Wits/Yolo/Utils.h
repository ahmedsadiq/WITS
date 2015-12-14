//
//  Utils.h
//  Yolo
//
//  Created by Salman Khalid on 10/06/2014.
//  Copyright (c) 2014 Xint Solutions. All rights reserved.
//

#ifndef Yolo_Utils_h
#define Yolo_Utils_h

#define IS_IPHONE_6 ([[UIScreen mainScreen] bounds].size.height == 667)
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define IS_IPHONE_4 ([[UIScreen mainScreen] bounds].size.height == 480)
#define IS_IPAD ([[UIScreen mainScreen] bounds].size.height == 1024)
//#define SERVER_URL @"http://quizapplication.faditekdev.com/api/service.php"

/////Live Server///

//#define SERVER_URL @"http://quizapplication.witsapplication.com/api/service.php"
////// Dev Server
#define SERVER_URL @"http://witsdev.witsapplication.com/api/service.php"

//#define FONT_NAME @"PTC55F"
#define FONT_NAME @"PTSans-Caption"
#define STORE_FONT_NAME @"GameFont7"

//#define WEBSOCKETS_URL @"ws://192.163.211.75:1215"

///Port changed for testing////

#define WEBSOCKETS_URL @"ws://192.163.211.75:4000"

#define StaticlblTAG -2

#define HIDE_TAG -888

#define ALPHA_OVERLAY_VALUE 0.4


#define GOOGlE_SCHEME @"com.faditek.wits"
#define FACEBOOK_SCHEME @"fb1524399421105901"
#define INVALID_CREDENTIALS 0
#define SUCCESSFUL_LOGIN_FLAG 1
#define USER_ALREADY_FLAG 2

#define CAMERA_INDEX 0
#define GALLERY_INDEX 1
#define AVATAR_INDEX 2

#define iPad_KeyBoard_PORTRAIT_OFFSET 250
#define iPhone_KeyBoard_PORTRAIT_OFFSET 215
#define docs [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

/////HOme//////
#define Loading @"Loading"
#define APP_NAME @"Wits"
#define HOME_PAGE_TITLE @"Home"
#define PLAY_NOW @"Play Now"
#define Challenge_a_friend @"Challenge a Friend"
#define WITS_STORE @"WITS Store"
#define EARN_FREE_POINTS @"Earn Free Points"
#define MY_MESSAGE @"My Messages"
#define MY_FRIENDS @"My Friends"
#define RANKING @"Ranking"
#define SETTINGS @"Settings"

#define Loading_1 @"تحميل..."
#define APP_NAME_1 @"Wits"
#define HOME_PAGE_TITLE_1 @"الصفحة الرئسية"
#define PLAY_NOW_1 @"تلعب الآن!"
#define Challenge_a_friend1 @"اضغط لقبول التحدي"
#define WITS_STORE_1 @"متجر الويتس"
#define EARN_FREE_POINTS_1 @"احصل على النقاط مجانية"
#define MY_MESSAGE_1 @"رسائلي"
#define MY_FRIENDS_1 @"اصدقائي"
#define RANKING_1 @" تصنيف"
#define SETTINGS_1 @"إعدادات"

#define Loading_2 @"Chargement en cours ..."
#define APP_NAME_2 @"Wits"
#define HOME_PAGE_TITLE_2 @"Accueil"
#define PLAY_NOW_2 @"Jouez maintenant!"
#define Challenge_a_friend2 @ "Desafío"
#define WITS_STORE_2 @"WITS Boutique"
#define EARN_FREE_POINTS_2 @"Gagnez des Points"
#define MY_MESSAGE_2 @"Mes Messages"
#define MY_FRIENDS_2 @"Mes Amis"
#define RANKING_2 @"Classements"
#define SETTINGS_2 @"paramètres"

#define Loading_3 @"Cargando..."
#define APP_NAME_3 @"Wits"
#define Challenge_a_friend3 @"défi"
#define HOME_PAGE_TITLE_3 @"Inicio"
#define PLAY_NOW_3 @"Jugar ahora"
#define WITS_STORE_3 @"WITS Tienda"
#define EARN_FREE_POINTS_3 @"Gana pontus gratis"
#define MY_MESSAGE_3 @"Mis mensajes"
#define MY_FRIENDS_3 @"Mis Amigos"
#define RANKING_3 @"Clasificaciones"
#define SETTINGS_3 @"Ajustes"

#define Loading_4 @"Carregando..."
#define APP_NAME_4 @"Wits"
#define HOME_PAGE_TITLE_4 @"Início"
#define PLAY_NOW_4 @"Jogue Agora"
#define Challenge_a_friend4 @"Desafie um Amigo"
#define WITS_STORE_4 @"WITS loja"
#define EARN_FREE_POINTS_4 @"Ganhe pontus grátis"
#define MY_MESSAGE_4 @"Meus Mensagens"
#define MY_FRIENDS_4 @"Meus Amigos"
#define RANKING_4 @"Classificação "
#define SETTINGS_4 @"configurações"

///////Store/////

#define WITS_STORE_BUY_BUTTON_100 @"Buy 100 Gems"
#define WITS_STORE_BUY_BUTTON_100_1 @"شراء 100 الأحجار الكريمة"
#define WITS_STORE_BUY_BUTTON_100_2 @"Comprar 100 Gemas"
#define WITS_STORE_BUY_BUTTON_100_3 @"Acheter 100 Gems"
#define WITS_STORE_BUY_BUTTON_100_4 @"Compre 100 Gems"


#define WITS_STORE_TITLE @"WITS Store"
#define CASHABLE_TITLE @"Gems :"
#define NON_CASHABLE_TITLE @"Non Cashable : "
#define BUY_TITLE @"Buy More Gems"
#define CASHOUT_TITLE @"CashOut Gems"
#define CURRENT_POINT_TITLE @"Current Gems:"
#define STORE_DESC_LBL @"Minimum cash out limit is 100 Gems"
#define CASHOUT_BTN_TITLE @"Cash Out"
#define PLZ_ENTER_POINTS @"Please Enter Points"
#define BUY_NOW @"Buy Now"

#define INAPP_BTN1 @"100 Gems"
#define INAPP_BTN2 @"220 Gems"
#define INAPP_BTN3 @"500 Gems"

#define WITS_STORE_TITLE_1 @"متجر الويتس "
#define CASHABLE_TITLE_1 @"النقاط:"
#define NON_CASHABLE_TITLE_1 @"غير قابل للصرف نقدا"
#define BUY_TITLE_1 @"اشتري المزيد من النقاط"
#define CASHOUT_TITLE_1 @"استبدل جواهرك بنقود"
#define CURRENT_POINT_TITLE_1 @"الرصيد الحالي من الجواهر:"
#define STORE_DESC_LBL_1 @"الحد الأدنى لاستبدال الجواهر هو 100 جوهرة "
#define CASHOUT_BTN_TITLE_1 @"صرف نقاطك إلى مال"
#define PLZ_ENTER_POINTS_1 @"من فضلك ادخل النقاط"
#define BUY_NOW_1 @"اشتري الآن"


#define INAPP_BTN1_1 @"نقطة 100"
#define INAPP_BTN2_1 @"220 نقطة"
#define INAPP_BTN3_1 @"500 نقطة"

#define WITS_STORE_TITLE_2 @"Wits Boutique"
#define CASHABLE_TITLE_2 @"Cashable :"
#define NON_CASHABLE_TITLE_2 @"Non Cashable"
#define BUY_TITLE_2 @"Acheter plus de Gems"
#define CASHOUT_TITLE_2 @"Cash out"
#define CURRENT_POINT_TITLE_2 @"Vos Gems:"
#define STORE_DESC_LBL_2 @"L'encaissement minimum est de 100 Gems"
#define CASHOUT_BTN_TITLE_2 @"Cash out"
#define PLZ_ENTER_POINTS_2 @"Entrez le nombre de Points"
#define BUY_NOW_2 @"Achetez maintenant"

#define INAPP_BTN1_2 @"100 Gems"
#define INAPP_BTN2_2 @"220 Gems"
#define INAPP_BTN3_2 @"500 Gems"

#define WITS_STORE_TITLE_3 @"WITS TIENDA"
#define CASHABLE_TITLE_3 @"Gems :"
#define NON_CASHABLE_TITLE_3 @"Non Cashable"
#define BUY_TITLE_3 @"Compra más Gems"
#define CASHOUT_TITLE_3 @"Cash out"
#define CURRENT_POINT_TITLE_3 @"Gemas actuales:"
#define STORE_DESC_LBL_3 @"Limite minimo para retirar son 100 gemas"
#define CASHOUT_BTN_TITLE_3 @"Cash out"
#define PLZ_ENTER_POINTS_3 @"Porfavor ingresa pontus"
#define BUY_NOW_3 @"Comprar ahora"

#define INAPP_BTN1_3 @"100 Gems"
#define INAPP_BTN2_3 @"220 Gems"
#define INAPP_BTN3_3 @"500 Gems"

#define WITS_STORE_TITLE_4 @"Loja Wits"
#define CASHABLE_TITLE_4 @"Disponíveis :"
#define NON_CASHABLE_TITLE_4 @"Indisponíveis"
#define BUY_TITLE_4 @"Comprar mais Gems"
#define CASHOUT_TITLE_4 @"Trocar"
#define CURRENT_POINT_TITLE_4 @"Gemas atuais:"
#define STORE_DESC_LBL_4 @"O limite mínimo para regates é de 100 Gemas"
#define CASHOUT_BTN_TITLE_4 @"Trocar"
#define PLZ_ENTER_POINTS_4  @"Entregue as suas pontus por favor"
#define BUY_NOW_4 @"Compre agora"

#define INAPP_BTN1_4 @"100 Gems"
#define INAPP_BTN2_4 @"220 Gems"
#define INAPP_BTN3_4 @"500 Gems"

////////// Tutorial screen

#define screenOne1 @"مرحبا بكم في WITS - جائزة الفوز متعددة لعبة التوافه الذي يسمح لك كسب النقود الحقيقي أثناء التنافس على المواضيع كنت جيدة في!"


#define screenTwo1 @"تسجيل الدخول الأسلوب المفضل لديك من أجل البدء في اللعب والفوز!"

#define screenThree1 @"تسجيل الدخول الأسلوب المفضل لديك من أجل البدء في اللعب والفوز!"

#define screenfour1 @"اختر الطريقة التي تريد أن تلعب! ضد صديق أو خصم عشوائي من جميع أنحاء العالم! الخيار لك!"

#define screenfive1 @"تختار ما تريد أن تلعب ل، n\  الأحجار الكريمة - لكسب المكافآت الفعلية والنقدية أو \n نقاط - لتحسين رتبتك في المتصدرين."

#define screensix1 @"دون \ ر ذعر! مجرد قراءة السؤال واختيار الإجابة الصحيحة قبل الخصم الخاص بك لا!"

#define screenseven1 @"ماكسثون هناك لمساعدتك! استخدامها لجعل المنافسة أسهل بالنسبة لك!"

#define screeneight1 @"لعب أكثر من ذلك، كسب المزيد n\ المطالبة المكافآت الخاصة بك مقفلة"

// spanish
#define screenOne2 @"Bienvenido a WITS - un galardonado juego multijugador Trivia que te permite ganar dinero real mientras se compite con los temas que son buenos!"


#define screenTwo2 @"Regístrate En su método preferido para empezar a jugar y ganar!"

#define screenThree2 @"Regístrate En su método preferido para empezar a jugar y ganar!"

#define screenfour2 @"Elige cómo quieres jugar! Contra un amigo o un oponente al azar de todo el mundo! ¡La decisión es tuya!"

#define screenfive2 @"Elige lo que quieres jugar, \n Gems - gane recompensas reales y Efectivo O \n Puntos - para mejorar su ranking en la tabla de posiciones."

#define screensix2 @"Don \'t Panic! Acabo de leer la pregunta y elegir la respuesta correcta antes que tu oponente!"

#define screenseven2 @"Complementos están ahí para ayudarle! Úsalos para hacer la competencia más fácil para usted!"

#define screeneight2 @"Juega más, ganar más \n demandar sus recompensas desbloqueados"









#define screenOne @"Welcome to WITS - an award winning multiplayer Trivia game that let's you earn real cash while you compete with the topics you are good at!"


#define screenTwo @"Sign In your preferred method in order to start playing and winning!"

#define screenThree @"Choose a topic out of different categories provided. Choose your favorite one to gain advantage over others!"

#define screenfour @"Choose how you want to play! Against a friend or a random opponent from around the globe! The choice is yours!"

#define screenfive @"Choose what you want to play for Gems - to earn actual Real Rewards OR Points - to improve your ranking in the leaderboards!"

#define screensix @"Don't Panic! Just read the question and choose the right answer before your opponent does!"

#define screenseven @"Addons are there to help you! Use them to make the competition easier for you!"

#define screeneight @"Play more, Earn More Claim your unlocked rewards"






#define screenOne3 @"Bienvenue à ESPRITS - un jeu multijoueur Trivia primé qui vous permet de gagner de l\'argent réel pendant que vous rivaliser avec les sujets que vous êtes bon!"


#define screenTwo3 @"Connectez-vous votre méthode préférée pour commencer à jouer et gagner!"

#define screenThree3 @"Choose a topic out of different categories provided. Choose your favorite one to gain advantage over others!"

#define screenfour3 @"Choisissez comment vous voulez jouer! Contre un ami ou un adversaire aléatoire du monde entier! Le choix t\'appartient!"

#define screenfive3 @"Choisissez ce que vous voulez jouer pour, \n Gems - de gagner des récompenses réelles et des espèces ou \n points - pour améliorer votre classement dans leaderboard."

#define screensix3 @"Don \'t Panic! Il suffit de lire la question et choisissez la bonne réponse avant votre adversaire!"

#define screenseven3 @"Extensions sont là pour vous aider! Utilisez-les pour rendre la compétition plus facile pour vous!"

#define screeneight3 @"Jouer plus pour gagner plus \ n revendication vos récompenses débloqués"








#define screenOne4 @"Bem-vindo ao WITS - um premiado jogo de trivia multiplayer que permite que você ganhe dinheiro real quando você competir com os tópicos que você é bom em!"


#define screenTwo4 @"Entrar em seu método preferido para começar a jogar e ganhar!"

#define screenThree4 @"Entrar em seu método preferido para começar a jogar e ganhar!"

#define screenfour4 @"Escolha como você deseja jogar! Contra um amigo ou um oponente aleatório de todo o mundo! A escolha é sua!"

#define screenfive4 @"Escolha o que você quer jogar, \n - Gems para ganhar recompensas reais e dinheiro ou \n pontos - para melhorar seu ranking no leaderboard."

#define screensix4 @"Don \'t Panic! Basta ler a pergunta e escolher a resposta correta antes do seu oponente!"

#define screenseven4 @"Complementos estão lá para ajudá-lo! Use-os para tornar a competição mais fácil para você!"

#define screeneight4 @"Jogue mais, ganhe mais \ n reivindicação suas recompensas desbloqueados"















/////////Sign In///////

#define FACEBOOK_BTN @"FACEBOOK"
#define TWITTER_BTN @"TWITTER"
#define OR_LBL @"Or"
#define SIGNUP_BTN @"Sign up with Email"
#define ALREADY_LBL @"Already have an Account?"
#define LOGIN_BTN @"SIGN IN"
#define TUTORIAL_BTN @"Tutorial"
#define LANGUAGE_SELECTION_LBL @"Language Selection"
#define CHOOSE_LANG_LBL @"Please choose your Language"
#define TUTORIAL_LBL @"Tutorial"
#define KNOWLEDGE_LBL @"Share the Joy with your friends!"
#define TUTORIAL_DESC_LBL @"Wits application will make your wish come true, log in and finish 10 Witty question in any topic you master."
#define TUTORIAL_DESC_LBL2 @"Wits will make you earn real money the fastest and most guaranteed way."
#define SHARE_WITS_LBL @"Share WITS on any of the following tools and you 'll earn free Gems every time one of your friends uses the referral code you have shared"

#define FACEBOOK_BTN @"Se connecter via Facebook"
#define TWITTER_BTN_2 @"Se connecter via Twitter"
#define OR_LBL @"OU"
#define SIGNUP_BTN_2 @"Créer un compte"
#define ALREADY_LBL_2 @"Vous avez déjà un compte?"
#define LOGIN_BTN_2 @"Identifiant"
#define TUTORIAL_BTN_2 @"Tutoriel"
#define LANGUAGE_SELECTION_LBL_2 @"Sélection de la langue"
#define CHOOSE_LANG_LBL_2 @"Yolo propose cette application en plusieurs langues internationales. S\'il vous plaît sélectionnez celui que vous êtes à l\'aise avec."
#define TUTORIAL_LBL_2 @"Tutoriel"
#define KNOWLEDGE_LBL_2 @"La connaissance est l'argent , Savoir plus pour gagner plus!"
#define TUTORIAL_DESC_LBL_2 @"Demande de Wits fera de votre souhait se réalise , vous connecter et terminer 10 question Witty dans un sujet que vous maîtrisez ."
#define TUTORIAL_DESC_LBL2_2 @"Wits le hará ganar dinero de verdad la forma más rápida y segura"
#define SHARE_WITS_LBL_2 @"Partagez WITS sur un des réseaux suivants et vous gagnerez des Gems si vos amis utilisent votre code parrainage"

#define FACEBOOK_BTN_1 @"أدخل عبر الفيسبوك"
#define TWITTER_BTN_1 @"أدخل عبر التويتر"
#define OR_LBL_1 @" أو"
#define SIGNUP_BTN_1 @"انشئ حساب عبر بريدك الإلكتروني"
#define ALREADY_LBL_1 @"لديك حساب!"
#define LOGIN_BTN_1 @"الدخول الآن"
#define TUTORIAL_BTN_1 @"دليل اللعبة"
#define LANGUAGE_SELECTION_LBL_1 @"اختيار اللغة"
#define CHOOSE_LANG_LBL_1 @"يقدم يولو هذا التطبيق في عدة لغات عالمية. الرجاء اختيار واحد كنت مرتاحا."
#define TUTORIAL_LBL_1 @"دليل اللعبة"
#define KNOWLEDGE_LBL_1 @"العلم هو مال، أعلم أكثر لتربح أكثر !"
#define TUTORIAL_DESC_LBL_1 @"سيتم تطبيق دهاء جعل رغبتكم تتحقق ، تسجيل الدخول و إنهاء 10 قضية بارع في أي موضوع لك سيد"
#define TUTORIAL_DESC_LBL2_1 @"تطبيق ويتس سيمنحك فرصة ربح المال بطريقة سريعة و مضمونة."
#define SHARE_WITS_LBL_1 @" قم بمشاركة WITS  مع اصدقائك على أي من الوسائل التالية، ستحصل على النقاط مجاناً كلما استخدم أحد من اصدقائك رمز الإحالة الذي شاركته معه  "

#define FACEBOOK_BTN_4 @" Iniciar Sesión con Facebook"
#define TWITTER_BTN_4 @"Iniciar Sesión con Twitter"
#define OR_LBL @"O"
#define SIGNUP_BTN_4 @"Crie uma conta com E-Mail"
#define ALREADY_LBL_4 @"Você já possui uma conta?"
#define LOGIN_BTN_4 @"Usuário"
#define TUTORIAL_BTN_4 @"Tutorial"
#define LANGUAGE_SELECTION_LBL_4 @"Seleção de idioma"
#define CHOOSE_LANG_LBL_4 @"Por favor, escolha o seu idioma."
#define TUTORIAL_LBL_4 @"Tutorial"
#define KNOWLEDGE_LBL_4 @"O conhecimento é o dinheiro , saber mais ganhar mais !"
#define TUTORIAL_DESC_LBL_4 @"Aplicação Wits vai fazer seu desejo se tornar realidade , faça o login e terminar 10 pergunta Witty em qualquer assunto que você domina ."
#define TUTORIAL_DESC_LBL2_4 @"Wits vai fazer você ganhar dinheiro de verdade da maneira mais rápida e garantida."
#define SHARE_WITS_LBL_4 @"Partilhe os WITS de qualquer uma das seguintes ferramentas e receba pontus grátis de cada vez que um dos seus amigos usa o código por si partilhado."

#define FACEBOOK_BTN_3 @"Conectar com Facebook"
#define TWITTER_BTN_3 @"Conectar com Twitter"
#define OR_LBL_3 @"OU"
#define SIGNUP_BTN_3 @"Registrarse con E-Mail"
#define ALREADY_LBL_3 @"Ya tiene una cuenta?"
#define LOGIN_BTN_3 @"Usuario"
#define TUTORIAL_BTN_3 @"Tutorial"
#define LANGUAGE_SELECTION_LBL_3 @"lingvo Selektado"
#define CHOOSE_LANG_LBL_3 @"Por favor, elige tu idioma"
#define TUTORIAL_LBL_3 @"Tutorial"
#define KNOWLEDGE_LBL_3 @"Scio estas Mono , Sciu Pli Gajnas Pli !"
#define TUTORIAL_DESC_LBL_3 @"Menskapablo apliko faros via deziro realiĝis , ensalutu kaj fini 10 spritaj demando en iu temo vi sinjoro."
#define TUTORIAL_DESC_LBL2_3 @"Wits vous fera gagner de l'argent réel d'une façon sûre et rapide."
#define SHARE_WITS_LBL_3 @"Comparte WITS en cualquiera de las siguientes herramientas y gana pontus gratis cada vez que de tus amigos utilicen el codigo de referencia que compartiste"

//////Sign Up with Email////////


#define SIGNUP_TEXT @" SIGN UP"
#define SIGIN_TEXT @" LOG IN"
#define OR_TEXT @"  OR"
#define SIGNUP_EMAIL @"  Email"
#define SIGNUP_DISPLAY_NAME @"  Display Name"
#define SIGNUP_PASSWORD @"  Password"
#define SIGNUP_BIRTHDAY @" Birthday"
#define SIGNUP_USERNAME @"  Username"
#define SIGNUP_DESC @"We approxomate your location so you can see how you rank in your country By signing up, you agree with Term of Service & Privacy Policy"
#define SIGNUP_REGISTER @"REGISTER"

#define SIGNUP_FORGOT_PASS @" Forgot Password? Reset"


#define OR_TEXT_1 @"  أو"
#define SIGIN_TEXT_1 @" تسجيل الدخول"
#define SIGNUP_TEXT_1 @" سجل"
#define SIGNUP_FORGOT_PASS_1 @" ?نسيت كلمة السر"
#define SIGNUP_EMAIL_1 @"البريد الإلكتروني   "
#define SIGNUP_DISPLAY_NAME_1 @"عرض اسم  "
#define SIGNUP_PASSWORD_1 @"كلمات السر   "
#define SIGNUP_BIRTHDAY_1 @" يوم ميلادك  "
#define SIGNUP_USERNAME_1 @"اسم المستخدم  "
#define SIGNUP_DESC_1 @"نحن نقوم بتحديد موقعك حتى نتمكن من معرفة ترتيبك في بلدك. من خلال التوقيع، فإنك توافق على شروط الخدمة وسياسة خصوصية هذا التطبيق."
#define SIGNUP_REGISTER_1 @"تسجيل"



#define SIGNUP_TEXT_2 @" contratar"
#define SIGIN_TEXT_2 @" ingresar"
#define SIGNUP_EMAIL_2 @" Adresse mail"
#define OR_TEXT_2 @" o"
#define SIGNUP_FORGOT_PASS_2 @" Olvidado Contraseña"
#define SIGNUP_FORGOT_PASS_1 @" ?نسيت كلمة السر"
#define SIGNUP_DISPLAY_NAME_2 @"   Nom d'affichage"
#define SIGNUP_PASSWORD_2 @"   Mot de passe"
#define SIGNUP_BIRTHDAY_2 @"  anniversaire"
#define SIGNUP_USERNAME_2 @"   Nom d\'affichage"
#define SIGNUP_DESC_2 @"Nous utilisons votre localisation pour déterminer votre classement dans votre pays. En vous inscrivant, vous acceptez les Conditions d'Utilisation et la Politique de Confidentialité."
#define SIGNUP_REGISTER_2 @"Enregistrer"




#define OR_TEXT_3 @" ou"
#define SIGNUP_TEXT_3 @" signer"
#define SIGNUP_FORGOT_PASS_3 @" Oublié Mot de passe"
#define SIGNUP_EMAIL_3 @"   Correo electrónico"
#define SIGNUP_DISPLAY_NAME_3 @"   nombre para mostrar"
#define SIGNUP_PASSWORD_3 @"  Contraseña"
#define SIGNUP_BIRTHDAY_3 @" Cumpleaños"
#define SIGIN_TEXT_3 @" S'inscrire"
#define SIGNUP_USERNAME_3 @"   Usuario"
#define SIGNUP_DESC_3 @"Necesitamos su ubicación para determinar su clasificación en su país. Al inscribirse, usted ha aceptado las Condiciones del Servicio y la Política de Privacidad."
#define SIGNUP_REGISTER_3 @"Registro"


#define OR_TEXT_4 @" ou"
#define SIGNUP_FORGOT_PASS_4 @" Esqueceu Senha"
#define SIGNUP_EMAIL_4 @"   Email"
#define SIGNUP_DISPLAY_NAME_4 @"   Nome de exibição"
#define SIGNUP_TEXT_4 @" Inscrever-se"
#define SIGNUP_PASSWORD_4 @"   Senha"
#define SIGIN_TEXT_4 @" assinar em"
#define SIGNUP_BIRTHDAY_4 @" Aniversário"
#define SIGNUP_USERNAME_4 @"   Nome de Usuário"
#define SIGNUP_DESC_4 @"Nós aproximamos sua localização afim de que você possa ver sua classificação no seu país. Ao registrar-se, você concorda com nossos Termos de Serviço e Política de Privacidade."
#define SIGNUP_REGISTER_4 @"Cadastre-se"

/////////Login with Email//////

#define LOGIN_EMAIL @" Enter Email or Username"
#define LOGIN_FORGOT_PSWD @" Forgot Password"
#define LOGIN_PASSWORD @" Password"
#define LOGIN_LOGIN_BTN @"Login"

#define LOGIN_EMAIL_1 @" أدخل البريد الإلكتروني أو اسم المستخدم  "
#define LOGIN_FORGOT_PSWD_1 @"البريد الإلكتروني  "
#define LOGIN_PASSWORD_1 @" كلمة السر  "
#define LOGIN_LOGIN_BTN_1 @" الدخول الآن "

#define LOGIN_EMAIL_2 @" Saisissez votre email ou nom d'utilisateur"
#define LOGIN_FORGOT_PSWD_2 @" Email"
#define LOGIN_PASSWORD_2 @" Mot de passe"
#define LOGIN_LOGIN_BTN_2 @" Identifiant"

#define LOGIN_EMAIL_3 @" Eniri Retpoŝto aŭ salutnomo"
#define LOGIN_FORGOT_PSWD_3 @" Email"
#define LOGIN_PASSWORD_3 @" Pasvorto"
#define LOGIN_LOGIN_BTN_3 @"Usuario"

#define LOGIN_EMAIL_4 @" Digite o e-mail ou usuário"
#define LOGIN_FORGOT_PSWD_4 @" Email"
#define LOGIN_PASSWORD_4 @" Senha"
#define LOGIN_LOGIN_BTN_4 @"Usuário"

////////HomePage//////

#define HOME_BTN @"Home"
#define TOPICS_BTN @"Categories"
#define FRIENDS_BTN @"Friends"
#define HISTORY_BTN @"History"
#define MESSAGE_BTN @"Earn Free Points"
#define DISCUSSION_BTN @"Discussion"
#define RANKING_BTN @"Rankings"
#define WITS_STORE_BTN @"WITS Store (-)"
#define SETTINGS_BTN @"Settings"
#define LOGOUT_BTN @"Log Out"
#define TRANSFER_POINTS_BTN @"Transfer Points"
#define CONTACTS_BTN @"Contact Us"
#define ABOUTUS_TEXT @"About"

#define HOME_BTN_1 @"الصفحة الرئسية"
#define ABOUTUS_TEXT_1 @"معلومات "
#define TOPICS_BTN_1 @"فئات الأسئلة "
#define FRIENDS_BTN_1 @"اصدقائي"
#define HISTORY_BTN_1 @"تاريخ المباريات"
#define MESSAGE_BTN_1 @"رسائلي"
#define DISCUSSION_BTN_1 @"مناقشة"
#define RANKING_BTN_1 @"جدول الترتيب"
#define WITS_STORE_BTN_1 @"متجر الويتس (-)"
#define SETTINGS_BTN_1 @"الإعدادات"
#define LOGOUT_BTN_1 @"تسجيل الخروج"
#define TRANSFER_POINTS_BTN_1 @"إرسل النقاط  "
#define CONTACTS_BTN_1 @"إتصل بنا"

#define ABOUTUS_TEXT_2 @"Acerca de nosotros"
#define HOME_BTN_2 @"Accueil"
#define TOPICS_BTN_2 @"Catégories"
#define FRIENDS_BTN_2 @"Amis"
#define HISTORY_BTN_2 @"Historique"
#define MESSAGE_BTN_2 @"Messages"

#define DISCUSSION_BTN_2 @"Discussions"
#define RANKING_BTN_2 @"Classements"
#define WITS_STORE_BTN_2 @"Wits Boutique"
#define SETTINGS_BTN_2 @"Paramètres"
#define LOGOUT_BTN_2 @"Déconnexion"
#define TRANSFER_POINTS_BTN_2 @"Transfert de Points"
#define CONTACTS_BTN_2 @"Contactez-nous"

#define ABOUTUS_TEXT_3 @"A propos de nous"
#define HOME_BTN_3 @"Inicio"
#define TOPICS_BTN_3 @"Categorias"
#define FRIENDS_BTN_3 @"Amigos"
#define HISTORY_BTN_3 @"Historial"
#define MESSAGE_BTN_3 @"Mensajes"
#define DISCUSSION_BTN_3 @"Discusiones"
#define RANKING_BTN_3 @"Clasificaciones"
#define WITS_STORE_BTN_3 @"Wits Tienda"
#define SETTINGS_BTN_3 @"Herramientas"
#define LOGOUT_BTN_3 @"salir"
#define TRANSFER_POINTS_BTN_3 @"Transferencia de Pontus"
#define CONTACTS_BTN_3 @"Contactarnos"

#define ABOUTUS_TEXT_4 @"Sobre"
#define HOME_BTN_4 @"Início"
#define TOPICS_BTN_4 @"Categorias"
#define FRIENDS_BTN_4 @"Amigos"
#define HISTORY_BTN_4 @" Histórico"
#define MESSAGE_BTN_4 @"Mensagens"
#define DISCUSSION_BTN_4 @"Discussões"
#define RANKING_BTN_4 @"Classificação"
#define WITS_STORE_BTN_4 @"Wits Loja"
#define SETTINGS_BTN_4 @"Configurações"
#define LOGOUT_BTN_4 @"sair"
#define TRANSFER_POINTS_BTN_4 @"Transferir Pontus"
#define CONTACTS_BTN_4 @"Contate-nos"


//////////Navigation Bar//////

#define SETTINGS_LBL @"Settings"
#define MUSIC_LBL @"Music"
#define SOUND_LBL @"Sound Effects"
#define VIBRATION_LBL @"Vibration"
#define GENERAL_LBL @"General"
#define PUSH_LBL @"Push Notification"
#define CHALLENGE_LBL @"Challenge Notifictions"
#define CHAT_LBL @"Chat Notifications"
#define REFERAL_CODE_LBL @"Referral Code"
#define SEND_BTN @"Send"
#define ABOUT_BTN @"About Us"
#define CHANGE_LANG_BTN @"Change Language"

#define SETTINGS_LBL_1 @"الإعدادات"
#define MUSIC_LBL_1 @"الموسيقى"
#define SOUND_LBL_1 @"تأثير الصوت"
#define VIBRATION_LBL_1 @"اهتزاز"
#define GENERAL_LBL_1 @"عام"
#define PUSH_LBL_1 @"التبليغات"
#define CHALLENGE_LBL_1 @"التبليغ بالتحدي"
#define CHAT_LBL_1 @"التبليغ بالرسائل"
#define REFERAL_CODE_LBL_1 @"رمز الإحالة"
#define SEND_BTN_1 @"إرسال"
#define ABOUT_BTN_1 @"حول بنا"
#define CHANGE_LANG_BTN_1 @"تغيير اللغة"

#define SETTINGS_LBL_2 @"Paramètres"
#define MUSIC_LBL_2 @"Musique"
#define SOUND_LBL_2 @"Effets sonores"
#define VIBRATION_LBL_2 @"Vibration"
#define GENERAL_LBL_2 @"Général"
#define PUSH_LBL_2 @"Notifications Push"
#define CHALLENGE_LBL_2 @"Notifications du Défi"
#define CHAT_LBL_2 @"Notifications du Chat"
#define REFERAL_CODE_LBL_2 @"code de Parrainage"
#define SEND_BTN_2 @"Envoyer"
#define ABOUT_BTN_2 @"à propos de nous"
#define CHANGE_LANG_BTN_2 @"Changer de langue"

#define SETTINGS_LBL_3 @" Herramientas"
#define MUSIC_LBL_3 @"Musica"
#define SOUND_LBL_3 @"Efectos de sonido"
#define VIBRATION_LBL_3 @"Vibración"
#define GENERAL_LBL_3 @"General"
#define PUSH_LBL_3 @"Notificaciones Push"
#define CHALLENGE_LBL_3 @"Notificaciones del Reto"
#define CHAT_LBL_3 @"Notificaciones Del Chat"
#define REFERAL_CODE_LBL_3 @"Referenco Kodo"
#define SEND_BTN_3 @"enviar"
#define ABOUT_BTN_3 @"Pri ni"
#define CHANGE_LANG_BTN_3 @"ŝanĝo Lingvo"

#define SETTINGS_LBL_4 @"Configurações"
#define MUSIC_LBL_4 @"Música"
#define SOUND_LBL_4 @"Efeitos sonoros"
#define VIBRATION_LBL_4 @"Vibração"
#define GENERAL_LBL_4 @"Geral"
#define PUSH_LBL_4 @"Notificações Push"
#define CHALLENGE_LBL_4 @"Notificações do Desafio"
#define CHAT_LBL_4 @"Notificações do Chat"
#define REFERAL_CODE_LBL_4 @"Código de Referência"
#define SEND_BTN_4 @"Enviar"
#define ABOUT_BTN_4 @"Sobre nós"
#define CHANGE_LANG_BTN_4 @"Alterar idioma"

/////////Play Now Categories////////////

#define SEARCH_CATEGORY @"Search"
#define CATEGORIES @"Categories"
#define TOPICS_LBL @"Topics"
#define GO @"Go"
#define BUSINESS @"Business"
#define EDUCATION @"Education"
#define GAMES @"Games"
#define GEOGRAPHY @"Geography"
#define HISTORY @"HISTORY"
#define LIFESTYLE @"LifeStyle"
#define MUSIC @"Music"
#define SCIENCE_&_TECH @"Science and Technology"
#define SPORT @"Sports"
#define TV @"TV"

#define SEARCH_CATEGORY_1 @"بحث"
#define CATEGORIES_1 @"فئات الأسئلة "
#define TOPICS_LBL_1 @"موضوع "
#define GO_1 @"إذهب "
#define BUSINESS_1 @"عالم الأعمال "
#define EDUCATION_1 @" العلم "
#define GAMES_1 @" ألعاب الحاسوب "
#define GEOGRAPHY_1 @"الجغرافيا "
#define HISTORY_1 @" التاريخ "
#define LIFESTYLE_1 @"نمط العيش "
#define MUSIC_1 @"الموسيقى "
#define SCIENCE_&_TECH_1 @" العلوم والتكنولوجيا "
#define SPORT_1 @" الرياضة "
#define TV @"لتلفاز"


#define SEARCH_CATEGORY_2 @"Trouver"
#define CATEGORIES_2 @" Catégories"
#define TOPICS_LBL_2@"sujet"
#define GO_2 @"Jouer"
#define BUSINESS_2 @"Business"
#define EDUCATION_2 @"Education"
#define GAMES_2 @"Jeux"
#define GEOGRAPHY_2 @"Géographie"
#define HISTORY_2 @" Histoire"
#define LIFESTYLE_2 @" Mode de Vie"
#define MUSIC_2 @"Musique"
#define SCIENCE_&_TECH_2 @" Sciences et Technologies"
#define SPORT_2 @"Sports"
#define TV @"TV"

#define SEARCH_CATEGORY_3 @"Buscar"
#define CATEGORIES_3 @" Categorías"
#define TOPICS_LBL_3 @"Temas sub"
#define GO_3 @"Jugar"
#define BUSINESS_3 @"Negocios"
#define EDUCATION_3 @" Educación"
#define GAMES_3 @"Juegos"
#define GEOGRAPHY_3 @" Geografía"
#define HISTORY_3 @"Historia"
#define LIFESTYLE_3 @" Estilo de vida"
#define MUSIC_3 @"Musica"
#define SCIENCE_&_TECH_3 @"Ciencias y Tecnologías"
#define SPORT_3 @"Deporte"
#define TV @"TV"

#define SEARCH_CATEGORY_4 @"Buscar"
#define CATEGORIES_4 @" Categorías"
#define TOPICS_LBL_4@"tema"
#define GO_4 @"Jogar"
#define BUSINESS_4 @" Negócios"
#define EDUCATION_4 @"Educação"
#define GAMES_4 @"Jogos"
#define GEOGRAPHY_4 @"Geografia"
#define HISTORY_4 @" História"
#define LIFESTYLE_4 @"Estilo de vida"
#define MUSIC_4 @"Música"
#define SCIENCE_&_TECH_4 @"Ciência e Tecnologia"
#define SPORT_4 @" Esporte"
#define TV @"TV"

///////////SubTopics//////////

/////// Business ////////

#define BRANDS @"Brands"
#define COMMERCIAL @"Commercial"
#define CURRENCY @"Currency"
#define ECONOMICS @"Economics"
#define LOGOS @"Logos"

#define BRANDS_1 @" العلامات التجارية"
#define COMMERCIAL_1 @"الأعلانات"
#define CURRENCY_1 @"العملات النقدية"
#define ECONOMICS_1 @" الاقتصاد"
#define LOGOS_1 @"الشعارات"

#define BRANDS_2 @"Marques"
#define COMMERCIAL_2 @"Commercial"
#define CURRENCY_2 @" Devise "
#define ECONOMICS_2 @"Economie"
#define LOGOS_2 @"Logos"

#define BRANDS_3 @"Marcas"
#define COMMERCIAL_3 @"Comercio "
#define CURRENCY_3 @"Divisas"
#define ECONOMICS_3 @"Economía"
#define LOGOS_3 @" Logotipos"

#define BRANDS_4 @"Marcas"
#define COMMERCIAL_4 @"Comércio"
#define CURRENCY_4 @"Moedas"
#define ECONOMICS_4 @"Economia"
#define LOGOS_4 @"Logotipos"

/////// ADDON INSTRUCTIONS //////


#define REWARD_INSTRUCTION @"Buy AddOns to unlock rewards."
#define REWARD_INSTRUCTION_1 @"شراء ظائف الإضافية لفتح المكافآت"
#define REWARD_INSTRUCTION_2 @"Comprar AddOns para desbloquear recompensas."
#define REWARD_INSTRUCTION_3 @"Acheter AddOns pour débloquer des récompenses."
#define REWARD_INSTRUCTION_4 @"Compre AddOns para destravar recompensas."


#define ADDON_INSTRUCTION @"Buying AddOn will help you unlock exciting rewards. Buy more, win more!"
#define ADDON_INSTRUCTION_1 @"و شراء الملحق تساعدك على فتح المكافآت مثيرة. نشتري أكثر، و كسب المزيد !"
#define ADDON_INSTRUCTION_2 @"Comprar AddOn le ayudará a desbloquear recompensas emocionantes . Compre más, ganar más !"
#define ADDON_INSTRUCTION_3 @"Acheter addon vous aider à débloquer des récompenses intéressantes . Achetez plus, gagner plus !"
#define ADDON_INSTRUCTION_4 @"Comprar AddOn irá ajudá-lo a desbloquear recompensas emocionantes. Comprar mais, ganhar mais!"


/////// Education ////////



#define MATH @"Math"
#define GRAMMER @"Grammar"
#define FINISH_THE_SAYING @"Finish the saying"
#define SPELLING @"Spelling"

#define MATH_1 @"الرياضيات"
#define GRAMMER_1 @"القواعد"
#define FINISH_THE_SAYING_1 @"أكمل المقولة "
#define SPELLING_1 @" التهجئة"

#define MATH_2 @"Mathématiques"
#define GRAMMER_2 @"Grammaire"
#define FINISH_THE_SAYING_2 @"Compléter le Proverbe "
#define SPELLING_2 @"Orthographe"

#define MATH_3 @"Matemáticas "
#define GRAMMER_3 @"Gramática"
#define FINISH_THE_SAYING_3 @"Completar el Dicho"
#define SPELLING_3 @"Ortografía"

#define MATH_4 @"Matemática"
#define GRAMMER_4 @"Gramática"
#define FINISH_THE_SAYING_4 @"Complete o Provérbio"
#define SPELLING_4 @"Ortografia"

//////// Games /////////

#define WORLD_OF_WARCRAFTS @"World of Warcraf"
#define POKEMON @"Pokemon"
#define LEAGUE_OF_LEGENDS @"League of legends"
#define VALVE_GAMES @"Valve games"

#define WORLD_OF_WARCRAFTS_1 @"World of Warcraf"
#define POKEMON_1 @"Pokemon"
#define LEAGUE_OF_LEGENDS_1 @"League of legends"
#define VALVE_GAMES_1 @"Valve games"

#define WORLD_OF_WARCRAFTS_2 @"World of Warcraf"
#define POKEMON_2 @"Pokemon"
#define LEAGUE_OF_LEGENDS_2 @"League of legends"
#define VALVE_GAMES_2 @" Valve games"

#define WORLD_OF_WARCRAFTS_3 @"World of Warcraf"
#define POKEMON_3 @"Pokemon"
#define LEAGUE_OF_LEGENDS_3 @"League of legends"
#define VALVE_GAMES_3 @"uegos de Valve"

#define WORLD_OF_WARCRAFTS_4 @"World of Warcraf"
#define POKEMON_4 @"Pókemon"
#define LEAGUE_OF_LEGENDS_4 @"League of legends"
#define VALVE_GAMES_4 @"Jogos da Valve"


//////// Geography ///////

#define ASIA @"Asia"
#define EUROPE @"Europe"
#define AMERICA @"America"
#define AFRICA @"Africa "
#define MIDDLE_EAST @"Middle East"
#define AUSTRALIA @"Australia"


#define ASIA_1 @"اسيا"
#define EUROPE_1 @"أوروبا"
#define AMERICA_1 @"أمريكا"
#define AFRICA_1 @"أفريقيا"
#define MIDDLE_EAST_1 @"الشرق الأوسط"
#define AUSTRALIA_1 @"أستراليا"


#define ASIA_2 @"Asie"
#define EUROPE_2 @"Europe"
#define AMERICA_2 @"Amérique"
#define AFRICA_2 @"Afrique"
#define MIDDLE_EAST_2 @"Moyen-Orient"
#define AUSTRALIA_2 @" Australie"


#define ASIA_3 @"Asia"
#define EUROPE_3 @"Europa"
#define AMERICA_3 @" América"
#define AFRICA_3 @"Africa"
#define MIDDLE_EAST_3 @"Oriente Medio"
#define AUSTRALIA_3 @"Australia"

#define ASIA_4 @"Ásia"
#define EUROPE_4 @"Europa"
#define AMERICA_4 @" América"
#define AFRICA_4 @"África"
#define MIDDLE_EAST_4 @"Oriente Médio"
#define AUSTRALIA_4 @" Austrália "


//////// History /////////

#define ANCIENT_HISTORY @"Ancient History"
#define MODREN_HISTORY @"Modern History"
#define WW1 @"WW1 "
#define WW2 @"WW2"

#define ANCIENT_HISTORY_1 @"التاريخ القديم"
#define MODREN_HISTORY_1 @"التاريخ المعاصر"
#define WW1_1 @"الحرب العالمية الأولى"
#define WW2_1 @"الحرب العالمية الثانية"

#define ANCIENT_HISTORY_2 @"Histoire ancienne"
#define MODREN_HISTORY_2 @"Histoire moderne"
#define WW1_2 @"GM1"
#define WW2_2 @"GM2"

#define ANCIENT_HISTORY_3 @"Historia Antigua"
#define MODREN_HISTORY_3 @"Historia Moderna"
#define WW1_3 @"1ra GM"
#define WW2_3 @"2da GM"

#define ANCIENT_HISTORY_4 @"História Antiga"
#define MODREN_HISTORY_4 @"História Moderna"
#define WW1_4 @"Guerra Mundial I"
#define WW2_4 @"Guerra Mundial II"

///////  Lifestyle ////////

#define CARS @"Cars"
#define CELRBRATIES @"Celebrities "
#define FASHION @"Fashion"
#define FOOD_AND_DRINKS @"Food & drinks"

#define CARS_1 @"السيارات"
#define CELRBRATIES_1 @"المشاهير"
#define FASHION_1 @"المودة"
#define FOOD_AND_DRINKS_1 @"الأكل و الشرب"

#define CARS_2 @"Voitures"
#define CELRBRATIES_2 @"Célébrités"
#define FASHION_2 @"Mode"
#define FOOD_AND_DRINKS_2 @"Nourriture et boissons"

#define CARS_3 @"Automóviles"
#define CELRBRATIES_3 @"Celebridades"
#define FASHION_3 @"Moda"
#define FOOD_AND_DRINKS_3 @"Comida y Bebidas"

#define CARS_4 @"Carros"
#define CELRBRATIES_4 @"Celebridades"
#define FASHION_4 @"Moda"
#define FOOD_AND_DRINKS_4 @"Comida y Bebidas"




///// EARN FREE POINTS

#define REFER_YOUR_FRIENDS @"Refer Your Friends!"
#define REFER_YOUR_FRIENDS_1 @"الرجوع أصدقائك!"
#define REFER_YOUR_FRIENDS_2 @"Recomiéndanos a tus amigos !"
#define REFER_YOUR_FRIENDS_3 @"Parrainez vos amis !"
#define REFER_YOUR_FRIENDS_4 @"Consulte seus amigos!"


#define EARN_POINT_TEXT @"Share WITS on any of the following tools and you \'ll earn free Gems every time one of your friends uses the referral code you have shared"
#define EARN_POINT_TEXT_1 @"قم بمشاركة WITS  مع اصدقائك على أي من الوسائل التالية، ستحصل على جواهر مجاناً كلما استخدم أحد من اصدقائك رمز الإحالة الذي شاركته معه"
#define EARN_POINT_TEXT_2 @"Comparte WITS en cualquiera de las siguientes herramientas y gana gemas gratis cada vez que de tus amigos utilicen el codigo de referencia que compartiste"
#define EARN_POINT_TEXT_3 @"Partagez WITS sur un des réseaux suivants et vous gagnerez des Gems si vos amis utilisent votre code parrainage"
#define EARN_POINT_TEXT_4 @"Partilhe os WITS de qualquer uma das seguintes ferramentas e receba Gemas grátis de cada vez que um dos seus amigos usa o código por si partilhado."








/////////  Music /////////

#define INSTRUMENTS @"Instruments"
#define GENRES @"Genres "
#define PERFORMERS @"Performers"
#define HISTORY @"History"
#define SUPERSTARS @"Superstars"
#define SONGS @"Songs"

#define INSTRUMENTS_1 @"الآت العزف"
#define GENRES_1 @"نوع الموسيقى"
#define PERFORMERS_1 @"المؤديون"
#define HISTORY_1 @"التاريخ"
#define SUPERSTARS_1 @"النجوم"
#define SONGS_1 @"الأغاني"

#define INSTRUMENTS_2 @"Instruments"
#define GENRES_2 @"Genres "
#define PERFORMERS_2 @"Performers"
#define HISTORY_2 @"Histoire"
#define SUPERSTARS_2 @"Superstars"
#define SONGS_2 @"chansons"

#define INSTRUMENTS_3 @"Instrumentos"
#define GENRES_3 @"Géneros"
#define PERFORMERS_3 @"Cantantes"
#define HISTORY_3 @"Historia"
#define SUPERSTARS_3 @"Superestrellas"
#define SONGS_3 @"Canciones "

#define INSTRUMENTS_4 @"Instrumentos"
#define GENRES_4 @"Gêneros"
#define PERFORMERS_4 @"Cantores "
#define HISTORY_4 @"História"
#define SUPERSTARS_4 @"Superestrelas"
#define SONGS_4 @"Músicas "

/////// Science & Tech //////

#define TECH_AND_INNOVATION @"Technology and Innovation"
#define COMP_SCIENCE @"Computer Science"
#define SPACE @"Space"


#define TECH_AND_INNOVATION_1 @"التكنولوجيا والإبتكارات"
#define COMP_SCIENCE_1 @"علم الكمبيوتر"
#define SPACE_1 @"الفضاء"

#define TECH_AND_INNOVATION_2 @"Technologie et innovation"
#define COMP_SCIENCE_2 @"Informatique Ciencias"
#define SPACE_2 @" Espace"

#define TECH_AND_INNOVATION_3 @"Tecnología e Innovación"
#define COMP_SCIENCE_3 @"de la Computación"
#define SPACE_3 @"Espacio"

#define TECH_AND_INNOVATION_4 @"Tecnologia e Inovação "
#define COMP_SCIENCE_4 @"Ciência da Computação"
#define SPACE_4 @"Espaço "

/////// Sport ////////

#define GENERAL_SPORTS @"General Sport"
#define EUROPEAN_FOOTBALL @"European Football"
#define WORLDCUP @"World cup"
#define OLYMPICS @"Olympics"
#define TENNIS @"Tennis"
#define NBA @"NBA"
#define FORMULA_ONE @"Formula One"

#define GENERAL_SPORTS_1 @"عام"
#define EUROPEAN_FOOTBALL_1 @" كرة قدم اوروبية "
#define WORLDCUP_1 @"كأس العالم"
#define OLYMPICS_1 @"الألمبياد"
#define TENNIS_1 @"تنس"
#define NBA_1 @"كرة سلة أميركية"
#define FORMULA_ONE_1 @"فورمولا ون"

#define GENERAL_SPORTS_2 @"Sport Général"
#define EUROPEAN_FOOTBALL_2 @"Football Européen"
#define WORLDCUP_2 @"Coupe du Monde"
#define OLYMPICS_2 @"Jeux olympiques"
#define TENNIS_2 @"Tennis"
#define NBA_2 @"NBA"
#define FORMULA_ONE_2 @"Formule Un"

#define GENERAL_SPORTS_3 @"Deporte General"
#define EUROPEAN_FOOTBALL_3 @"Football Europeo"
#define WORLDCUP_3 @"Copa del Mundo"
#define OLYMPICS_3 @" Juegos Olímpicos "
#define TENNIS_3 @"Tenis "
#define NBA_3 @"NBA"
#define FORMULA_ONE_3 @"Fórmula Uno"

#define GENERAL_SPORTS_4 @"Esporte Geral"
#define EUROPEAN_FOOTBALL_4 @"Futebol Europeu"
#define WORLDCUP_4 @"Copa do Mundo"
#define OLYMPICS_4 @"Jogos Olímpicos"
#define TENNIS_4 @"Tênis "
#define NBA_4 @"NBA"
#define FORMULA_ONE_4 @"Fórmula Um "

//////   TV     //////

#define MOVIES @"Movies"
#define ANIMATION @"Animations"
#define SERIES @"Series"

#define MOVIES_1 @"الأفلام"
#define ANIMATION_1 @"حيوية"
#define SERIES_1 @"المسلسلات"

#define MOVIES_2 @"Films"
#define ANIMATION_2 @"Animation"
#define SERIES_2 @"Séries"


#define MOVIES_3 @"Películas"
#define ANIMATION_3 @"Animación "
#define SERIES_3 @"Series"

#define MOVIES_4 @"Filmes"
#define ANIMATION_4 @"Animação"
#define SERIES_4 @"Séries"



////////Language Selection/////

#define CHANGE_LANGUAGE @"Change Language"
#define SELECT_LANGUAGE @"Select Language"
#define CHOOSE_LANGUAGE @"Please choose your Language "
#define LANGUAGE_BTN @""
#define SAVE_LANGUAGE_BTN @"Save Language"

#define CHANGE_LANGUAGE_1 @"تغير اللغة"
#define SELECT_LANGUAGE_1 @"اختيار اللغة"
#define CHOOSE_LANGUAGE_1 @"الرجاء اختيار لغتك"
#define LANGUAGE_BTN_1 @""
#define SAVE_LANGUAGE_BTN_1 @"حفظ اللغة"

#define CHANGE_LANGUAGE_2 @" Changer de langue"
#define SELECT_LANGUAGE_2 @"Sélectionnez la langue"
#define CHOOSE_LANGUAGE_2 @"Se il vous plaît choisir votre langue"
#define LANGUAGE_BTN_2 @""
#define SAVE_LANGUAGE_BTN_2 @"Enregistrer Langue"

#define CHANGE_LANGUAGE_3 @"Cambiar el idioma"
#define SELECT_LANGUAGE_3 @"Elektita Lingvo"
#define CHOOSE_LANGUAGE_3 @"Bonvolu elektu vian lingvon"
#define LANGUAGE_BTN_3 @""
#define SAVE_LANGUAGE_BTN_3 @"Konservu Lingvo"

#define CHANGE_LANGUAGE_4 @" Alterar o idioma"
#define SELECT_LANGUAGE_4 @"Selecione o idioma"
#define CHOOSE_LANGUAGE_4 @"Por favor, escolha o seu idioma"
#define LANGUAGE_BTN_4 @""
#define SAVE_LANGUAGE_BTN_4 @"Salvar Idioma"
//////////Alerts/////////

#define Friend_Not_Available @"Friend not Available."

#define Friend_Not_Availabl_1 @"الصديق غير متوفر"

#define Friend_Not_Availabl_2 @"Amigo no disponible"

#define Friend_Not_Availabl_3 @"Ami non disponible"


#define Friend_Not_Availabl_4 @"Amigo não disponível"

#define ChallengeForGem @"Challenge For Gems"
#define ChallengeForPoint @"Challenge For Points"

#define ChallengeForGem1 @"التحدي للحصول على الجواهر"
#define ChallengeForPoints1 @"التحدي للحصول على نقاط"

#define ChallengeForGem2 @"Desafío por Gemas"
#define ChallengeForPoints2 @"Desafío por Puntos"
#define ChallengeForGem3 @"Défi par Gems"
#define ChallengeForPoints3 @"Défi pour les points"
#define ChallengeForGem4 @"Desafiar por Gems"
#define ChallengeForPoints4 @"Desafiar por Pontos"

////////// Game Play Strings /////////
#define VS @"VS"
#define Round @"Round"
#define LAST_ROUND @"Last Round"
#define BRAVO @"Bravo"
#define KO @"K.O"
#define CORRECT @"Correct! that was close. "
#define OPPONENT_ANS_BEFORE @"Opponent Answered Before You"
#define TIMES_UP @"Time is up"
#define WRONG_ANS_WAIT_OPP @"Wrong Answer! Waiting for Opponent to Answer.."
#define YOU_WIN @"You Win"
#define ITS_TIE @"It's a Tie."
#define BETTER_LUCK @"Alas! You could NOT win any new Reward or Cash Prize. Play harder next time!"
#define STATUS @"Status"
#define TIME @"Time"
#define POINTS @"Points"
#define GEMS @"Gems"
#define YOU_BEAT @"You beat XYZ 6 minutes ago."
#define XYZ_BEAT_YOU @"XYZ beat you 2 days ago"
#define PERSONAL_INFO @"Personal Information"
#define VERIFIED @"Verified"
#define NOT_VERIFIED @"Not Verified"
#define ABOUT @"About"
#define EMAIL_INVITE_DESC @"You are Invited to play WITS by XYZ, The referral code of user is : "
#define TWITTER_INVITE_MSG @"Hi, My referral Code is xyz. Help me Earn Free Points. Lets play Wits together."
#define TWITTER_REFERRAL_CODE @"WITS - Referral Code xyz"
#define FB_INVITE_DESC1 @"WITS is an award winning multiplayer trivia game and fan community."
#define FB_INVITE_DESC2 @"Hi, My referral Code is xyz. Help me Earn Free Points. Lets play Wits together."
#define UNFRIEND_CONFIRM @"You want to Unfriend?"
#define OK_BTN @"OK"
#define CANCEL @"Cancel"
#define GENERAL_FEEDBACK @"General Feedback"
#define TECH_ISSUE @"Technical Issue"
#define DAYS_AGO @"Days Ago"
#define XYZ_ADDED_U @"XYZ Added You!"
#define XYZ_CHALLANGED_U @"XYZ Chellanged you!"
#define XYZ_SENT_MSG @"XYZ sent Message"
#define FRIEND_REQ @"Friend Request"
#define JOIN @"Join"
#define VIEW @"View"
#define POINT_TRANS_MSG @"XYZ has granted you 30 Points!"
#define OPPO_NOT_AVAIL @"Opponent you are trying to reach is not available at the Moment"
#define OPPO_GONE_AWAY @ "Opponent you are trying to reach has gone away"
#define RETURN_HOME @"Return Home"
#define PLAY_AGAIN @"Play Again"
#define ENTER_EMAIL_USERNAME @"Enter Email or UserName!"
#define ENTER_USERNAME @"Enter Username!"
#define SENDING_EMAIL @"Sending Email"
#define PLZ_WAIT @"Please Wait"
#define BANK_LOCATION @"Bank Location"
#define BANK_NAME @"Bank Name"
#define IBAN "IBAN # (Optional)	"
#define SWIFT_CODE @"Swift Code"
#define BANK_ACCOUNT_NO @"Bank Account # "
#define BANK_TITLE @"Bank Title"
#define BANK_ADDRESS @"Address"
#define CONTACT_NO @"Enter Contact Number "
#define CONTACT_EMAIL @"Enter Contact Email "
#define SKRIL_EMAIL @"Enter Email of Skrill "
#define PAYPAL_EMAIL @"Enter Email of Paypal "
#define ERR_REFERAL_CODE @"Error in entering referral Code, Try again later!"
#define SUCCESS_REFERAL_CODE @"Referral Code posted Successfully"
#define ERR_TRANF_POINTS @"Error in transferring Points, Try again later!"
#define SUCCESS_TRANF_POINTS @"Points Transferred Successfully"
#define SUBMIT_MSG_SUCCESS  @"Message has been submitted."
#define QUIT_GAME @"Quit Game"
#define ERR_WENT_WRONG @"Something went Wrong"
#define ALREADY_LOGGED @"Already Logged In"
#define SHARE_WITS @"Share WITS on any of the following tools and you 'll earn free Points every time one of your friends uses the referral code you have shared"

#define CASHOUT_OPTION @"Select Option to Cash out"
#define NO_ACC_SETUP @"NO ACCOUNT SETUP"
#define ADD_FRIEND @"Add Friend"
#define PENDING @"Pending"

#define VS_1 @"مقابل"
#define Round_1 @"جولة "
#define LAST_ROUND_1 @"آخر جولة"
#define BRAVO_1 @" أحسنت "
#define KO_1 @" ضربة قاضية "
#define CORRECT_1 @" صح! كانت قريبة  "
#define OPPONENT_ANS_BEFORE_1 @"الخصم جواب قبلك "
#define TIMES_UP_1 @"الوقت إنتهى "
#define WRONG_ANS_WAIT_OPP_1 @"جواب خاطئ، بإنتظار جواب الخصم "
#define YOU_WIN_1 @"لقد ربحت !"
#define ITS_TIE_1 @"تعادلت !"
#define BETTER_LUCK_1 @"للأسف ! أنت لا تستطيع الحصول على أي مكافأة أو جائزة نقدية جديدة. الان وقت اللعب أصبح أكثر صعوبة في المرحلة المقبل !"
#define STATUS_1 @"الحالة"
#define TIME_1 @" الوقت "
#define POINTS_1 @"النقاط"
#define GEMS_1 @"جواهر"
#define YOU_BEAT_1 @"لقد هزمت الخصم () منذ 6 دقائق"
#define XYZ_BEAT_YOU_1 @" لقد هزمك  () منذ 6 دقائق "
#define PERSONAL_INFO_1 @" معلومات خاصة "
#define VERIFIED_1 @"الحساب مؤكد "
#define NOT_VERIFIED_1 @"الحساب غير مؤكد "
#define ABOUT_1 @" معلومات عنا "
#define EMAIL_INVITE_DESC_1 @"أنت مدعو للعب الويتس من قبل () "
#define TWITTER_INVITE_MSG_1 @"حباً، هيا بنا نلعب ويتس، استخدم هذا الرقم لإحالة"
#define TWITTER_REFERRAL_CODE_1 @" ويتس - رقم الإحالة  "
#define FB_INVITE_DESC1_1 @"WITS is an award winning multiplayer trivia game and fan community."
#define FB_INVITE_DESC2_1 @"في الحصول على نكت مجانية، هيا بنا نلعب سوياً     "
#define UNFRIEND_CONFIRM_1 @"هل أنت أكيد من إلغاء الصداقة؟"
#define OK_BTN_1 @"نعم "
#define CANCEL_1 @" إلغاء "
#define GENERAL_FEEDBACK_1 @"رأيك بشكل عام"
#define TECH_ISSUE_1 @"مشكلة تقنية "
#define DAYS_AGO_1 @"منذ أيام "
#define XYZ_ADDED_U_1 @"() دعاك للصداقة  "
#define XYZ_CHALLANGED_U_1 @"() تحداك لجولة "
#define XYZ_SENT_MSG_1 @" () أرسل رسالة "
#define FRIEND_REQ_1 @"طلب صداقة "
#define JOIN_1 @"أدخل "
#define VIEW_1 @" شاهد "
#define POINT_TRANS_MSG_1 @"() أعطاك ثلاثين نقطة "
#define OPPO_NOT_AVAIL_1 @" الخصم غير موجود "
#define OPPO_GONE_AWAY_1 @ "الخصم قد غادر "
#define RETURN_HOME_1 @" عد إلى الصفحة الرئسية "
#define PLAY_AGAIN_1 @"إلعب مرة أخرى "
#define ENTER_EMAIL_USERNAME_1 @"أدخل حسابك الإلكتروني "
#define ENTER_USERNAME_1 @"أدخل إسم المستخدم "
#define SENDING_EMAIL_1 @"إرسال الرسالة"
#define PLZ_WAIT_1 @" إنتظر قليلاً "
#define BANK_LOCATION_1 @"عنوان المصرف"
#define BANK_NAME_1 @"إسم المصرف "
#define IBAN_1 "IBAN # (اختياري)	"
#define SWIFT_CODE_1 @"رمز سويفت"
#define BANK_ACCOUNT_NO_1 @"رقم الحساب  "
#define BANK_TITLE_1 @"إسم المصرف "
#define BANK_ADDRESS_1 @"أدخل عنوانك "
#define CONTACT_NO_1 @"دخل رقمك الهاتفي"
#define CONTACT_EMAIL_1 @"أدخل بريدك الإلكتروني  "
#define SKRIL_EMAIL_1 @" أدخل حسابك  "
#define PAYPAL_EMAIL_1 @"أدخل حسابك  "
#define ERR_REFERAL_CODE_1 @"خطأ في إدخال رمز الإحالة، الرجاء المحاولة لاحقا!"
#define SUCCESS_REFERAL_CODE_1 @"الرقم الاحالي تم إرساله"
#define ERR_TRANF_POINTS_1 @"هناك مشكلة في تحويل النقاط، حاول مرة أخرى!"
#define SUCCESS_TRANF_POINTS_1 @"تم تحويل الجواهر بنجاح "
#define SUBMIT_MSG_SUCCESS_1  @"تم إرسال الرسالة"
#define QUIT_GAME_1 @"غادراللعبة"
#define ERR_WENT_WRONG_1 @"Something went Wrong"
#define ALREADY_LOGGED_1 @"Already Logged In"
#define SHARE_WITS_1 @"Share WITS on any of the following tools and you 'll earn free Points every time one of your friends uses the referral code you have shared"
#define CASHOUT_OPTION_1 @"حدد الخيار لسحب أموالهم"
#define NO_ACC_SETUP_1 @"NO ACCOUNT SETUP"
#define ADD_FRIEND_1 @"إضافة صديق"
#define PENDING_1 @"ريثما"

#define VS_2 @"VS"
#define Round_2 @"Tour"
#define LAST_ROUND_2 @"Dernier tour"
#define BRAVO_2 @"Bravo"
#define KO_2 @"K.O"
#define CORRECT_2 @"Correct! C'était juste "
#define OPPONENT_ANS_BEFORE_2 @"L'opposant a répondu avant vous"
#define TIMES_UP_2 @"Le temps est écoulé"
#define WRONG_ANS_WAIT_OPP_2 @"Mauvaise réponse! En attente de réponse de l'opposant"
#define YOU_WIN_2 @"vous avez gagné!"
#define ITS_TIE_2 @"tirer!"
#define BETTER_LUCK_2 @"Hélas! Géré pas gagner toute récompense ou un prix en argent. Jouer mieux la prochaine fois!"
#define STATUS_2 @" Statut"
#define TIME_2 @" Temps"
#define POINTS_2 @"Points"
#define GEMS_2 @"Gems"
#define YOU_BEAT_2 @"Vous avez battu XYZ il y a 6 minutes"
#define XYZ_BEAT_YOU_2 @" XYZ vous a battu il y a deux jours"
#define PERSONAL_INFO_2 @"Informations confidentielles"
#define VERIFIED_2 @" Vérifié"
#define NOT_VERIFIED_2 @"Non vérifié"
#define ABOUT_2 @" À propos"
#define EMAIL_INVITE_DESC_2 @" Vous êtes invité à jouer WITS par XYZ, Le code de référence de l'utilisateur est: "
#define TWITTER_INVITE_MSG_2 @"Salut, Jouons à WITS. Mon code de référence est xyz. Aidez-moi à gagner des Points"
#define TWITTER_REFERRAL_CODE_2 @"WITS - Code de référence"
#define FB_INVITE_DESC1_2 @"WITS est un jeu primé multijoueur de trivia  et une communauté de fans."
#define FB_INVITE_DESC2_2 @"Salut, Mon code de référence est xyz. Aidez-moi à gagner des Points gratuits. Jouons ensemble à WITS."
#define UNFRIEND_CONFIRM_2 @"Êtes-vous sûr de vouloir supprimer cette personne?"
#define OK_BTN_2 @" D'accord"
#define CANCEL_2 @"Annuler"
#define GENERAL_FEEDBACK_2 @"Commentaires généraux"
#define TECH_ISSUE_2 @"Problème technique"
#define DAYS_AGO_2 @"Il y a jours"
#define XYZ_ADDED_U_2 @" XYZ vous a ajouté!"
#define XYZ_CHALLANGED_U_2 @"XYZ vous a défié"
#define XYZ_SENT_MSG_2 @"XYZ a envoyé un message"
#define FRIEND_REQ_2 @"Demande d'ami"
#define JOIN_2 @"Joindre"
#define VIEW_2 @"Voir"
#define POINT_TRANS_MSG_2 @"XYZ vous a donné 30 Points!"
#define OPPO_NOT_AVAIL_2 @"L'opposant que vous essayez de joindre n'est pas disponible pour le moment"
#define OPPO_GONE_AWAY_2 @ "L'opposant que vous essayez de joindre est parti"
#define RETURN_HOME_2 @" Retour à l'accueil"
#define PLAY_AGAIN_2 @"Rejouer"
#define ENTER_EMAIL_USERNAME_2 @"Saisissez votre pseudo ou votre adresse e-mail"
#define ENTER_USERNAME_2 @" Saisissez le nom d'utilisateur!"
#define SENDING_EMAIL_2 @"Envoyer un e-mail "
#define PLZ_WAIT_2 @"Veuillez patienter"
#define BANK_LOCATION_2 @" Adresse de la banque"
#define BANK_NAME_2 @"Nom de la banque"
#define IBAN_2 "IBAN # (Facultatif)"
#define SWIFT_CODE_2 @"Le BIC"
#define BANK_ACCOUNT_NO_2 @"Numéro de compte bancaire"
#define BANK_TITLE_2 @"Titre de la Banque"
#define BANK_ADDRESS_2 @"Saisissez votre adresse"
#define CONTACT_NO_2 @"Entrez votre numéro de téléphone "
#define CONTACT_EMAIL_2 @" Entrez votre adresse e-mail "
#define SKRIL_EMAIL_2 @" Entrez votre adresse -mail Skril "
#define PAYPAL_EMAIL_2 @"Entrez votre adresse e-mail PayPal"
#define ERR_REFERAL_CODE_2 @"Le code de référence n'est pas correct, veuillez réessayer plus tard"
#define SUCCESS_REFERAL_CODE_2 @"Le code de parrainage a été envoyé avec succès"
#define ERR_TRANF_POINTS_2 @"Une erreur est survenue lors du transfert de Points, réessayez plus tard!"
#define SUCCESS_TRANF_POINTS_2 @"Points transférés avec succès."
#define SUBMIT_MSG_SUCCESS_2  @"Message a été soumis."
#define QUIT_GAME_2 @"Quitter le jeu"
#define ERR_WENT_WRONG_2 @"Erreur: Quelque chose s'est mal passé"
#define ALREADY_LOGGED_2 @"Already Logged In"
#define SHARE_WITS_2 @"Vous pouvez toujours gagner des Points gratuits en invitant vos amis et en partageant votre application sur les médias sociaux"
#define CASHOUT_OPTION_2 @"Select Option to Cash out"
#define NO_ACC_SETUP_2 @"NO ACCOUNT SETUP"
#define ADD_FRIEND_2 @"Ajouter un ami "
#define PENDING_2 @"en attendant"


#define VS_3 @"VS"
#define Round_3 @"Ronda"
#define LAST_ROUND_3 @"Última Ronda"
#define BRAVO_3 @"Bravo"
#define KO_3 @"Nocaut	"
#define CORRECT_3 @"Correcto! Estuvo cerca "
#define OPPONENT_ANS_BEFORE_3 @"Tu adversario contestó antes"
#define TIMES_UP_3 @"Tiempo acabado"
#define WRONG_ANS_WAIT_OPP_3 @"¡Respuesta equivocada! Esperando la respuesta del Adversario.."
#define YOU_WIN_3 @"Te has ganado"
#define ITS_TIE_3 @"Dibujar!"
#define BETTER_LUCK_3 @"Vaya! NO has ganado ningún Premio nuevo ni dinero en metálico. ¡Juega mejor la próxima vez!"
#define STATUS_3 @"Estatus"
#define TIME_3 @"Tiempo  "
#define POINTS_3 @"Puntos"
#define GEMS_3 @"Gemas"
#define YOU_BEAT_3 @"Venciste XYZ hace 6 minutos"
#define XYZ_BEAT_YOU_3 @"XYZ te venció hace 2 días"
#define PERSONAL_INFO_3 @"INFORMACIóN PRIVADA"
#define VERIFIED_3 @"Verificado"
#define NOT_VERIFIED_3 @"No Verificado"
#define ABOUT_3 @"Sobre"
#define EMAIL_INVITE_DESC_3 @"YXYZ te invitó a jugar WITS. El código de referencia del usuario es: "
#define TWITTER_INVITE_MSG_3 @"Hola, jugamos WITS. Mi Código de Referencia es XYZ. Ayudame a ganar puntos"
#define TWITTER_REFERRAL_CODE_3 @"WITS - Código de Referencia"
#define FB_INVITE_DESC1_3 @"WITS es un galardonado juego de trivia multiplayer y una comunidad de Fans."
#define FB_INVITE_DESC2_3 @"Hola. Mi Código de Referencia es XYZ. Ayudame a ganar puntos. Jugamos WITS juntos."
#define UNFRIEND_CONFIRM_3 @"¿Seguro quieres desagregar a esa persona?"
#define OK_BTN_3 @"OK"
#define CANCEL_3 @"Cancelar"
#define GENERAL_FEEDBACK_3 @"Comentarios generales"
#define TECH_ISSUE_3 @"Comentarios generales"
#define DAYS_AGO_3 @"Hace días"
#define XYZ_ADDED_U_3 @"¡XYZ te agregó!"
#define XYZ_CHALLANGED_U_3 @"¡XYZ te desafió!"
#define XYZ_SENT_MSG_3 @"XYZ mandó un mensage"
#define FRIEND_REQ_3 @"Solicitud de amistad"
#define JOIN_3 @"Unete"
#define VIEW_3 @"Visualiza"
#define POINT_TRANS_MSG_3 @"¡XYZ te otorgó 30 puntos!"
#define OPPO_NOT_AVAIL_3 @"Este adversario no está disponible por el momento"
#define OPPO_GONE_AWAY_3 @ "Este adversario Salió"
#define RETURN_HOME_3 @"Retorno al Inicio"
#define PLAY_AGAIN_3 @"Jugar de nuevo"
#define ENTER_EMAIL_USERNAME_3 @"Ingresar Email o Usuario"
#define ENTER_USERNAME_3 @"Ingresar Usuario"
#define SENDING_EMAIL_3 @"Enviando Email"
#define PLZ_WAIT_3 @"Por favor espera"
#define BANK_LOCATION_3 @"Ubicación del banco"
#define BANK_NAME_3 @"Nombre del Banco"
#define IBAN_3 "IBAN # (Optional)	"
#define SWIFT_CODE_3 @"Código Swift"
#define BANK_ACCOUNT_NO_3 @"Numero de cuenta #"
#define BANK_TITLE_3 @"Título del Banco"
#define BANK_ADDRESS_3 @"Introduzca la dirección"
#define CONTACT_NO_3 @"Introduzca el numero de teléfono "
#define CONTACT_EMAIL_3 @"Introduzca el Email "
#define SKRIL_EMAIL_3 @"Introduzca el Email de Skril "
#define PAYPAL_EMAIL_3 @"Introduzca el Email de Paypal "
#define ERR_REFERAL_CODE_3 @"¡Error al ingresar el Código de Referencia, vuelva a intentarlo más tarde!"
#define SUCCESS_REFERAL_CODE_3 @"Código de Referencia informado con éxito"
#define ERR_TRANF_POINTS_3 @"Error en transferir pontus, intenta más tarde!"
#define SUCCESS_TRANF_POINTS_3 @"pontus transferidas exitosamente"
#define SUBMIT_MSG_SUCCESS_3  @"Mensage enviado"
#define QUIT_GAME_3 @"Salir del juego"
#define ERR_WENT_WRONG_3 @"Algo salió mal"
#define ALREADY_LOGGED_3 @"Already Logged In"
#define SHARE_WITS_3 @"Comparte WITS en cualquiera de los medios siguientes y gana Points gratis siempre que tus amigos usen el código de referencia que has compartido"
#define CASHOUT_OPTION_3 @"Select Option to Cash out"
#define NO_ACC_SETUP_3 @"NO ACCOUNT SETUP"
#define ADD_FRIEND_3 @"Añadir amigo"
#define PENDING_3 @"A la espera de"


#define VS_4 @"VS"
#define Round_4 @"Rodadas"
#define LAST_ROUND_4 @"Último Rodadas"
#define BRAVO_4 @"Bravo"
#define KO_4 @"Nocaute"
#define CORRECT_4 @"Correto! Foi por pouco"
#define OPPONENT_ANS_BEFORE_4 @"Adversário Respondeu Antes de Você"
#define TIMES_UP_4 @"Tempo Esgotado"
#define WRONG_ANS_WAIT_OPP_4 @"Resposta Incorreta! Aguardando Resposta do Adversário.."
#define YOU_WIN_4 @"você ganhou!"
#define ITS_TIE_4 @"desenhar!"
#define BETTER_LUCK_4 @"Infelizmente você NÃO conseguiu ganhar nenhum novo Prêmio ou Prêmio em Dinheiro. Continue tentando!"
#define STATUS_4 @"Status"
#define TIME_4 @"Tempo"
#define POINTS_4 @"Pontos"
#define GEMS_4 @"Gemas"
#define YOU_BEAT_4 @"Você derrotou XYZ há 6 minutos"
#define XYZ_BEAT_YOU_4 @"Você foi derrotado por XYZ há 2 dias"
#define PERSONAL_INFO_4 @"INFORMAÇÃO CONFIDENCIAL"
#define VERIFIED_4 @"Verificado"
#define NOT_VERIFIED_4 @"Não Verificado"
#define ABOUT_4 @"Sobre"
#define EMAIL_INVITE_DESC_4 @"Você foi convidado a jogar WITS por XYZ, o código de referência do usuário é: "
#define TWITTER_INVITE_MSG_4 @"Olá, Vamos Jogar WITS. Meu código de referência é xyz. Ajude-me a Ganhar Pontos"
#define TWITTER_REFERRAL_CODE_4 @"WITS - Código de Referência xyz"
#define FB_INVITE_DESC1_4 @"WITS é um premiado jogo de trivia multiplayer e uma comunidade de fãs."
#define FB_INVITE_DESC2_4 @"Olá, Meu código de referência é xyz. Ajude-me a ganhar pontos. Vamos jogar Wits juntos."
#define UNFRIEND_CONFIRM_4 @"Você tem certeza que deseja excluir esta pessoa?"
#define OK_BTN_4 @"OK"
#define CANCEL_4 @"Cancelar"
#define GENERAL_FEEDBACK_4 @"Comentários Gerais"
#define TECH_ISSUE_4 @"Problema Técnico"
#define DAYS_AGO_4 @"dias atrás"
#define XYZ_ADDED_U_4 @"XYZ adicionou você!"
#define XYZ_CHALLANGED_U_4 @"XYZ desafiou você!"
#define XYZ_SENT_MSG_4 @XYZ mandou mensagem"
#define FRIEND_REQ_4 @"Solicitação de amizade"
#define JOIN_4 @"Faça parte"
#define VIEW_4 @"Visualize"
#define POINT_TRANS_MSG_4 @"WYX deu 30 pontos para você!"
#define OPPO_NOT_AVAIL_4 @"O adversário não está disponível no momento"
#define OPPO_GONE_AWAY_4 @ "O adversário saiu"
#define RETURN_HOME_4 @"Retorne para o Início"
#define PLAY_AGAIN_4 @"Jogue Novamente"
#define ENTER_EMAIL_USERNAME_4 @"Informe Email ou Nome de Usuário"
#define ENTER_USERNAME_4 @"Enviando Email"
#define SENDING_EMAIL_4 @"Por favor, aguarde"
#define PLZ_WAIT_4 @"Localidade do Banco"
#define BANK_LOCATION_4 @"Bank Location"
#define BANK_NAME_4 @"Nome do Banco"
#define IBAN_4 "IBAN # (Optional)	"
#define SWIFT_CODE_4 @"Código Swift"
#define BANK_ACCOUNT_NO_4 @"Número da Conta "
#define BANK_TITLE_4 @"Título do Banco"
#define BANK_ADDRESS_4 @"Informe o Endereço"
#define CONTACT_NO_4 @"Informe o Número de Contato "
#define CONTACT_EMAIL_4 @"nforme o Email de Contato "
#define SKRIL_EMAIL_4 @"Informe o Email do Skril "
#define PAYPAL_EMAIL_4 @"Informe o Email do PayPal"
#define ERR_REFERAL_CODE_4 @"Erro ao informar o Código de Referência. Tente novamente mais tarde!"
#define SUCCESS_REFERAL_CODE_4 @"Código de Referência enviado com sucesso!"
#define ERR_TRANF_POINTS_4 @">Erro na transferência das pontus, Tente outra vez mais tarde!"
#define SUCCESS_TRANF_POINTS_4 @"pontus transferidas com sucesso"
#define SUBMIT_MSG_SUCCESS_4  @"Mensagem foi enviada."
#define QUIT_GAME_4 @"Sair do Jogo"
#define ERR_WENT_WRONG_4 @"Alguma coisa deu errado"
#define ALREADY_LOGGED_4 @"Already Logged In"
#define SHARE_WITS_4 @"Compartilhe o Wits em uma das ferramentas seguintes e você irá ganhar Points sempre que um de seus amigos usar o código de referência que você compartilhou"
#define CASHOUT_OPTION_4 @"Select Option to Cash out"
#define NO_ACC_SETUP_4 @"NO ACCOUNT SETUP"
#define ADD_FRIEND_4 @"Adicionar amigo"
#define PENDING_4 @"Pendendo"


///////Miscelleneuse//////
#define SURRENDER_LBL @" Are you sure you want to surrender? "
#define YES_BTN @"YES"
#define NO_BTN @"NO"
#define RESULTS_LBL @"Results"
#define MUSIC_BTN @"Music"
#define SOUNDEFFECTS_LBL @"Sound Effects"
#define VIBRATION @"Vibration"
#define CHELLANGE_NOTIF @"Chellange Notification"
#define CHAT_NOTIF @"Chat Notification"
#define EDIT @"Edit"
#define GENDER @"Gender"
#define ABOUT @"About"
#define COUNTRY @"Country"
#define CITY @"City"
#define UPDATE @"Update"
#define SAVE  @"Save"
#define SEND @"Send"
#define REFERRAL_CODE @"Referral Code"
#define PUSH_NOTIF @"Push Notification"
#define ADD_CONTENT @"Add Content"
#define ADD_QUESTION @"Add a Question"
#define ENTER_ANSWER @"Enter an Answer"
#define GUIDELINES @"Guidelines"
#define PROFILE @"Profile"
#define BACK_BTN @"Back"
#define ONLINE_LBL @"Online"

#define SURRENDER_LBL_1 @"هل أنت أكيد من الإستسلام؟"
#define YES_BTN_1 @" نعم "
#define NO_BTN_1 @"لا"
#define RESULTS_LBL_1 @"النتائج "
#define MUSIC_BTN_1 @"الموسيقى"
#define SOUNDEFFECTS_LBL_1 @" تأثير الصوت"
#define VIBRATION_1 @"اهتزاز"
#define CHELLANGE_NOTIF_1 @" التبليغ بالتحدي"
#define CHAT_NOTIF_1 @"التبليغ بالرسائل "
#define EDIT_1 @"التعديل "
#define GENDER_1 @" الجنس"
#define ABOUT_1 @"معلومات عنا "
#define COUNTRY_1 @" البلد"
#define CITY_1 @" المدينة "
#define UPDATE_1 @"تحديث"
#define SAVE_1 @"إحفظ "
#define SEND_1 @"ارسل"
#define REFERRAL_CODE_1 @"الرمز "
#define PUSH_NOTIF_1 @"التبليغات"
#define ADD_CONTENT_1 @"ضف موضوع "
#define ADD_QUESTION_1 @" أضافة سؤال"
#define ENTER_ANSWER_1 @ "أدخل الجواب"
#define GUIDELINES_1 @"الإرشادات"
#define PROFILE_1 @"الملف الشخصي"
#define BACK_BTN_1 @"العودة"
#define ONLINE_LBL_1 @"متصل"

#define SURRENDER_LBL_2 @"Etes-vous sûre de vouloir abandonner?"
#define YES_BTN_2 @"Oui"
#define NO_BTN_2 @"NO"
#define RESULTS_LBL_2 @ "Résultats"
#define MUSIC_BTN_2 @"Musique"
#define SOUNDEFFECTS_LBL_2 @"Effets sonores"
#define VIBRATION_2 @"Vibration"
#define CHELLANGE_NOTIF_2 @"Notifications du Défi"
#define CHAT_NOTIF_2 @"Notifications du Chat"
#define EDIT_2 @" Editer"
#define GENDER_2 @" Sexe"
#define ABOUT_2 @" A propos"
#define COUNTRY_2 @" Pays"
#define CITY_2 @" Ville"
#define UPDATE_2 @" Mise à jour"
#define SAVE_2 @"Enregistrer"
#define SEND_2 @" Envoyer"
#define REFERRAL_CODE_2 @"Code de Parrainage"
#define PUSH_NOTIF_2 @" Notifications Push"
#define ADD_CONTENT_2 @"Contribuer au contenu"
#define ADD_QUESTION_2 @"Ajouter une question"
#define ENTER_ANSWER_2 @"Ajouter une réponse"
#define GUIDELINES_2 @"instructions"
#define PROFILE_2 @"Profil"
#define BACK_BTN_2 @"arrière"
#define ONLINE_LBL_2 @"en ligne"

#define SURRENDER_LBL_3 @"¿Seguro que desea abandonar?"
#define YES_BTN_3 @" Sí"
#define NO_BTN_3 @"NO"
#define RESULTS_LBL_3 @" Resultados"
#define MUSIC_BTN_3 @" Musica"
#define SOUNDEFFECTS_LBL_3 @" Efectos de sonido"
#define VIBRATION_3 @"Vibración"
#define CHELLANGE_NOTIF_3 @" Notificaciones del Reto"
#define CHAT_NOTIF_3 @"Notificaciones Del Chat"
#define EDIT_3 @"Editar"
#define GENDER_3 @" Sexo"
#define ABOUT_3 @" Sobre"
#define COUNTRY_3 @" País"
#define CITY_3 @"Ciudad"
#define UPDATE_3 @"Actualización"
#define SAVE_3 @"Guardar"
#define SEND_3 @" Enviar"
#define REFERRAL_CODE_3 @"Código de Referencia"
#define PUSH_NOTIF_3 @"Notificaciones Push"
#define ADD_CONTENT_3 @"Agregar contenido"
#define ADD_QUESTION_3 @" Agregar una pregunta"
#define ENTER_ANSWER_3 @"Agregar una respuesta"
#define GUIDELINES_3 @"Instrucciones"
#define PROFILE_3 @"Perfil"
#define BACK_BTN_3 @"Volver"
#define ONLINE_LBL_3 @"en línea"

#define SURRENDER_LBL_4 @"Tem certeza que deseja abandonar?"
#define YES_BTN_4 @"Sim"
#define NO_BTN_4 @"NO"
#define RESULTS_LBL_4 @" Resultados"
#define MUSIC_BTN_4 @"Música"
#define SOUNDEFFECTS_LBL_4 @" Efeitos sonoros"
#define VIBRATION_4 @" Vibração"
#define CHELLANGE_NOTIF_4 @"Notificações do Desafio"
#define CHAT_NOTIF_4 @"Notificações do Chat"
#define EDIT_4 @"Editar"
#define GENDER_4 @" Género"
#define ABOUT_4 @" Sobre"
#define COUNTRY_4 @" País"
#define CITY_4 @"Cidade"
#define UPDATE_4 @"Atualização"
#define SAVE_4 @"Guardar"
#define SEND_4 @" Enviar"
#define REFERRAL_CODE_4 @"Código de referência"
#define PUSH_NOTIF_4 @"Notificações Push"
#define ADD_CONTENT_4 @"Adicionar conteúdo"
#define ADD_QUESTION_4 @"Adicionar uma pergunt"
#define ENTER_ANSWER_4 @"Adicionar uma resposta"
#define GUIDELINES_4 @" Instruções"
#define PROFILE_4 @"Perfil"
#define BACK_BTN_4 @"Voltar"
#define ONLINE_LBL_4 @"emlinha"

#define INVITE_FRIENDS @"Invite Friends"
#define INVITE_FRIENDS_1 @"دعوة الأصدقاء"
#define INVITE_FRIENDS_2 @"inviter des amis"
#define INVITE_FRIENDS_3 @"invitar a amigos"
#define INVITE_FRIENDS_4 @"convidar amigos"

///// Dialog Strings /////

#define PLAY_FOR_POINTS @"PLAY FOR POINTS"
#define PLAY_FOR_GEMS @"PLAY FOR GEMS"
#define For_Gems @"For Gems"
#define For_Points @"For Points"

#define WILL_HELP_IN_RANKING @"Will improve your Ranking"
#define WILL_HELP_EARN_MONEY @"Will help you earn rewards"
#define TUTORIAL_STR_1 @"Play in your own language"
#define TUTORIAL_STR_2 @"Compete with others in topics of your own choice. "
#define TUTORIAL_STR_3 @"Find random players having same interests; be correct and quick to gain more"
#define TUTORIAL_STR_4 @"Buy gems to unlock game play that helps you earn real money. Redeem Your Gems for Real Money."

#define For_Gems1 @"للحصول على الجواهر"
#define For_Points1 @"للحصول على نقاط"
#define PLAY_FOR_POINTS_1 @"العب من أجل الحصول على نقاط"
#define PLAY_FOR_GEMS_1 @"العب من أجل الحصول على جواهر"
#define WILL_HELP_IN_RANKING_1 @"سيحسن من ترتيبك"
#define WILL_HELP_EARN_MONEY_1 @"سوف تساعدك على كسب المكافآت"
#define TUTORIAL_STR_1_1 @"العب بلغتك الخاصة."
#define TUTORIAL_STR_2_1 @"تنافس مع الآخرين في مواضيع من إختيارك."
#define TUTORIAL_STR_3_1 @"ابحث عن لاعبين عشوائيين لديهم نفس اهتماماتك; كن دقيقا وسريعا لتكسب أكثر."
#define TUTORIAL_STR_4_1 @"اشتر حجارة مرصعًة لفك الألعاب التي تساعدك لكسب أموال حقيقية. استبدل حجارتك الكريمة بأموال حقيقية."

#define For_Gems2 @"Por Gemas"
#define For_Points2 @"Por PuntosS"
#define PLAY_FOR_POINTS_2 @"Jouez pour des points"
#define PLAY_FOR_GEMS_2 @"Jouez pour des Gems"
#define WILL_HELP_IN_RANKING_2 @"Améliorera votre classement"
#define WILL_HELP_EARN_MONEY_2 @"vous aideront à gagner des récompenses"
#define TUTORIAL_STR_1_2 @"Jouez dans votre langue."
#define TUTORIAL_STR_2_2 @"Affrontez les autres sur des themes."
#define TUTORIAL_STR_3_2 @"Trouvez des joueurs avec les mêmes intérêts de façon aléatoire; répondez correctement et soyez rapide pour plus de gains."
#define TUTORIAL_STR_4_2 @"Achetez des gemmes pour débloquer une catégorie de jeu qui vous aide à gagner de l'argent réel. Echangez vos gemmes contre de l'argent réel."

#define For_Gems3 @"Par les gems"
#define For_Points3 @"Pour les points"
#define PLAY_FOR_POINTS_3 @"Juega para obtener puntos"
#define PLAY_FOR_GEMS_3 @"Juega para obtener gemas"
#define WILL_HELP_IN_RANKING_3 @"Mejorará tu ranking"
#define WILL_HELP_EARN_MONEY_3 @"le ayudará a ganar recompensas"
#define TUTORIAL_STR_1_3 @"Juega en tu propio idioma."
#define TUTORIAL_STR_2_3 @"Compite con otros en temas de tu elección."
#define TUTORIAL_STR_3_3 @"Encuentra aleatoriamente jugadores con tus mismos intereses; acierta y se rápido para ganar más."
#define TUTORIAL_STR_4_3 @"Compra gemas para desbloquear el modo de juego que te ayuda a ganar dinero real. Canjea tus gemas por dinero real."

#define For_Gems4 @"Por Gems"
#define For_Points4 @"Por Pontos"
#define PLAY_FOR_POINTS_4 @"JOGUE PARA PONTOS"
#define PLAY_FOR_GEMS_4 @"JOGUE PARA GEMAS"
#define WILL_HELP_IN_RANKING_4 @"Melhora a sua pontuação"
#define WILL_HELP_EARN_MONEY_4 @"irá ajudá-lo a ganhar recompensas"
#define TUTORIAL_STR_1_4 @"Jogue no seu próprio idioma."
#define TUTORIAL_STR_2_4 @"Dispute com outras pessoas sobre temas da sua escolha."
#define TUTORIAL_STR_3_4 @"Encontre jogadores com os seus interesses; acerte rápido para ganhar mais."
#define TUTORIAL_STR_4_4 @"Compre joias e libere o modo que ajuda você a ganhar dinheiro de verdade. Troque suas Joias por Dinheiro de Verdade."


////Rewards Addons //////
#define REWARDS @"Rewards"
#define COMGRATULATIONS @"Congratulations"
#define REQUEST_RECIEVED @"Your Request is recieved"
#define OUR_TEAM_WILL_VERIFY @"Our team will verify your details and will contact you for further process"
#define CANNOT_PURCHASE @"Your purchase cannot be processed at the moment, please try again"
#define TWO_CONSECUTIVE @"For two consecutive questions two wrong answers will be removed."
#define FIVE_CONSECUTIVE @"For five consecutive questions two wrong answers will be removed."
#define PURCHASE_ERROR @"Purchase Error"
#define ADDONS @"AddOns"
#define CLAIM @"Redeem"
#define REWARDSLIST @"Rewards List"
#define UNLOCK_TWO_QUESTIONS @"Unlock 2 Questions"
#define UNLOCK_FIVE_QUESTIONS @"Unlock 5 Questions"
#define YOU_UNLOCKED_50_50 @"You have unlocked 50/50"
#define NOW_FIVE_QUESTIONS_MSG @"Now for five consecutive questions two wrong answers will be removed"

#define REWARDS_1 @"المكافآت"
#define COMGRATULATIONS_1 @"تهانينا"
#define REQUEST_RECIEVED_1 @"تم استلام طلبك"
#define OUR_TEAM_WILL_VERIFY_1 @" سيتأكد فريقنا من تفاصيل طلبك وسيتم الاتصال بك للمتابعة"
#define CANNOT_PURCHASE_1 @".لا يمكن متابعة عملية الشراء حاليا، المرجو المحاولة لاحقا"
#define TWO_CONSECUTIVE_1 @"سيتم استبعاد جوابين خاطئين لسؤالين متتابعين "
#define FIVE_CONSECUTIVE_1 @"سيتم استبعاد جوابين خاطئين لخمسة أسئلة متتابعة"
#define PURCHASE_ERROR_1 @"خطأ في عملية الشراء"
#define ADDONS_1 @"إضافات"
#define CLAIM_1 @"اطلب"
#define REWARDSLIST_1 @"قائمة الجوائز"
#define UNLOCK_TWO_QUESTIONS_1 @"افتح سؤالين"
#define UNLOCK_FIVE_QUESTIONS_1 @"افتح خمسة أسئلة"
#define YOU_UNLOCKED_50_50_1 @"لقد انجزت 50/50"
#define NOW_FIVE_QUESTIONS_MSG_1 @".الآن سيتم استبعاد جوابين خاطئين لخمسة أسئلة متتابعة"
#define REWARDS_2 @"Récompenses"
#define COMGRATULATIONS_2 @"Félicitations"
#define REQUEST_RECIEVED_2 @"Votre demande a bien été reçue"
#define OUR_TEAM_WILL_VERIFY_2 @"Notre équipe vérifiera vos informations et vous contactera pour la suite"
#define CANNOT_PURCHASE_2 @"Votre achat ne peut pas être finalisé actuellement, veuillez essayer plus tard s.v.p."
#define TWO_CONSECUTIVE_2 @"Pour deux questions consécutives deux mauvaises réponses seront éliminées"
#define FIVE_CONSECUTIVE_2 @"Pour cinq questions consécutives deux mauvaises réponses seront éliminées"
#define PURCHASE_ERROR_2 @"Erreur au niveau de l'achat"
#define ADDONS_2 @"Suppléments"
#define CLAIM_2 @"Récupérer "
#define REWARDSLIST_2 @"Liste de récompenses"
#define UNLOCK_TWO_QUESTIONS_2 @"Déverrouiller 2 Questions"
#define UNLOCK_FIVE_QUESTIONS_2 @"Déverrouiller 5 Questions"
#define YOU_UNLOCKED_50_50_2 @"Vous avez débloqué 50/50"
#define NOW_FIVE_QUESTIONS_MSG_2 @"Désormais pour cinq questions consécutives deux mauvaises réponses seront éliminées"

#define REWARDS_3 @"Recompensas"
#define COMGRATULATIONS_3 @"Felicidades"
#define REQUEST_RECIEVED_3 @"Su solicitud fue recibida"
#define OUR_TEAM_WILL_VERIFY_3 @"Nuestro equipo verificará sus detalles y lo contactará para avanzar el proceso"
#define CANNOT_PURCHASE_3 @"Su compra no puede ser procesada en este momento, por favor trate más tarde"
#define TWO_CONSECUTIVE_3 @"Por dos respuestas consecutivas, dos respuestas incorrectas serán eliminadas."
#define FIVE_CONSECUTIVE_3 @"Por cinco respuestas consecutivas, dos respuestas incorrectas serán eliminadas."
#define PURCHASE_ERROR_3 @"Error de compra"
#define ADDONS_3 @"Suplementos"
#define CLAIM_3 @"Reclama"
#define REWARDSLIST_3 @"Lista de recompensas"
#define UNLOCK_TWO_QUESTIONS_3 @"Desbloquear 2 Preguntas"
#define UNLOCK_FIVE_QUESTIONS_3 @"Desbloquear 5 Preguntas"
#define YOU_UNLOCKED_50_50_3 @"Has desbloqueado 50/50"
#define NOW_FIVE_QUESTIONS_MSG_3 @"Ahora por cinco respuestas consecutivas, dos respuestas incorrectas serán eliminadas."

#define REWARDS_4 @"Recompensas"
#define COMGRATULATIONS_4 @"Parabéns"
#define REQUEST_RECIEVED_4 @"Seu pedido foi recebido"
#define OUR_TEAM_WILL_VERIFY_4 @"Nossa equipe irá verificar seus detalhes e contatá-lo para continuar o processo"
#define CANNOT_PURCHASE_4 @"Sua compra não pode ser processada no momento. Por favor, tente novamente."
#define TWO_CONSECUTIVE_4 @"Para duas perguntas consecutivas, duas respostas erradas serão removidas"
#define FIVE_CONSECUTIVE_4 @"Para cinco perguntas consecutivas, duas respostas erradas serão removidas"
#define PURCHASE_ERROR_4 @"Erro na Compra"
#define ADDONS_4 @"Suppléments"
#define CLAIM_4 @"Receber"
#define REWARDSLIST_4 @"Lista de Recompensas"
#define UNLOCK_TWO_QUESTIONS_4 @"Liberar 2 Perguntas"
#define UNLOCK_FIVE_QUESTIONS_4 @"Liberar 5 Perguntas"
#define YOU_UNLOCKED_50_50_4 @"Você liberou 50/50"
#define NOW_FIVE_QUESTIONS_MSG_4 @"Agora para cinco perguntas consecutivas, duas respostas erradas serão removidas"





enum {
	
	FromAvatar = 0,
    FromGallery = 1,
    FromCamera = 2,
	
};
typedef NSUInteger ProfileImageType;


enum{
    iPhone4 = 480,
    iPhone5 = 588,
    iPad = 1024
};
typedef NSUInteger DeviceType;

enum{
    OPEN_STATE = 0,
    ACCEPT_CHALLENGE_TYPE = 1,
    WAITING_CHALLENGE_REQUEST = 2,
    OPPONENT_SEARCHING = 3,
    OPTION_SELECTED = 4,
    QUITE_USER = 5
    
};
typedef NSUInteger messageType;




#endif
