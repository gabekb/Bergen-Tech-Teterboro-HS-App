//
//  DataToString.swift
//  BTTeterboroApp
//
//  Created by GKB on 3/24/18.
//  Copyright © 2018 Gabriel Baffo. All rights reserved.
//

import Foundation

extension Data
{
    func toString() -> String
    {
        return String(data: self, encoding: .utf8)!
    }
}
