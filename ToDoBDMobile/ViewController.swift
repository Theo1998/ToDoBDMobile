//
//  ViewController.swift
//  ToDoBDMobile
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var items = [CheckListItem]()
    var filteredItems = [CheckListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupConstraints()
        
        // Reload the table
        tableView.reloadData()
    }
    
    @IBAction func addItem(_ sender: Any) {
        
        searchBar.text = ""
        tableView.reloadData()
        
        let alertController = UIAlertController(title: "Doing", message: "New Item ?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            (action) in
            self.items.append(CheckListItem(text: (alertController.textFields![0] as UITextField).text!))
            self.tableView.insertRows(at: [IndexPath(row: self.items.count - 1, section: 0)], with: .none)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Item name"
        })
        
        alertController.addAction(okAction)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setupConstraints() {
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (searchBar.text?.isEmpty == false) {
            return filteredItems.count
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.items[indexPath.row].toggleChecked();
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Doing", message: "Edit Item ?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            (action) in
            self.items[indexPath.row].text = (alertController.textFields![0] as UITextField).text!
            tableView.reloadRows(at: [indexPath], with: .none)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField(configurationHandler: { (textField) in
            textField.text = self.items[indexPath.row].text
        })
        
        alertController.addAction(okAction)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! ChecklistItemCell
        
        
        if (searchBar.text?.isEmpty == false) {
            configureText(for: cell, withItem: self.filteredItems[indexPath.row])
            configureCheckmark(for: cell, withItem: self.filteredItems[indexPath.row])
            return cell
        }
        else {
            configureText(for: cell, withItem: self.items[indexPath.row])
            configureCheckmark(for: cell, withItem: self.items[indexPath.row])
            return cell
        }
        
    }
    
    func configureCheckmark(for cell: ChecklistItemCell, withItem item: CheckListItem) {
        cell.checkMark.isHidden = !item.checked
    }
    
    func configureText(for cell: ChecklistItemCell, withItem item: CheckListItem) {
        cell.textCell.text = item.text
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredItems = items.filter { return $0.text.lowercased().contains(searchBar.text!.lowercased()) }
        tableView.reloadData()
    }
}
