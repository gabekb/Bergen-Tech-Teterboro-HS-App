//
//  NeverClearView.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/31/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//
import UIKit

class NeverClearView: UIView {
    override var backgroundColor: UIColor? {
        didSet {
            if backgroundColor != nil && backgroundColor!.cgColor.alpha == 0 {
                backgroundColor = oldValue
            }
        }
    }
}
