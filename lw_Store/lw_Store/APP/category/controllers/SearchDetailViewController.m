//
//  SearchDetailViewController.m
//  SearchControllerDemo
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "SearchDetailView.h"
#import "SearchTagTableViewCell.h"
#import "SearchTagHeadView.h"
#import "HHTagModel.h"

@interface UIImage (SKTagView)

+ (UIImage *)imageWithColor: (UIColor *)color;

@end

@implementation UIImage (SKTagView)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

@interface SearchDetailViewController ()
<SearchDetailViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
SKTagViewDelegate,SearchTagHeadViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchTagTableView;
@property (strong, nonatomic) SearchDetailView *searchDetailView;
@property (copy, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSMutableArray *historyTags;
@property (copy, nonatomic) NSArray *colors;

@end

@implementation SearchDetailViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchView];
    [self registerCells];
    
    //获取数据
    [self getDatas];
}
//获取数据
- (void)getDatas{
    
    //热门搜索
    [[[HHCartAPI GetHotSearchWithtop:@10] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                NSArray *history_arr = api.Data[@"userSearch"];
                NSArray *tags_arr = api.Data[@"hotSearch"];
                self.historyTags = history_arr.mutableCopy;
                self.tags = tags_arr.mutableCopy;
                [self.searchTagTableView reloadData];
            }
        }
    }];

}
#pragma mark - Private

- (void)configureCell:(SearchTagTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
    cell.tagView.padding = UIEdgeInsetsMake(0, 10, 0, 10);
    cell.tagView.interitemSpacing = 10;
    cell.tagView.lineSpacing = 10;
    [cell.tagView removeAllTags];
    if (indexPath.section == 0) {
        cell.tagView.hidden = self.historyTags.count == 0 ;
        cell.contentEmptyLabel.hidden = !cell.tagView.hidden;
        
        [self.historyTags enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            HHTagModel *model = [HHTagModel mj_objectWithKeyValues:obj];
            SKTag *tag = [SKTag tagWithText: model.Name];
            tag.textColor =  [UIColor blackColor];
            tag.fontSize = 14;
            tag.padding = UIEdgeInsetsMake(8, 8, 8, 8);
//            tag.cornerRadius = 10;
//            tag.borderColor = [UIColor lightGrayColor];
//            tag.borderWidth = .5f;
            tag.bgImg = [UIImage imageWithColor: [UIColor colorWithRed:222 / 255.0f green:222 / 255.0f blue:222/255.0f alpha:1.0f]];
            tag.enable = YES;
            [cell.tagView addTag:tag];
        }];
    } else {
        [self.tags enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            HHTagModel *model = [HHTagModel mj_objectWithKeyValues:obj];
            SKTag *tag = [SKTag tagWithText:model.Name];
//            tag.textColor = self.colors[idx % self.colors.count];
            tag.textColor = [UIColor blackColor];
            tag.fontSize = 14;
            tag.padding = UIEdgeInsetsMake(8, 8, 8, 8);
//            tag.cornerRadius = 10;
//            tag.borderColor = [UIColor lightGrayColor];
//            tag.borderWidth = .5f;
            tag.bgImg = [UIImage imageWithColor:[UIColor colorWithRed:222 / 255.0f green:222 / 255.0f blue:222/255.0f alpha:1.0f]];
            tag.enable = YES;
            [cell.tagView addTag:tag];
        }];
    }
}

- (void)setupSearchView {
    self.navigationController.navigationBar.translucent = NO;
    self.searchDetailView = [[SearchDetailView alloc] initWithFrame:CGRectMake(0, 3, [UIScreen mainScreen].bounds.size.width, 30)];
    self.searchDetailView.textField.placeholder = self.placeHolderText;
    self.searchDetailView.textField.text  =  self.textFieldText;
    self.searchDetailView.delegate = self;
    [self.searchDetailView.textField becomeFirstResponder];
    [self.navigationController.navigationBar addSubview:self.searchDetailView];
    
    self.searchTagTableView.tableFooterView = [[UIView alloc] init];
    self.searchTagTableView.backgroundColor = [UIColor whiteColor];
}

- (void)registerCells {
    UINib *searchTagNib =
    [UINib nibWithNibName:NSStringFromClass([SearchTagTableViewCell class])
                                         bundle:nil];
    [self.searchTagTableView registerNib:searchTagNib
                  forCellReuseIdentifier:NSStringFromClass([SearchTagTableViewCell class])];
}

