//
//  CompleteProfileViewController.swift
//  Spectator
//
//  Created by Edward de la Fuente on 4/23/18.
//  Copyright © 2018 Claitco. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class CompleteProfileViewController: UIViewController {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUser = Auth.auth().currentUser {
            welcomeLabel.text = "Welcome \(String(describing: currentUser.displayName))"
        }
        
        if let _ = FBSDKAccessToken.current()
        {
            fetchUserProfile()
        }
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
                    self.welcomeLabel.text = "Welcome \(userName)"
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
