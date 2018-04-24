//
//  ViewController.swift
//  Spectator
//
//  Created by Edward de la Fuente on 4/23/18.
//  Copyright © 2018 Claitco. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImage.center.x = self.view.center.x
        logoImage.center.y = self.view.center.y
        
        logoImage.alpha = 0.0
        signInButton.alpha = 0.0
        registerButton.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.logoImage.fadeIn()
        self.signInButton.fadeIn()
        self.registerButton.fadeIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension UIView {
    func fadeIn() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
}
