//
//  DigitalClockView.m
//  DigitalClock
//
//  Created by wenyou on 2017/7/11.
//  Copyright © 2017年 wenyou. All rights reserved.
//

#import "DigitalClockView.h"

#import <AppKit/AppKit.h>
#import <Masonry/Masonry.h>
#import "Font.h"
#import "SettingWindow.h"


NSString *const kDefaultsSupport24h = @"support24h";
NSString *const kDefaultsFontColor = @"fontColor";
NSString *const kDefaultsBackFontColor = @"backFontColor";

@implementation DigitalClockView {
    NSTextField *_backDateTextField;
    NSTextField *_dateTextField;
    NSTextField *_backTimeTextField;
    NSTextField *_timeTextField;
    NSTextField *_amPmTextField;
    NSMutableArray<NSTextField *> *_weekTextFields;

    CGFloat _height;
    NSColor *_backFontColor;
    NSColor *_fontColor;
    BOOL _isSupport24h;
    SettingWindow *_settingWindow;
}

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];

        [[self getDefaults] registerDefaults:@{kDefaultsSupport24h: @NO,
                                               kDefaultsFontColor: [NSArchiver archivedDataWithRootObject:[NSColor greenColor]], // NSColor 不可序列化, 封装一下
                                               kDefaultsBackFontColor: [NSArchiver archivedDataWithRootObject:[[NSColor greenColor] colorWithAlphaComponent:0.08]]}];
        _height = frame.size.height / 2;
        if (frame.size.width < frame.size.height) {
            _height = frame.size.width / 3.5;
        }
        [self getDefaultsValue];

        [self initTimeTextField];
        [self initDateTextFiel];
        [self initAmPmTextField];
        [self initWeekTextFields];
        [self setColor];
        [self setDate:[[NSDate alloc] init]];
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

    [[NSColor blackColor] setFill];
    NSRectFill(self.bounds);
}

- (void)animateOneFrame {
    [self setDate:[[NSDate alloc] init]];
    return;
}

- (BOOL)hasConfigureSheet {
    return YES;
}

- (NSWindow*)configureSheet {
    if (!_settingWindow) {
        _settingWindow = [[SettingWindow alloc] init];
        _settingWindow.parentView = self;
        _settingWindow.releasedWhenClosed = false;
    }
    [_settingWindow setDefaults];
    return _settingWindow;
}

#pragma mark - private
- (void)setColor {
    _backTimeTextField.textColor = _backFontColor;
    _backDateTextField.textColor = _backFontColor;

    _timeTextField.textColor = _fontColor;
    _dateTextField.textColor = _fontColor;

    _amPmTextField.textColor = _backFontColor;
}

- (void)setDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy  MM  dd";
    _dateTextField.stringValue = [dateFormatter stringFromDate:date];

    _timeTextField.attributedStringValue = ({
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]; // 不设置 locale 的话, 12 hour 不生效
        dateFormatter.dateFormat = _isSupport24h ? @"HH:mm ss" : @"hh:mm ss";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[dateFormatter stringFromDate:date]];
        [attributedString addAttribute:NSFontAttributeName value:[[Font shareInstance] fontOfSize:_height name:@"DigitalDismay"] range:NSMakeRange(0, 5)];
        [attributedString addAttribute:NSFontAttributeName value:[[Font shareInstance] fontOfSize:_height / 2 name:@"DigitalDismay"] range:NSMakeRange(5, 3)];
        attributedString;
    });

    dateFormatter.dateFormat = @"e";
    int week = [dateFormatter stringFromDate:date].intValue;
    [_weekTextFields enumerateObjectsUsingBlock:^(NSTextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == week - 1) {
            obj.textColor = _fontColor;
        } else {
            obj.textColor = _backFontColor;
        }
    }];

    if (_isSupport24h) { // 清除
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_amPmTextField.attributedStringValue.string];
        _amPmTextField.attributedStringValue = attributedString;
    } else {
        dateFormatter.dateFormat = @"H";
        BOOL isAm = ([dateFormatter stringFromDate:date].intValue < 12);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_amPmTextField.attributedStringValue.string];
        [attributedString addAttribute:NSForegroundColorAttributeName value:_fontColor range:NSMakeRange(isAm ? 0 : 3, 2)];
        _amPmTextField.attributedStringValue = attributedString;
    }
}

