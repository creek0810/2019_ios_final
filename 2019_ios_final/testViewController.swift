//
//  testViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/3.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class testViewController: UIViewController {
        @IBOutlet weak var imageButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageButton.imageView?.contentMode = .scaleAspectFit
        
        let frame = imageButton.imageView!.frame
        let size = imageButton.imageView!.image!.size
        let widthRatio = frame.width / size.width
        let heightRatio = frame.height / size.height
        print("widthRatio: \(widthRatio)")
        print("heightRatio: \(heightRatio)")
        if widthRatio < heightRatio {
            let delta = (frame.height - widthRatio * size.height) / 2
            print("top delta: \(delta)")
            //cell.imageButton.imageEdgeInsets = UIEdgeInsets(top: -delta, left: 0, bottom: delta, right: 0)
        } else {
            let delta = (frame.width - heightRatio * size.width) / 2
            print("left delta: \(delta)")
            //cell.imageButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -93, bottom: 0, right: 93)
        }
        //imageButton.imageEdgeInsets = UIEdgeInsets(top: -13.5, left: 0, bottom: 13.5, right: 0)
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
