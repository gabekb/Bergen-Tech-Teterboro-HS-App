//
//  NotificationCell.swift
//  BTTeterboroApp
//
//  Created by GKB on 4/4/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var dateRecievedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
