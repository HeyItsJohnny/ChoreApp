//
//  TaskLog.swift
//  Homey2
//
//  Created by jonathan laroco on 3/10/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct TaskLog: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var description: String
    var totalpoints: Int
    var room: String
    var userId: String
    var username: String
    var datecompleted: Date
}
