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
    var Name: String
    var Description: String
    var TotalPoints: Int
    var Frequency: ChoreFrequency
    var Room: String
    var UserId: String
    var Username: String
    var NextDueDate: Date
    var ScheduleSunday: Bool
    var ScheduleMonday: Bool
    var ScheduleTuesday: Bool
    var ScheduleWednesday: Bool
    var ScheduleThursday: Bool
    var ScheduleFriday: Bool
    var ScheduleSaturday: Bool
}
