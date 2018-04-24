//
//  LoginViewController.swift
//  Spectator
//
//  Created by Edward de la Fuente on 4/23/18.
//  Copyright © 2018 Claitco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailPasswordCheckLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailPasswordCheckLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailDidBeginEditing(_ sender: UITextField) {
        self.emailPasswordCheckLabel.text = ""
    }
    
    @IBAction func passwordDidBeginEditing(_ sender: UITextField) {
        self.emailPasswordCheckLabel.text = ""
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){
            (user, error) in
            
            if error != nil {
                print(error!)
                self.emailPasswordCheckLabel.text = "Username and/or password not found"
                SVProgressHUD.dismiss()
            } else {
                print("Login successful")
                self.emailPasswordCheckLabel.text = ""
                SVProgressHUD.dismiss()
                
                self.performSegue(withIdentifier: "goToDashboard", sender: self)
            }
        }
    }
    
    @IBAction func facebookLogin(_ sender: UIButton) {
        
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
                
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "navDashboard") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
                
//                self.performSegue(withIdentifier: "goToDashboard", sender: self)
//                self.dismiss(animated: true, completion: nil)
                
            })
        }
                
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
