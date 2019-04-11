//
//  CategoryDetailViewController.swift
//  ToDoBDMobile
//
//  Created by lpiem on 11/04/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UITableViewController, UITextFieldDelegate {
    var delegate: CategoryDetailViewControllerDelegate?
    var itemToEdit: Category?
    var itemToCreate: Category?
    var dataManager = CoreDataManager.shared
    
    @IBOutlet weak var bDone: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBAction func cancel(_ sender: Any) {
        delegate?.categoryDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if itemToEdit != nil {
            itemToEdit?.nom = textField.text!
            delegate?.categoryDetailViewController(self, didFinishEditingItem: itemToEdit!)
        }
        else {
            if itemToCreate == nil {
                itemToCreate = Category(context: self.dataManager.context)
                itemToCreate?.nom = textField.text
            }
            else {
                itemToCreate?.nom = textField.text!
            }
            delegate?.categoryDetailViewController(self, didFinishAddingItem: itemToCreate!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if itemToEdit != nil {
            self.navigationItem.title = "Edit Category"
            textField.text = itemToEdit?.nom
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder();
    }
    
}

protocol CategoryDetailViewControllerDelegate : class {
    func categoryDetailViewControllerDidCancel(_ controller: CategoryDetailViewController)
    func categoryDetailViewController(_ controller: CategoryDetailViewController, didFinishAddingItem item: Category)
    func categoryDetailViewController(_ controller: CategoryDetailViewController, didFinishEditingItem item: Category)
}
