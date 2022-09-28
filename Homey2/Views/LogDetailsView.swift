//
//  LogDetailsView.swift
//  Homey2
//
//  Created by jonathan laroco on 9/27/22.
//

import SwiftUI

struct LogDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var presentEditBookSheet = false
    
    var log: Log
    
    var body: some View {
        Form {
            Section(header: Text("Log Type")) {
                Text(log.LogType)
            }
            Section(header: Text("Details/Owner")) {
                Text(log.Name)
                Text(log.Description)
                Text(log.Username)
                Text("Point: \(log.TotalPoints)")
            }
            Section(header: Text("Chore")) {
                Text(log.ChoreName)
            }
            Section(header: Text("Room")) {
                Text(log.RoomName)
            }
            Section(header: Text("Approver")) {
                Text(log.ApprovedBy)
            }
            Section(header: Text("Approved")) {
                if (log.Approved) {
                    Text("Yes")
                } else {
                    Text("No")
                }
            }
            
            Section(header: Text("Date Completed")) {
                if #available(iOS 15.0, *) {
                    Text("\(log.DateCompleted.formatted(date: .long, time: .shortened))")
                } else {
                    // Fallback on earlier versions
                }
            }
            
        }
        .navigationBarTitle(log.Name)
        .onAppear() {
        }
        .onDisappear() {
        }
    }
}

struct LogDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let log = Log(LogType: "", Name: "", Description: "", TotalPoints: 0, UserId: "", Username: "", RoomId: "", RoomName: "", ChoreId: "", ChoreName: "", Approved: false, ApprovedBy: "", ApprovedByID: "", DateCompleted: Date())
        return
        NavigationView {
            LogDetailsView(log: log)
        }
    }
}
