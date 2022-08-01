//
//  ChoreEditView.swift
//  Homey2
//
//  Created by jonathan laroco on 8/1/22.
//

import SwiftUI

enum ChoreMode {
  case new
  case edit
}

enum ChoreAction {
  case delete
  case done
  case cancel
}

struct ChoreEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
    
    @ObservedObject var viewModel = ChoreViewModel()
    @StateObject var membersViewModel = HouseMembersViewModel()
    
    var mode: ChoreMode = .new
    var completionHandler: ((Result<ChoreAction, Error>) -> Void)?
        
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
                  TextField("Name", text: $viewModel.chore.name)
              }
              Section(header: Text("Details")) {
                  Picker("Chore Owner", selection: $viewModel.chore.username) {
                      ForEach(membersViewModel.housemember) { housemember in
                          Text(housemember.name)
                              .tag(housemember.name)
                      }
                  }
                  DatePicker("Next Due Date", selection: $viewModel.chore.nextduedate, displayedComponents: [.date, .hourAndMinute])
                  Picker("Frequency", selection: $viewModel.chore.frequency) {
                      ForEach(ChoreFrequency.allCases, id: \.self) { value in
                          Text(value.localizedName)
                              .tag(value)
                      }
                  }
                  Toggle("Mondays", isOn: $viewModel.chore.schedulemonday)
                  Toggle("Tuesdays", isOn: $viewModel.chore.scheduletuesday)
                  Toggle("Wednesdays", isOn: $viewModel.chore.schedulewednesday)
                  Toggle("Thursdays", isOn: $viewModel.chore.schedulethursday)
                  Toggle("Fridays", isOn: $viewModel.chore.schedulefriday)
                  Toggle("Saturdays", isOn: $viewModel.chore.schedulesaturday)
                  Toggle("Sundays", isOn: $viewModel.chore.schedulesunday)
              }
            if mode == .edit {
              Section {
                Button("Delete Chore") { self.presentActionSheet.toggle() }
                  .foregroundColor(.red)
              }
            }
          }
          .navigationTitle(mode == .new ? "New Chore" : viewModel.chore.name)
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
                          .destructive(Text("Delete Chore"),
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

struct ChoreEditView_Previews: PreviewProvider {
    static var previews: some View {
        ChoreEditView()
    }
}
