//
//  LogViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 9/26/22.
//

import Foundation
import Combine
import FirebaseFirestore

class LogViewModel: ObservableObject {
    @Published var log: Log
    @Published var modified = false
    
  private var cancellables = Set<AnyCancellable>()
  
  //Constructors
  
    
    init(log: Log = Log(LogType: "", Name: "", Description: "", TotalPoints: 0, UserId: "", Username: "", RoomId: "", RoomName: "", ChoreId: "", ChoreName: "",Approved: false, ApprovedBy: "", ApprovedByID: "", DateCompleted: Date())) {
        self.log = log
        self.$log
          .dropFirst()
          .sink { [weak self] room in
            self?.modified = true
          }
          .store(in: &self.cancellables)
    }
  
    private var db = Firestore.firestore()
    
      func addLog(_ log: Log) {
          do {
            let _ = try db.collection("logs").addDocument(from: log)
          }
          catch {
            print(error)
          }
      }
      
      private func updateLog(_ log: Log) {
          if let documentId = log.id {
              do {
                  try db.collection("logs").document(documentId).setData(from: log)
              }
              catch {
                  print(error)
              }
        }
      }
      
      private func updateOrAddLog() {
          if let _ = log.id {
              self.updateLog(self.log)
          }
          else {
              addLog(log)
          }
      }
      
      private func removeLog() {
          if let documentId = log.id {
            db.collection("logs").document(documentId).delete { error in
              if let error = error {
                print(error.localizedDescription)
              }
            }
          }
      }
    
      func handleDoneTapped() {
          self.updateOrAddLog()
      }
      
      func handleDeleteTapped() {
          self.removeLog()
        }
}
