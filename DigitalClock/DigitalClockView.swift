//
//  DigitalClockView.swift
//  DigitalClock
//
//  Created by wenyou on 2017/7/11.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import ScreenSaver

// https://segmentfault.com/a/1190000007076865
// http://blog.lanvige.com/2015/01/04/library-vs-framework-in-ios/?utm_source=tuicool&utm_medium=referral
class DigitalClockView: ScreenSaverView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.red.setFill()
        NSRectFill(bounds)
    }
}
