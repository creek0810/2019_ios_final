//
//  User.swift
//  2019_ios_final
//
//  Created by 王心妤 on 2019/5/30.
//  Copyright © 2019 river. All rights reserved.
//

import Foundation

struct User{
    static var shared = User(id: "", password: "")
    var id: String
    var password: String
}
