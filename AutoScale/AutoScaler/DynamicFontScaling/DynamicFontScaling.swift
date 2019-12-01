//
//  DynamicFontScaling.swift
//  AutoScaler
//
//  Created by Tèo Lực on 12/1/19.
//  Copyright © 2019 Luc Nguyen. All rights reserved.
//

import Foundation
import UIKit

// MARK: -

enum Platform: Int {
    case unknownPlatform     = -1
    case iPhone4Platform     = 1000
    case iPhone4sPlatform    = 1001
    case iPhone5Platform     = 1002
    case iPhone5sPlatform    = 1003
    case iPhone6Platform     = 1004
    case iPhone6PlusPlatform = 1005
    case iPhone7Platform     = 1006
    case iPhone7sPlatform    = 1007
    case iPadMiniPlatform    = 1008
    case iPadAirPlatform     = 1009
    case iPadProPlatform     = 1010
}

// MARK: -

protocol DynamicFontScalingLogic {
    var platform: Platform { set get }
    var ratio: CGFloat { set get }
    var pauseUpdateFontScaling: Bool  { set get }
    var customFontSizeBundleFileName: String? { set get }
    
    func fontScaleByGreaterThanOrEqual(platform: Platform, with ratio: CGFloat) -> Self

    // Automatic ratio on iPhone
    func iPhoneFontScaleByGreaterThanOrEqual(platform: Platform) -> Self

    // Automatic ratio on iPad
    func iPadFontScaleByGreaterThanOrEqual(platform: Platform) -> Self

    // **** TRANSACTION ***
    // BEGIN Pausing update font scaling in another special case
    // If you set this function, you MUST call resumeUpdateFontScaling in your flow to reset
    func beginPausingUpdateFontScaling()

    // RESUME Pausing update font scaling in another special case
    func resumeUpdateFontScaling()
}


// MARK: -

final class DynamicFontScaling: DynamicFontScalingLogic {
    var platform: Platform = .unknownPlatform
    
    var ratio: CGFloat = 0.0
    
    var pauseUpdateFontScaling: Bool = false
    
    var customFontSizeBundleFileName: String?
    
    func fontScaleByGreaterThanOrEqual(platform: Platform, with ratio: CGFloat) -> Self {
        let screenResolution = Screen.resolution(from: platform)
        // Update Ratio
        self.ratio = ratio
        // Update platform
        if screenResolution != CGSize.zero && ((Screen.deviceSH * Screen.scale) >= screenResolution.height) {
            self.platform = platform
            swizzling()
        } else {
            self.platform = .unknownPlatform
        }
        return self
    }
    
    func iPhoneFontScaleByGreaterThanOrEqual(platform: Platform) -> Self {
        let ratio = (Screen.deviceSW / Screen.BASE_IPHONE_SW) - 1.0
        return fontScaleByGreaterThanOrEqual(platform: platform, with: ratio)
    }
    
    func iPadFontScaleByGreaterThanOrEqual(platform: Platform) -> Self {
        let ratio = (Screen.deviceSW / Screen.BASE_IPAD_SW) - 1.0
        return fontScaleByGreaterThanOrEqual(platform: platform, with: ratio)
    }
    
    func beginPausingUpdateFontScaling() {
        // Todo
    }
    
    func resumeUpdateFontScaling() {
        // Todo
    }
    
    // MARK: -
    private func swizzling() {
        
    }
}
