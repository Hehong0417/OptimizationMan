//
//  HHShippingAddressVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHPostEvaluationVC.h"
#import "HHShippingAddressCell.h"
#import "HHAddAdressVC.h"
#import "HHEvaluteStarCell.h"
#import "HHSelectPhotosCell.h"
#import "HHEvaluationSuccessVC.h"
#import "HHPostEvaluateFooter.h"

@interface HHPostEvaluationVC ()<UITableViewDelegate,UITableViewDataSource,HHPostEvaluateFooterDelegate>

@property (nonatomic, strong)   UITableView *tableView;

@end

@implementation HHPostEvaluationVC

- (void)viewDidLoad {
   [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"发布评价";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - Status_HEIGHT - 44;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = KVCBackGroundColor;
    [self.view addSubview:self.tableView];
    
    //footerView
    HHPostEvaluateFooter *footer =   [[HHPostEvaluateFooter alloc] initWithFrame:CGRectMake(0, 60, ScreenW, WidthScaleSize_H(100)+80)];
    footer.backgroundColor = kWhiteColor;
    footer.delegate = self;
    self.tableView.tableFooterView = footer;
    

    
    [self.tableView registerClass:[HHSelectPhotosCell class] forCellReuseIdentifier:@"HHSelectPhotosCell"];

    [self.tableView registerClass:[HHEvaluteStarCell class] forCellReuseIdentifier:@"HHEvaluteStarCell"];
    
    
    self.view.backgroundColor = KVCBackGroundColor;
    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridCell;
        HHSelectPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSelectPhotosCell"];
        cell.vc = self;
        gridCell = cell;
    
     return gridCell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HHproducts_item_Model *model = [self.orderItem_m.items firstObject];
    //headView
    UIView *head_view = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(85)) backColor:kWhiteColor];
    UIImageView *product_imageV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(10), WidthScaleSize_H(10), WidthScaleSize_H(65), WidthScaleSize_H(65)) image:nil];
    product_imageV.backgroundColor = KVCBackGroundColor;
    [head_view addSubview:product_imageV];
    [product_imageV sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
    
    UILabel *title_lab = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(product_imageV.frame)+WidthScaleSize_W(10), WidthScaleSize_H(10), 150, 30) text:model.prodcut_name textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    title_lab.numberOfLines=3;
    [head_view addSubview:title_lab];
    //添加约束
    [self setHeadConstraintsWithHead_view:head_view product_imageV:product_imageV title_lab:title_lab];
    
    return head_view;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return WidthScaleSize_H(260);
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return WidthScaleSize_H(85);
}
#pragma mark - HHPostEvaluateFooterDelegate

- (void)postEvaluateBtnClick:(UIButton *)button{
    
    HHEvaluationSuccessVC *vc = [HHEvaluationSuccessVC new];
    vc.title_str = @"评价成功";
    HHproducts_item_Model *model = [self.orderItem_m.items firstObject];
    vc.pid = model.product_item_id;
    [self.navigationController pushVC:vc];
    
}
- (void)setHeadConstraintsWithHead_view:(UIView *)head_view product_imageV:(UIImageView *)product_imageV title_lab:(UILabel *)title_lab {
    
    [product_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(head_view.mas_left).with.offset(10);
        make.top.equalTo(head_view.mas_top).offset(10);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(65);
        
    }];
    [title_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(product_imageV.mas_right).with.offset(10);
        make.top.mas_equalTo(10);
        make.right.equalTo(head_view.mas_right).with.offset(-15);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
    
}
@end

