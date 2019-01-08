//
//  Item.swift
//  Todoey
//
//  Created by Kurtis Hill on 1/8/19.
//  Copyright © 2019 Kurtis Hill. All rights reserved.
//

import Foundation

class Item {
    
    var item: String = ""
    var done: Bool = false
    
    init(item: String, done: Bool) {
        self.item = item
        self.done = done
    }
    
}
