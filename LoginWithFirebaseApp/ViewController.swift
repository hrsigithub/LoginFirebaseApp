//
//  ViewController.swift
//  LoginWithFirebaseApp
//
//  Created by Hiroshi.Nakai on 2022/07/06.
//

import UIKit
import Firebase

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


class ViewController: UIViewController {

    @IBOutlet weak var emsilTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        registerButton.layer.cornerRadius = 10

        registerButton.isEnabled = false
        registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)


        emsilTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard),
                                                name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard),
                                                name: UIResponder.keyboardWillShowNotification, object: nil)
 }

    @objc func showKeyboard(notification: Notification) {

//        let keyboardFrame = (notification.userInfo![UIResponder.keyboardIsLocalUserInfoKey] as AnyObject).cgRectValue
//        guard let keyboardMinY = keyboardFrame?.minY else { return }

//        let registerButtonMaxY = registerButton.frame.maxY
//        let distance = registerButtonMaxY - keyboardMinY + 20
//        let transform = CGAffineTransform(translationX: 0, y: -distance)

//        UIView.animate(withDuration: 0.5
//                       , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: []) {
//            self.view.transform = transform
//        }

    }

    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.5
                       , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: []) {
            self.view.transform = .identity
        }

    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    @IBAction func tappedRegisterButton(_ sender: Any) {
        handleAuthToFirebase()
    }

    private func handleAuthToFirebase() {
        guard let email = emsilTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { res, err in
            if let err = err {
                print("認証情報の保存に失敗しました。\(err)")
                return
            }
            print("認証情報の保存に成功しました。")

            self.addUserInfoToFirestore(email: email)

        }
    }

    private func addUserInfoToFirestore(email: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let name = self.usernameTextField.text else { return }

        let docData = ["email": email, "name": name, "createAt": Timestamp()] as [String : Any]
        let userRef = Firestore.firestore().collection("users").document(uid)

        userRef.setData(docData) { (err) in
            if let err = err {
                print("FireStoreの保存に失敗しました。\(err)")
                return
            }

            print("FireStoreの保存に成功しました。")

            userRef.getDocument { (snapshot, err) in
                if let err = err {
                    print("ユーザ情報の取得に失敗しました。\(err)")
                    return
                }

                guard let data = snapshot?.data() else { return }
                let user = User.init(dic: data)

                print("ユーザー情報の取得が出来ました。\(user.name)")

                let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                let homeViewController = storyBoard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController

                self.present(homeViewController, animated: true, completion: nil)


            }
        }
    }


}

extension ViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emsilTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? true

        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
        }
    }
}
