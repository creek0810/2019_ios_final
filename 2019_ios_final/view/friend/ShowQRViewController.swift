//
//  ShowQRViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/8.
//  Copyright © 2019 river. All rights reserved.
//

import UIKit

class ShowQRViewController: UIViewController {
    var tmpImage: CIImage = CIImage()
    @IBOutlet weak var qrImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrImage.image = UIImage(ciImage: tmpImage)
    }
}
