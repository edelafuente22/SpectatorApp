//
//  DashboardViewController.swift
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

class DashboardViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = Auth.auth().currentUser {
            let email = currentUser.email!
            self.welcomeLabel.text = "\(String(describing: email))"
        }
        
        if let _ = FBSDKAccessToken.current()
        {
            fetchUserProfile()
        }
        
        self.navigationController?.navigationBar.isHidden = false
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 176.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        
        avatar.makeCircle()

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
                    self.welcomeLabel.text = "\(userName)"
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
                                self.avatar.image = userProfileImage
                                self.avatar.contentMode = UIViewContentMode.scaleAspectFit
                            }
                        }
                    }
                }
            }
        })
    }
    @IBAction func logOut(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            
            do {
                
                try Auth.auth().signOut()
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Title")
                
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                
                print(error.localizedDescription)
                
            }
            
        }
    }
    
}
