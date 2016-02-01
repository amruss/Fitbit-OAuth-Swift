//
//  AlarmTableCell.swift
//  FitAlarm Helper
//
//  Created by Abigail Russell on 1/30/16.
//  Copyright © 2016 Abigail Russell. All rights reserved.
//

import UIKit

class AlarmTableCell: UITableViewCell {
    @IBOutlet weak var AlarmTimeCell: UILabel!

    
        @IBOutlet weak var AlarmOnCell: UILabel!
        @IBOutlet weak var AlarmRepetitionCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
