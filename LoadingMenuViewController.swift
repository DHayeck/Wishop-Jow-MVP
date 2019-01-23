//
//  LoadingViewController.swift
//  Wishop
//
//  Created by Lucien Dagher Hayeck on 3/19/17.
//  Copyright © 2017 Wishop. All rights reserved.
//



import UIKit
import ImageIO
import Foundation



class LoadingMenuViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loaderView: UIView!
    var r = 90
    var gameTimer: Timer!
    var recipeArray = [Recipe]()
    var recipeSuggestionArray = [Recipe]()
    var image: UIImage!
    var imageArray = [UIImage]()
    var ingredientArray = [String]()
    var originalPosition: CGPoint!
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        loaderView.layer.borderWidth = 1.0
        loaderView.layer.borderColor = UIColor.clear.cgColor
        loaderView.layer.cornerRadius = loaderView.bounds.width/2
        originalPosition = loaderView.center
    }




    
    func rotateView(targetView: UIView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi)) }) { finished in
            self.rotateView(targetView: targetView, duration: duration)
        }
    }
    
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        loadRecipes()
        self.performSegue(withIdentifier: "menu", sender: self)

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
    
    func loadRecipes() {
        
        rotateView(targetView: imageView, duration: 0.5)
        let URL = Foundation.URL(string:"http://wishop.netne.net/Recipes.php")
        
        if recipeArray.isEmpty == false {
            recipeArray.removeAll()
        }
        
        if (URL != nil)
        {
            do
            {
                let s:NSString =  try NSString(contentsOf: URL!, encoding:String.Encoding.utf8.rawValue)
                let xmlData = s.data(using: String.Encoding.utf8.rawValue)!
                let parser = XMLParser(data: xmlData)
                let root = Root()
                parser.delegate = root
                parser.parse()
                var i = 0
                for r0 in root.recettes
                {
                    if ( (nbMeal <= recipeArray.count) && (recipeSuggestionArray.count < 3)){
                        createImageArray(urlString: r0.urlPhoto)
                        ingredientArray.removeAll()
                        for r1 in r0.ingredients {
                            
                            ingredientArray.append(r1.title)
                            
                        }
                        let recipe = Recipe(title: r0.title,image: imageArray[i], ingredients: ingredientArray)
                        recipeSuggestionArray.append(recipe)
                        i = i + 1
                    }
                    
                    if (recipeArray.count < nbMeal) {
                        createImageArray(urlString: r0.urlPhoto)
                        ingredientArray.removeAll()
                        for r1 in r0.ingredients {
                            
                            ingredientArray.append(r1.title)
                            
                        }
                        let recipe = Recipe(title: r0.title,image: imageArray[i], ingredients: ingredientArray)
                        recipeArray.append(recipe)
                        i = i + 1
                    }
                }
            } catch let error as  NSError {
                print ("Error: \(error.domain) \(error.code)")
            }
        
        }
        
    }
    
    @IBAction func pan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        
        sender.setTranslation(CGPoint.zero, in: self.view)

    }
    
    func createImageArray(urlString: String){
        let url = URL(string: urlString)
        
        
        let data = NSData.init(contentsOf: url!)
        let src = CGImageSourceCreateWithData(data!, nil)
        
        if (src != nil) {
            let l = CGImageSourceGetCount(src!)
            for i in 0..<l {
                let img = CGImageSourceCreateImageAtIndex(src!, i, nil)!
                imageArray.append(UIImage.init(cgImage: img))
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.image = UIImage(named: "back")
        navigationItem.backBarButtonItem = .none
        navigationItem.backBarButtonItem = backItem
        
            
        self.navigationItem.title = ""
        if segue.identifier == "menu" {
            let m = segue.destination as? MenuViewController
            m?.recipeArray = recipeArray
            m?.recipeSuggestionArray = recipeSuggestionArray
            
        }
    }

}



