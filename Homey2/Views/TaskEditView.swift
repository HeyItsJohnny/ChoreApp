//
//  TaskEditView.swift
//  Homey2
//
//  Created by jonathan laroco on 11/16/21.
//

import SwiftUI

enum Mode {
  case new
  case edit
}

enum Action {
  case delete
  case done
  case cancel
}

struct TaskEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
    
    @ObservedObject var viewModel = TaskViewModel()
    @StateObject var membersViewModel = HouseMembersViewModel()
    
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
        
    var cancelButton: some View {
      Button(action: { self.handleCancelTapped() }) {
        Text("Cancel")
      }
    }
    
    var saveButton: some View {
      Button(action: { self.handleDoneTapped() }) {
        Text(mode == .new ? "Done" : "Save")
      }
      .disabled(!viewModel.modified)
    }
    
    var body: some View {
        NavigationView {
          Form {
              Section(header: Text("Chore/Responsibility")) {
                  TextField("Name", text: $viewModel.task.name)
              }
              Section(header: Text("Details")) {
                  Picker("Task Owner", selection: $viewModel.task.username) {
                      ForEach(membersViewModel.housemember) { housemember in
                          Text(housemember.name)
                              .tag(housemember.name)
                      }
                  }
                  DatePicker("Next Due Date", selection: $viewModel.task.nextduedate, displayedComponents: [.date, .hourAndMinute])
                  Picker("Frequency", selection: $viewModel.task.frequency) {
                      ForEach(TaskFrequency.allCases, id: \.self) { value in
                          Text(value.localizedName)
                              .tag(value)
                      }
                  }
                  Toggle("Mondays", isOn: $viewModel.task.schedulemonday)
                  Toggle("Tuesdays", isOn: $viewModel.task.scheduletuesday)
                  Toggle("Wednesdays", isOn: $viewModel.task.schedulewednesday)
                  Toggle("Thursdays", isOn: $viewModel.task.schedulethursday)
                  Toggle("Fridays", isOn: $viewModel.task.schedulefriday)
                  Toggle("Saturdays", isOn: $viewModel.task.schedulesaturday)
                  Toggle("Sundays", isOn: $viewModel.task.schedulesunday)
              }
            if mode == .edit {
              Section {
                Button("Delete Task") { self.presentActionSheet.toggle() }
                  .foregroundColor(.red)
              }
            }
          }
          .navigationTitle(mode == .new ? "New Task" : viewModel.task.name)
          .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
          .navigationBarItems(
            leading: cancelButton,
            trailing: saveButton
          )
          .onAppear() {
              //Subscribing to Members View Model
              self.membersViewModel.subscribe()
          }
          .actionSheet(isPresented: $presentActionSheet) {
            ActionSheet(title: Text("Are you sure?"),
                        buttons: [
                          .destructive(Text("Delete Task"),
                                       action: { self.handleDeleteTapped() }),
                          .cancel()
                        ])
          }
        }
    }
    
    func handleCancelTapped() {
      self.dismiss()
    }
    
    func handleDoneTapped() {
        self.viewModel.handleDoneTapped()
        self.dismiss()
    }
    
    func handleDeleteTapped() {
        self.viewModel.handleDeleteTapped()
        self.dismiss()
        self.completionHandler?(.success(.delete))
    }
    
    func dismiss() {
      self.presentationMode.wrappedValue.dismiss()
    }
}

struct TaskEditView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditView()
    }
}
