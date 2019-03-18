//
//  CheckListItemCell.swift
//  ToDoBDMobile
//
//  Created by lpiem on 22/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//
import UIKit

class ChecklistItemCell: UITableViewCell {
    
    @IBOutlet weak var checkMark: UILabel!
    @IBOutlet weak var textCell: UILabel!
    @IBOutlet weak var newImage: UIImageView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
