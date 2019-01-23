//
//  ViewController.swift
//  Wishop
//
//  Created by Lucien Dagher Hayeck on 1/29/17.
//  Copyright © 2017 Wishop. All rights reserved.
//

import UIKit

class PayementViewController: UIViewController {
    
    var amazonProductArray = [[AmazonProduct]]()
    let p = ProductAdvertisingApi()
    var recipeArray = [Recipe]()
    var create = ["":""]
    var cart = ["":""]
    var totalPrice = 0.0
    
    @IBOutlet weak var payementButton: UIButton!
    @IBOutlet weak var backbutton: UIBarButtonItem!
    @IBOutlet weak var priceExponent: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var payementView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payementButton.titleLabel?.textAlignment = NSTextAlignment.center
        payementButton.clipsToBounds = true
        payementView.layer.borderWidth = 1
        payementView.layer.cornerRadius = 5
        payementView.layer.borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1).cgColor
        let a = String(totalPrice)
        
        if a.range(of: ".") != nil {
            var arr = a.components(separatedBy: ".")
            priceLabel.text = arr[0]
            priceExponent.text = "," + arr[1] + "€"
            
        } else {
            priceLabel.text = a
            priceExponent.text = ",00€"
            
        }
        
        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: BasketViewController.self) {
                _ = self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
        
    }
    
    func getAmazonCart(){
        
        self.create = self.p.CreateCart(ASIN: self.amazonProductArray[0][0].productASIN , quantity: "1")
        
        
        if let cartId = self.create["CartId"] {
            if let hmac = self.create["URLEncodedHMAC"] {
                var c = 0
                for _ in self.recipeArray {
                    for r in self.amazonProductArray[c] {
                        if (r.productASIN != amazonProductArray[0][0].productASIN){
                            _ = self.p.AddCart(cartId: cartId, HMAC: hmac, ASIN: r.productASIN, quantity: "1")
                        }
                    }
                    c = c + 1
                }
                self.cart = self.p.GetCart(cartId: cartId, HMAC: hmac)
            }
        }
        
        
        if let purchaseURL = self.cart["PurchaseURL"] {
            let url = Foundation.URL(string: purchaseURL)
            print(purchaseURL)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
            
            
        }
        
    }
    

    
    @IBAction func continuerClicked(_ sender: Any) {
        getAmazonCart()
    }
    
    
}

