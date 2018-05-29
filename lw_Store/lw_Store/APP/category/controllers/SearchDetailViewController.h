//
//  SearchDetailViewController.h
//  SearchControllerDemo
//
//  Created by admin on 16/8/30.
//  Copyright © 2016年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchDetailView;

@protocol SearchDetailViewControllerDelegate <NSObject>

- (void)tagViewButtonDidSelectedForTagTitle:(NSString *)title;

- (void)dismissButtonWasPressedForSearchDetailView:(SearchDetailView *)searchView;

@end

@interface SearchDetailViewController : UIViewController

@property (copy, nonatomic) NSString *placeHolderText;

@property (copy, nonatomic) NSString *textFieldText;

@property (weak, nonatomic) id<SearchDetailViewControllerDelegate> delegate;

@property(nonatomic,assign)   HHenter_Type enter_Type;

@end
