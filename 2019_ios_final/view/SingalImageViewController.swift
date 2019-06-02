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
    
    @IBOutlet weak var singalImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singalImage.image = tmpImage
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
