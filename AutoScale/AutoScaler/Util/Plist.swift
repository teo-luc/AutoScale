//
//  Plist.swift
//  AutoScaler
//
//  Created by Tèo Lực on 12/1/19.
//  Copyright © 2019 Luc Nguyen. All rights reserved.
//

import Foundation

struct Plist {
    static func readPropertyList(from file: String) -> NSDictionary? {
        guard let filePath = Bundle.main.path(forResource: file, ofType: "plist") else { return nil }
        let dict = NSDictionary(contentsOfFile: filePath)
        return dict
    }
}
