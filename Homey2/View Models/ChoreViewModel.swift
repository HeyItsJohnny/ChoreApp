//
//  ChoreViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 8/1/22.
//

import Foundation
import Combine
import FirebaseFirestore

class ChoreViewModel: ObservableObject {
  @Published var chore: Chore
  @Published var modified = false
    
  private var cancellables = Set<AnyCancellable>()
  
  //Constructors
  
    init(chore: Chore = Chore(name: "", description: "", totalpoints: 0, frequency: .daily, room: "", userId: "", username: "", nextduedate: Date(), schedulesunday: false, schedulemonday: false, scheduletuesday: false, schedulewednesday: false, schedulethursday: false, schedulefriday: false, schedulesaturday: false)) {
    self.chore = chore
    self.$chore
      .dropFirst()
      .sink { [weak self] task in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
  
  //Firestore
  
  private var db = Firestore.firestore()
  
    func addChore(_ chore: Chore) {
        do {
          let _ = try db.collection("chores").addDocument(from: chore)
        }
        catch {
          print(error)
        }
    }
    
    private func updateChore(_ chore: Chore) {
        if let documentId = chore.id {
            do {
                try db.collection("chores").document(documentId).setData(from: chore)
            }
            catch {
                print(error)
            }
      }
    }
    
    private func updateOrAddChore() {
        if let _ = chore.id {
            self.updateChore(self.chore)
        }
        else {
            addChore(chore)
        }
    }
    
    private func removeChore() {
        if let documentId = chore.id {
          db.collection("chores").document(documentId).delete { error in
            if let error = error {
              print(error.localizedDescription)
            }
          }
        }
    }
    
    func updateChoreDueDate(_ chore: Chore) {
        let dueDate = chore.nextduedate
        var modifiedDate = dueDate
        
        switch chore.frequency.rawValue {
            case "Daily": modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: dueDate)!
            case "Weekly": modifiedDate = Calendar.current.date(byAdding: .day, value: 7, to: dueDate)!
            case "Every 2 Weeks": modifiedDate = Calendar.current.date(byAdding: .day, value: 14, to: dueDate)!
            case "Every 3 Weekly": modifiedDate = Calendar.current.date(byAdding: .day, value: 21, to: dueDate)!
            case "Monthly": modifiedDate = Calendar.current.date(byAdding: .month, value: 1, to: dueDate)!
            case "Annually": modifiedDate = Calendar.current.date(byAdding: .year, value: 1, to: dueDate)!
        default:
            print("Something got fucked up..")
        }
        
        db.collection("chores").document(chore.id!).updateData([
            "nextduedate": modifiedDate
        ])
    }
  
    func handleDoneTapped() {
        self.updateOrAddChore()
    }
    
    func handleDeleteTapped() {
        self.removeChore()
      }
}
