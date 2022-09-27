//
//  LogViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 9/26/22.
//

import Foundation
import Combine
import FirebaseFirestore

class LogViewModel: ObservableObject {
    @Published var log: Log
    @Published var modified = false
    
  private var cancellables = Set<AnyCancellable>()
  
  //Constructors
  
    
    init(log: Log = Log(LogType: "", Name: "", Description: "", TotalPoints: 0, UserId: "", Username: "", RoomId: "", RoomName: "", ChoreId: "", ChoreName: "",Approved: false, ApprovedBy: "", ApprovedByID: "", DateCompleted: Date())) {
        self.log = log
        self.$log
          .dropFirst()
          .sink { [weak self] room in
            self?.modified = true
          }
          .store(in: &self.cancellables)
    }
  
  //Firestore
  
  private var db = Firestore.firestore()
  
    func addChoreLog(_ chore: Chore) {
        do {
          //let _ = try db.collection("rooms").addDocument(from: room)
        }
        catch {
          print(error)
        }
    }
    
    func addRoomLog(_ room: Room) {
        do {
          //let _ = try db.collection("rooms").addDocument(from: room)
        }
        catch {
          print(error)
        }
    }
    
    func addUserLog(_ user: User) {
        do {
          //let _ = try db.collection("rooms").addDocument(from: room)
        }
        catch {
          print(error)
        }
    }
    
    private func removeLog() {
        if let documentId = log.id {
          db.collection("logs").document(documentId).delete { error in
            if let error = error {
              print(error.localizedDescription)
            }
          }
        }
    }
  
    func handleDoneTapped() {
        //self.updateOrAddRoom()
    }
    
    func handleDeleteTapped() {
        self.removeLog()
    }
}
