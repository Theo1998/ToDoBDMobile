//
//  File.swift
//  ToDoBDMobile
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class CheckListItem {
    var text: String;
    var checked: Bool;
    var image: UIImage;
    
    init(text: String, image: UIImage, checked: Bool = false) {
        self.text = text;
        self.checked = checked;
        self.image = image;
    }
    
    func toggleChecked() {
        self.checked = !self.checked;
    }
    
}
