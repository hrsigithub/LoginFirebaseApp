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

            let dateStiing = Util.dateFormatterForCreateAt(date: user.createAt.dateValue())
            dateLabel.text = "作成日： " + dateStiing

        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        confirmLoggedUser()

    }

    private func confirmLoggedUser() {
        if Auth.auth().currentUser?.uid == nil || user == nil {

            presentToSignUpVC()

        }
    }

    private func presentToSignUpVC () {
        let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "ViewController") as! ViewController

        let nav = UINavigationController(rootViewController: vc)

        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)


    }

    @IBAction func taptoLogoutButton(_ sender: Any) {
        Logout()
    }

    private func Logout() {
        do {
            try Auth.auth().signOut()
            presentToSignUpVC()

        } catch(let err) {
            print("ログアウトに失敗しました。\(err)")
        }
    }


}
