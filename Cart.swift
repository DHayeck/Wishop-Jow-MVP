//
//  Cart.swift
//  Amazon
//
//  Created by Samer Azar on 4/5/17.
//  Copyright © 2017 Samer Azar. All rights reserved.
//


import Foundation

class Cart : MyParser {
    
    var cartId = ""
    var hmac = ""
    var urlEncodedHMAC = ""
    var purchaseURL = ""
    var cartItems = CartItems()
    
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "CartItems" {
            parser.delegate = self.cartItems
            self.cartItems.parent = self
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "CartId" {
            self.cartId = foundCharacters
        }
        else if elementName == "HMAC" {
            self.hmac = foundCharacters
        }
            
        else if elementName == "URLEncodedHMAC" {
            self.urlEncodedHMAC = foundCharacters
        }
        else if elementName == "PurchaseURL" {
            self.purchaseURL = foundCharacters
        }
        else if elementName == "Cart" {
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
    }
}

class CartItems : MyParser {
    
    var subTotal = SubTotal()
    var cartItems = [CartItem]()
    
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "CartItem" {
            let cartItem = CartItem()
            self.cartItems.append(cartItem)
            parser.delegate = cartItem
            cartItem.parent = self
        } else if elementName == "SubTotal" {
            parser.delegate = self.subTotal
            self.subTotal.parent = self
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "CartItems" {
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
    }
    
    
}

class SubTotal : MyParser {
    
    var formattedPrice = ""
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "FormattedPrice" {
            self.formattedPrice = foundCharacters
        }
        if elementName == "SubTotal" {
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
    }
    
}

class CartItem : MyParser {
    
    var asin = ""
    var quantity = ""
    var title = ""
    var productGroup = ""
    var price = Price()
    
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "Price" {
            parser.delegate = price
            price.parent = self
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "ASIN" {
            self.asin = foundCharacters
        }
        else if elementName == "Quantity" {
            self.quantity = foundCharacters
        }
            
        else if elementName == "Title" {
            self.title = foundCharacters
        }
        else if elementName == "ProductGroup" {
            self.productGroup = foundCharacters
        }
        else if elementName == "CartItem" {
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
    }
    
    
}

class Price : MyParser {
    
    var amount = ""
    var currencyCode = ""
    var formattedPrice = ""
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Amount" {
            self.amount = foundCharacters
        } else if elementName == "CurrencyCode" {
            self.currencyCode = foundCharacters
        } else if elementName == "FormattedPrice" {
            self.formattedPrice = foundCharacters
        }else if elementName == "Price" {
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
    }
}
