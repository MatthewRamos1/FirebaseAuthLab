//
//  LoginViewController.swift
//  FirebaseAuthLab
//
//  Created by Matthew Ramos on 3/14/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth

enum LoginState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var currentState: LoginState = .existingUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
    }
}
