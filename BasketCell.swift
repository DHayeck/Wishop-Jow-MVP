//
//  BasketCell.swift
//  Wishop
//
//  Created by Lucien Dagher Hayeck on 4/7/17.
//  Copyright © 2017 Wishop. All rights reserved.
//


import UIKit

class BasketCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productPackaging: UILabel!
    @IBOutlet weak var changeProductView: UIView!
    
    @IBOutlet weak var priceExponentLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageContainer: UIView!
}
