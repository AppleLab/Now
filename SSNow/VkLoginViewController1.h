//
//  VkLoginViewController1.h
//  SSNow
//
//  Created by itisioslab on 22.08.14.
//  Copyright (c) 2014 kpfu.itisioslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+StringBetween.h"

@interface VkLoginViewController1 : UIViewController{
UIWebView *authView;
UIActivityIndicatorView *indicator;
}
@property (nonatomic, retain) IBOutlet UIWebView *authView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@end