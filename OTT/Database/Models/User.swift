//
//  User.swift
//  OTT
//
//  Created by Akash Sen on 05/07/24.
//

import Foundation

class User {
    let pKey: UUID
    var email: String
    
    init(pKey: UUID, email: String) {
        self.pKey = pKey
        self.email = email
    }
}
