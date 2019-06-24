//
//  FirebaseUtilis.swift
//  Instagram
//
//  Created by Findl MAC on 10/04/2019.
//  Copyright © 2019 YD. All rights reserved.
//

import UIKit
import Firebase

extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
            
        }) { (error) in
            print("Failed to fetch user for posts:", error)
        }
    }
}
