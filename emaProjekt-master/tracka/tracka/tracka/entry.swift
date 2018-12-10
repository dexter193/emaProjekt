class Entry{
    
    var id: Int
    var name: String?
    var description: String?
    var instructions: String?
    var difficulty: Int
    var url: String?
    
    
    init(id: Int, name: String?, description: String?, instructions: String?, difficulty: Int, url: String?){
        self.id = id
        self.name = name
        self.description = description
        self.instructions = instructions
        self.difficulty = difficulty
        self.url = url
    }
}
//
//  entry.swift
//  tracka
//
//  Created by David Michel on 03.12.18.
//  Copyright © 2018 David Michel. All rights reserved.
//

import Foundation
