//
//  TaskViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 11/16/21.
//
import Foundation
import Combine
import FirebaseFirestore

class TaskViewModel: ObservableObject {
  @Published var task: Task
  @Published var modified = false
    
  private var cancellables = Set<AnyCancellable>()
  
  //Constructors
  
    init(task: Task = Task(name: "", description: "", totalpoints: 0, frequency: .daily, room: "", userId: "", username: "", nextduedate: Date(), schedulesunday: false, schedulemonday: false, scheduletuesday: false, schedulewednesday: false, schedulethursday: false, schedulefriday: false, schedulesaturday: false)) {
    self.task = task
    self.$task
      .dropFirst()
      .sink { [weak self] task in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
  
  //Firestore
  
  private var db = Firestore.firestore()
  
    func addTask(_ task: Task) {
        do {
          let _ = try db.collection("tasks").addDocument(from: task)
        }
        catch {
          print(error)
        }
    }
    
    private func updateTask(_ task: Task) {
        if let documentId = task.id {
            do {
                try db.collection("tasks").document(documentId).setData(from: task)
            }
            catch {
                print(error)
            }
      }
    }
    
    private func updateOrAddTask() {
        if let _ = task.id {
            self.updateTask(self.task)
        }
        else {
            addTask(task)
        }
    }
    
    private func removeTask() {
        if let documentId = task.id {
          db.collection("tasks").document(documentId).delete { error in
            if let error = error {
              print(error.localizedDescription)
            }
          }
        }
    }
    
    func updateTaskDueDate(_ task: Task) {
        let taskDueDate = task.nextduedate
        var modifiedDate = taskDueDate
        
        switch task.frequency.rawValue {
            case "Daily": modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: taskDueDate)!
            case "Weekly": modifiedDate = Calendar.current.date(byAdding: .day, value: 7, to: taskDueDate)!
            case "Every 2 Weeks": modifiedDate = Calendar.current.date(byAdding: .day, value: 14, to: taskDueDate)!
            case "Every 3 Weekly": modifiedDate = Calendar.current.date(byAdding: .day, value: 21, to: taskDueDate)!
            case "Monthly": modifiedDate = Calendar.current.date(byAdding: .month, value: 1, to: taskDueDate)!
            case "Annually": modifiedDate = Calendar.current.date(byAdding: .year, value: 1, to: taskDueDate)!
        default:
            print("Something got fucked up..")
        }
        
        db.collection("tasks").document(task.id!).updateData([
            "nextduedate": modifiedDate
        ])
    }
  
    func handleDoneTapped() {
        self.updateOrAddTask()
    }
    
    func handleDeleteTapped() {
        self.removeTask()
      }
}
