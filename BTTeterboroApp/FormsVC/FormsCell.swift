//
//  FormsCell.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/25/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit

class FormsCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
