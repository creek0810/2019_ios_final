//
//  AddFriendMenuViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/7.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class AddFriendMenuViewController: UIViewController {
    @IBOutlet weak var idText: UITextField!
    
    
    @IBAction func showQR(_ sender: Any) {
        
    }
    
    @IBAction func searchByID(_ sender: Any) {
        NetworkController.shared.getProfile(name: idText.text!, completion: { status, data in
            if status == 204 {
                print("can't find")
            } else if status == 200 {
                if let data = data, let profile = try? JSONDecoder().decode(Friend.self, from: data) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showProfile", sender: profile)
                    }
                }
            }
        })
    }
    
    @IBAction func searchByQR(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfile" {
            let controller = segue.destination as! AddFriendViewController
            controller.target = sender as? Friend
        }
    }

}
