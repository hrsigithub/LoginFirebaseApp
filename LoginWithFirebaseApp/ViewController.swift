//
//  ViewController.swift
//  LoginWithFirebaseApp
//
//  Created by Hiroshi.Nakai on 2022/07/06.
//

import UIKit

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


    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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


        print(":", textField.text)
    }
}
