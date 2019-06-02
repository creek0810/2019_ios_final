//
//  ChatMenuViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/30.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class ChatMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var chatList: [Chat] = [
        Chat(propic: "", name: "test1", message: "你知道嗎？"),
        Chat(propic: "test", name: "test2", message: "ldldldldldfdhighehhishvkdhihkenihvdnkhgioehgioherhioeirhoieldldldldldffkkfkfkfkfkfkkfldldldldldldl"),
    ]
    
    @IBOutlet weak var chatMenuTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let curChat = chatList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
        cell.nameLabel.text = curChat.name
        cell.messageLabel.text = curChat.message
        if let image = UIImage(named: curChat.propic) {
            cell.propic.image = image
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
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChat", let receiver = sender as? Chat {
            let controller = segue.destination as! ChatViewController
            controller.receiver = Friend(propic: receiver.propic, name: receiver.name)
        }
    }
 

}
