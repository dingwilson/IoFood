//
//  Food.swift
//  IoFood
//
//  Created by Wilson Ding on 3/26/16.
//  Copyright © 2016 Wilson Ding. All rights reserved.
//

import Foundation

class Food {
    var name_ = ""
    var count_ : Int
    var imageURL_ = ""
    
    init(name: String, count: Int, imageURL: String) {
        self.name_ = name
        self.count_ = count
        self.imageURL_ = imageURL
    }
    
    func name() -> String! {
        return name_
    }
    
    func count() -> Int! {
        return count_
    }
    
    func imageURL() -> String! {
        return imageURL_
    }
}