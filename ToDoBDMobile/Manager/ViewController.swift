//
//  ViewController.swift
//  ToDoBDMobile
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredItems = [Tache]()
    var dataManager = CoreDataManager.shared
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchBar.text = ""
        if (segue.identifier == "addItem") {
            let controller = (segue.destination as! UINavigationController).topViewController as! ItemDetailViewController
            controller.delegate = self
        }
        if (segue.identifier == "editItem") {
            if let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell){
                let controller = (segue.destination as! UINavigationController).topViewController as! ItemDetailViewController
                controller.itemToEdit = self.dataManager.items[indexPath.row]
                controller.delegate = self
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        tableView.reloadData()
    }
    
    override func awakeFromNib() {
        dataManager.loadItems()
    }
    
    
    func setupConstraints() {
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }

}


// MARK: - Data Manager Delegate
extension ViewController: DataManagerDelegate {
    func didAddItem(_ item: Tache) {
        print("didAddItem controller")
//        let indexPath = [IndexPath(row: self.dataManager.items.count - 1, section: 0)]
//       self.tableView.insertRows(at: indexPath, with: .none)
//        self.tableView.reloadRows(at: indexPath, with: UITableView.RowAnimation.fade)
    }
    
    func didUpdateItem(_ item: Tache) {
    }
    
    func didDidLoadItem(_ item: Tache) {
    }
    
    func didDeleteItem(_ item: Tache) {
    }
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (searchBar.text?.isEmpty == false) {
            return filteredItems.count
        } else {
            return dataManager.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dataManager.items[indexPath.row].toggleChecked();
        self.dataManager.saveData()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Doing", message: "Edit Item ?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            (action) in
             self.dataManager.items[indexPath.row].nom = (alertController.textFields![0] as UITextField).text!
            self.dataManager.saveData()
            tableView.reloadRows(at: [indexPath], with: .none)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.text = self.dataManager.items[indexPath.row].nom
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ aTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = aTableView.dequeueReusableCell(withIdentifier: "CellIdentifier")! as! ChecklistItemCell
                
        if (searchBar.text?.isEmpty == false) {
            configureText(for: cell, withItem: self.filteredItems[indexPath.row])
            configureCheckmark(for: cell, withItem: self.filteredItems[indexPath.row])
            if (cell.newImage?.image) != nil {
                configureImage(for: cell, withItem: self.filteredItems[indexPath.row])
            }
            return cell
        }
        else {
            configureText(for: cell, withItem: self.dataManager.items[indexPath.row])
            configureCheckmark(for: cell, withItem: self.dataManager.items[indexPath.row])
            if (cell.newImage?.image) != nil {
                configureImage(for: cell, withItem: self.dataManager.items[indexPath.row])
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (searchBar.text?.isEmpty == false) {
                self.filteredItems.remove(at: indexPath.row)
            }
            
            self.dataManager.removeItem(self.dataManager.items[indexPath.row])
            self.dataManager.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.dataManager.saveData()
           
        }
    }
    
    func configureCheckmark(for cell: ChecklistItemCell, withItem item: Tache) {
        cell.checkMark.isHidden = !item.checked
    }
    
    func configureText(for cell: ChecklistItemCell, withItem item: Tache) {
        cell.textCell.text = item.nom
    }
    
    func configureImage(for cell: ChecklistItemCell, withItem item: Tache) {
        cell.newImage?.image = UIImage(data: (item.image?.image)!)
    }
}

// MARK: - UISearchBar
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredItems = self.dataManager.items.filter { return $0.nom!.lowercased().contains(searchBar.text!.lowercased()) }
        tableView.reloadData()
    }
}

extension ViewController: ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: Tache) {
        tableView.reloadData()
//        self.tableView.insertRows(at: [IndexPath(row: self.items.count - 1, section: 0)], with: .none)
        self.dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: Tache) {
        self.tableView.reloadRows(at: [IndexPath(row: self.dataManager.items.index(where: { $0 === item })!, section: 0)], with: .none)
        self.dismiss(animated: true, completion: nil)
    }
    
}