#pragma mark - SKTagViewDelegate

- (void)tagButtonDidSelectedForTagTitle:(NSString *)title {
    NSLog(@"热门搜索，历史搜索 title:::::::%@", title);
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagViewButtonDidSelectedForTagTitle:)]) {
       
        [self.searchDetailView.textField resignFirstResponder];
        [self dismissViewControllerAnimated:NO
                                 completion:^{
        [self.delegate tagViewButtonDidSelectedForTagTitle:title];
                                     
                                 }];

    }
    
}

#pragma mark - Getters & Setters

- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (NSMutableArray *)historyTags {
    if (!_historyTags) {
        _historyTags = [NSMutableArray array];
    }
    return _historyTags;
}


- (NSArray *)colors {
    if (!_colors) {
        _colors = @[
                    [UIColor colorWithRed:245 / 255.0f green:86 / 255.0f blue:160 / 255.0f alpha:1.0f],
                    [UIColor colorWithRed:81 / 255.0f green:81 / 255.0f blue:81/255.0f alpha:1.0f]
                    ];
    }
    return _colors;
}

#pragma mark - SearchTagHeadViewDelegate

- (void)clearButtonWasPressedForSearchTagHeadView:(id)tagHeadView{
    
    [self.historyTags removeAllObjects];
    [self.searchTagTableView reloadData];
}

#pragma mark - SearchDetailViewDelegate

- (void)dismissButtonWasPressedForSearchDetailView:(SearchDetailView *)searchView {
    
    if (self.enter_Type == HHenter_category_Type||self.enter_Type == HHenter_home_Type) {
        [self dismissViewControllerAnimated:NO
                                 completion:^{
                                     //取消按钮代理
                                     if (self.delegate&&[self.delegate respondsToSelector:@selector(dismissButtonWasPressedForSearchDetailView:)]) {
                                         
                                        [self.delegate dismissButtonWasPressedForSearchDetailView:searchView];
                                         
                                     }
                                 }];
        
    }else{
        
        [self dismissViewControllerAnimated:NO
                                 completion:nil];
    }
    
}
//点击键盘上的搜索按钮
- (void)searchButtonWasPressedForSearchDetailView:(SearchDetailView *)searchView {
    NSLog(@"键盘搜索按钮:::::::::%@",searchView.textField.text);
    if (self.delegate&&[self.delegate respondsToSelector:@selector(tagViewButtonDidSelectedForTagTitle:)]) {

        [searchView.textField resignFirstResponder];
        [self dismissViewControllerAnimated:NO
                                 completion:^{
                                     
        [self.delegate tagViewButtonDidSelectedForTagTitle:searchView.textField.text];

                                 }];
    }
}

- (void)textFieldEditingChangedForSearchDetailView:(SearchDetailView *)searchView {
    NSLog(@"搜索内容：：：：：：：%@",searchView.textField.text);
    self.searchTagTableView.hidden  = YES;
}


#pragma mark - UITableViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.searchDetailView) {
        [self.searchDetailView.textField resignFirstResponder];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTagTableView) {
        SearchTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchTagTableViewCell class])];
        [self configureCell:cell atIndexPath: indexPath];
        return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    }
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchTagTableView) {
        SearchTagHeadView *headView = [[SearchTagHeadView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 45.0f)];
        headView.backgroundColor = [UIColor whiteColor];
        headView.delegate = self;
        NSString *leftImageName = section == 0 ? @"" : @"";
        NSString *titleName = section == 0 ? @"最近搜索" : @"热门搜索";
        BOOL isHidden = section == 0 ? NO : YES;
        headView.leftImageView.image = [UIImage imageNamed:leftImageName];
        headView.titleLabel.text = titleName;
        headView.clearButton.hidden = isHidden;
        return headView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchTagTableView) {
        return 45.0f;
    }
    return CGFLOAT_MIN;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchTagTableView) {
        return 1;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchTagTableView) {
        return 2;
    }
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SearchTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchTagTableViewCell class])];
        if ([cell respondsToSelector:@selector(layoutMargins)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.contentEmptyLabel.hidden = indexPath.section != 0;
        [self configureCell:cell atIndexPath:indexPath];
        cell.tagView.delegate = self;
        return cell;


}


@end
