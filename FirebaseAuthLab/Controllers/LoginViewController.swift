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
    
    private var currentState: LoginState = .newUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
      UIViewController.showViewController(storyBoardName: "MainView", viewControllerId: "ProfileViewController")
    }

    
    
}
