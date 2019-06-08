//
//  SingalImageViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/1.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class SingalImageViewController: UIViewController {
    
    var tmpImage: UIImage = UIImage()
    var receiver: Friend = Friend(propic: "test", name: "", id: "")

    
    @IBOutlet weak var nameLabel: UINavigationItem!
    @IBOutlet weak var singalImage: UIImageView!
    
    @IBAction func showAllImages(_ sender: Any) {
        self.performSegue(withIdentifier: "showAllImages", sender: "")
    }
    
    @IBAction func download(_ sender: Any) {
        if let image = singalImage.image{
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        singalImage.image = tmpImage
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAllImages" {
            let controller = segue.destination as! AllImagesViewController
            controller.receiver = receiver
        }
    }
    

}
