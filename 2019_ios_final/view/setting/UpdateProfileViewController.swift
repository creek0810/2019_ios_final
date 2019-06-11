//
//  UpdateProfileViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/11.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController {
    
    var profile: Friend = Friend(propic: "", name: "", id: "", status: "")
    var change: profileData = profileData.name
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBAction func update(_ sender: Any) {
        if change == profileData.name {
            NetworkController.shared.updateName(newName: inputTextField.text!)
        } else if change == profileData.status {
            NetworkController.shared.updateStatus(status: inputTextField.text!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
