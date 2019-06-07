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
        NetworkController.shared.addFriend(name: idText.text!, completion: {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "backToFriendList", sender: "")
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let target = target {
            if let image = Image.getImage(imageName: target.propic) {
                propicImage.image = image
            }
            idText.text = target.name
        }
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

