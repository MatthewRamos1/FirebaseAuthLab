//
//  ViewController.swift
//  FirebaseAuthLab
//
//  Created by Matthew Ramos on 3/11/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func updatePressed(_ sender: UIButton) {
        guard let displayName = displayNameField.text, !displayName.isEmpty, let email = emailField.text, !email.isEmpty, let phoneNum = phoneNumField.text, !phoneNum.isEmpty else {
            showAlert(title: "Missing Fields", message: "Please complete all fields before updating.")
            return
        }
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.displayName = displayName
        request?.commitChanges { [unowned self] (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error updating profile", message: error.localizedDescription)
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Profile Update", message: "Profile successfully updated.")
                }
            }
        }
    }
    
    private func updateUI() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        emailField.text = user.email
        displayNameField.text = user.displayName
        phoneNumField.text = user.phoneNumber
    }
}
