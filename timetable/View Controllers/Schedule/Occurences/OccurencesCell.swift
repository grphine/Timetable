//
//  OccurencesCell.swift
//  timetable
//
//  Created by Juheb on 23/11/2018.
//  Copyright © 2018 Juheb. All rights reserved.
//

import UIKit

class OccurencesCell: UITableViewCell {
    
    //TODO: Make uncheckable, remember to check multiple answers stack
    
    @IBOutlet weak var nameLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }

}
