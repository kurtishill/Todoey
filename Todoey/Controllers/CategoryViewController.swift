//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kurtis Hill on 1/9/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        
        tableView.separatorStyle = .none

    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else { fatalError() }
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
            cell.backgroundColor = UIColor(hexString: category.color)
            
            cell.accessoryView?.tintColor = ContrastColorOf(categoryColor, returnFlat: true)
            
            cell.accessoryType = .disclosureIndicator
            
            cell.tintColor = ContrastColorOf(categoryColor, returnFlat: true)
            
            let image = UIImage(named:"disclosureArrow")?.withRenderingMode(.alwaysTemplate)
            if let width = image?.size.width, let height = image?.size.height {
                let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                disclosureImageView.image = image
                cell.accessoryView = disclosureImageView
            }
            
            
            
        }
        
        return cell
    }
    
     // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField() {
            alertTextField in
            
            alertTextField.placeholder = "New category"
            textField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add Category", style: .default) {
            action in
            
            if textField.text != "" {
                
                let category = Category()
                category.name = textField.text!
                category.color = UIColor.randomFlat.hexValue()
                
                self.save(category: category)
                
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func load() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    
    // MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {

                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting category: \(error)")
                }
                
            }
            
        }
    
}












