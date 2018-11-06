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
#import "HHPostEvaluateSectionHead.h"
#import "HHPostOrderEvaluateItem.h"

@interface HHPostEvaluationVC ()<UITableViewDelegate,UITableViewDataSource,HHPostEvaluateFooterDelegate>

@property (nonatomic, strong)   UITableView *tableView;

@end

@implementation HHPostEvaluationVC


- (void)viewDidLoad {
   [super viewDidLoad];

    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        
        //清除评价总模型数据
        [self clearpostOrderEvaluateItem];
        
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        
        //创建评价总模型
        HHPostOrderEvaluateItem *postOrderEvaluateItem = [HHPostOrderEvaluateItem sharedPostOrderEvaluateItem];
        
        postOrderEvaluateItem.orderId = self.orderId;
        postOrderEvaluateItem.level = @1;
        [self.orderItem_m.items enumerateObjectsUsingBlock:^(HHproducts_item_Model *item_model, NSUInteger idx, BOOL * _Nonnull stop) {
            HHproductEvaluateModel *evaluate_m = [HHproductEvaluateModel new];
            evaluate_m.orderItemId = item_model.product_item_id;
            [postOrderEvaluateItem.productEvaluate addObject:evaluate_m];
        } ];
        
        [postOrderEvaluateItem write];
        
    }];

    [operation2 addDependency:operation1];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation2,operation1] waitUntilFinished:NO];
   
    
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
    HHPostEvaluateFooter *footer =   [[HHPostEvaluateFooter alloc] initWithFrame:CGRectMake(0, 60, ScreenW,75+ WidthScaleSize_H(100)+80)];
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
        cell.section = indexPath.section;
        gridCell = cell;
     return gridCell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HHproducts_item_Model *model = [self.orderItem_m.items firstObject];
    //headView
    HHPostEvaluateSectionHead *section_head = [[HHPostEvaluateSectionHead alloc] initWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(85))];
    section_head.section = section;
    [section_head.product_imageV sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:KPlaceImageName]];

    return section_head;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.orderItem_m.items.count;
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
    
    HHPostOrderEvaluateItem *oEvaluateItem = [HHPostOrderEvaluateItem sharedPostOrderEvaluateItem];
    NSLog(@"oEvaluateItem:%@",[oEvaluateItem mj_JSONString]);

    [[[HHMineAPI postOrderEvaluateWithOrderId:nil level:nil logisticsScore:nil serviceScore:nil productEvaluate:[oEvaluateItem mj_JSONString]] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {

        if (!error) {
            if (api.State == 1) {
                
                    [self clearpostOrderEvaluateItem];

                    HHEvaluationSuccessVC *vc = [HHEvaluationSuccessVC new];
                    vc.title_str = @"评价成功";
                    HHproducts_item_Model *model = [self.orderItem_m.items firstObject];
                    vc.pid = model.product_item_id;
                    vc.product_id = model.product_id;
                
                    [self.navigationController pushVC:vc];
            }else{
                NSLog(@"Msg:%@",api.Msg);
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            NSLog(@"error:%@",error.localizedDescription);
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];
        }
    }];
}

//清除
- (void)clearpostOrderEvaluateItem{
    
    HHPostOrderEvaluateItem *postOrderEvaluateItem = [HHPostOrderEvaluateItem sharedPostOrderEvaluateItem];
    postOrderEvaluateItem.orderId = nil;
    postOrderEvaluateItem.level = nil;
    postOrderEvaluateItem.logisticsScore = nil;
    postOrderEvaluateItem.serviceScore = nil;
    postOrderEvaluateItem.productEvaluate = nil;
    [postOrderEvaluateItem write];
    
}
@end

