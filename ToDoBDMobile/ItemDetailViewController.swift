//
//  ItemDetailViewController.swift
//  ToDoBDMobile
//
//  Created by lpiem on 18/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: CheckListItem?
    @IBOutlet weak var bDone: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBAction func cancel(_ sender: Any) {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.photoLibrary;
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
            
            
        }
    }
    @IBAction func done(_ sender: Any) {
        if itemToEdit != nil {
            itemToEdit?.text = textField.text!
            itemToEdit?.image = imageView.image!
            delegate?.itemDetailViewController(self, didFinishEditingItem: itemToEdit!)
            
        }
        else {
            
            delegate?.itemDetailViewController(self, didFinishAddingItem: CheckListItem(text: textField.text ?? "", image: imageView.image!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if itemToEdit != nil {
            self.navigationItem.title = "Edit Item"
            textField.text = itemToEdit?.text
            imageView.image = itemToEdit?.image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder();
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = self.textField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)
        if newString?.isEmpty ?? true {
            bDone.isEnabled = false
        } else {
            bDone.isEnabled = true
        }
        return true
    }
    
}

protocol ItemDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem)
}

extension ItemDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = image
        } else{
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
