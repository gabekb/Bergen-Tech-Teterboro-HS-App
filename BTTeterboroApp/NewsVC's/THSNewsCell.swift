//
//  THSNewsCell.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/22/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import UIKit

class THSNewsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePublishedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
