//
//  AddFriendViewController.swift
//  Pods-2019_ios_final
//
//  Created by 王心妤 on 2019/6/6.
//

import UIKit

class AddFriendViewController: UIViewController {
    
    var target: Friend?
    
    @IBOutlet weak var propicImage: UIImageView!
    
    @IBOutlet weak var idText: UILabel!
    
    @IBAction func addFriend(_ sender: Any) {
        if let target = target {
            NetworkController.shared.addFriend(id: target.id, completion: {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "backToFriendList", sender: "")
                }
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let target = target {
            if let image = Image.getImage(imageName: target.propic) {
                propicImage.image = image
            }
            idText.text = target.name
        }
    }
}

