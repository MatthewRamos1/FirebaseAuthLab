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
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var toggleStateButton: UIButton!
    
    private var currentState: LoginState = .existingUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func toggleStatePressed(_ sender: UIButton) {
        let logIn = "Log In"
        let signUp = "Sign Up"
        if currentState == .existingUser {
            logInButton.titleLabel?.text = signUp
            toggleStateButton.titleLabel?.text = logIn
            currentState = .newUser
        } else {
            logInButton.titleLabel?.text = logIn
            toggleStateButton.titleLabel?.text = signUp
            currentState = .existingUser
        }
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(title: "Missing Fields", message: "Please complete all fields before logging in.")
            return
        }
        continueLoginFlow(email: email, password: password)
    }
    
    private func continueLoginFlow(email: String, password: String) {
        if currentState == .existingUser {
            AuthenticationSession.shared.signExistingUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.navigateToMainView()
                    }
                }
            }
        } else {
            AuthenticationSession.shared.createNewUser(email: email, password: password) { [weak self] (result)
                in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error", message: error.localizedDescription)
                    }
                case .success(let result):
                    self?.createDatabaseUser(authDataResult: result)
                }
            }
        }
    }
    
    private func createDatabaseUser(authDataResult: AuthDataResult) {
        DatabaseService.shared.createDatabaseUser(authDataResult: authDataResult) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Account error", message: error.localizedDescription)
                }
            case .success:
                DispatchQueue.main.async {
                    self?.navigateToMainView()
                }
            }
        }
    }
    
    private func navigateToMainView() {
        UIViewController.showViewController(storyBoardName: "Main", viewControllerId: "ProfileViewController")
    }
    
    
    
}
