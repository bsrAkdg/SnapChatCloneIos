//
//  UserSingleton.swift
//  SnapChatClone
//
//  Created by Büşra Serdaroğlu on 13.06.2020.
//  Copyright © 2020 Busra Serdaroglu. All rights reserved.
//

import Foundation

class UserSingleton {
    // singleton
    
    static let sharedUserInfo = UserSingleton()
    var email = ""
    var username = ""
    
    private init() {
        
    }
}
