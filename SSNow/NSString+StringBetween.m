//
//  NSString+StringBetween.m
//  SSNow
//
//  Created by itisioslab on 22.08.14.
//  Copyright (c) 2014 kpfu.itisioslab. All rights reserved.
//

#import "NSString+StringBetween.h"

@implementation NSString (StringBetween)
- (NSString *)getStringBetweenString:(NSString *)first andString:(NSString *)second {
    NSRange rangeofFirst = [(NSString *)self rangeOfString:first];
    NSRange rangeOfSecond = [(NSString *)self rangeOfString:second];
    if ((rangeofFirst.length == 0) || (rangeOfSecond.length == 0)) {
        return nil;
    }
    NSString *result = [[(NSString *)self substringFromIndex:rangeofFirst.location+rangeofFirst.length]
                        substringToIndex:
                        [[(NSString *)self substringFromIndex:rangeofFirst.location+rangeofFirst.length] rangeOfString:second].location];
    return result;
}
@end
