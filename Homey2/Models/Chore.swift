//
//  Chore.swift
//  Homey2
//
//  Created by jonathan laroco on 5/20/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

enum ChoreFrequency: String, CaseIterable, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case everytwoweeks = "Every 2 Weeks"
    case everythreeweeks = "Every 3 Weeks"
    case monthly = "Monthly"
    case annualy = "Annually"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

struct Chore: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var description: String
    var totalpoints: Int
    var frequency: ChoreFrequency
    var room: String
    var userId: String
    var username: String
    var nextduedate: Date
    var schedulesunday: Bool
    var schedulemonday: Bool
    var scheduletuesday: Bool
    var schedulewednesday: Bool
    var schedulethursday: Bool
    var schedulefriday: Bool
    var schedulesaturday: Bool
}
