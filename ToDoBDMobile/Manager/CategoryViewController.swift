//
//  CategoryViewController.swift
//  ToDoBDMobile
//
//  Created by lpiem on 11/04/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    var dataManager = CoreDataManager.shared
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showCategory") {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell){
                let controller = segue.destination as! ViewController
                controller.categoryIndex = indexPath.row
                controller.category = self.dataManager.lists[indexPath.row]
            }
        }
        if (segue.identifier == "addCategory") {
            let controller = (segue.destination as! UINavigationController).topViewController as! CategoryDetailViewController
            controller.delegate = self
        }
        if (segue.identifier == "editCategory") {
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell){
                let controller = (segue.destination as! UINavigationController).topViewController as! CategoryDetailViewController
                controller.itemToEdit = self.dataManager.lists[indexPath.row]
                controller.delegate = self
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dataManager.sortCategory()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataManager.lists.count;
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.dataManager.lists.remove(at: indexPath.row);
        tableView.deleteRows(at: [indexPath], with: .none);
        self.dataManager.saveData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItem", for: indexPath)
        cell.textLabel?.text = self.dataManager.lists[indexPath.row].nom
        return cell
    }
}

extension CategoryViewController: CategoryDetailViewControllerDelegate {
    func categoryDetailViewControllerDidCancel(_ controller: CategoryDetailViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func categoryDetailViewController(_ controller: CategoryDetailViewController, didFinishAddingItem item: Category) {
        self.dataManager.lists.append(item)
        tableView.insertRows(at: [IndexPath(row: self.dataManager.lists.count - 1, section: 0)], with: .none)
        self.dismiss(animated: true, completion: nil)
    }
    
    func categoryDetailViewController(_ controller: CategoryDetailViewController, didFinishEditingItem item: Category) {
        tableView.reloadRows(at: [IndexPath(row: self.dataManager.lists.index(where: { $0 === item })!, section: 0)], with: .none)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
