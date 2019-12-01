//
//  UIView+Swizzling.swift
//  AutoScaler
//
//  Created by Tèo Lực on 12/1/19.
//  Copyright © 2019 Luc Nguyen. All rights reserved.
//

import Foundation
import UIKit

// MARK: -

fileprivate struct Holder {
    private static var cache = Dictionary<Int, Bool>()
    static func capture(_ view: UIView) {
        let hash = view.hashValue
        cache[hash] = true
    }
    static func isCaptured(_ view: UIView) -> Bool {
        let hash = view.hashValue
        return (cache[hash] != nil)
    }
    static func revoke(_ view: UIView) {
        let hash = view.hashValue
        cache[hash] = nil
    }
}

// MARK: -

protocol FontScaleLogic {
    func updateFontSize()
    func shouldSwizzling() -> Bool
    func isUpdatedFontScaling() -> Bool
    func capture()
    func revoke()
}

extension FontScaleLogic {
    func updateFontSize() { }
    func shouldSwizzling() -> Bool { return false }
}

// MARK: -

extension UIView : FontScaleLogic {
    func isUpdatedFontScaling() -> Bool { return Holder.isCaptured(self) }
    func capture() { Holder.capture(self) }
    func revoke() { Holder.revoke(self) }
}

// MARK: -

final class Deallocator {
    var closure: () -> Void
    init(_ closure: @escaping () -> Void) { self.closure = closure }
    deinit { closure() }
}

extension UIView {
    struct PropertyKeys { static var DeallocatorKey = "Deallocator Key" }
    private static let classInit: Void = {
        let originalMethod = #selector(didMoveToSuperview)
        let swizzledMethod = #selector(swizzled_didMoveToSuperview)
        SwizzleConfiguration.swizzling(UIView.self, originalMethod, swizzledMethod)
    }()
    
    @objc private func swizzled_didMoveToSuperview() {
        // Dealloc
        if objc_getAssociatedObject(self, &PropertyKeys.DeallocatorKey) == nil {
            let deallocator = Deallocator { self.revoke() }
            objc_setAssociatedObject(self, &PropertyKeys.DeallocatorKey, deallocator, .OBJC_ASSOCIATION_RETAIN)
        }
        // didMoveToSuperview
        if !isUpdatedFontScaling() && DynamicFontScaling.shared.ratio != 0 {
            updateFontSize()
            capture()
        }
        swizzled_didMoveToSuperview()
    }
    
    static func beginSwizzling() {
        let _ = UIView.classInit
    }
}
