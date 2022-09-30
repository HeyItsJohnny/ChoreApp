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
  
    init(chore: Chore = Chore(Name: "", Description: "", TotalPoints: 0, Frequency: .daily, Room: "", UserId: "", Username: "", NextDueDate: Date(), ScheduleSunday: false, ScheduleMonday: false, ScheduleTuesday: false, ScheduleWednesday: false, ScheduleThursday: false, ScheduleFriday: false, ScheduleSaturday: false)) {
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
        let dueDate = chore.NextDueDate
        var modifiedDate = dueDate
        
        switch chore.Frequency.rawValue {
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
            "NextDueDate": modifiedDate
        ])
    }
  
    func handleDoneTapped() {
        self.updateOrAddChore()
    }
    
    func handleDeleteTapped() {
        self.removeChore()
      }
    
    func fetchMembername(documentID: String) {
        let db = Firestore.firestore()

        let docRef = db.collection("housemembers").document(documentID)

        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    print("data", data)
                    //selectedMember = data["Name"] as? String ?? ""
                }
            }

        }
    }
}
