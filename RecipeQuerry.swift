//
//  RecipeQuerry.swift
//  Amazon
//
//  Created by Samer Azar on 4/5/17.
//  Copyright © 2017 Samer Azar. All rights reserved.
//

import Foundation

class Root : MyParser {
    
    var recettes = [Recette]()
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "recette" {
            let recette = Recette()
            self.recettes.append(recette)
            parser.delegate = recette
            recette.parent = self
        }
    }
    
}


class Recette : MyParser {
    
    var id = ""
    var title = ""
    var urlPhoto = ""
    var ingredients = [Ingredient]()
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "ingredient" {
            let ingredient = Ingredient()
            self.ingredients.append(ingredient)
            parser.delegate = ingredient
            ingredient.parent = self
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "id" {
            self.id = foundCharacters
        }
        else if elementName == "t" {
            self.title = foundCharacters
        }
            
        else if elementName == "url" {
            self.urlPhoto = foundCharacters
        }
            
        else if elementName == "recette" {
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
        
    }
    
    
}

class Ingredient : MyParser {
    
    var id = ""
    var title =  ""
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "id" {
            self.id = foundCharacters
        }
        else if elementName == "t" {
            self.title = foundCharacters
        }
            
        else if elementName == "ingredient"{
            parser.delegate = self.parent as XMLParserDelegate?
        }
        foundCharacters = ""
        
    }
    
}
