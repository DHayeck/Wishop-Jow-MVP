//
//  ViewController.swift
//  Wishop
//
//  Created by Lucien Dagher Hayeck on 1/29/17.
//  Copyright © 2017 Wishop. All rights reserved.
//

import UIKit

class DemarrerViewController: UIViewController {
    
    @IBOutlet weak var demarrerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        demarrerButton.layer.borderWidth = 1.0
        demarrerButton.layer.borderColor = UIColor.clear.cgColor
        demarrerButton.layer.cornerRadius = 30
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}

