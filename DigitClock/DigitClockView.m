//
//  DigitClockView.m
//  DigitClock
//
//  Created by wenyou on 2017/7/10.
//  Copyright © 2017年 wenyou. All rights reserved.
//

#import "DigitClockView.h"

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

@implementation DigitClockView {
    NSTextField *_textField;
}

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];

        self.wantsLayer = YES;
        self.layer.backgroundColor = NSColor.blackColor.CGColor;

        NSTextField *backTextField = [[NSTextField alloc] initWithFrame:self.bounds];
        [self addSubview:backTextField];
        backTextField.stringValue = @"8888888888";
        backTextField.font = [NSFont systemFontOfSize:100];
        backTextField.backgroundColor = NSColor.clearColor;
        backTextField.textColor = NSColor.yellowColor;
        

        _textField = [[NSTextField alloc] initWithFrame:self.bounds];
        [self addSubview:_textField];
        _textField.stringValue = @"1234567890";
        _textField.font = [NSFont systemFontOfSize:100];
        _textField.backgroundColor = NSColor.clearColor;
        _textField.textColor = NSColor.redColor;

    }
    return self;
}

- (void)startAnimation {
    [super startAnimation];
}

- (void)stopAnimation {
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect {
    [super drawRect:rect];
}

- (void)animateOneFrame {
    return;
}

- (BOOL)hasConfigureSheet {
    return NO;
}

- (NSWindow*)configureSheet {
    return nil;
}
@end
