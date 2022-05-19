//
//  RestaurantViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 4/7/22.
//

import Foundation
import Combine
import FirebaseFirestore

class RestaurantViewModel: ObservableObject {
  @Published var restaurant: Restaurant
  @Published var modified = false
    
  private var cancellables = Set<AnyCancellable>()
  
  //Constructors
  
    init(restaurant: Restaurant = Restaurant(name: "", type: "", distance: 0, healthyMeter: .healthy)) {
    self.restaurant = restaurant
    self.$restaurant
      .dropFirst()
      .sink { [weak self] restaurant in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
  
  //Firestore
  
  private var db = Firestore.firestore()
  
    func addRestaurant(_ restaurant: Restaurant) {
        do {
          let _ = try db.collection("restaurants").addDocument(from: restaurant)
        }
        catch {
          print(error)
        }
    }
    
    private func updateRestaurant(_ restaurant: Restaurant) {
        if let documentId = restaurant.id {
            do {
                try db.collection("restaurants").document(documentId).setData(from: restaurant)
            }
            catch {
                print(error)
            }
      }
    }
    
    private func updateOrAddRestaurant() {
        if let _ = restaurant.id {
            self.updateRestaurant(self.restaurant)
        }
        else {
            addRestaurant(restaurant)
        }
    }
    
    private func removeRestaurant() {
        if let documentId = restaurant.id {
          db.collection("restaurants").document(documentId).delete { error in
            if let error = error {
              print(error.localizedDescription)
            }
          }
        }
    }
  
    func handleDoneTapped() {
        self.updateOrAddRestaurant()
    }
    
    func handleDeleteTapped() {
        self.removeRestaurant()
      }
}
