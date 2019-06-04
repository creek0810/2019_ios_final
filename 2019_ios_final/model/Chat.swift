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
    var message: Message
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    
    static func saveTofile(chatHistory: [Chat]) {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(chatHistory) {
            let url = Chat.documentDirectory.appendingPathComponent("\(User.shared.name)-chatHistory").appendingPathExtension("plist")
            try? data.write(to: url)
        }
    }
    
    static func readFromFile() -> [Chat]? {
        let decoder = PropertyListDecoder()
        let url = Chat.documentDirectory.appendingPathComponent("\(User.shared.name)-chatHistory").appendingPathExtension("plist")
        if let data = try? Data(contentsOf: url), let chatHistory = try? decoder.decode([Chat].self, from: data) {
            return chatHistory
        } else {
            return nil
        }
    }
}
extension Chat: Comparable {
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        if let lhs_date = dateFormatter.date(from: lhs.message.timeStamp), let rhs_date = dateFormatter.date(from: rhs.message.timeStamp) {
            return lhs_date == rhs_date
        }
        return false
    }
    
    static func < (lhs: Chat, rhs: Chat) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        if let lhs_date = dateFormatter.date(from: lhs.message.timeStamp), let rhs_date = dateFormatter.date(from: rhs.message.timeStamp) {
            return lhs_date > rhs_date
        }
        return false
    }
}
