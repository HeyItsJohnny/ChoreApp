//
//  RestaurantsViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 4/7/22.
//

import Foundation
import Combine
import FirebaseFirestore

class RestaurantsViewModel: ObservableObject {
  @Published var restaurant = [Restaurant]()
  
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
        listenerRegistration = db.collection("restaurants").order(by: "distance").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        self.restaurant = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Restaurant.self)
        }
      }
    }
  }
  
  func removeRestaurantItems(atOffsets indexSet: IndexSet) {
    let restaurants = indexSet.lazy.map { self.restaurant[$0] }
      restaurants.forEach { restaurant in
      if let documentId = restaurant.id {
        db.collection("restaurants").document(documentId).delete { error in
          if let error = error {
            print("Unable to remove document: \(error.localizedDescription)")
          }
        }
      }
    }
  }
}
