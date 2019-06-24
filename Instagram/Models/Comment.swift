//
//  Comment.swift
//  Instagram
//
//  Created by Findl MAC on 29/04/2019.
//  Copyright © 2019 YD. All rights reserved.
//

import Foundation


struct Comment {
    
    var user: User
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    
}
