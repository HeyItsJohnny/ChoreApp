//
//  User.swift
//  Homey2
//
//  Created by jonathan laroco on 12/28/21.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

class User {
    var uid: String
    var email: String?
    var displayName: String?

    init(uid: String, displayName: String?, email: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }

}
