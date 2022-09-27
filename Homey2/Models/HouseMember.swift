//
//  HouseMember.swift
//  Homey2
//
//  Created by jonathan laroco on 1/31/22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct HouseMember: Codable, Identifiable, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    var Name: String
}
