//
//  ChatViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/30.
//  Copyright © 2019 river. All rights reserved.
//

// todo: handle socket
// todo: adjust image offset
// todo: message from another user to notification

import UIKit
import SocketIO
import UserNotifications


class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NetworkDelegate {
    
    var receiver: Friend = Friend(propic: "test", name: "")
    var chatHistory: [Message] = [
        Message(type: Type.Image, sender: "", receiver: User.shared.name, message: "", timeStamp: ""),
        Message(type: Type.Image, sender: User.shared.name, receiver: "", message: "", timeStamp: "")
    ]
    var first = true
    
    let manager = SocketManager(socketURL: URL(string: "http://140.121.197.197:6700")!, config: [.log(true), .compress])
    let leftFrameHeight = CGFloat(150)
    var leftFrameWidth = CGFloat(0)
    let rightFrameHeight = CGFloat(150)
    var rightFrameWidth = CGFloat(0)
    
    @IBOutlet weak var inputMessage: UITextField!
    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var nameLabel: UINavigationItem!
    @IBOutlet weak var maskView: UIView!
    
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
                if let image = Image.getImage(imageName: receiver.propic) {
                    cell.propic.image = image
                }
                cell.messageLabel.text = chatHistory[indexPath.row].message
                return cell
            }
        } else {
            if curMessage.sender == User.shared.name {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightImageCell", for: indexPath) as! RightImageTableViewCell
                if let image = Image.getImage(imageName: chatHistory[indexPath.row].message) {
                    cell.imageButton.image = image
                    let widthRatio = rightFrameWidth / image.size.width
                    let heightRatio = rightFrameHeight / image.size.height
                    if widthRatio < heightRatio {
                        let delta = (rightFrameHeight - widthRatio * image.size.height) / 2
                        cell.imageButton.image = image.withAlignmentRectInsets(UIEdgeInsets(top: -delta, left: 0, bottom: delta, right: 0))

                    } else {
                        let delta = (rightFrameWidth - heightRatio * image.size.width) / 2
                        cell.imageButton.image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -delta, bottom: 0, right: delta))
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LeftImageCell", for: indexPath) as! LeftImageTableViewCell
                if let image = Image.getImage(imageName: chatHistory[indexPath.row].message) {
                    cell.imageButton.image = image
                    let widthRatio = leftFrameWidth / image.size.width
                    let heightRatio = leftFrameHeight / image.size.height
                    if widthRatio < heightRatio {
                        let delta = (leftFrameHeight - widthRatio * image.size.height) / 2
                        cell.imageButton.image = image.withAlignmentRectInsets(UIEdgeInsets(top: -delta, left: 0, bottom: delta, right: 0))
                    } else {
                        let delta = (leftFrameWidth - heightRatio * image.size.width) / 2
                        cell.imageButton.image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: delta, bottom: 0, right: -delta))
                    }
                }
                if let image = Image.getImage(imageName: receiver.propic) {
                    cell.propic.image = image
                }
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if chatHistory[indexPath.row].type == Type.Image {
            self.performSegue(withIdentifier: "showSingalImage", sender: chatHistory[indexPath.row].message)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetworkController.shared.delegate = self
        if first {
            first = false
            let leftCell = chatTable.cellForRow(at: IndexPath(row: 0, section: 0)) as! LeftImageTableViewCell
            leftFrameWidth = leftCell.imageButton.frame.width
            
            let rightCell = chatTable.cellForRow(at: IndexPath(row: 1, section: 0)) as! RightImageTableViewCell
            rightFrameWidth = rightCell.imageButton.frame.width
            
            if let history = Message.readMessagesFromFile(receiver: receiver.name) {
                chatHistory = history
            } else {
                chatHistory = [Message]()
            }
            chatTable.reloadData()
            Message.saveMessagesToFile(receiver: receiver.name, msgs: chatHistory)
            scrollToBottom()
            
            maskView.removeFromSuperview()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        NetworkController.shared.delegate = nil
    }
    
    func update(data: Message) {
        print("update by chat view")
        if data.sender == receiver.name || data.receiver == receiver.name {
            self.chatHistory.append(data)
            let indexPath = IndexPath(row: self.chatHistory.count - 1, section: 0)
            self.chatTable.insertRows(at: [indexPath], with: .automatic)
            self.scrollToBottom()
        } else {
            NetworkController.shared.sendNotification(data: data)
        }
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSingalImage", let imageName = sender as? String, let image = Image.getImage(imageName: imageName) {
            let controller = segue.destination as! SingalImageViewController
            controller.tmpImage = image
            controller.receiver = receiver
        }
    }
}
extension ChatViewController {

    func scrollToBottom() {
        if chatHistory.count >= 1 {
            let indexPath = IndexPath(row: self.chatHistory.count - 1, section: 0)
            self.chatTable.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
}

