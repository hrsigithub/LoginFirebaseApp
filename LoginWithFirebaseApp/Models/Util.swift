//
//  Util.swift
//  LoginWithFirebaseApp
//
//  Created by Hiroshi.Nakai on 2022/07/10.
//

import Foundation
import UIKit

class Util {

    static func dateFormatterForCreateAt(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")

        return formatter.string(from: date)
    }


}
