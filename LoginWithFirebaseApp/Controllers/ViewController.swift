//
//  ViewController.swift
//  LoginWithFirebaseApp
//
//  Created by Hiroshi.Nakai on 2022/07/06.
//

import UIKit
import Firebase
import PKHUD



class ViewController: UIViewController {

    @IBOutlet weak var emsilTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
    }

    private func setupViews() {
        registerButton.layer.cornerRadius = 10
        registerButton.isEnabled = false
        registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)

        emsilTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
    }

    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func showKeyboard(notification: Notification) {

        let w = notification.userInfo![UIResponder.keyboardIsLocalUserInfoKey]


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


    @IBAction func TappedToAleadyAccountButton(_ sender: Any) {

        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(identifier: "LoginViewController") as! LoginViewController

        navigationController?.pushViewController(viewController, animated: true)

    }


    @IBAction func tappedRegisterButton(_ sender: Any) {
        handleAuthToFirebase()
    }

    private func handleAuthToFirebase() {
        HUD.show(.progress, onView: view)
        guard let email = emsilTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        Auth.auth().createUser(withEmail: email, password: password) { res, err in
            if let err = err {
                print("?????????????????????????????????????????????\(err)")
                HUD.hide{ ( _ ) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }
            print("?????????????????????????????????????????????")

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
                print("FireStore?????????????????????????????????\(err)")
                HUD.hide{ ( _ ) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }

            self.fetchUserInfoFromFirestrore(userRef: userRef)

        }
    }

    private func fetchUserInfoFromFirestrore(userRef: DocumentReference) {
        userRef.getDocument { (snapshot, err) in
            if let err = err {
                print("????????????????????????????????????????????????\(err)")
                HUD.hide{ ( _ ) in
                    HUD.flash(.error, delay: 1)
                }
                return
            }

            guard let data = snapshot?.data() else { return }
            let user = User.init(dic: data)

            print("????????????????????????????????????????????????\(user.name)")
            HUD.hide{ ( _ ) in
                HUD.flash(.success, onView: self.view, delay: 1) { (_) in
                    self.presentToHomeViewController(user: user)
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



extension ViewController: UITextFieldDelegate {
    // ???????????????
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
