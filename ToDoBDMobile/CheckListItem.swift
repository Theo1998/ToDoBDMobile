//
//  File.swift
//  ToDoBDMobile
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation

class CheckListItem {
    var text: String;
    var checked: Bool;
    
    init(text: String, checked: Bool = false) {
        self.text = text;
        self.checked = checked;
    }
    
    func toggleChecked() {
        self.checked = !self.checked;
    }
    
}
