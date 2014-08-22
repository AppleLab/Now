//
//  VkloginViewController.h
//  SSNow
//
//  Created by itisioslab on 22.08.14.
//  Copyright (c) 2014 kpfu.itisioslab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VkloginViewController : UIViewController

id delegate;
UIWebView *vkWebView;
NSString *appID;

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) UIWebView *vkWebView;
@property (nonatomic, retain) NSString *appID;

- (NSString*)stringBetweenString:(NSString*)start
                       andString:(NSString*)end
                     innerString:(NSString*)str;
@end
