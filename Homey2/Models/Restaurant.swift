//
//  Restaurant.swift
//  Homey2
//
//  Created by jonathan laroco on 4/7/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

enum HealthyMeter: String, CaseIterable, Codable {
    case healthy = "Healthy"
    case semihealthy = "Semi-Healthy"
    case unhealthy = "Un-Healthy"
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}

struct Restaurant: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
    var type: String
    var distance: Double
    var healthyMeter: HealthyMeter
}
