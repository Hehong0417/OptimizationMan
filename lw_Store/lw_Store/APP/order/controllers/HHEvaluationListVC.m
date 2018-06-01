//
//  HHEvaluationListVC.m
//  lw_Store
//
//  Created by User on 2018/5/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHEvaluationListVC.h"
#import "HHEvaluationListCell.h"
#import "HHEvaluationListModel.h"


@interface HHEvaluationListVC ()

@end

@implementation HHEvaluationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"评价";
    
    [self.tableView registerClass:[HHEvaluationListCell class] forCellReuseIdentifier:[HHEvaluationListCell className]];
    self.tableView.backgroundColor = KVCBackGroundColor;

    
    [self setupDatas];
}
- (void)setupDatas{
    
    NSArray *icon_urls = @[@"icon0.jpg",@"icon1.jpg",@"icon2.jpg",@"icon3.jpg",@"icon4.jpg",@"icon0.jpg",@"icon1.jpg",@"icon2.jpg",@"icon3.jpg",@"icon4.jpg"];
    NSArray *names = @[@"icon0.jpg",@"icon1.jpg",@"icon2.jpg",@"icon3.jpg",@"icon4.jpg",@"icon0.jpg",@"icon1.jpg",@"icon2.jpg",@"icon3.jpg",@""];
    NSArray *grades = @[@"1",@"1",@"2",@"0",@"4",@"1",@"2",@"0",@"1",@"2"];
    NSArray *times =  @[@"2018.10.1",@"2018.10.1",@"2018.10.2",@"2018.10.3",@"2018.10.4",@"2018.10.1",@"2018.10.2",@"2018.10.0",@"2018.10.1",@"2018.10.2"];
    NSArray *contents =  @[@"那年，我们21  习近平的“五四”寄语  十句箴言",@"青年“引路人”习近平  这些“金句”  “致青春”",@"微视频|重温《共产党宣言》",@"知识产权保护需各国携手 《共产党宣言》的前世今生",@"全国楼市金三银四成色普遍不足 全年成交或震荡下行",@"美公布人口数据：亚裔2141.92万 华裔超508万居首",@"女子把房子过户给开豪车小姐妹投资 结果悲剧了",@"“致癌”漩涡中的槟榔:患癌45人中44人长期大量嚼",@"广州昨发布首个暴雨红色预警",@"教育部发火了，5个就业“最差”大学专业将被严整"];
    NSArray *imagesModelArray = @[@"icon0.jpg",@"icon1.jpg",@"icon2.jpg",@""];
    NSArray *replyContent =  @[@"感谢你对优选君的关注与信任，由于我们对您造成的不便我们道歉。由于国庆节假日日后，快递造成的阻塞等问题，我们正在尝试解决",@"",@"",@"广州昨发布首个暴雨红色预警",@"教育部发火了，5个就业“最差”大学专业将被严整",@"",@"",@"广州昨发布首个暴雨红色预警",@"",@"",@"全国楼市金三银四成色普遍不足 全年成交或震荡下行"];
    NSArray *addition_time =  @[@"2018.10.1",@"2018.10.1",@"2018.10.2",@"2018.10.3",@"2018.10.4",@"2018.10.1",@"2018.10.2",@"2018.10.0",@"2018.10.1",@"2018.10.2"];
    NSArray *addition_comment =  @[@"追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评",@"",@"追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评",@"",@"追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评",@"",@"追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评",@"",@"追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评追评",@""];
    
    [self.dataArray removeAllObjects];
    for (NSInteger i = 0; i<10; i++) {
        HHEvaluationListModel *model = [HHEvaluationListModel new];
        model.icon_url = icon_urls[i];
        model.name = names[i];
        model.dateTime = times[i];
        model.proper = @"15/1包";
        model.grade = grades[i];
        model.content = contents[i];
        model.imagesModelArray = imagesModelArray;
        model.replyContent = replyContent[i];
        model.addition_time = addition_time[i];
        model.addition_comment = addition_comment[i];
        [self.dataArray addObject:model];
    }
    
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHEvaluationListCell *cell = [tableView dequeueReusableCellWithIdentifier:[HHEvaluationListCell className]];
    cell.indexPath = indexPath;
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HHEvaluationListCell class] contentViewWidth:[self cellContentViewWith]];
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

@end
