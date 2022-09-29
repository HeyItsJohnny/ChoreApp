//
//  HouseMembersViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 1/31/22.
//

import Foundation
import Combine
import FirebaseFirestore

class HouseMembersViewModel: ObservableObject {
    @Published var housemember = [HouseMember]()
    
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
            listenerRegistration = db.collection("housemembers").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.housemember = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: HouseMember.self)
                }
            }
        }
    }
    
    func removeHouseMembers(atOffsets indexSet: IndexSet) {
        let housemembers = indexSet.lazy.map { self.housemember[$0] }
        housemembers.forEach { housemember in
            if let documentId = housemember.id {
                db.collection("housemembers").document(documentId).delete { error in
                    if let error = error {
                        print("Unable to remove document: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    /*
    func getHousememberIDFromName(username: String, userID: String) {
        let housemembersRef = db.collection("housemembers")
        let query = housemembersRef.whereField("Name", isEqualTo: username)
                
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //return docID = document.documentID
                    var userID = userID
                    userID = document.documentID
                    //print("Doc ID: " + docID);
                }
            }
        }
     
    }*/
    
}
