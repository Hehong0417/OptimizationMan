

//【链接】LouisDM/IDCardPort （身份证扫描）
//https://github.com/LouisDM/IDCardPort

//导航栏标题字体大小
#define JDNavigationFont [UIFont systemFontOfSize:20]
#define FontBigSize [UIFont systemFontOfSize:16]
#define FontNormalSize [UIFont systemFontOfSize:14]
#define FontSmallSize [UIFont systemFontOfSize:12]
//公用颜色
#define JDCommonColor [UIColor colorWithRed:0.478 green:0.478 blue:0.478 alpha:1]

//#define APP_COMMON_COLOR  [UIColor blackColor]
//#define APP_COMMON_COLOR  RGB(255, 63, 111)
//#define APP_COMMON_COLOR  RGB(139, 71, 247)
#define APP_COMMON_COLOR  RGB(196, 125, 114)
#define APP_BUTTON_COMMON_COLOR  RGB(196, 125, 114)



#define APP_green_COLOR RGB(190, 225, 255)
//紫
#define APP_purple_Color RGB(47, 0, 159)
//深紫
#define APP_Deep_purple_Color RGB(36, 27, 57)

#define KVCBackGroundColor RGB(242, 242, 242)

#define KTitleLabelColor [UIColor colorWithHexString:@"#9e9e9e"] //158
#define K7ELabelColor [UIColor colorWithHexString:@"#7E7E7E"] //126
#define KFCLabelColor [UIColor colorWithHexString:@"#FC5F00"] //252 95 0
#define KA0LabelColor [UIColor colorWithHexString:@"#A0A0A0"] //160
#define KACLabelColor [UIColor colorWithHexString:@"#ACACAC"] //172
#define KLightTitleColor [UIColor colorWithHexString:@"#5f5f5f"]//95
#define TitleGrayColor [UIColor colorWithHexString:@"#333333"] //51
#define KDCLabelColor  [UIColor colorWithHexString:@"#DCDCDE"]//220

#define KPartingLineColor RGB(228, 227, 239)

#define KPlaceImageName  @"loadImag_default"

#define KPlaceHoldColor RGB(204, 204, 204)

#define KButoonBackGround RGB(220, 220, 220)

#define KWXLoginButoonColor RGB(8, 187, 8)


#define GrayBackGroudColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
#define LineLightColor RGB(229, 229, 229)
#define LineDeepColor RGB(95, 95, 95)
#define FontLightGrayColor RGB(153, 153, 153)
#define FontGrayColor RGB(102, 102, 102)

#define FontBlackColor RGB(51, 51, 51)
//用户信息
#define USER_CURRENT_ADDRESS @"user_current_address"
#define uDefault_CURRENT_ADDRESS [uDefault objectForKey:USER_CURRENT_ADDRESS]

//API返回信息
#define API_RETURN_SUCCESS @(1)
#define API_RETURN_FAILURE @(0)
#define API_RETURN_BUSY    @(-1)
#define API_RETURN_EXPIRE  @(40000)


//storyboard名称

#define SB_LOGIN @"Login"
#define SB_HOME_PAGE @"HomePage"
#define SB_SHOP_CAR @"ShoppingCar"
#define SB_GOODS_CLASSIFY @"GoodsClassify"
#define SB_PERSON_CENTER @"PersonCenter"
//#define kUrlScheme      @"WXMYJPay" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。
#define kUrlScheme      @"wx4a20e81b69eba007"
//
#define kTel_Number @"10086"

//获取或上传位置间隔时间
#define REQUEST_TIME_INTERVAL   10.0f

//输入文字限制
static const NSUInteger kReasonNoteMaxLength = 300;
//
////边框间距
static const CGFloat kGroupTablePadding = 15;
static const CGFloat kNormalButtonMargin = 30;
#define kNormalButtonWidth (SCREEN_WIDTH-kNormalButtonMargin*2)
#define kNormalButtonHeight 35

#define HUD_COLOR RGBA(53, 53, 53, 0.6)
#define IMAGE_SHOW_TIME 0.6
#define VIEW_SHOW_TIME 0.4

#define API_PAGE_COUNT 15

//圆角大小
#define kSmallCornerRadius 5.0f

//城市选择器
#define FirstComponent 0
#define SubComponent 1
#define ThirdComponent 2
#define FourComponent 3
#define CITYADDRESS_KEY @"CITYADDRESS_KEY"

//图片大小
#define BigImage 3
#define MiddleImage 2
#define SmallImage 1

#define IMAGE_280 @"280x280"
#define IMAGE_430 @"430x430"


#define ROOM_ONLY_SINGLE 1
#define ROOM_ONLY_SUIT 2
#define ROOM_SUIT_WITH_SINGLE 3

////商品类型
#define PRODUCT_SINGLE @"1"

//Cache
#define CACHE_HOME_MENU @"CACHE_HOME_MENU"
#define CACHE_HOME_ADS @"CACHE_HOME_ADS"
#define CACHE_HOME_VIRTUAL @"CACHE_HOME_VIRTUAL"

//NOTIFICATION
//登录失效通知
#define kNotificationTokenExpire @"kNotificationTokenExpire"

//扫码登录
#define NOTI_GUEST_FROM_QR @"NOTI_GUEST_FROM_QR"
#define APP_ACCOUNT_NAME @"APP_ACCOUNT_NAME"
#define APP_ACCOUNT_PWD @"APP_ACCOUNT_PWD"

//AliPay
#define kNotificationDidPayOrder @"NotificationDidPayOrder"
#define kNotificationGo2OrderPage @"kNotificationGo2OrderPage"

//支付成功
#define kNotificationPaySuccess @"kNotificationPaySuccess"

//修改信息成功
#define kNotificationModifySuccess @"kNotificationModifySuccess"

//密码类型
#define kNotificationPdCatory @"kNotificationPdCatory"


//网络状态
#define kNotificationNetWorkChange @"kNotificationNetWorkChange"

//tabBar双击
#define kNOTIFY_TABBAR_DOUBLE_CLICK @"kNOTIFY_TABBAR_DOUBLE_CLICK"


//tabBar选中
#define kNOTIFY_TABBAR_CLICK @"kNOTIFY_TABBAR_CLICK"

//网络状态
#define kNotificationNetWorkState @"kNotificationNetWorkState"

/** 商品属性选择返回通知 */
#define SHOPITEMSELECTBACK @"SHOPITEMSELECTBACK"

/** 删除商品属性选择返回通知 */
#define DELETE_SHOPITEMSELECTBACK @"DELETE_SHOPITEMSELECTBACK"


/** 删除通知 */
#define DELETE_SHOPITEMSELE @"DELETE_SHOPITEMSELECT"


//Block
//
typedef void(^voidBlock)();
typedef void(^idBlock)(id obj);
typedef void(^idBlock2)(id obj,NSURL *str);
typedef void(^stringBlock)(NSString *result);
typedef void(^stringBlock2)(NSString *result,NSString *description);
typedef void(^boolBlock)(BOOL boolen);
typedef void(^errorBlock)(NSError *error);
typedef void(^numberBlock)(NSNumber *result);
typedef void(^arrayWithErrorBlock)(NSArray *results,NSError *error);
typedef void(^arrayAndDescription)(NSArray *results,NSString *description);
typedef void(^arrayBlock)(NSArray *results);
typedef void(^successBlock)(id resultObj);
