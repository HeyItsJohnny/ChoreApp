//
//  HouseMemberViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 1/31/22.
//

import Foundation
import Combine
import FirebaseFirestore

class HouseMemberViewModel: ObservableObject {
  @Published var housemember: HouseMember
  @Published var modified = false
    
  private var cancellables = Set<AnyCancellable>()
  
  //Constructors
  
    init(housemember: HouseMember = HouseMember(name: "")) {
    self.housemember = housemember
    self.$housemember
      .dropFirst()
      .sink { [weak self] housemember in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
  
  //Firestore
  
  private var db = Firestore.firestore()
  
    func addHouseMember(_ housemember: HouseMember) {
        do {
          let _ = try db.collection("housemembers").addDocument(from: housemember)
        }
        catch {
          print(error)
        }
    }
    
    private func updateHouseMember(_ housemember: HouseMember) {
        if let documentId = housemember.id {
            do {
                try db.collection("housemembers").document(documentId).setData(from: housemember)
            }
            catch {
                print(error)
            }
      }
    }
    
    private func updateOrAddHouseMember() {
        if let _ = housemember.id {
            self.updateHouseMember(self.housemember)
        }
        else {
            addHouseMember(housemember)
        }
    }
    
    private func removeHouseMember() {
        if let documentId = housemember.id {
          db.collection("housemembers").document(documentId).delete { error in
            if let error = error {
              print(error.localizedDescription)
            }
          }
        }
    }
  
    func handleDoneTapped() {
        self.updateOrAddHouseMember()
    }
    
    func handleDeleteTapped() {
        self.removeHouseMember()
      }
}

