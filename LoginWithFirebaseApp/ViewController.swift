//
//  ViewController.swift
//  LoginWithFirebaseApp
//
//  Created by Hiroshi.Nakai on 2022/07/06.
//

import UIKit
import Firebase

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

            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let name = self.usernameTextField.text else { return }

            let docData = ["email": email, "name": name, "createAt": Timestamp()] as [String : Any]

            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                if let err = err {
                    print("FireStoreの保存に失敗しました。\(err)")
                    return
                }

                print("FireStoreの保存に成功しました。")



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
