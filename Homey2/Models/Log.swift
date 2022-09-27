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
    var LogType: String
    var Name: String
    var Description: String
    var TotalPoints: Int
    var UserId: String
    var Username: String
    var RoomId: String
    var RoomName: String
    var ChoreId: String
    var ChoreName: String
    var Approved: Bool
    var ApprovedBy: String
    var ApprovedByID: String
    var DateCompleted: Date
}
