//
//  SettingWindow.m
//  EmptyOC
//
//  Created by wenyou on 2017/7/10.
//  Copyright © 2017年 wenyou. All rights reserved.
//

#import "SettingWindow.h"

#import <Masonry/Masonry.h>
#import "Font.h"
#import "DigitalClockView.h"


@implementation SettingWindow {
    NSTextField *_textField;
    NSTextField *_backTextField;
}

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    if (self = [super initWithContentRect:NSMakeRect(0, 0, 400, 240) styleMask:style backing:bufferingType defer:flag]) {
        self.contentView = [self getContentView];

        NSLog(@"initWithContentRect");
    }
    return self;
}

- (NSView *)getContentView {
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 400, 300)];

    NSButton *support24hButton = [NSButton checkboxWithTitle:@"support 24h" target:self action:@selector(support24hButtonClicked:)];
    [view addSubview:support24hButton];
    [support24hButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(30);
        make.left.equalTo(view).offset(30);
    }];

    NSButton *fontColorButton = [NSButton buttonWithTitle:@"font color" target:self action:@selector(fontColorButtonClicked:)];
    [view addSubview:fontColorButton];
    [fontColorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(support24hButton.mas_bottom).offset(30);
        make.left.equalTo(support24hButton);
    }];

    NSButton *fontShadowColorButton = [NSButton buttonWithTitle:@"font shadow color" target:self action:@selector(fontShadowColorButtonClicked:)];
    [view addSubview:fontShadowColorButton];
    [fontShadowColorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fontColorButton.mas_bottom).offset(30);
        make.left.equalTo(fontColorButton);
    }];

    NSView *fontView = [[NSView alloc] init];
    fontView.wantsLayer = YES;
    fontView.layer.backgroundColor = NSColor.blackColor.CGColor;
    [view addSubview:fontView];
    [fontView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fontColorButton);
        make.right.equalTo(view).offset(0 - 30);
    }];

    _backTextField = [NSTextField labelWithString:@"88:88"];
    _backTextField.font = [[Font shareInstance] fontOfSize:50 name:@"DigitalDismay"];
    _backTextField.textColor = [[NSColor blueColor] colorWithAlphaComponent:0.08];
    [fontView addSubview:_backTextField];
    [_backTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fontView).offset(10);
        make.right.equalTo(fontView).offset(0 - 20);
    }];

    _textField = [NSTextField labelWithString:@"10:10"];
    _textField.font = [[Font shareInstance] fontOfSize:50 name:@"DigitalDismay"];
    _textField.textColor = [NSColor blueColor];
    [fontView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fontView).offset(10);
        make.right.equalTo(fontView).offset(0 - 20);
    }];

    [fontView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_backTextField).offset(40);
        make.height.equalTo(_backTextField).offset(20);
    }];

    NSButton __block *lastButton;
    NSArray<NSString *> *colors = @[@"绿", @"蓝", @"白"];
    [colors enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSButton *button = [NSButton buttonWithTitle:[NSString stringWithFormat:@"预设%@", obj] target:self action:@selector(colorButtonClicked:)];
        button.tag = idx;
        [view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(fontShadowColorButton.mas_bottom).offset(30);
            if (lastButton) {
                make.left.equalTo(lastButton.mas_right).offset(15);
            } else {
                make.left.equalTo(view).offset(30);
            }
        }];
        lastButton = button;
    }];

    NSButton *backButton = [NSButton buttonWithTitle:@"submit" target:self action:@selector(backButtonclicked:)];
    [view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(0 - 30);
        make.top.equalTo(fontShadowColorButton.mas_bottom).offset(30);
    }];

    return view;
}

- (void)backButtonclicked:(NSButton *)sender {
    if (self.parentView) {
        [self.parentView settingEnd];
    }
}

- (void)support24hButtonClicked:(NSButton *)sender {
}

- (void)fontColorButtonClicked:(NSButton *)sender {
    NSColorPanel *panel = [NSColorPanel sharedColorPanel];
    [panel setTarget:self];
    [panel setAction:@selector(fontColorSelected:)];
    panel.showsAlpha = YES;
    [panel makeKeyAndOrderFront:[NSApp mainWindow]];
}

- (void)fontShadowColorButtonClicked:(NSButton *)sender {
    NSColorPanel *panel = [NSColorPanel sharedColorPanel];
    [panel setTarget:self];
    [panel setAction:@selector(fontShadowColorSelected:)];
    panel.showsAlpha = YES;
    [panel makeKeyAndOrderFront:[NSApp mainWindow]];
}


- (void)colorButtonClicked:(NSButton *)sender {
    switch (sender.tag) {
        case 0:
            _textField.textColor = NSColor.greenColor;
            _backTextField.textColor = [_textField.textColor colorWithAlphaComponent:0.08];
            break;
        case 1:
            _textField.textColor = NSColor.blueColor;
            _backTextField.textColor = [_textField.textColor colorWithAlphaComponent:0.08];
            break;
        case 2:
            _textField.textColor = NSColor.whiteColor;
            _backTextField.textColor = [_textField.textColor colorWithAlphaComponent:0.08];
            break;
        default:
            break;
    }
}

- (void)fontShadowColorSelected:(NSColorPanel *)sender {
    _backTextField.textColor = sender.color;
}

- (void)fontColorSelected:(NSColorPanel *)sender {
    _textField.textColor = sender.color;
}
@end
