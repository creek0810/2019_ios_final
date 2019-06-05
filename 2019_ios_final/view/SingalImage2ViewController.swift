//
//  SingalImage2ViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/5.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class SingalImage2ViewController: UIViewController {
    var tmpImage: UIImage = UIImage()
    
    @IBOutlet weak var singalImage: UIImageView!
    
    @IBAction func download(_ sender: Any) {
        if let image = singalImage.image{
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singalImage.image = tmpImage

        // Do any additional setup after loading the view.
    }
}
