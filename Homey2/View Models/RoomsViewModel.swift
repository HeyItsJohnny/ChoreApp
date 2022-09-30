//
//  RoomsViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 5/20/22.
//

import Foundation
import Combine
import FirebaseFirestore

class RoomsViewModel: ObservableObject {
    @Published var room = [Room]()
    
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
            listenerRegistration = db.collection("rooms").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.room = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Room.self)
                }
            }
        }
    }
    
    func updateRoomStatus(_ room: Room, roomStatus: String) {
        do {
            var stat = "";
            switch roomStatus {
            case "Clean": stat = "Clean"
            case "Semi-Dirty": stat = "Semi-Dirty"
            case "Dirty": stat = "Dirty"
            default:
                print("Something got fucked up.");
            }
            print("Room NAME: \(room.Name)" );
            db.collection("rooms").document(room.id!).updateData([
                "Status": stat
            ])
            createRoomLog(room, NewStatus: roomStatus)
        } catch {
            print(error)
        }

    }
    
    func createRoomLog(_ room: Room, NewStatus: String) {
        do {
            var totPoints = 0
            
            if room.Status == .cleaned {
                totPoints = room.TotalPoints
            }
            let choreLog: Log = Log(
                LogType: "Room",
                Name: "Room: " + room.Name,
                Description: "Room Status Changed to: \(NewStatus)",
                TotalPoints: totPoints,
                UserId: room.UserID,
                Username: room.User,
                RoomId: room.id!,
                RoomName: room.Name,
                ChoreId: "",
                ChoreName: "",
                Approved: false,
                ApprovedBy: "",
                ApprovedByID: "",
                DateCompleted: Date()
            )
            
            let _ = try db.collection("logs").addDocument(from: choreLog)
        } catch {
            print(error)
        }
    }
    
    func removeRoomItems(atOffsets indexSet: IndexSet) {
        let rooms = indexSet.lazy.map { self.room[$0] }
        rooms.forEach { room in
            if let documentId = room.id {
                db.collection("rooms").document(documentId).delete { error in
                    if let error = error {
                        print("Unable to remove document: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
