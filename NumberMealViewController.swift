//
//  NumberMealViewController.swift
//  Wishop
//
//  Created by Lucien Dagher Hayeck on 3/19/17.
//  Copyright © 2017 Wishop. All rights reserved.
//


import UIKit
import Foundation

var nbMeal = 3

class NumberMealViewController: UIViewController {
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var nbMealLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nbMealLabel.text = String(nbMeal)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func minusClicked(_ sender: Any) {
        
        nbMeal -= 1
        plusButton.isEnabled = true
        if(nbMeal == 0){
            minusButton.isEnabled = false
        }
        nbMealLabel.text = String(nbMeal)
        
    }
    
    @IBAction func plusClicked(_ sender: Any) {
        
        nbMeal += 1
        minusButton.isEnabled = true
        if(nbMeal == 7){
            plusButton.isEnabled = false
        }
        nbMealLabel.text = String(nbMeal)
    }
    
    @IBAction func cestPartiClicked(_ sender: Any) {
        if nbMeal == 0 {
            self.performSegue(withIdentifier: "zero", sender: sender)
        } else {
            self.performSegue(withIdentifier: "load", sender: sender)
        }
    }
    
}
