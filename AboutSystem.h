//
//  AboutSystem.h
//  HealthScale
//
//  Created by Justin Yang on 15-3-7.
//  Copyright (c) 2015年 Justin Yang. All rights reserved.
//

#ifndef CSleep_AboutSystem_h
#define CSleep_AboutSystem_h

/* define system version */
#define IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

/* define screen frame */
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define TrailOfView(view) (view.frame.origin.x+view.frame.size.width)
#define BottomOfView(view) (view.frame.origin.y+view.frame.size.height)
#define kScaleWidth (ScreenWidth/375)
#define kScaleHeight ((self.navigationController==nil)?(ScreenHeight/667):(self.navigationController.navigationBarHidden==NO?((ScreenHeight-64)/603):(ScreenHeight/667)))
#define kWidthAfterScale(x)  ((x)*kScaleWidth)
#define kHeightAfterScale(y) ((y)*kScaleHeight)

#define isiPhone6 (([[UIScreen mainScreen] bounds].size.width>320)&&([[UIScreen mainScreen] bounds].size.width<=375))
#define isiPhone6Plus (([[UIScreen mainScreen] bounds].size.width>375)&&([[UIScreen mainScreen] bounds].size.width<=414))

#define isiPhone5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define isiPhone4 ([[UIScreen mainScreen] bounds].size.height <568)

#define  iPhone5Weight 320.0
#define  iPhone5Height 568.0

#define  BasicHeight  (1/iPhone5Height*(isiPhone4?iPhone5Height:ScreenHeight))
#define  BasicWeight  (1/iPhone5Weight*ScreenWidth)

#define IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#define IOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")


#define CURRENT_LANGUAGE_IS_CHINESE ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"zh-Hans"]||[[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"zh-Hant"])
#define kScaleCenterX(dis,view) (kWidthAfterScale(dis)+view.bounds.size.width/2.0)
#define kScaleCenterY(dis,view) (kHeightAfterScale(dis)+view.bounds.size.height/2.0)


#define kPinkColor   [BNRTools HealthPinkColor]

#define Pt(px)  (((px)/96.)*72)


#endif
