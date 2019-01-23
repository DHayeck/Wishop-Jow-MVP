//
//  ViewController.swift
//  Test
//
//  Created by Lucien Dagher Hayeck on 12/31/16.
//  Copyright © 2016 Lucien Dagher Hayeck. All rights reserved.
//

import UIKit


class ChooseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var gradientLayer: CAGradientLayer!
    
    var recipeSuggestionArray = [Recipe]()
    var recipeArray = [Recipe]()
    var tag = Int()
    var choose = false
    var replace = false
    @IBOutlet weak var annuler: UIBarButtonItem!
    var i: String = ""

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLaunch()
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.collectionView.backgroundColor = UIColor.clear
        self.navigationController?.isNavigationBarHidden = true

        self.viewDidLayoutSubviews()
    }
    
    @IBAction func annulerClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func garderClicked(_ sender: AnyObject) {
        tag = sender.tag
        performSegue(withIdentifier: "unwindChoose", sender: self)
        self.dismiss(animated: true, completion: nil)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    func firstLaunch () {
        let launchedBefore = UserDefaults.standard.bool(forKey: "LaunchedBefore")
        
        if launchedBefore {
            print("Not first launch.")
        }
            
        else {
            print ("First launch, settin NSUserDefault.")
            UserDefaults.standard.set(true, forKey: "LaunchedBefore")
        }
        

    }
    
    

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = self.collectionView.contentInset
        let value = (self.view.frame.size.width - (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        insets.left = value
        insets.right = value
        self.collectionView.contentInset = insets
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeSuggestionArray.count;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickerCell", for: indexPath) as! PickerCell
        cell.containerView.layer.borderWidth = 1
        cell.containerView.layer.borderColor = UIColor.clear.cgColor
        cell.containerView.layer.cornerRadius = 15
        cell.garderButton.tag = indexPath.row
        cell.imageView.image = recipeSuggestionArray[indexPath.row].recipeImage
        cell.recipeTitle.text = recipeSuggestionArray[indexPath.row].recipeTitle
        
        if (choose){
            cell.garderButton.setTitle("Ajouter Ce Plat", for: .normal)
        }
        
        if (replace) {
            cell.garderButton.setTitle("Garder Ce Plat", for: .normal)
        }
        
        i = ""
        var c0 = 0
        for ingredient in recipeSuggestionArray[indexPath.row].recipeIngredients! {
            c0 = c0 + 1
            if (c0 == recipeSuggestionArray[indexPath.row].recipeIngredients!.count) {
                i += ingredient
            } else {
                i += ingredient + ", "
                
            }
        }
        cell.recipeIngredients.text = i
        
        return cell;
    }
 
}

