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
    var id: String
    var message: Message
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    
    static func saveTofile(chatHistory: [Chat]) {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(chatHistory) {
            let url = Chat.documentDirectory.appendingPathComponent("\(User.shared.id)-chatHistory").appendingPathExtension("plist")
            try? data.write(to: url)
        }
    }
    
    static func readFromFile() -> [Chat]? {
        let decoder = PropertyListDecoder()
        let url = Chat.documentDirectory.appendingPathComponent("\(User.shared.id)-chatHistory").appendingPathExtension("plist")
        if let data = try? Data(contentsOf: url), let chatHistory = try? decoder.decode([Chat].self, from: data) {
            return chatHistory
        } else {
            return nil
        }
    }
    
    static func updateToFile(receiver: String, data: Message) {
        if let chatHistory = Chat.readFromFile() {
            var tmpChatHistory = chatHistory
            for i in 0...tmpChatHistory.count - 1 {
                if tmpChatHistory[i].id == receiver {
                    tmpChatHistory[i].message = data
                    tmpChatHistory.sort(by: <)
                    Chat.saveTofile(chatHistory: tmpChatHistory)
                    return
                }
            }
            tmpChatHistory.append(Chat(id: receiver, message: data))
            tmpChatHistory.sort(by: <)
            Chat.saveTofile(chatHistory: tmpChatHistory)
        } else {
            let chatHistory = [Chat(id: receiver, message: data)]
            Chat.saveTofile(chatHistory: chatHistory)
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
