//
//  Image.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/5.
//  Copyright © 2019 river. All rights reserved.
//

import Foundation
import UIKit

struct Image: Codable {
    
    var imageName: String
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func saveImagesNameToFile(receiver: String, images: [Image]) {
        let encoder = PropertyListEncoder()
        if let data = try? encoder.encode(images) {
            let fileName = "\(User.shared.id)-\(receiver)-imageHistory"
            let url = Message.documentDirectory.appendingPathComponent(fileName).appendingPathExtension("plist")
            try? data.write(to: url)
        }
    }
    
    static func readImagesNameFromFile(receiver: String) -> [Image]? {
        let decoder = PropertyListDecoder()
        let fileName = "\(User.shared.id)-\(receiver)-imageHistory"
        let url = Friend.documentsDirectory.appendingPathComponent(fileName).appendingPathExtension("plist")
        if let data = try? Data(contentsOf: url), let history = try? decoder.decode([Image].self, from: data) {
            return history
        }
        return nil
    }
    
    static func updateToFile(receiver: String, data: Image){
        if let images = Image.readImagesNameFromFile(receiver: receiver){
            var tmpImages = images
            tmpImages.append(data)
            Image.saveImagesNameToFile(receiver: receiver, images: tmpImages)
        } else {
            let images = [data]
            Image.saveImagesNameToFile(receiver: receiver, images: images)
        }
    }
    
    static func getImage(imageName: String) -> UIImage? {
        print("getImage: \(imageName)")
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
        if let image = UIImage(named: "broken image") {
            return image
        }
        return nil
    }
}
