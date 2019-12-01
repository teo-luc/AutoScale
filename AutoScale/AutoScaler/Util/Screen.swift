//
//  Screen.swift
//  AutoScaler
//
//  Created by Tèo Lực on 12/1/19.
//  Copyright © 2019 Luc Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct Screen {
    private static let SW = "sw"
    private static let SH = "sh"
    private static let orientation = UIApplication.shared.statusBarOrientation
    
    static let screen = UIScreen.main
    static let scale = screen.scale;
    static let BASE_IPHONE_SW: CGFloat = 320.0
    static let BASE_IPAD_SW: CGFloat = 768.0

    private static func getWidth() -> CGFloat {
        if (orientation == .portrait || orientation == .portraitUpsideDown) {
            return screen.bounds.size.width
        } else {
            return screen.bounds.size.height
        }
    }
    
    private static func getHeight() -> CGFloat {
        if (orientation == .portrait || orientation == .portraitUpsideDown) {
            return screen.bounds.size.height
        } else {
            return screen.bounds.size.width
        }
    }

    static var deviceSW: CGFloat = {
        let width = getWidth()
        return width
    }()

    static var deviceSH: CGFloat = {
        let height = getHeight()
        return height
    }()
}

extension Screen {
    static func resolution(from platform: Platform) -> CGSize {
        guard let dict = Plist.readPropertyList(from: "Platforms"),
            let deviceInfos = dict["\(platform)"] as? NSDictionary,
            let sw = deviceInfos[Screen.SW] as? NSNumber,
            let sh = deviceInfos[Screen.SH] as? NSNumber
            else { return CGSize.zero }
        //
        let screenSize = CGSize(width: CGFloat(sw.floatValue), height: CGFloat(sh.floatValue))
        //
        return screenSize
    }
}
