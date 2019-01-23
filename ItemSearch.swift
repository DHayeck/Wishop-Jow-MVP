//
//  ItemSearch.swift
//  Amazon
//
//  Created by Samer Azar on 4/5/17.
//  Copyright © 2017 Samer Azar. All rights reserved.
//

import Foundation

class Items : MyParser {
    
    var items = [Item]()
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "Item" {
            let item = Item()
            self.items.append(item)
            parser.delegate = item
            item.parent = self
        }
    }
    
}


class Item : MyParser {
    
    var asin = ""
    let smallImage = SmallImage()
    let itemAttributes = ItemAttributes()
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "SmallImage" {
            parser.delegate = self.smallImage
            self.smallImage.parent = self
        } else if elementName == "ItemAttributes" {
            parser.delegate = self.itemAttributes
            self.itemAttributes.parent = self
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "ASIN" {
            self.asin = foundCharacters
        } else if elementName == "Item" {
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
        
    }
    
}

class SmallImage : MyParser {
    var url = ""
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "URL" {
            self.url = foundCharacters
        } else if elementName == "SmallImage" {
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
        
    }
    
}

class ItemAttributes : MyParser {
    
    var brand = ""
    var feature = ""
    var title = ""
    var size = ""
    var productGroup = ""
    
    let itemDimensions = ItemDimensions()
    let listPrice = ListPrice()
    
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "ListPrice" {
            parser.delegate = self.listPrice
            self.listPrice.parent = self
        } else if elementName == "ItemDimensions" {
            parser.delegate = self.itemDimensions
            self.itemDimensions.parent = self
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Brand" {
            self.brand = foundCharacters
        } else if elementName == "Feature" {
            self.feature = foundCharacters
        } else if elementName == "Title" {
            self.title = foundCharacters
        } else if elementName == "Size" {
            self.size = foundCharacters
        } else if elementName == "ProductGroup" {
            self.productGroup = foundCharacters
        } else if elementName == "ItemAttributes" {
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
        
    }
    
}

class ItemDimensions : MyParser {
    
    var weight = " "
    var units = " "
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "Weight" {
            if let units = attributeDict["Units"] {
                self.units = units
            }
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Weight" {
            self.weight = foundCharacters
        } else if elementName == "ItemDimensions" {
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
    }
    
    
    
    
}


class ListPrice : MyParser {
    
    var formattedPrice = ""
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "FormattedPrice" {
            self.formattedPrice = foundCharacters
        } else if elementName == "ListPrice" {
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
    }
}

