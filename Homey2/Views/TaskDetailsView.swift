//
//  TaskDetailsView.swift
//  Homey2
//
//  Created by jonathan laroco on 11/16/21.
//

import SwiftUI

struct TaskDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var presentEditBookSheet = false
    
    var task: Task
    
    private func editButton(action: @escaping () -> Void) -> some View {
        Button(action: { action() }) {
          Text("Edit")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Name")) {
                Text(task.name)
            }
            Section(header: Text("User")) {
                Text(task.username)
            }
            Section(header: Text("Next Due Date")) {
                if #available(iOS 15.0, *) {
                    Text("\(task.nextduedate.formatted(date: .long, time: .shortened))")
                } else {
                    // Fallback on earlier versions
                }
            }
            Section(header: Text("Frequency")) {
                Text(task.frequency.localizedName)
            }
            Section(header: Text("Schedules")) {
                if (task.schedulemonday) {
                    Text("Monday")
                }
                if (task.scheduletuesday) {
                    Text("Tuesday")
                }
                if (task.schedulewednesday) {
                    Text("Wednesday")
                }
                if (task.schedulethursday) {
                    Text("Thursday")
                }
                if (task.schedulefriday) {
                    Text("Friday")
                }
                if (task.schedulesaturday) {
                    Text("Saturday")
                }
                if (task.schedulesunday) {
                    Text("Sunday")
                }
            }
            
        }
        .navigationBarTitle(task.name)
        .navigationBarItems(trailing: editButton {
          self.presentEditBookSheet.toggle()
        })
        .onAppear() {
            print("TaskDetailsView.onAppear() for \(self.task.name)")
        }
        .onDisappear() {
          print("TaskDetailsView.onDisappear()")
        }
        .sheet(isPresented: self.$presentEditBookSheet) {
          TaskEditView(viewModel: TaskViewModel(task: task), mode: .edit) { result in
            if case .success(let action) = result, action == .delete {
              self.presentationMode.wrappedValue.dismiss()
            }
          }
        }
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let task = Task(name: "TEST1", description: "", totalpoints: 0, frequency: .daily,room: "", userId: "", username: "", nextduedate: Date(), schedulesunday: false, schedulemonday: false, scheduletuesday: false, schedulewednesday: false, schedulethursday: false, schedulefriday: false, schedulesaturday: false)
        return
            NavigationView {
               TaskDetailsView(task: task)
             }
    }
}
