
//
//  TSHomePageHeaderView.m
//  Transport
//
//  Created by zhipeng-mac on 15/11/28.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import "HJHomePageHeaderView.h"

@interface HJHomePageHeaderView ()


@end

@implementation HJHomePageHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
  
    if (self == [super initWithFrame:frame]) {
        
        _cycleSrollView = [self setCycleSrollViewWithFrame:frame];
        
        [self addSubview:_cycleSrollView];
        
    }
    return self;
}


- (SDCycleScrollView *)setCycleSrollViewWithFrame:(CGRect)frame{
//      NSArray *imagesURLStrings = @[
//                                                                    @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t1402/221/421883372/88115/8cc2231a/55815835N35a44559.jpg",
//                                                                    @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t976/208/1221678737/91179/5d7143d5/5588e849Na2c20c1a.jpg",
//                                                                    @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t805/241/1199341035/289354/8648fe55/5581211eN7a2ebb8a.jpg",
//                                                                    @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t1606/199/444346922/48930/355f9ef/55841cd0N92d9fa7c.jpg",
//                                                                    @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t1609/58/409100493/49144/7055bec5/557e76bfNc065aeaf.jpg",
//                                                                    @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t895/234/1192509025/111466/512174ab/557fed56N3e023b70.jpg",
//                                                                    @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t835/313/1196724882/359493/b53c7b70/5581392cNa08ff0a9.jpg",
//                                                                    @"http://img30.360buyimg.com/mobilecms/s480x180_jfs/t898/15/1262262696/95281/57d1f12f/558baeb4Nbfd44d3a.jpg"
//                                                                    ];
   NSArray *imageNamesGroup = @[@"01",@"02",@"03",@"04",@"05"];
//  //
    SDCycleScrollView  *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageNamesGroup:imageNamesGroup];
    scrollView.infiniteLoop = YES;
    scrollView.placeholderImage=[UIImage imageNamed:@"homepagebannerplaceholder"];
    scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    scrollView.autoScrollTimeInterval = 2.0; // 轮播时间间隔，默认1.0秒，可自定义
//    
////    模拟加载延迟
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        _cycleSrollView.imageURLStringsGroup = imagesURLStrings;
//    });
    return scrollView;
}

@end
