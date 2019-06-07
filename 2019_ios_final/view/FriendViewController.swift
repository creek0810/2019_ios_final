//
//  FriendViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/30.
//  Copyright © 2019 river. All rights reserved.
//

// todo: network reload

import UIKit

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var friendList: [Friend] = [Friend]()
    
    @IBOutlet weak var friendTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableViewCell
        cell.nameLabel.text = friendList[indexPath.row].name
        if let image = Image.getImage(imageName: friendList[indexPath.row].propic) {
            cell.propic.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "startChat", sender: friendList[indexPath.row])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        friendTable.delegate = self
        friendTable.dataSource = self

        NetworkController.shared.getFriendList { (friendList: [Friend]?) in
            if let friendList = friendList {
                self.friendList = friendList
            } else if let friendList = Friend.readFromFile() {
                self.friendList = friendList
            }
            DispatchQueue.main.async {
                self.friendTable.reloadData()
                Friend.saveTofile(friends: self.friendList)
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        NetworkController.shared.getFriendList { (friendList: [Friend]?) in
            if let friendList = friendList {
                self.friendList = friendList
            } else if let friendList = Friend.readFromFile() {
                self.friendList = friendList
            }
            DispatchQueue.main.async {
                self.friendTable.reloadData()
                Friend.saveTofile(friends: self.friendList)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startChat", let receiver = sender as? Friend {
            let controller = segue.destination as! ChatViewController
            controller.receiver = receiver
        }
    }
}


