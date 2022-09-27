//
//  Room.swift
//  Homey2
//
//  Created by jonathan laroco on 11/16/21.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

enum RoomStatus: String, CaseIterable, Codable {
    case cleaned = "Clean"
    case semidirty = "Semi-Dirty"
    case dirty = "Dirty"
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

struct Room: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var Name: String
    var User: String
    var UserID: String
    var Status: RoomStatus
    var TotalPoints: Int
    var LastStatusUpdate: Date
}
