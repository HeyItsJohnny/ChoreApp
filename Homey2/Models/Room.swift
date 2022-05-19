//
//  Room.swift
//  Homey2
//
//  Created by jonathan laroco on 11/16/21.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct Room: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String
}
