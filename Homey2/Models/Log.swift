//
//  Log.swift
//  Homey2
//
//  Created by jonathan laroco on 8/1/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct Log: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var logtype: String
    var name: String
    var description: String
    var totalpoints: Int
    var userId: String
    var username: String
    var roomId: String
    var room: String
    var choreId: String
    var choreName: String
    var datecompleted: Date
}
