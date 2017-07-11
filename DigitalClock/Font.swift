//
//  Font.swift
//  DigitalClock
//
//  Created by wenyou on 2017/7/11.
//  Copyright © 2017年 wenyou. All rights reserved.
//

import AppKit

class Font {
    static let sharedInstance = Font()

    private init() {
        ["DigitalDismay": "otf", "DS-Digital": "ttf"].forEach { (key: String, value: String) in
            registFont(name: key, type: value)
        }
    }

    private func registFont(name: String, type: String) {
        if let path = Bundle.main.path(forResource: name, ofType: type), let dynamicFontData = NSData(contentsOfFile: path), let dataProvider = CGDataProvider(data: dynamicFontData) {
            let font = CGFont.init(dataProvider)
            var error: Unmanaged<CFError>? = nil
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
                NSLog("Failed to load font: %@", errorDescription as String)
            }
            error?.release()
        }
    }

    func fontOfSize(fontSize: CGFloat, fontName: String) -> NSFont {
        if let font = NSFont.init(name: fontName, size: fontSize) {
            return font
        }
        return NSFont.systemFont(ofSize: fontSize)
    }
}
