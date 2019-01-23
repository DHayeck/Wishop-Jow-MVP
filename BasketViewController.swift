//
//  basketViewController.swift
//  Wishop
//
//  Created by Lucien Dagher Hayeck on 4/7/17.
//  Copyright © 2017 Wishop. All rights reserved.
//

//
//  MenuViewController.swift
//  Wishop
//
//  Created by Lucien Dagher Hayeck on 2/21/17.
//  Copyright © 2017 Wishop. All rights reserved.





import UIKit


class BasketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var amazonProductArray = [[AmazonProduct]]()
    var recipeArray = [Recipe]()
    var numberRows = [Int]()
    @IBOutlet weak var activity: UIActivityIndicatorView!
    let p = ProductAdvertisingApi()
    var create = ["":""]
    var cart = ["":""]

    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var totalPriceExponent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.hidesWhenStopped = true
        
        tableView.backgroundColor = UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        self.view.backgroundColor = UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         let a = String(totalPrice())
        
        if a.range(of: ".") != nil {
            var arr = a.components(separatedBy: ".")
            totalPriceLabel.text = arr[0]
            totalPriceExponent.text = "," + arr[1] + "€"
            
        } else {
            totalPriceLabel.text = a
            totalPriceExponent.text = ",00€"
            
        }

        
         rowsInSection()
    }
    
    func rowsInSection(){
        numberRows.append(1)
        for r in recipeArray {
           numberRows.append((r.recipeIngredients?.count)!)
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberRows[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return recipeArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else {
            return 82
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section > 0 {
            return (recipeArray[section - 1].recipeTitle).uppercased()
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if forSection > 0 {
            if let headerTitle = view as? UITableViewHeaderFooterView {
                headerTitle.textLabel?.textColor = UIColor.white
                headerTitle.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
                headerTitle.backgroundView?.backgroundColor = UIColor(red: 210/255, green: 215/255, blue:223/255, alpha: 1.0)
            }
        }
    }
    
    func totalPrice () -> Double {
        var price: Double = 0
        var c = 0
        for _ in recipeArray {
            for i in amazonProductArray[c] {
                price = price + Double(i.productPrice)!
            }
            c = c + 1
        }
        return price
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: MenuViewController.self) {
                _ = self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell: NbProductCell = tableView.dequeueReusableCell(withIdentifier: "NbProductCell") as! NbProductCell
            cell.separatorInset = UIEdgeInsetsMake(0,0,0,0)
            var c = 0
            var count = 0
            for _ in recipeArray {
                count += amazonProductArray[c].count
                c = c + 1
            }
            cell.NbProductLabel.text = String(count) + " " + "produits"
            return cell
            
        } else {
        
        let cell: BasketCell = tableView.dequeueReusableCell(withIdentifier: "BasketCell") as! BasketCell
        cell.selectionStyle = .none
        cell.imageContainer.layer.borderWidth = 1
        cell.imageContainer.layer.cornerRadius = cell.imageContainer.bounds.width/2
        cell.imageContainer.layer.borderColor = UIColor(red: 240/255, green: 240/255, blue:240/255, alpha: 1.0).cgColor
        
        cell.changeProductView.layer.borderWidth = 0.5
        cell.changeProductView.layer.borderColor = UIColor.clear.cgColor
        cell.changeProductView.layer.cornerRadius = 3
        
        cell.separatorInset = UIEdgeInsetsMake(0,cell.productName.frame.minX , 0, 0)
            
            
            if amazonProductArray[indexPath.section-1][indexPath.row].productPrice.range(of: ".") != nil {
                var arr = amazonProductArray[indexPath.section-1][indexPath.row].productPrice.components(separatedBy: ".")
                cell.priceLabel.text = arr[0]
                cell.priceExponentLabel.text = "," + arr[1] + "€"
    
            } else {
                cell.priceLabel.text = amazonProductArray[indexPath.section-1][indexPath.row].productPrice
                cell.priceExponentLabel.text = ",00€"
                
            }
            
                cell.productBrand.text = (amazonProductArray[indexPath.section-1][indexPath.row].productBrand).lowercased()
                cell.productName.text = amazonProductArray[indexPath.section-1][indexPath.row].productCategory

                cell.productImage.image = amazonProductArray[indexPath.section-1][indexPath.row].productImage
            if ( amazonProductArray[indexPath.section-1][indexPath.row].productQuantity != "0 ") {
                cell.productPackaging.text = amazonProductArray[indexPath.section-1][indexPath.row].productQuantity
            }

            return cell
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payement" {
            let m = segue.destination as? PayementViewController
            m?.recipeArray = recipeArray
            m?.amazonProductArray = amazonProductArray
            m?.totalPrice = totalPrice()
            
        }
    }

    

    
    
}

