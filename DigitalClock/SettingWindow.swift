//
//  SettingWindow.swift
//  DigitalClock
//
//  Created by wenyou on 2017/7/11.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import AppKit
import SnapKit


class SettingWindow: NSWindow {
    private let textField = NSTextField(labelWithString: "10:10")
    private let backTextField = NSTextField(labelWithString: "88:88")

    override init(contentRect: NSRect, styleMask style: NSWindowStyleMask, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: bufferingType, defer: flag)

        contentView = getContentView()
    }

    private func getContentView() -> NSView {
        let view = NSView.init(frame: NSMakeRect(0, 0, 400, 300))

//        let support24hButton = NSButton.

        let fontColorButton = NSButton.init()
        view.addSubview(fontColorButton)

        return view
    }
}
