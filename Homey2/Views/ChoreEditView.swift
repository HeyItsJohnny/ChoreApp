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
              Section(header: Text("Chore")) {
                  TextField("Name", text: $viewModel.chore.Name)
              }
              Section(header: Text("Points")) {
                  if #available(iOS 15.0, *) {
                      TextField("Points", value: $viewModel.chore.TotalPoints, format: .number)
                  } else {
                      // Fallback on earlier versions
                  }
              }
              Section(header: Text("Details")) {
                  Picker("Chore Owner", selection: $viewModel.chore.Username) {
                      ForEach(membersViewModel.housemember) { housemember in
                          Text(housemember.Name)
                              .tag(housemember.Name)
                      }
                  }
                  DatePicker("Next Due Date", selection: $viewModel.chore.NextDueDate, displayedComponents: [.date, .hourAndMinute])
                  Picker("Frequency", selection: $viewModel.chore.Frequency) {
                      ForEach(ChoreFrequency.allCases, id: \.self) { value in
                          Text(value.localizedName)
                              .tag(value)
                      }
                  }
                  Toggle("Mondays", isOn: $viewModel.chore.ScheduleMonday)
                  Toggle("Tuesdays", isOn: $viewModel.chore.ScheduleTuesday)
                  Toggle("Wednesdays", isOn: $viewModel.chore.ScheduleWednesday)
                  Toggle("Thursdays", isOn: $viewModel.chore.ScheduleThursday)
                  Toggle("Fridays", isOn: $viewModel.chore.ScheduleFriday)
                  Toggle("Saturdays", isOn: $viewModel.chore.ScheduleSaturday)
                  Toggle("Sundays", isOn: $viewModel.chore.ScheduleSunday)
              }
            if mode == .edit {
              Section {
                Button("Delete Chore") { self.presentActionSheet.toggle() }
                  .foregroundColor(.red)
              }
            }
          }
          .navigationTitle(mode == .new ? "New Chore" : viewModel.chore.Name)
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
