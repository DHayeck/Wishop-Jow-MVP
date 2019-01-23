//
//  AmazonBasket.swift
//  Wishop
//
//  Created by Samer Azar on 4/12/17.
//  Copyright © 2017 Wishop. All rights reserved.
//

import Foundation

class Basket : MyParser {
    
    var basketIngredients = [BasketIngredient]()
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "ingredient" {
            let basketIngredient = BasketIngredient()
            self.basketIngredients.append(basketIngredient)
            parser.delegate = basketIngredient
            basketIngredient.parent = self
        }
    }
    
}


class BasketIngredient : MyParser {
    
    var asin = ""
    var category = ""
    var title =  ""
    var brand = ""
    var quantity = ""
    var price = ""
    var priceCurrency = ""
    var image = ""
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "asin" {
            self.asin = foundCharacters
        } else if elementName == "category" {
            self.category = foundCharacters
        } else if elementName == "t" {
            self.title = foundCharacters
        } else if elementName == "brand" {
            self.brand = foundCharacters
        } else if elementName == "quantity" {
            self.quantity = foundCharacters
        } else if elementName == "price" {
            self.price = foundCharacters
        } else if elementName == "currency" {
            self.priceCurrency = foundCharacters
        } else if elementName == "image" {
            self.image = foundCharacters
        } else if elementName == "ingredient"{
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
        
    }
    
}
