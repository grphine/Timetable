//
//  CollapsibleCell.swift
//  collapsible tableview
//
//  Created by Juheb on 28/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import UIKit

class CollapsibleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none //checkmark cell
    }
    
    
    
}
