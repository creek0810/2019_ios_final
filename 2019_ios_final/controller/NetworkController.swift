//
//  NetworkController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/30.
//  Copyright © 2019 river. All rights reserved.
//

import Foundation
import SocketIO
import UserNotifications

protocol NetworkDelegate: class {
    func update(data: Message)
}

struct NetworkController {
    var delegate: NetworkDelegate?

    static var shared = NetworkController()
    
    let manager = SocketManager(socketURL: URL(string: "http://140.121.197.197:6700")!, config: [.log(true), .compress])

    struct API {
        static let login = "http://140.121.197.197:6700/login"
        static let sendText = "http://140.121.197.197:6700/send_text"
        static let uploadImage = "http://140.121.197.197:6700/send_image"
        static let getFriendList = "http://140.121.197.197:6700/get_friends"
        static let getProfile = "http://140.121.197.197:6700/profile"
    }

    func socketConnect(sender: String) {
        let socket = self.manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            socket.emit("post name", ["sender": User.shared.name])
            socket.emit("get history", ["sender": User.shared.name])
        }
        
        socket.on("get msg") { rawData, ack in
            if let data = rawData[0] as? NSDictionary {
                let message = Message.decodeFromDict(data: data)
                socket.emit("get msg success", [
                    "sender": User.shared.name,
                    "timeStamp": message.timeStamp
                ])
                // get receiver name
                var receiver: String = ""
                if message.receiver == User.shared.name {
                    receiver = message.sender
                } else {
                    receiver = message.receiver
                }
                // start update
                Message.updateToFile(receiver: receiver, data: message)
                Chat.updateToFile(receiver: receiver, data: message)
                if message.type == Type.Image {
                    Image.updateToFile(receiver: receiver, data: Image(imageName: message.message))
                }
                if let tmpDelegate = NetworkController.shared.delegate {
                    tmpDelegate.update(data: message)
                } else {
                    if message.sender != User.shared.name {
                        print("no delagate")
                        self.sendNotification(data: message)
                    }
                }
                
    
            }
        }
        socket.connect()
    }
    
    func sendText(message: SendMessage) {
        if let url = URL(string: API.sendText){
            var request = URLRequest(url: url)
            let data = try? JSONEncoder().encode(message)
            request.httpMethod = "POST"
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "content-type")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                print(data)
            }
            task.resume()
        }
    }

    func sendImage(sender: String, receiver: String, image: UIImage) {
        let boundary = UUID().uuidString
        
        if let url = URL(string: API.uploadImage){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
            var data = Data()
            
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(boundary)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(image.jpegData(compressionQuality: 0.5)!)
            
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"receiver\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(receiver)".data(using: .utf8)!)
            
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"sender\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(sender)".data(using: .utf8)!)

            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            
            let task = URLSession.shared.uploadTask(with: request, from: data)
            task.resume()
        }
    }
    
    func login(user: User, completion: @escaping (Int) -> Void) {
        if let url = URL(string: API.login){
            var request = URLRequest(url: url)
            let userString = "name=\(user.name)&password=\(user.password)"
            request.httpMethod = "POST"
            request.httpBody = userString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    completion(response.statusCode)
                }
            }
            task.resume()
        }
    }
    
    func getFriendList(completion: @escaping ([Friend]?) -> Void){
        if let url = URL(string: API.getFriendList){
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let friendList = try? JSONDecoder().decode([Friend].self, from: data)
                    completion(friendList)
                }
            }
            task.resume()
        }
    }
    
    func getProfile(name: String, completion: @escaping (Int, Data?) -> Void) {
        let urlString = "\(API.getProfile)?name=\(name)"
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    completion(response.statusCode, data)
                }
            }
            task.resume()
        }
    }
    
}

extension NetworkController {
    func sendNotification(data: Message) {
        let content = UNMutableNotificationContent()
        content.title = "\(data.sender)"
        if data.type == Type.Image {
            content.body = "Photo"
        } else {
            content.body = "\(data.message)"
        }
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("成功建立通知...")
        })
    }
    
}
