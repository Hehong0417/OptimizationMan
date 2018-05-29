//
//  HHBroughtGiftResultVC.m
//  lw_Store
//
//  Created by User on 2018/5/7.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHBroughtGiftResultVC.h"
#import "HHBroughtGiftResultHead.h"
#import "HHBroughtGiftResultCell.h"

#import "HHEvaluationListModel.h"

@interface HHBroughtGiftResultVC ()

@property (nonatomic, strong)  NSMutableArray *datas;

@end

@implementation HHBroughtGiftResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"送礼";
    
    self.tableView.backgroundColor = KVCBackGroundColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHBroughtGiftResultCell" bundle:nil] forCellReuseIdentifier:@"HHBroughtGiftResultCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    HHBroughtGiftResultHead *head = [[HHBroughtGiftResultHead alloc]initWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(250))];
    
    self.tableView.tableHeaderView = head;
    
    
    UIView *foot = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(130)) backColor:KVCBackGroundColor];
    UIButton *top_btn = [UIButton lh_buttonWithFrame:CGRectMake(35, 25, ScreenW-70, WidthScaleSize_H(35)) target:self action:@selector(deseAction:) title:@"嘚瑟一下" titleColor:kWhiteColor font:FONT(14) backgroundColor:kBlackColor];
    [foot addSubview:top_btn];
    UIButton *down_btn = [UIButton lh_buttonWithFrame:CGRectMake(35, CGRectGetMaxY(top_btn.frame)+25, ScreenW-70, WidthScaleSize_H(35)) target:self action:@selector(bargainingAction:) title:@"玩一下送礼" titleColor:kWhiteColor font:FONT(14) backgroundColor:kBlackColor];
    [foot addSubview:down_btn];
    
    self.tableView.tableFooterView = foot;
    
    self.datas = [NSMutableArray array];
    
    [self setupDatas];
    
}
//嘚瑟一下
- (void)deseAction:(UIButton *)btn{
    
    
}
//玩一下送礼
- (void)bargainingAction:(UIButton *)btn{
    
    
}
- (void)setupDatas{
    
    
    NSArray *icon_urls = @[@"icon0.jpg",@"icon1.jpg",@"icon2.jpg",@"icon3.jpg"];
    NSArray *names = @[@"icon0.jpg",@"icon1.jpg",@"icon2.jpg",@"icon3.jpg"];
    NSArray *times =  @[@"2018.10.1",@"2018.10.1",@"2018.10.2",@"2018.10.3",@"2018.10.4",@"2018.10.1",@"2018.10.2",@"2018.10.0",@"2018.10.1",@"2018.10.2"];
    NSArray *contents =  @[@"那年，我们21  习近平的“五四”寄语  十句箴言",@"知识产权保护需各国携手 《共产党宣言》的前世今生,致癌漩涡中的槟榔:患癌45人中44人长期大量嚼女子把房子过户给开豪车小姐妹投资 结果悲剧了",@"全国楼市金三银四成色普遍不足 全年成交或震荡下行",@"女子把房子过户给开豪车小姐妹投资 结果悲剧了"];
    
    [self.datas removeAllObjects];
    
    for (NSInteger i = 0; i<4; i++) {
        HHEvaluationListModel *model = [HHEvaluationListModel new];
        model.icon_url = icon_urls[i];
        model.name = names[i];
        model.dateTime = times[i];
        model.content = contents[i];
        [self.datas addObject:model];
    }
    
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHBroughtGiftResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHBroughtGiftResultCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [cell setIndexPath:indexPath count:self.datas.count];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHEvaluationListModel *model = self.datas[indexPath.row];
    
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HHBroughtGiftResultCell class] contentViewWidth:ScreenW];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
@end
