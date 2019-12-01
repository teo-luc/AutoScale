//
//  SwizzleConfiguration.swift
//  AutoScaler
//
//  Created by Tèo Lực on 12/1/19.
//  Copyright © 2019 Luc Nguyen. All rights reserved.
//

import Foundation
import UIKit

class SwizzleConfiguration {
    static func swizzling(_ forClass: AnyClass, _ originalSelector: Selector, _ swizzledSelector: Selector) {
        guard
            let originalMethod = class_getInstanceMethod(forClass, originalSelector),
            let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
            else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
