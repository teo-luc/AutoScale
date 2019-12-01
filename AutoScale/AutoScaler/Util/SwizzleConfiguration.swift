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
    static let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
        guard
            let originalMethod = class_getInstanceMethod(forClass, originalSelector),
            let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
            else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
