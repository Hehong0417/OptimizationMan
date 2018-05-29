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

@interface HHPostEvaluationVC ()<UITableViewDelegate,UITableViewDataSource>

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
    self.tableView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.tableView];
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"HHShippingAddressCell" bundle:nil] forCellReuseIdentifier:@"HHShippingAddressCell"];
    
    
    //headView
    UIView *head_view = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(85)) backColor:kWhiteColor];
    UIImageView *product_imageV = [UIImageView lh_imageViewWithFrame:CGRectMake(WidthScaleSize_W(10), WidthScaleSize_H(10), WidthScaleSize_H(65), WidthScaleSize_H(65)) image:nil];
    product_imageV.backgroundColor = kGreenColor;
    [head_view addSubview:product_imageV];
    UILabel *title_lab = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(product_imageV.frame)+WidthScaleSize_W(10), WidthScaleSize_H(10), 150, 30) text:@"liwo 美国进口 菊花茶300哥*15包 即泡即喝挂耳型茶包【盒装】" textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    title_lab.numberOfLines=3;
    [head_view addSubview:title_lab];
    self.tableView.tableHeaderView = head_view;
    
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
    
    
    //footerView
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(80)) backColor:kWhiteColor];
    UIButton *addAddressBtn = [UIButton lh_buttonWithFrame:CGRectMake(60, WidthScaleSize_H(20), SCREEN_WIDTH-120, WidthScaleSize_H(35)) target:self action:@selector(pushEvulation:) image:nil];
    [addAddressBtn setBackgroundColor:kBlackColor];
    [addAddressBtn setTitle:@"发布评价" forState:UIControlStateNormal];
    [addAddressBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [addAddressBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [footView addSubview:addAddressBtn];
    
    self.tableView.tableFooterView = footView;
    

    
    [self.tableView registerClass:[HHSelectPhotosCell class] forCellReuseIdentifier:@"HHSelectPhotosCell"];

    [self.tableView registerClass:[HHEvaluteStarCell class] forCellReuseIdentifier:@"HHEvaluteStarCell"];
    
    
}

//发布评价
- (void)pushEvulation:(UIButton *)btn{
    
    HHEvaluationSuccessVC *vc = [HHEvaluationSuccessVC new];
    vc.title_str = @"评论成功";
    [self.navigationController pushVC:vc];
    
}

#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridCell;
    if(indexPath.row == 0){
        HHSelectPhotosCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSelectPhotosCell"];
        cell.vc = self;
        gridCell = cell;
    }else{
        HHEvaluteStarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHEvaluteStarCell"];
        gridCell = cell;
    }
        gridCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
     return gridCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        return WidthScaleSize_H(260);
    }else{
       return WidthScaleSize_H(100);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}


@end

