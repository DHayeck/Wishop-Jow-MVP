//
//  LoadingBasketViewController.swift
//  Wishop
//
//  Created by Lucien Dagher Hayeck on 4/21/17.
//  Copyright © 2017 Wishop. All rights reserved.
//



import UIKit
import ImageIO
import Foundation



class LoadingBasketViewController: UIViewController {
    
    @IBOutlet weak var load: UIActivityIndicatorView!
    
    var recipeArray = [Recipe]()
    var amazonProductArray1 = [[AmazonProduct]]()
    var amazonProductArray0 = [AmazonProduct]()
    var basketIngredients = [String]()

    var productImageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        load.startAnimating()
    

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadBasket()
        self.performSegue(withIdentifier: "basket", sender: self)
        
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
    
    
    func loadBasket() {
        
        if amazonProductArray1.isEmpty == false {
            amazonProductArray1.removeAll()
        }
        if amazonProductArray0.isEmpty == false {
            amazonProductArray0.removeAll()
        }
        
        var i: Int = 0
        var j: Int = 0
        var k: Int = 0
        var numberIngredient = [Int]()
        
        for r in recipeArray {
            numberIngredient.append((r.recipeIngredients?.count)!)
            for r0 in r.recipeIngredients! {
                basketIngredients.append(r0)
            }
        }
        
        for c in basketIngredients {
            
            let URL = Foundation.URL(string: ("http://wishop.netne.net/Basket.php?Ingredient=" + c).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
            if (URL != nil)
            {
                do
                {
                    let s:NSString =  try NSString(contentsOf: URL!, encoding:String.Encoding.utf8.rawValue)
                    let xmlData = s.data(using: String.Encoding.utf8.rawValue)!
                    let parser = XMLParser(data: xmlData)
                    let root = Basket()
                    parser.delegate = root
                    parser.parse()
                    for r0 in root.basketIngredients
                    {
                        createImageArray(urlString: r0.image)
                        let amazonProduct = AmazonProduct(asin: r0.asin,title: r0.title, image: productImageArray[i], category: r0.category, brand: r0.brand, price: r0.price, priceCurrency: r0.priceCurrency, quantity: r0.quantity)
                        amazonProductArray0.append(amazonProduct)
                        i = i + 1
                    }
                    k = k + 1
                    if ( j != recipeArray.count ) {
                        if ( k == numberIngredient[j] ){
                            j = j + 1
                            k = 0
                            amazonProductArray1.append(amazonProductArray0)
                            amazonProductArray0.removeAll()
                        }
                    }
                    
                } catch let error as  NSError {
                    print ("Error: \(error.domain) \(error.code)")
                }
                
            }
        }
        
    }
    
    func createImageArray(urlString: String){
        let url = URL(string: urlString)
        
        
        let data = NSData.init(contentsOf: url!)
        let src = CGImageSourceCreateWithData(data!, nil)
        
        if (src != nil) {
            let l = CGImageSourceGetCount(src!)
            for i in 0..<l {
                let img = CGImageSourceCreateImageAtIndex(src!, i, nil)!
                productImageArray.append(UIImage.init(cgImage: img))
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "basket" {
            let b = segue.destination as? BasketViewController
            b?.amazonProductArray = amazonProductArray1
            b?.recipeArray = recipeArray
        }
    }
}


