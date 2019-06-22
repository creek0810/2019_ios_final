//
//  AddFriendMenuViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/7.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class AddFriendMenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var userIDLabel: UILabel!

    @IBAction func showQR(_ sender: Any) {
        let name = User.shared.id
        let data = name.data(using: String.Encoding.utf8)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter!.setValue(data, forKey: "inputMessage")
        let qrImage = qrFilter!.outputImage
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage!.transformed(by: transform)
        self.performSegue(withIdentifier: "showQR", sender: scaledQrImage)
    }
    
    @IBAction func searchByID(_ sender: Any) {
        NetworkController.shared.getProfile(id: idText.text!, completion: { status, data in
            if status == 204 {
                let controller = UIAlertController(title: "錯誤", message: "無法找到該用戶", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(controller, animated: true, completion: nil)
                }
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
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let qrcodeImg = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        let ciImage: CIImage = CIImage(image:qrcodeImg)!
        var qrCodeLink = ""
        
        let features = detector.features(in: ciImage)
        for feature in features as! [CIQRCodeFeature] {
            qrCodeLink += feature.messageString!
        }
        dismiss(animated: true, completion: nil)
        NetworkController.shared.getProfile(id: qrCodeLink) { (status, data) in
            if status == 204 {
                let controller = UIAlertController(title: "錯誤", message: "無法找到該用戶", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(controller, animated: true, completion: nil)
                }
            } else if status == 200 {
                if let data = data, let profile = try? JSONDecoder().decode(Friend.self, from: data) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showProfile", sender: profile)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIDLabel.text = User.shared.id
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfile" {
            let controller = segue.destination as! AddFriendViewController
            controller.target = sender as? Friend
        } else if segue.identifier == "showQR" {
            let controller = segue.destination as! ShowQRViewController
            if let image = sender as? CIImage {
                controller.tmpImage = image
            }
        }
    }

}
