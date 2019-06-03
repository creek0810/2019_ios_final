//
//  NetworkController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/30.
//  Copyright © 2019 river. All rights reserved.
//

import Foundation
import SocketIO



struct NetworkController {
    
    static let shared = NetworkController()

    
    
    struct API {
        static let login = "http://140.121.197.197:6700/login"
        static let getFriendList = "http://140.121.197.197:6700/get_friends"
        static let uploadImage = "http://140.121.197.197:6700/send_image"
        static let sendText = "http://140.121.197.197:6700/send_text"
    }
    
    
    
    /*func socketConnect(sender: String) {
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { data, ack in
            socket.emit("post name", ["sender": sender])
        }
        socket.on("get msg") { data, ack in
            if let data = data[0] as? NSDictionary {
                let msg = self.jsonToMessage(data: data)
                if data["receiver"] as! String == ChatViewController.receiver.name {
                    ChatViewController.chatHistory.append(msg)
                    if let topVC = UIApplication.topViewController() {
                        if topVC == ChatViewController {
                            topVC.
                        }
                    }
                }
                
            }
        }
        socket.connect()
    }*/
    
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
    
}
extension NetworkController {
    /*func jsonToMessage(data: NSDictionary) -> Message{
        let type = Type.Text
        var sender = Sender.User
        if data["sender"] as! String != User.shared.name {
            sender = Sender.Opposite
        }
        return Message(type: type, sender: sender, image: "", text: data["msg"] as! String)
    }*/
}

