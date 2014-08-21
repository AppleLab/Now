//
//  ModelController.h
//  SSNow
//
//  Created by itisioslab on 21.08.14.
//  Copyright (c) 2014 kpfu.itisioslab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end
