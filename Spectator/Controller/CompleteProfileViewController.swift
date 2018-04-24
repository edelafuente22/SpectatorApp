//
//  CompleteProfileViewController.swift
//  Spectator
//
//  Created by Edward de la Fuente on 4/23/18.
//  Copyright © 2018 Claitco. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import SVProgressHUD

class CompleteProfileViewController: UIViewController {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUser = Auth.auth().currentUser {
        }
        
        if let _ = FBSDKAccessToken.current()
        {
            fetchUserProfile()
        }
        
        userAvatar.makeCircle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUserProfile()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error took place: \(String(describing: error))")
                
            }
            else
            {
                guard let data = result as? [String : Any] else {
                    return
                }
                
                print("Print entire fetched result: \(String(describing: result))")
                
                let id = data["id"]
                print("User ID is: \(String(describing: id))")
                
                if let userName = data["name"] {
                    self.nameField.text = "\(userName)"
                }
                
                if let profilePictureObj = data["picture"] as? NSDictionary
                {
                    let data = profilePictureObj.value(forKey: "data") as! NSDictionary
                    let pictureUrlString  = data.value(forKey: "url") as! String
                    let pictureUrl = NSURL(string: pictureUrlString)
                    
                    let background = DispatchQueue.global()
                    background.async() {
                        
                        let imageData = NSData(contentsOf: pictureUrl! as URL)
                        
                        DispatchQueue.main.async() {
                            if let imageData = imageData
                            {
                                let userProfileImage = UIImage(data: imageData as Data)
                                self.userAvatar.image = userProfileImage
                                self.userAvatar.contentMode = UIViewContentMode.scaleAspectFit
                            }
                        }
                    }
                }
            }
        })
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        
        SVProgressHUD.show()
        
        let finishProfile = Auth.auth().currentUser?.createProfileChangeRequest()
        finishProfile?.displayName = nameField.text!
        
        finishProfile?.commitChanges {
            (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Profile changes saved successfully")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChooseTeams", sender: self)
            }
        }
    }
    

}

extension UIImageView {
    
    func makeCircle() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
    }
}

