//
//  Meal.swift
//  Homey2
//
//  Created by jonathan laroco on 1/21/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

enum DayofTheWeek: String, CaseIterable, Codable {
    case sunday = "Sunday"
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}


struct Meal: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var description: String
    var dayofmeal: DayofTheWeek
    var user: String
}

