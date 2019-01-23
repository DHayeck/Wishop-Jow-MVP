//
//  AmazonProduct.swift
//  Wishop
//
//  Created by Samer Azar on 4/12/17.
//  Copyright © 2017 Wishop. All rights reserved.
//

import Foundation
import UIKit

class AmazonProduct {
    var productASIN: String! = nil
    var productTitle: String! = nil
    var productImage: UIImage! = nil
    var productCategory: String! = nil
    var productBrand: String! = nil
    var productPrice: String! = nil
    var productPriceCurrency: String! = nil
    var productQuantity: String! = nil

    
    init(asin: String, title: String, image: UIImage, category: String, brand: String, price: String, priceCurrency: String, quantity: String){
        productASIN = asin
        productTitle = title
        productImage = image
        productCategory = category
        productBrand = brand
        productPrice = price
        productPriceCurrency = priceCurrency
        productQuantity = quantity
    }

}
