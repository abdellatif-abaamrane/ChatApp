//
//  Validation.swift
//  ByChat
//
//  Created by macbook-pro on 25/05/2020.
//

import UIKit




class Validation: NSObject {
    let loginButton : UIButton
    let passwordField : UITextField
    let emailField : UITextField

    init(emailField: UITextField,
         passwordField: UITextField,loginButton: UIButton) {
        self.emailField = emailField
        self.passwordField = passwordField
        self.loginButton = loginButton
        super.init()
        UIView.animate(withDuration: 0.4) {
            loginButton.alpha = 0.5
        }
        loginButton.isEnabled = false
        passwordField.delegate = self
        emailField.delegate = self
    }
    
}
extension Validation: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let password = passwordField.text,
           let email = emailField.text,
           email.isValidEmail(),
           password.isValidPassword() {
            UIView.animate(withDuration: 0.4) {
                self.loginButton.alpha = 1
            }
            loginButton.isEnabled = true
        } else {
            UIView.animate(withDuration: 0.4) {
                self.loginButton.alpha = 0.5
            }
            loginButton.isEnabled = false
        }
    }
}

class RegisterValidation:  NSObject {
    let registerButton : UIButton
    let profileImage : UIButton
    let passwordField : UITextField
    let emailField : UITextField
    let fullnameField : UITextField
    let usernameField : UITextField
    init(emailField: UITextField,
         passwordField: UITextField,
         fullnameField: UITextField,
         usernameField: UITextField,
         profileImage: UIButton,
         registerButton: UIButton) {
        self.emailField = emailField
        self.passwordField = passwordField
        self.fullnameField = fullnameField
        self.usernameField = usernameField
        self.profileImage = profileImage
        self.registerButton = registerButton
        super.init()
        UIView.animate(withDuration: 0.4) {
            registerButton.alpha = 0.5
        }
        registerButton.isEnabled = false
        passwordField.delegate = self
        emailField.delegate = self
    }
    
}
extension RegisterValidation: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let password = passwordField.text,
           let email = emailField.text,
           let fullname = fullnameField.text,
           let username = usernameField.text,
           username.isValidUsername(),
           fullname.isValidFullname(),
           email.isValidEmail(),
           profileImage.isValidProfileImage(),
           password.isValidPassword() {
            UIView.animate(withDuration: 0.4) {
                self.registerButton.alpha = 1
            }
            registerButton.isEnabled = true
        } else {
            UIView.animate(withDuration: 0.4) {
                self.registerButton.alpha = 0.5
            }
            registerButton.isEnabled = false
        }
    }
}
