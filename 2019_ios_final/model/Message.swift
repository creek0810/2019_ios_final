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
            let fileName = receiver + "-messageHistory"
            let url = Message.documentDirectory.appendingPathComponent(fileName).appendingPathExtension("plist")
            try? data.write(to: url)
        }
    }
    
    static func readMessagesFromFile(receiver: String) -> [Message]? {
        let decoder = PropertyListDecoder()
        let fileName = receiver + "-messageHistory"
        let url = Friend.documentsDirectory.appendingPathComponent(fileName).appendingPathExtension("plist")
        if let data = try? Data(contentsOf: url), let history = try? decoder.decode([Message].self, from: data) {
            return history
        }
        return nil
    }
}

struct SendMessage: Codable {
    var sender: String
    var receiver: String
    var message: String
}

struct Image: Codable {
    
    var imageName: String
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func saveImagesNameToFile(receiver: String, images: [Image]) {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(images) {
            let fileName = receiver + "-imageHistory"
            let url = Message.documentDirectory.appendingPathComponent(fileName).appendingPathExtension("plist")
            try? data.write(to: url)
        }
    }
    
    static func readImagesNameFromFile(receiver: String) -> [Image]? {
        let decoder = PropertyListDecoder()
        let fileName = receiver + "-imageHistory"
        let url = Friend.documentsDirectory.appendingPathComponent(fileName).appendingPathExtension("plist")
        if let data = try? Data(contentsOf: url), let history = try? decoder.decode([Image].self, from: data) {
            return history
        }
        return nil
    }
    
    
    static func readImageFromFile(imageName: String) -> UIImage? {
        let localUrl = Image.documentDirectory.appendingPathComponent(imageName)
        let remoteUrl = "http://140.121.197.197:6700/image?path=\(imageName)"
        if let image = UIImage(contentsOfFile: localUrl.path) {
            return image
        }
        if let url = URL(string: remoteUrl) {
            let data = try? Data(contentsOf: url)
            if let imageData = data, let image = UIImage(data: imageData) {
                try? imageData.write(to: localUrl)
                return image
            }
        }
        return nil
    }
}
