//
//  ChoresViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 8/1/22.
//

import Foundation
import Combine
import FirebaseFirestore

class ChoresViewModel: ObservableObject {
    @Published var chore = [Chore]()
    var choreViewModel = ChoreViewModel()
    
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
      listenerRegistration = db.collection("chores").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        self.chore = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Chore.self)
        }
      }
    }
    }
    func subscribeByNextDueDate() {
        if listenerRegistration == nil {
            listenerRegistration = db.collection("chores").order(by: "NextDueDate").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.chore = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Chore.self)
                }
            }
        }
    }

    func removeChoreItems(atOffsets indexSet: IndexSet) {
        let tasks = indexSet.lazy.map { self.chore[$0] }
          tasks.forEach { task in
          if let documentId = task.id {
            db.collection("chores").document(documentId).delete { error in
              if let error = error {
                print("Unable to remove document: \(error.localizedDescription)")
              }
            }
          }
        }
    }

    func confirmChoreItems(_ chore: Chore) {
        do {
            let choreLog: Log = Log(
                LogType: "Chore",
                Name: chore.Name,
                Description: chore.Description,
                TotalPoints: chore.TotalPoints,
                UserId: chore.UserId,
                Username: chore.Username,
                RoomId: "",
                RoomName: "",
                ChoreId: chore.id!,
                ChoreName: chore.Name,
                Approved: false,
                ApprovedBy: "",
                ApprovedByID: "",
                DateCompleted: Date()
            )
            
            //let _ = try db.collection("chores").document(chore.id!).collection("chorelogs").addDocument(from: choreLog)
            let _ = try db.collection("logs").addDocument(from: choreLog)
            choreViewModel.updateChoreDueDate(chore)
        } catch {
            print(error)
        }
        //Create a Task Log for the item
        //Update Next Due Date
        //print("Document ID: " + chore.id! + " Name: " + chore.Name);
    }
}
