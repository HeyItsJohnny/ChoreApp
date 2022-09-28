//
//  LogsViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 9/27/22.
//

import Foundation
import Combine
import FirebaseFirestore

class LogsViewModel: ObservableObject {
    @Published var log = [Log]()
    var logViewModel = LogViewModel()
    
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
            listenerRegistration = db.collection("logs").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.log = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Log.self)
                }
            }
        }
    }
    
    func subscribeByLatestDateCompleted() {
        if listenerRegistration == nil {
            listenerRegistration = db.collection("logs").order(by: "DateCompleted", descending: true).addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.log = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Log.self)
                }
            }
        }
    }
    
    func removeLogItems(atOffsets indexSet: IndexSet) {
        let tasks = indexSet.lazy.map { self.log[$0] }
        tasks.forEach { task in
            if let documentId = task.id {
                db.collection("logs").document(documentId).delete { error in
                    if let error = error {
                        print("Unable to remove document: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
}

