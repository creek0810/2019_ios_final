//
//  Friend.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/31.
//  Copyright © 2019 river. All rights reserved.
//

import Foundation
import UIKit

struct Friend: Codable {
    var propic: String
    var name: String
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func saveTofile(friends: [Friend]) {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(friends) {
            let url = Friend.documentsDirectory.appendingPathComponent("friends").appendingPathExtension("plist")
            try? data.write(to: url)
        }
    }
    
    static func readFromFile() -> [Friend]? {
        let decoder = PropertyListDecoder()
        let url = Friend.documentsDirectory.appendingPathComponent("friends").appendingPathExtension("plist")
        if let data = try? Data(contentsOf: url), let friends = try? decoder.decode([Friend].self, from: data) {
            return friends
        } else {
            return nil
        }
    }
    
}
