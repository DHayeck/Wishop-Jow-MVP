//
//  Recipe.swift
//  Wishop
//
//  Created by Lucien Dagher Hayeck on 3/14/17.
//  Copyright © 2017 Wishop. All rights reserved.
//

import UIKit

class Recipe {
    var recipeTitle: String! = nil
    var recipeImage: UIImage! = nil
    var recipeIngredients: [String]? = nil
    
    init(title: String, image: UIImage, ingredients: [String]){
        recipeTitle = title
        recipeImage = image
        recipeIngredients = ingredients
    }
    
}
