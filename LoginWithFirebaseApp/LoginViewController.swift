//
//  LoginViewController.swift
//  LoginWithFirebaseApp
//
//  Created by Hiroshi.Nakai on 2022/07/08.
//

import UIKit
import Firebase
import PKHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!

    @IBOutlet weak var LoginBtn: UIButton!
    
    @IBOutlet weak var DontHaveAccount: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        LoginBtn.layer.cornerRadius = 10
        LoginBtn.isEnabled = false
        LoginBtn.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)

        emailText.delegate = self
        passwordText.delegate = self


    }

    @IBAction func tappedDontHaveAccount(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TappedLogin(_ sender: Any) {

        HUD.show(.progress, onView: self.view)

        guard let email = emailText.text else { return }
        guard let pass = passwordText.text else { return }

        Auth.auth().signIn(withEmail: email, password: pass) { (res, err) in
            if let err = err {
                print("ログイン情報の取得に失敗しました。\(err)")
                return
            }
            print("ログインに成功しました。")

            guard let uid = Auth.auth().currentUser?.uid else { return }
            let userRef = Firestore.firestore().collection("users").document(uid)

            userRef.getDocument { (snapshot, err) in
                if let err = err {
                    print("ユーザ情報の取得に失敗しました。\(err)")
                    HUD.hide{ ( _ ) in
                        HUD.flash(.error, delay: 1)
                    }
                    return
                }

                guard let data = snapshot?.data() else { return }
                let user = User.init(dic: data)

                print("ユーザー情報の取得が出来ました。\(user.name)")
                HUD.hide{ ( _ ) in
                    HUD.flash(.success, onView: self.view, delay: 1) { (_) in
                        self.presentToHomeViewController(user: user)
                    }
                }



            }


        }
    }

    private func presentToHomeViewController(user: User) {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyBoard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController

        homeViewController.user = user
        homeViewController.modalPresentationStyle = .fullScreen

        self.present(homeViewController, animated: true, completion: nil)

    }

}


extension LoginViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailText.text?.isEmpty ?? true
        let passwordIsEmpty = passwordText.text?.isEmpty ?? true

        if emailIsEmpty || passwordIsEmpty  {
            LoginBtn.isEnabled = false
            LoginBtn.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        } else {
            LoginBtn.isEnabled = true
            LoginBtn.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
        }
    }
}


