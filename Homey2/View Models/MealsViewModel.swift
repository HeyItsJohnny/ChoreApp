//
//  MealsViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 1/21/22.
//

import Foundation
import Combine
import FirebaseFirestore

class MealsViewModel: ObservableObject {
  @Published var meal = [Meal]()
  
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
      listenerRegistration = db.collection("meals").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        self.meal = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Meal.self)
        }
      }
    }
  }
  
  func removeMealItems(atOffsets indexSet: IndexSet) {
    let meals = indexSet.lazy.map { self.meal[$0] }
      meals.forEach { meal in
      if let documentId = meal.id {
        db.collection("meals").document(documentId).delete { error in
          if let error = error {
            print("Unable to remove document: \(error.localizedDescription)")
          }
        }
      }
    }
  }
}
