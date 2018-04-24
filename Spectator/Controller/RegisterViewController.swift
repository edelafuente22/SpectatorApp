//
//  RegisterViewController.swift
//  Spectator
//
//  Created by Edward de la Fuente on 4/23/18.
//  Copyright © 2018 Claitco. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD
import FBSDKLoginKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailPasswordCheck: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var emailValid: Bool = false
    var passwordValid: Bool = false
    var confirmValid: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailPasswordCheck.text = ""

        registerButton.isEnabled = false
        registerButton.alpha = 0.3
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailEditingDidEnd(_ sender: UITextField) {
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: emailTextField.text!)
        
        if isEmailAddressValid {
            print("Email address is valid")
            emailValid = true
            emailPasswordCheck.text = ""
            checkFields()
        } else {
            print("Email address is not valid")
            emailPasswordCheck.text = "Please enter a valid email address"
        }
    }
    
    @IBAction func passwordEditingDidEnd(_ sender: UITextField) {
        let isPasswordValid = isValidPassword(passwordString: passwordTextField.text!)
        
        if isPasswordValid {
            print("Password is valid")
            emailPasswordCheck.text = ""
            passwordValid = true
            checkFields()
        } else {
            print("Password is not valid")
            emailPasswordCheck.text = "Password must be at least 8 characters and contain 1 letter and 1 number"
        }
    }
    
    @IBAction func confirmEditingDidEnd(_ sender: UITextField) {
        if passwordTextField.text == confirmPasswordTextField.text {
            emailPasswordCheck.text = ""
            confirmValid = true
            checkFields()
        } else {
            print("Passwords do not match")
            emailPasswordCheck.text = "Passwords do not match"
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            
            if error != nil {
                print(error!)
            } else {
                print("Registration successful")
                
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToCompleteProfile", sender: self)
            }
        }
    }
    
    @IBAction func facebookSignUp(_ sender: UIButton) {
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: {
                (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "completeProfile") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
        }
    }
    
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func isValidPassword(passwordString: String) -> Bool {
        
        var passwordValue = true
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        
        do {
            let regex = try NSRegularExpression(pattern: passwordRegEx)
            let nsString = passwordString as NSString
            let results = regex.matches(in: passwordString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                
                passwordValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            passwordValue = false
        }
        
        return passwordValue
    }
    
    func checkFields() {
        if emailValid == true && passwordValid == true && confirmValid == true {
            registerButton.isEnabled = true
            registerButton.alpha = 1.0
        } else {
            registerButton.isEnabled = false
        }
    }

}
