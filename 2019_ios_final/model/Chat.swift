//
//  Chat.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/31.
//  Copyright © 2019 river. All rights reserved.
//

import Foundation
import UIKit

struct Chat: Codable {
    var name: String
    var message: String
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    
    static func saveTofile(chatHistory: [Chat]) {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(chatHistory) {
            let url = Chat.documentDirectory.appendingPathComponent("chatHistory").appendingPathExtension("plist")
            try? data.write(to: url)
        }
    }
    
    static func readFromFile() -> [Chat]? {
        let decoder = PropertyListDecoder()
        let url = Chat.documentDirectory.appendingPathComponent("chatHistory").appendingPathExtension("plist")
        if let data = try? Data(contentsOf: url), let chatHistory = try? decoder.decode([Chat].self, from: data) {
            return chatHistory
        } else {
            return nil
        }
    }
}
