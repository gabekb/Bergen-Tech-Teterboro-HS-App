//
//  CalendarEventCell.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/28/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit

class CalendarEventCell: UITableViewCell {
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventCountdown: UILabel!
    @IBOutlet weak var eventIconView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
