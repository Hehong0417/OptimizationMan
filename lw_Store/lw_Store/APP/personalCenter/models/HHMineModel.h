//
//  HHMineModel.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHMineModel : BaseModel

//用户详细
@property(nonatomic,strong) NSString *BuyTotal;
@property(nonatomic,strong) NSString *Id;
@property(nonatomic,strong) NSString *UserName;
@property(nonatomic,strong) NSString *UserImage;
@property(nonatomic,strong) NSString *parent_userid;
@property(nonatomic,strong) NSString *parent_username;
@property(nonatomic,strong) NSString *level;
@property(nonatomic,strong) NSString *ReferralUserName;
@property(nonatomic,strong) NSString  *Points;
@property(nonatomic,strong) NSNumber  *isExtraBonus;


//优惠券信息
@property(nonatomic,strong) NSString *CouponValue;
@property(nonatomic,strong) NSString *CouponsId;
@property(nonatomic,strong) NSString *StartTime;
@property(nonatomic,strong) NSString *EndTime;
@property(nonatomic,strong) NSString *CouponsName;

//粉丝列表
@property(nonatomic,strong) NSString *AgentName;
@property(nonatomic,strong) NSString *Icon;
@property(nonatomic,strong) NSString *AcId;
//@property(nonatomic,strong) NSString *UserName;
@property(nonatomic,strong) NSString *AgnetLevel;

//提现信息
@property(nonatomic,strong) NSString *MinBalance;
@property(nonatomic,strong) NSString *MaxBalance;
@property(nonatomic,strong) NSString *HadBalance;
@property(nonatomic,strong) NSString *IsBusiness;
@property(nonatomic,strong) NSString *IsExistApply;
@property(nonatomic,strong) NSString *RefuseReason;
@property(nonatomic,strong) NSString *ApplyMoney;

//我的积分
@property (nonatomic, assign) NSInteger integra;
@property (nonatomic, copy) NSString *integraType;
@property (nonatomic, copy) NSString *datetime;

//我的消息
@property (nonatomic, copy) NSString *Author;
@property (nonatomic, assign) NSInteger ClientInfo_Id;
@property (nonatomic, copy) NSString *Memo;
@property (nonatomic, copy) NSString *AddTime;
@property (nonatomic, copy) NSString *PubTime;
@property (nonatomic, assign) NSInteger SendTo;
@property (nonatomic, assign) BOOL IsRead;
@property (nonatomic, copy) NSString *Title;
@property (nonatomic, assign) NSInteger SendType;
@property (nonatomic, assign) NSInteger IsPub;

//收货地址
@property(nonatomic,strong) NSString *Recipient;
@property(nonatomic,strong) NSString *Moble;
@property(nonatomic,strong) NSString *IsDefault;
@property(nonatomic,strong) NSString *Province;
@property(nonatomic,strong) NSString *City;
@property(nonatomic,strong) NSString *District;
@property(nonatomic,strong) NSString *FullAddress;
@property(nonatomic,strong) NSString *Address;
@property(nonatomic,strong) NSString *AddrId;
@property(nonatomic,strong) NSString *CityId;
@property(nonatomic,strong) NSString *RegionId;

//物流信息
@property(nonatomic,strong) NSString *express_name;
@property(nonatomic,strong) NSString *express_order;
@property(nonatomic,strong) NSArray *express_message_list;
@property(nonatomic,strong) NSString *express_abb;
@property(nonatomic,strong) NSString *express_company;
@property(nonatomic,strong) NSString *order_number;
@property(nonatomic,strong) NSDictionary *express;


//收款银行卡列表
@property(nonatomic,strong) NSString *bank_name;
@property(nonatomic,strong) NSString *bank_no;


//我的钱包
@property(nonatomic,strong) NSString *action_name;
@property(nonatomic,strong) NSString *integral_type;

@property(nonatomic,strong) NSString *is_certified;

//代理信息
//@property(nonatomic,strong) NSString *AgentName;
@property(nonatomic,strong) NSString *CreateDate;
@property(nonatomic,strong) NSString *Discount;
@property(nonatomic,strong) NSString *IsApplyJoin;
@property(nonatomic,strong) NSString *JoinMoney;
@property(nonatomic,strong) NSString *Level;
@property(nonatomic,strong) NSString *UserCount;
//@property(nonatomic,strong) NSString *ApplyMoney;
@property(nonatomic,strong) NSString *IsApply;
@property(nonatomic,strong) NSString *IsVerifyMobile;
@property(nonatomic,strong) NSDictionary *ApplyName;

//评价统计信息
@property(nonatomic,strong) NSString *describeScore;
@property(nonatomic,strong) NSString *totalCount;
@property(nonatomic,strong) NSString *hasImageCount;
@property(nonatomic,strong) NSString *goodEvaluateProportion;

@end

@interface HHExpress_message_list : BaseModel
@property(nonatomic,strong) NSString *express_full_date;
@property(nonatomic,strong) NSString *express_date;
@property(nonatomic,strong) NSString *express_time;
@property(nonatomic,strong) NSString *express_message;

@property(nonatomic,strong) NSString *context;
@property(nonatomic,strong) NSString *location;
@property(nonatomic,strong) NSString *time;

@end
