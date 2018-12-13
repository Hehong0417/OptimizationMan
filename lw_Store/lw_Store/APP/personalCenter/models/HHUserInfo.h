//
//  HHUserInfoModel.h
//  lw_Store
//
//  Created by User on 2018/12/12.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHUserModel:BaseModel
@property(nonatomic,strong) NSString *Id;
@property(nonatomic,strong) NSString *UserName;
@property(nonatomic,strong) NSString *UserImage;
@property(nonatomic,strong) NSString *parent_userid;
@property(nonatomic,strong) NSString *parent_username;
@property(nonatomic,strong) NSString *level;
@property(nonatomic,strong) NSString *ReferralUserName;
@end

@interface HHUserInfo : BaseModel
singleton_h(UserInfo)
@property(nonatomic,strong) HHUserModel *userModel;
@property(nonatomic,strong) NSString  *regioninfo;

@end

NS_ASSUME_NONNULL_END
