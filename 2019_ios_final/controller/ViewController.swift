//
//  ViewController.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/6/5.
//  Copyright © 2019 river. All rights reserved.
//

import Foundation

enum Controller: Int, Codable {
    case Login = 0
    case Friend = 1
    case ChatMenu = 2
    case Chat = 4
    case SingalImage = 5
    case AllImage = 6
    case SingalImage2 = 7
}

struct ViewController {
    var curController: Controller = Controller.Login
    static var shared = ViewController()
}

