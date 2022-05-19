//
//  MealViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 11/16/21.
//

import Foundation
import Combine
import FirebaseFirestore

class MealViewModel: ObservableObject {
  @Published var meal: Meal
  @Published var modified = false
    
  private var cancellables = Set<AnyCancellable>()
  
  //Constructors
  
    init(meal: Meal = Meal(name: "", description: "", dayofmeal: .sunday, user: "")) {
    self.meal = meal
    self.$meal
      .dropFirst()
      .sink { [weak self] meal in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
  
  //Firestore
  
  private var db = Firestore.firestore()
  
    func addMeal(_ meal: Meal) {
        do {
          let _ = try db.collection("meals").addDocument(from: meal)
        }
        catch {
          print(error)
        }
    }
    
    private func updateMeal(_ meal: Meal) {
        if let documentId = meal.id {
            do {
                try db.collection("meals").document(documentId).setData(from: meal)
            }
            catch {
                print(error)
            }
      }
    }
    
    private func updateOrAddMeal() {
        if let _ = meal.id {
            self.updateMeal(self.meal)
        }
        else {
            addMeal(meal)
        }
    }
    
    private func removeMeal() {
        if let documentId = meal.id {
          db.collection("meals").document(documentId).delete { error in
            if let error = error {
              print(error.localizedDescription)
            }
          }
        }
    }
  
    func handleDoneTapped() {
        self.updateOrAddMeal()
    }
    
    func handleDeleteTapped() {
        self.removeMeal()
      }
}
