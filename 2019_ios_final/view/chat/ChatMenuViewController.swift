//
//  ChatMenuViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/30.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class ChatMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NetworkDelegate {
    
    var chatList: [Chat] = [Chat]()
    
    @IBOutlet weak var chatMenuTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curChat = chatList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        if let lastTime = dateFormatter.date(from: curChat.message.timeStamp){
            let today = Date()
            let result = today.compare(with: lastTime, only: .day)
            var dateString = ""
            if result == 0 {
                dateFormatter.dateFormat = "HH:mm"
                dateString = dateFormatter.string(from: lastTime)
            } else if result == 1 {
                dateString = "yesterday"
            } else if today.compare(with: lastTime, only: .year) == 1{
                dateFormatter.dateFormat = "yyy/MM/dd"
                dateString = dateFormatter.string(from: lastTime)
            } else {
                dateFormatter.dateFormat = "MM/dd"
                dateString = dateFormatter.string(from: lastTime)
            }
            cell.dateLabel.text = dateString
        }
        
        if curChat.message.type == Type.Image {
            cell.messageLabel.text = "Photo"
        } else {
            cell.messageLabel.text = curChat.message.message
        }
        if let profile = Friend.getProfile(id: curChat.id) {
            cell.nameLabel.text = profile.name
            if let image = Image.getImage(imageName: profile.propic) {
                cell.propic.image = image
            }
        }
        if curChat.unread == 0 {
            cell.unreadLabel.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
            cell.unreadLabel.text = ""
        } else {
            cell.unreadLabel.backgroundColor = UIColor(displayP3Red: 2/255.0, green: 132/255.0, blue: 255/255.0, alpha: 1)
            cell.unreadLabel.text = curChat.unread.description
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showChat", sender: chatList[indexPath.row])
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatMenuTable.delegate = self
        chatMenuTable.dataSource = self
        
        if let chatHistory = Chat.readFromFile() {
            chatList = chatHistory
            chatMenuTable.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetworkController.shared.delegate = self
        if let chatHistory = Chat.readFromFile() {
            chatList = chatHistory
            chatMenuTable.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NetworkController.shared.delegate = nil
    }
    
    func update(data: Message) {
        print("update by chat menu")
        if let chatHistory = Chat.readFromFile() {
            chatList = chatHistory
            chatMenuTable.reloadData()
        }
        if data.sender != User.shared.id {
            NetworkController.shared.sendNotification(data: data)
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat", let receiver = sender as? Chat {
            let controller = segue.destination as! ChatViewController
            if let friend = Friend.getProfile(id: receiver.id) {
                controller.receiver = friend
            }
            
        }
    }
}

extension Date {
    
    func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func compare(with date: Date, only component: Calendar.Component) -> Int {
        let days1 = Calendar.current.component(component, from: self)
        let days2 = Calendar.current.component(component, from: date)
        return days1 - days2
    }
    
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return self.compare(with: date, only: component) == 0
    }
}
