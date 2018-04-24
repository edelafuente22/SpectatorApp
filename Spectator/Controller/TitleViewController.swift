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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImage.center.x = self.view.center.x
        logoImage.center.y = self.view.center.y
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

