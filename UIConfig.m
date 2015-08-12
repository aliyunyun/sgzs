//
//  UIConfig.m
//  sgzs
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "UIConfig.h"

@implementation UIConfig



+(CGSize)sizeWithString:(NSString *)string Font:(UIFont*)font maxSize:(CGSize)maxsize{

    if (IOS8) {
        CGRect rect = [string boundingRectWithSize:maxsize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        return CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
    }
    else{
        return [string sizeWithFont:font constrainedToSize:maxsize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    
   
    
}

@end
