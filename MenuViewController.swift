//
//  MenuViewController.swift
//  Wishop
//
//  Created by Lucien Dagher Hayeck on 2/21/17.
//  Copyright © 2017 Wishop. All rights reserved.
//


import ImageIO
import UIKit
class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var NbMenuMeal: UILabel!
    let logo = UIImage(named: "wishop_black")
    
    @IBOutlet weak var ajouterButton: UIBarButtonItem!
    @IBOutlet weak var labelProposition: UILabel!
    var recipeArray = [Recipe]()
    var recipeSuggestionArray = [Recipe]()
    var suggestionTag = Int()
    var tag = Int()
    var choose = false
    var replace = false
    var amazonProductArray1 = [[AmazonProduct]]()
    var amazonProductArray0 = [AmazonProduct]()
    
    var i: String = ""
    var basketIngredients = [String]()
    
    var productImageArray = [UIImage]()
    @IBOutlet weak var activity: UIActivityIndicatorView!
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadTableView), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        updateLabels()
        
        activity.isHidden = true
        NbMenuMeal.layer.borderWidth = 1.0
        NbMenuMeal.layer.borderColor = UIColor.white.cgColor
        NbMenuMeal.layer.cornerRadius = 5.0
        
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.init(red: 73/255, green: 81/255, blue: 86/255, alpha: 1.0)
        tableView.backgroundColor = UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        self.view.backgroundColor = UIColor.init(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        
    }
    
    func updateLabels(){
        NbMenuMeal.text = String(nbMeal)
        labelProposition.text =  "Voici " +
            String(nbMeal) + " repas que nous avons séléctionné pour vous"
    }
    
    func loadTableView(){
        if (recipeSuggestionArray.isEmpty){
            ajouterButton.isEnabled = false
        }

        updateLabels()
        self.tableView.reloadData()
    }
   
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        for aViewController:UIViewController in viewControllers {
            if aViewController.isKind(of: NumberMealViewController.self) {
                _ = self.navigationController?.popToViewController(aViewController, animated: true)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row%2) == 0{
            return 150
        } else {
            return 10
        }
    }
    
      
    @IBAction func deleteClicked(_ sender: AnyObject) {
        var indexPath: NSIndexPath!
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? MenuCell {
                    indexPath = tableView.indexPath(for: cell) as NSIndexPath!
                    let indexSet = NSMutableIndexSet()
                    indexSet.add(indexPath.section)
                    recipeArray.remove(at: indexPath.section)
                    nbMeal -= 1
                    updateLabels()
                    tableView.deleteSections(indexSet as IndexSet, with: UITableViewRowAnimation.automatic)
                    tableView.reloadData()
                }
            }
        }
    }
 
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ((indexPath.row%2) == 0){
    
            let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
            if recipeArray.count == 1 {
                cell.deleteButton.isEnabled = false
            } else {
                cell.deleteButton.isEnabled = true

            }
            
            if recipeSuggestionArray.isEmpty {
                cell.changeButton.isEnabled = false
            }
            
            cell.deleteButton.tag = indexPath.section;
            cell.selectionStyle = .none
            cell.changeButton.tag = indexPath.section
            cell.platTitle.text = recipeArray[indexPath.section].recipeTitle
            cell.platImage.image = recipeArray[indexPath.section].recipeImage
            i = ""
            var c0 = 0
            for ingredient in recipeArray[indexPath.section].recipeIngredients! {
                c0 = c0 + 1
                if (c0 == recipeArray[indexPath.section].recipeIngredients!.count) {
                    i += ingredient
                } else {
                    i += ingredient + ", "
                    
                }
            }
            cell.platIngredients.text = i
            return cell
        }
        
        else {
            let cell: FooterCell = tableView.dequeueReusableCell(withIdentifier: "FooterCell") as! FooterCell
            cell.selectionStyle = .none
            return cell
        
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "l" {
            let b = segue.destination as? LoadingBasketViewController
            b?.recipeArray = recipeArray
        } else if segue.identifier == "choose" || segue.identifier == "replace"{
            if (segue.identifier == "choose") {
                choose = true
                replace = false
                tag = (sender as AnyObject).tag
            } else if (segue.identifier == "replace") {
                replace = true
                choose = false
                tag = (sender as AnyObject).tag

            }
            let b = segue.destination as? ChooseViewController
            b?.recipeSuggestionArray = recipeSuggestionArray
            b?.recipeArray = recipeArray
            b?.replace = replace
            b?.choose = choose


        }
    }
    
    @IBAction func unwindToThisView(segue: UIStoryboardSegue) {
        if let chooseViewController = segue.source as? ChooseViewController {
            suggestionTag = chooseViewController.tag
        if (choose) {
            recipeArray.append(recipeSuggestionArray[suggestionTag])
            recipeSuggestionArray.remove(at: suggestionTag)
            nbMeal += 1
        } else if (replace) {
            let rep = recipeArray[tag]
            recipeArray[tag] = recipeSuggestionArray[suggestionTag]
            recipeSuggestionArray[suggestionTag] = rep

        }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
    }
}
