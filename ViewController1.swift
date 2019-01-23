//
//  ViewController1.swift
//  Wishop
//
//  Created by Lucien Dagher Hayeck on 3/7/17.
//  Copyright © 2017 Wishop. All rights reserved.
//

import Foundation
import UIKit

/* class SamerCreateCart {

let a = AwsSigning()
var create = a.CreateCart(ASIN: "B01LYQCHJI", quantity: "1")

//  let itemSearch = a.itemSearch(keywords: "Riz")
//  print(itemSearch)

if let cartId = create["CartId"]
{
    if let hmac = create["HMAC"]
    {
        _ = a.AddCart(cartId: cartId, HMAC: hmac, ASIN: "B005JNT6LM", quantity: "1")
        _ = a.AddCart(cartId: cartId, HMAC: hmac, ASIN: "B013P897UW", quantity: "1")
        
        var cart = a.GetCart(cartId: cartId, HMAC: hmac)
        
        if let purchaseURL = cart["PurchaseURL"]
        {
            let url = Foundation.URL(string: purchaseURL)
            print(purchaseURL)
            if #available(iOS 10.0, *)
            {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
    }
}
}*/
