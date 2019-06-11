//
//  UserProfileViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/11.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit


class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var profile: Friend = Friend(propic: "", name: "", id: "", status: "")
    let tableMapping = ["ID", "暱稱", "狀態"]
    
    @IBOutlet weak var propic: UIImageView!
    @IBOutlet weak var profileTable: UITableView!
    
    @IBAction func changeImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileUITaTableViewCell
        cell.titleLabel.text = tableMapping[indexPath.row]
        if indexPath.row == 0{
            cell.contentLabel.text = profile.id
        }else if indexPath.row == 1 {
            cell.contentLabel.text = profile.name
        } else {
            cell.contentLabel.text = profile.status
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableMapping[indexPath.row] != "ID" {
            self.performSegue(withIdentifier: "updateProfile", sender: indexPath.row)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let newPropic = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        NetworkController.shared.updatePropic(propic: newPropic)
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTable.delegate = self
        profileTable.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        NetworkController.shared.getProfile(id: User.shared.id, completion: { status, data in
            if status == 204 {
                print("can't find")
            } else if status == 200 {
                if let data = data, let profile = try? JSONDecoder().decode(Friend.self, from: data) {
                    DispatchQueue.main.async {
                        self.propic.image = Image.getImage(imageName: profile.propic)
                        self.profile = profile
                        self.profileTable.reloadData()
                    }
                }
            }
        })
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateProfile" {
            let controller = segue.destination as! UpdateProfileViewController
            let value = sender as! Int
            controller.profile = profile
            if let sender = sender as? Int, let change = profileData(rawValue: value) {
                controller.change = change
            }
        }
    }
    

}
