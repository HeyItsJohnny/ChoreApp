//
//  RoomViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 5/20/22.
//

import Foundation
import Combine
import FirebaseFirestore

class RoomViewModel: ObservableObject {
  @Published var room: Room
  @Published var modified = false
    
  private var cancellables = Set<AnyCancellable>()
  
  //Constructors
  
    init(room: Room = Room(Name: "", User: "", UserID: "", Status: .dirty, TotalPoints: 0, LastStatusUpdate: Date())) {
    self.room = room
    self.$room
      .dropFirst()
      .sink { [weak self] room in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
  
  //Firestore
  
  private var db = Firestore.firestore()
  
    func addRoom(_ room: Room) {
        do {
          let _ = try db.collection("rooms").addDocument(from: room)
        }
        catch {
          print(error)
        }
    }
    
    private func updateRoom(_ room: Room) {
        if let documentId = room.id {
            do {
                try db.collection("rooms").document(documentId).setData(from: room)
            }
            catch {
                print(error)
            }
      }
    }
    
    private func updateOrAddRoom() {
        if let _ = room.id {
            self.updateRoom(self.room)
        }
        else {
            addRoom(room)
        }
    }
    
    private func removeRoom() {
        if let documentId = room.id {
          db.collection("rooms").document(documentId).delete { error in
            if let error = error {
              print(error.localizedDescription)
            }
          }
        }
    }
  
    func handleDoneTapped() {
        self.updateOrAddRoom()
    }
    
    func handleDeleteTapped() {
        self.removeRoom()
      }
}
