//
//  Font.m
//  DigitClock
//
//  Created by wenyou on 2017/7/10.
//  Copyright © 2017年 wenyou. All rights reserved.
//

#import "Font.h"

#import <CoreText/CoreText.h>
#import <AppKit/AppKit.h>


@implementation Font
static Font *_instance;

- (instancetype)init {
    if (self = [super init]) {
        NSDictionary<NSString *, NSString *> *fontNames = @{@"DigitalDismay": @"otf", @"DS-Digital": @"ttf"};
        [fontNames.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self registFont:obj type:fontNames[obj]];
        }];
    }
    return self;
}

- (void)registFont:(NSString *)name type:(NSString *)type {
    NSString *path = [[NSBundle bundleForClass:Font.class] pathForResource:name ofType:type];
    NSData *dynamicFontData = [NSData dataWithContentsOfFile:path];
    if (!dynamicFontData) {
        return;
    }
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((__bridge CFDataRef)dynamicFontData);
    CGFontRef font = CGFontCreateWithDataProvider(providerRef);
    CFErrorRef error;
    if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
        //注册失败
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(providerRef);
}

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance ;
}

- (NSFont *)fontOfSize:(CGFloat)fontSize name:(NSString *)fontName {
    NSFont *font = [NSFont fontWithName:fontName size:fontSize];
    NSAssert(font != nil, @"%@ couldn't be loaded", fontName);
    return font;
}
@end