- (void)initTimeTextField {
    _backTimeTextField = ({
        NSTextField *textField = [NSTextField labelWithString:@""];
        textField.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"88:88 88"];
        [attributedString addAttribute:NSFontAttributeName value:[[Font shareInstance] fontOfSize:_height name:@"DigitalDismay"] range:NSMakeRange(0, 5)];
        [attributedString addAttribute:NSFontAttributeName value:[[Font shareInstance] fontOfSize:_height / 2 name:@"DigitalDismay"] range:NSMakeRange(5, 3)];
        textField.attributedStringValue = attributedString;
        textField;
    });
    [self addSubview:_backTimeTextField];
    [_backTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];

    _timeTextField = [NSTextField labelWithString:@""];
    _timeTextField.alignment = NSTextAlignmentCenter;
    [self addSubview:_timeTextField];
    [_timeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)initDateTextFiel {
    _backDateTextField = ({
        NSTextField *textField = [NSTextField labelWithString:@"8888  88  88"];
        textField.font = [[Font shareInstance] fontOfSize:_height / 3 name:@"DigitalDismay"];
        textField.alignment = NSTextAlignmentCenter;
        textField;
    });
    [self addSubview:_backDateTextField];
    [_backDateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_backTimeTextField.mas_top);
        make.left.equalTo(_backTimeTextField);
    }];

    _dateTextField = ({
        NSTextField *textField = [NSTextField labelWithString:@""];
        textField.font = [[Font shareInstance] fontOfSize:_height / 3 name:@"DigitalDismay"];
        textField.alignment = NSTextAlignmentCenter;
        textField;
    });
    [self addSubview:_dateTextField];
    [_dateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backDateTextField);
    }];
}

- (void)initAmPmTextField {
    _amPmTextField = ({
        NSTextField *textField = [NSTextField labelWithString:@""];
        textField.font = [[Font shareInstance] fontOfSize:_height / 6 name:@"DS-Digital"];
        textField.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"AM PM"];
        textField.attributedStringValue = attributedString;
        textField;
    });
    [self addSubview:_amPmTextField];
    [_amPmTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backTimeTextField);
        make.baseline.equalTo(_backDateTextField);
    }];
}

- (void)initWeekTextFields {
    NSView *weekView = [[NSView alloc] init];
    [self addSubview:weekView];
    [weekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backTimeTextField);
        make.right.equalTo(_backTimeTextField);
        make.top.equalTo(_backTimeTextField.mas_bottom);
    }];

    NSArray<NSString *> *array = @[@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
    _weekTextFields = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_weekTextFields addObject:({
            NSTextField *textField = [NSTextField labelWithString:obj];
            textField.font = [[Font shareInstance] fontOfSize:_height / 6 name:@"DS-Digital"];
            textField.alignment = NSTextAlignmentCenter;
            [weekView addSubview:textField];
            textField;
        })];
    }];
    [_weekTextFields mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weekView);
    }];
    [_weekTextFields mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [weekView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_weekTextFields[0]);
    }];
}

- (void)settingEnd {
    [self getDefaultsValue];
    [self setColor];
    [self setDate:[[NSDate alloc] init]];
    [[NSApplication sharedApplication] endSheet:_settingWindow];
}

- (ScreenSaverDefaults *)getDefaults {
    NSString *identifier = [NSBundle bundleForClass:DigitalClockView.class].bundleIdentifier;
    ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:identifier];
    return defaults;
}

- (void)getDefaultsValue {
    ScreenSaverDefaults *defaults = [self getDefaults];
    _isSupport24h = [defaults boolForKey:kDefaultsSupport24h];
    _fontColor = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:kDefaultsFontColor]];
    _backFontColor = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:kDefaultsBackFontColor]];
}
@end
