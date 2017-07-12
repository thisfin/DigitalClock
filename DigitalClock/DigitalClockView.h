//
//  DigitalClockView.h
//  DigitalClock
//
//  Created by wenyou on 2017/7/11.
//  Copyright © 2017年 wenyou. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>


extern NSString *const kDefaultsSupport24h;
extern NSString *const kDefaultsFontColor;
extern NSString *const kDefaultsBackFontColor;

@interface DigitalClockView : ScreenSaverView
- (void)settingEnd;
- (ScreenSaverDefaults *)getDefaults;
@end
