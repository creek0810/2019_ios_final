//
//  LoginViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/30.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func login(_ sender: Any) {
        User.shared = User(id: nameTextField.text!, password: passwordTextField.text!)
        NetworkController.shared.login(user: User.shared) { (status) in
            if status == 200 {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "loginSuccess", sender: "")
                }
            } else if status == 401 {
                DispatchQueue.main.async {
                    let controller = UIAlertController(title: "登入失敗", message: "帳號或密碼錯誤", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    controller.addAction(okAction)
                    self.present(controller, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    let controller = UIAlertController(title: "系統錯誤", message: "系統錯誤", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    controller.addAction(okAction)
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NetworkController.shared.socketConnect(sender: User.shared.id)
    }
}
