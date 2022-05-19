//
//  TasksViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 11/16/21.
//
import Foundation
import Combine
import FirebaseFirestore

class TasksViewModel: ObservableObject {
    @Published var task = [Task]()
    var taskViewModel = TaskViewModel()
    
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
      listenerRegistration = db.collection("tasks").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
        
        self.task = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Task.self)
        }
      }
    }
    }
    func subscribeByNextDueDate() {
        if listenerRegistration == nil {
            listenerRegistration = db.collection("tasks").order(by: "nextduedate").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.task = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Task.self)
                }
            }
        }
    }

    func removeTaskItems(atOffsets indexSet: IndexSet) {
        let tasks = indexSet.lazy.map { self.task[$0] }
          tasks.forEach { task in
          if let documentId = task.id {
            db.collection("tasks").document(documentId).delete { error in
              if let error = error {
                print("Unable to remove document: \(error.localizedDescription)")
              }
            }
          }
        }
    }

    func confirmTaskItems(_ task: Task) {
        do {
            let taskLog: TaskLog = TaskLog(
                name: task.name,
                description: task.description,
                totalpoints: task.totalpoints,
                room: task.room,
                userId: task.userId,
                username: task.username,
                datecompleted: Date()
            )
            
            let _ = try db.collection("tasks").document(task.id!).collection("tasklogs").addDocument(from: taskLog)
            taskViewModel.updateTaskDueDate(task)
        } catch {
            print(error)
        }
        //Create a Task Log for the item
        //Update Next Due Date
        print("Document ID: " + task.id! + " Name: " + task.name);
    }

}
