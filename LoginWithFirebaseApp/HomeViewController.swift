//
//  HomeViewController.swift
//  LoginWithFirebaseApp
//
//  Created by Hiroshi.Nakai on 2022/07/07.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    var user: User? {

        // セットされたときに発火する。
        didSet {
            print("user.name", user?.name)
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButton.layer.cornerRadius = 10

        if let user = user {
            nameLabel.text = user.name + "さんようこそ"
            emailLabel.text = user.email

            let dateStiing = dateFormatterForCreateAt(date: user.createAt.dateValue())
            dateLabel.text = "作成日： " + dateStiing

        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        confirmLoggedUser()

    }

    private func confirmLoggedUser() {
        if Auth.auth().currentUser?.uid == nil || user == nil {

            presentToMainVC()

        }
    }

    private func presentToMainVC () {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "ViewController") as! ViewController

        let nav = UINavigationController(rootViewController: vc)

        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)


    }

    @IBAction func taptoLogoutButton(_ sender: Any) {
        Logout()
//        dismiss(animated: true)
    }

    private func Logout() {
        do {
        try Auth.auth().signOut()
            presentToMainVC()

        } catch(let err) {
            print("ログアウトに失敗しました。\(err)")
        }
    }


    private func dateFormatterForCreateAt(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")

        return formatter.string(from: date)
    }
}
