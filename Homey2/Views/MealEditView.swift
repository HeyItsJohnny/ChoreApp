//
//  MealEditView.swift
//  Homey2
//
//  Created by jonathan laroco on 1/22/22.
//

import SwiftUI

enum MealMode {
  case new
  case edit
}

enum MealAction {
  case delete
  case done
  case cancel
}

struct MealEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
    
    @ObservedObject var viewModel = MealViewModel()
    @StateObject var membersViewModel = HouseMembersViewModel()
    
    var mode: MealMode = .new
    var completionHandler: ((Result<MealAction, Error>) -> Void)?
        
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
              Section(header: Text("Name")) {
                  TextField("Name", text: $viewModel.meal.name)
              }
              Section(header: Text("Description")) {
                  TextField("Description", value: $viewModel.meal.description, formatter: NumberFormatter())
              }
             Section(header: Text("Details")) {
                  Picker("Cook", selection: $viewModel.meal.user) {
                      ForEach(membersViewModel.housemember) { housemember in
                          Text(housemember.name)
                              .tag(housemember.name)
                      }
                  }
                  Picker("Day of Meal", selection: $viewModel.meal.dayofmeal) {
                      ForEach(DayofTheWeek.allCases, id: \.self) { value in
                          Text(value.localizedName)
                              .tag(value)
                      }
                  }
             }
            if mode == .edit {
              Section {
                Button("Delete Meal") { self.presentActionSheet.toggle() }
                  .foregroundColor(.red)
              }
            }
          }
          .navigationTitle(mode == .new ? "New Meal" : viewModel.meal.name)
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
                          .destructive(Text("Delete Meal"),
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

struct MealEditView_Previews: PreviewProvider {
    static var previews: some View {
        MealEditView()
    }
}
