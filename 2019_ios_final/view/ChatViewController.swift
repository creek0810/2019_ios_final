//
//  ChatViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/30.
//  Copyright © 2019 river. All rights reserved.
//

// todo: handle socket
// todo: adjust image offset
// todo: offline image
// todo: right image cell

import UIKit
import SocketIO

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var receiver: Friend = Friend(propic: "test", name: "")
    var chatHistory: [Message] = [Message]()
    
    let manager = SocketManager(socketURL: URL(string: "http://140.121.197.197:6700")!, config: [.log(true), .compress])
    
    
    @IBOutlet weak var inputMessage: UITextField!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var nameLabel: UINavigationItem!
    
    @IBAction func sendMessage(_ sender: Any) {
        let messageText = inputMessage.text!
        let message = SendMessage(sender: User.shared.name, receiver: receiver.name, message: messageText)
        NetworkController.shared.sendText(message: message)
        inputMessage.text! = ""
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curMessage = chatHistory[indexPath.row]
        if curMessage.type == Type.Text {
            if curMessage.sender == User.shared.name {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightChatCell", for: indexPath) as! RightMessageTableViewCell
                cell.messageLabel.text = chatHistory[indexPath.row].message
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LeftChatCell", for: indexPath) as! LeftMessageTableViewCell
                if let image = UIImage(named: receiver.propic) {
                    cell.propic.image = image
                }
                cell.messageLabel.text = chatHistory[indexPath.row].message
                return cell
            }
        } else {
            if curMessage.sender == User.shared.name {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightImageCell", for: indexPath) as! RightImageTableViewCell
                let urlStr = "http://140.121.197.197:6700/image?path=\(chatHistory[indexPath.row].message)"
                if let url = URL(string: urlStr) {
                    let data = try? Data(contentsOf: url)
                    if let imageData = data{
                        cell.imageButton.image = UIImage(data: imageData)
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LeftImageCell", for: indexPath) as! LeftImageTableViewCell
                
                let urlStr = "http://140.121.197.197:6700/image?path=\(chatHistory[indexPath.row].message)"
                if let url = URL(string: urlStr) {
                    let data = try? Data(contentsOf: url)
                    if let imageData = data{
                        cell.imageButton.image = UIImage(data: imageData)
                    }
                }
                if let image = UIImage(named: receiver.propic) {
                    cell.propic.image = image
                }
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if chatHistory[indexPath.row].type == Type.Image {
            if chatHistory[indexPath.row].sender == User.shared.name {
                let cell = chatTable.cellForRow(at: indexPath) as! RightImageTableViewCell
                self.performSegue(withIdentifier: "showSingalImage", sender: cell.imageButton.image)
            } else {
                let cell = chatTable.cellForRow(at: indexPath) as! LeftImageTableViewCell
                self.performSegue(withIdentifier: "showSingalImage", sender: cell.imageButton.image)
            }
            
        }
    }
    
    @IBAction func pickImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        NetworkController.shared.sendImage(sender: User.shared.name, receiver: receiver.name, image: selectedImage)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTable.delegate = self
        chatTable.dataSource = self
        nameLabel.title = receiver.name
        connectSocket()
        if let history = Message.readMessagesFromFile(receiver: receiver.name) {
            chatHistory = history
            chatTable.reloadData()
        }
        Message.saveMessagesToFile(receiver: receiver.name, msgs: chatHistory)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSingalImage", let image = sender as? UIImage {
            let controller = segue.destination as! SingalImageViewController
            controller.tmpImage = image
        }
    }
}
extension ChatViewController {
    func connectSocket() {
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect) { data, ack in
            socket.emit("post name", ["sender": User.shared.name])
        }
        // need to deal with the message ffrom another people
        socket.on("get msg") { rawData, ack in
            if let data = rawData[0] as? NSDictionary {
                let message = self.jsonToMessage(data: data)
                if message.receiver == self.receiver.name || message.sender == self.receiver.name {
                    self.chatHistory.append(message)
                    self.chatTable.reloadData()
                    Message.saveMessagesToFile(receiver: self.receiver.name, msgs: self.chatHistory)
                    if message.receiver == User.shared.name {
                        socket.emit("get msg success", [
                            "sender": data["sender"] as! String,
                            "receiver": data["receiver"] as! String,
                            "msg": data["msg"] as! String,
                            "timeStamp": data["timeStamp"] as! String
                        ])
                    }
                    if message.type == Type.Image {
                        var images: [Image] = [Image]()
                        let tmpImages = Image.readImagesFromFile(receiver: self.receiver.name)
                        if let tmpImages = tmpImages {
                            images = tmpImages
                        }
                        images.append(Image(imageName: message.message))
                        Image.saveImagesToFile(receiver: self.receiver.name, images: images)
                        
                    }
                    
                    
                }
            }
        }
        socket.connect()
    }

    func jsonToMessage(data: NSDictionary) -> Message {
        let sender = data["sender"] as! String
        let receiver = data["receiver"] as! String
        let message = data["message"] as! String
        let timeStamp = data["timeStamp"] as! String
        if data["type"] as! Int == Type.Image.rawValue {
            return Message(type: Type.Image, sender: sender, receiver: receiver, message: message, timeStamp: timeStamp)
        } else {
            return Message(type: Type.Text, sender: sender, receiver: receiver, message: message, timeStamp: timeStamp)
        }
    }
}
