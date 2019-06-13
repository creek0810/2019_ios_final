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
        // personal api
        static let login = "http://140.121.197.197:6700/login"
        static let sendText = "http://140.121.197.197:6700/send_text"
        static let uploadImage = "http://140.121.197.197:6700/send_image"
        static let getFriendList = "http://140.121.197.197:6700/get_friends"
        static let getProfile = "http://140.121.197.197:6700/profile"
        static let addFriend = "http://140.121.197.197:6700/add_friend"
        static let updateName = "http://140.121.197.197:6700/update_name"
        static let updatePropic = "http://140.121.197.197:6700/update_propic"
        static let updateStatus = "http://140.121.197.197:6700/update_status"
        // open api
        static let getCity = "https://works.ioa.tw/weather/api/all.json"
        static let getWeather = "https://works.ioa.tw/weather/api/weathers/"
    }

    func socketConnect(sender: String) {
        let socket = self.manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in

            socket.emit("post name", ["sender": User.shared.id])
            socket.emit("get history", ["sender": User.shared.id])
        }
        
        socket.on("get msg") { rawData, ack in
            if let data = rawData[0] as? NSDictionary {
                let message = Message.decodeFromDict(data: data)
                socket.emit("get msg success", [
                    "sender": User.shared.id,
                    "timeStamp": message.timeStamp
                ])
                // get receiver name
                var receiver: String = ""
                if message.receiver == User.shared.id {
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
                print(NetworkController.shared.delegate)
                if let tmpDelegate = NetworkController.shared.delegate {
                    tmpDelegate.update(data: message)
                } else {
                    if message.sender != User.shared.id {
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
            data.append(image.jpegData(compressionQuality: 0.3)!)
            
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
            let userString = "id=\(user.id)&password=\(user.password)"
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
    
    func getProfile(id: String, completion: @escaping (Int, Data?) -> Void) {
        let urlString = "\(API.getProfile)?id=\(id)"
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
    
    func addFriend(id: String, completion: @escaping () -> Void){
        let urlString = "\(API.addFriend)?sender=\(User.shared.id)&id=\(id)"
        if let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    completion()
                }
            }
            task.resume()
        }
    }
    func updateName(newName: String) {
        let rawUrl = "\(API.updateName)?id=\(User.shared.id)&name=\(newName)"
        let urlString = rawUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        if let urlString = urlString, let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request)
            task.resume()
        }
    }
    
    func updateStatus(status: String) {
        let rawUrl = "\(API.updateStatus)?id=\(User.shared.id)&status=\(status)"
        let urlString = rawUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        if let urlString = urlString, let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request)
            task.resume()
        }
    }
    
    func updatePropic(propic: UIImage) {
        let boundary = UUID().uuidString
        
        if let url = URL(string: API.updatePropic){
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
            var data = Data()
            
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(boundary)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(propic.jpegData(compressionQuality: 0.3)!)
            
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"id\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(User.shared.id)".data(using: .utf8)!)
            
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            let task = URLSession.shared.uploadTask(with: request, from: data)
            task.resume()
        }
    }
    
    func getCity(completion: @escaping ([City]) -> Void) {
        let urlString = "\(API.getCity)"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: url) { (data, res, err) in
                print("start")
                if let data = data, let result = try? JSONDecoder().decode([City].self, from: data) {
                    completion(result)
                }
            }
            task.resume()
        }
    }
    
    func getWeather(townID: String, completion: @escaping (Weather) -> Void) {
        let urlString = "\(API.getWeather)\(townID).json"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: url) { (data, res, err) in
                if let data = data, let result = try? JSONDecoder().decode(WeatherAll.self, from: data), let weather = result.histories {
                    completion(weather[weather.count - 1])
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
        } else if data.type == Type.Text {
            content.body = "\(data.message)"
        } else if data.type == Type.AddFriend {
            content.body = "\(data.sender)想新增你為好友"
        }
        content.badge = 1
        content.sound = UNNotificationSound.default
        content.userInfo = [
            "type": data.type.rawValue,
            "sender": data.sender,
        ]
        if data.type == Type.AddFriend {
            let request = UNNotificationRequest(identifier: "addFriend", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { data in
                print("成功建立通知... from friend")
            })
        } else {
            let request = UNNotificationRequest(identifier: "message", content: content, trigger: nil)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                print("成功建立通知... from another")
            })
        }
        

    }
    
    func showAddFriendRequest(curController: UIViewController, message: Message) {
        let controller = UIAlertController(title: "加入好友", message: "是否新增\(message.sender)為好友", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default) { (_) in
            print("在行事曆裡加入送宵夜的提醒")
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        DispatchQueue.main.async {
            curController.present(controller, animated: true, completion: nil)
        }
    }
    
}
