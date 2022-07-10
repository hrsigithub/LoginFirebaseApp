//
//  User.swift
//  LoginWithFirebaseApp
//
//  Created by Hiroshi.Nakai on 2022/07/10.
//

import UIKit
import Firebase
//import PKHUD


struct User {
    let name: String
    let createAt: Timestamp
    let email: String

    init(dic: [String: Any]) {
        self.name = dic["name"] as! String
        self.createAt = dic["createAt"] as! Timestamp
        self.email = dic["email"] as! String

    }
}
