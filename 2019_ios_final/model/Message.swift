//
//  Message.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/31.
//  Copyright © 2019 river. All rights reserved.
//

import Foundation
import UIKit

enum Type: Int, Codable {
    case Image = 0
    case Text = 1
    case AddFriend = 2
}

struct Message: Codable {
    var type: Type
    var sender: String
    var receiver: String
    var message: String
    var timeStamp: String
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    static func saveMessagesToFile(receiver: String, msgs: [Message]) {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(msgs) {
            let fileName = "\(User.shared.id)-\(receiver)-messageHistory"
            let url = Message.documentDirectory.appendingPathComponent(fileName).appendingPathExtension("plist")
            try? data.write(to: url)
        }
    }
    
    static func readMessagesFromFile(receiver: String) -> [Message]? {
        let decoder = PropertyListDecoder()
        let fileName = "\(User.shared.id)-\(receiver)-messageHistory"
        let url = Friend.documentsDirectory.appendingPathComponent(fileName).appendingPathExtension("plist")
        if let data = try? Data(contentsOf: url), let history = try? decoder.decode([Message].self, from: data) {
            return history
        }
        return nil
    }
    
    static func updateToFile(receiver: String, data: Message) {
        // get history
        if let chatHistory = Message.readMessagesFromFile(receiver: receiver) {
            var tmpChatHistory = chatHistory
            tmpChatHistory.append(data)
            Message.saveMessagesToFile(receiver: receiver, msgs: tmpChatHistory)
        } else {
            let chatHistory = [data]
            Message.saveMessagesToFile(receiver: receiver, msgs: chatHistory)
        }
    }
    
    static func decodeFromDict(data: NSDictionary) -> Message {
        let sender = data["sender"] as! String
        let receiver = data["receiver"] as! String
        let message = data["message"] as! String
        let timeStamp = data["timeStamp"] as! String
        let type = Type(rawValue: data["type"] as! Int)!
        return Message(type: type, sender: sender, receiver: receiver, message: message, timeStamp: timeStamp)
    }
}

struct SendMessage: Codable {
    var sender: String
    var receiver: String
    var message: String
}

