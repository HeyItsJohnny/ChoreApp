//
//  RoomsViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 5/20/22.
//

import Foundation
import Combine
import FirebaseFirestore

class RoomsViewModel: ObservableObject {
  @Published var room = [Room]()
  
  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?
  
  deinit {
    unsubscribe()
  }
  
  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
  
  func subscribe() {
    if listenerRegistration == nil {
      listenerRegistration = db.collection("rooms").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        self.room = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Room.self)
        }
      }
    }
  }
  
  func removeRoomItems(atOffsets indexSet: IndexSet) {
    let rooms = indexSet.lazy.map { self.room[$0] }
      rooms.forEach { room in
      if let documentId = room.id {
        db.collection("rooms").document(documentId).delete { error in
          if let error = error {
            print("Unable to remove document: \(error.localizedDescription)")
          }
        }
      }
    }
  }
}
