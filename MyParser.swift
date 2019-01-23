//
//  MyParser.swift
//  AwsSigning
//
//  Created by Samer Azar on 2/28/17.
//  Copyright © 2017 Samer Azar. All rights reserved.
//

import Foundation

class MyParser : NSObject, XMLParserDelegate {
    
    var currentElement:String = ""
    var foundCharacters = ""
    weak var parent:MyParser? = nil
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }
    
}

