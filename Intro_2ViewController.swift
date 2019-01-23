//
//  Intro_2ViewController.swift
//  Wishop
//
//  Created by Lucien Dagher Hayeck on 3/6/17.
//  Copyright © 2017 Wishop. All rights reserved.
//


import UIKit

class Intro_2ViewController: UIViewController {
    
    @IBOutlet weak var suivantButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suivantButton.layer.borderWidth = 1.0
        suivantButton.layer.borderColor = UIColor.clear.cgColor
        suivantButton.layer.cornerRadius = 27
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
