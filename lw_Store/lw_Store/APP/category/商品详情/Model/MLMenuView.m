//
//  MLMenuView.m
//  MLMenuDemo
//
//  Created by 戴明亮 on 2018/4/20.
//  Copyright © 2018年 ML Day. All rights reserved.
//

#import "MLMenuView.h"
#import "HHActivityModel.h"
#import "MLMenuCell.h"

static  NSString * const IDETIFIRE = @"MLMENUCELLIDETIFIRE";

@interface MLMenuView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    CGRect _frame;
    CGFloat _triangleOffsetLeft;
    CGFloat _menuViewOffsetTop;
    MLEnterAnimationStyle _animationStyle;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *modelsArr;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation MLMenuView


- (instancetype)initWithFrame:(CGRect)frame WithmodelsArr:(NSArray *)modelsArr WithMenuViewOffsetTop:(CGFloat)top WithTriangleOffsetLeft:(CGFloat)left
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    
    if (self) {
        _frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, modelsArr.count * 50);
       
       _menuViewOffsetTop = _menuViewOffsetTop < Status_HEIGHT ? Status_HEIGHT+STATUS_NAV_HEIGHT : _menuViewOffsetTop;
        
        _triangleOffsetLeft = left;
        _menuViewOffsetTop = top;
        _isHasTriangle = self.isHasTriangle;
        self.modelsArr = modelsArr;
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


- (void)delaDataWithmodelsArr:(NSArray *)modelsArr
{
    [self.dataArray removeAllObjects];
    self.dataArray = modelsArr.mutableCopy;
    [self.tableView reloadData];
    
}

- (void)setMenuViewBackgroundColor:(UIColor *)backgroundColor
{
    self.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = kDarkGrayColor;
}

- (void)setCoverViewBackgroundColor:(UIColor *)backgroundColor
{
  self.coverView.backgroundColor =  backgroundColor != nil ?  backgroundColor : [UIColor clearColor];
}

- (void)setSubViews
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [self addSubview:self.coverView];
    [self.coverView addSubview:self.contentView];
    [self.contentView addSubview:self.tableView];
//    [self drawRectTableViewcornerRadius];
    _isHasTriangle ? [self drawRectCoverViewTriangleOffset:_triangleOffsetLeft] : nil;

    [self.tableView registerClass:[MLMenuCell class] forCellReuseIdentifier:IDETIFIRE];
    
}


//- (void)drawRectTableViewcornerRadius
//{
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height) cornerRadius:5];
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = path.CGPath;
//    self.tableView.layer.mask = layer;
//}


- (void)layoutSubviews
{
    [super layoutSubviews];

    self.tableView.frame = CGRectMake(0,0, _frame.size.width, _frame.size.height);
    self.contentView.frame = CGRectMake(_frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height);
    
}



- (void)showMenuEnterAnimation:(MLEnterAnimationStyle)animationStyle
{
    
   _animationStyle = animationStyle;
    [self setSubViews];

    [self delaDataWithmodelsArr:self.modelsArr];

        self.coverView.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.coverView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
}


- (void)hidMenuExitAnimation:(MLEnterAnimationStyle)animationStyle
{
    
        self.coverView.alpha = 1;
        [UIView animateWithDuration:0.2 animations:^{
            self.coverView.alpha = 0;
        } completion:^(BOOL finished) {
             [self removeFromSuperview];
        }];

}

- (void)singleTapCoverAction:(UITapGestureRecognizer *)gesture
{

    [self hidMenuExitAnimation:_animationStyle];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSString *class = NSStringFromClass(touch.view.class);
    if ([class isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}


#pragma mark UITableViewDataSource , UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MLMenuCell *cell =  [tableView dequeueReusableCellWithIdentifier:IDETIFIRE];
    
    if (!cell) {
        cell = [[MLMenuCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDETIFIRE];
    }
    cell.backgroundColor = [UIColor clearColor];
    HHActivityModel *item = [HHActivityModel mj_objectWithKeyValues: self.dataArray[indexPath.row]];
    cell.menuItem = item;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if ([_delegate respondsToSelector:@selector(didselectItemIndex:)]) {
        [_delegate didselectItemIndex:indexPath.row];
    }
    if (_didSelectBlock) {
        HHActivityModel *item = [HHActivityModel mj_objectWithKeyValues: self.dataArray[indexPath.row]];
        _didSelectBlock(indexPath.row,item);
    }
    
    [self hidMenuExitAnimation:_animationStyle];
}


#pragma mark Getter
- (UIView *)coverView
{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, _menuViewOffsetTop, SCREEN_WIDTH, SCREEN_HEIGHT - _menuViewOffsetTop)];
        _coverView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapCoverAction:)];
        tap.delegate = self;
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView =[[UIView alloc] initWithFrame:CGRectMake(_frame.origin.x, 0, _frame.size.width,_frame.size.height)];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0,0, _frame.size.width, _frame.size.height);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = kDarkGrayColor;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)drawRectCoverViewTriangleOffset:(CGFloat)offset
{

    if (offset < 6) offset = 6;
    if (offset > _frame.size.width - 6) offset = _frame.size.width - 6;

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(offset, 2)];
    [path addLineToPoint:CGPointMake(offset - 6, 10)];
    [path addLineToPoint:CGPointMake(offset + 6, 10)];
    CAShapeLayer *layer =[CAShapeLayer layer];
    layer.path = path.CGPath;
    [layer setFillColor:rgba(73, 72, 75, 1).CGColor];
    [self.contentView.layer addSublayer:layer];
}


@end
