//
//  RoomEditView.swift
//  Homey2
//
//  Created by jonathan laroco on 5/20/22.
//

import SwiftUI

enum RoomMode {
  case new
  case edit
}

enum RoomAction {
  case delete
  case done
  case cancel
}

struct RoomEditView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
    
    @ObservedObject var viewModel = RoomViewModel()
    @StateObject var membersViewModel = HouseMembersViewModel()
    
    var mode: RoomMode = .new
    var completionHandler: ((Result<RoomAction, Error>) -> Void)?
        
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
                  TextField("Name", text: $viewModel.room.Name)
              }
              Section(header: Text("Details")) {
                  Picker("User", selection: $viewModel.room.User) {
                      ForEach(membersViewModel.housemember) { housemember in
                          Text(housemember.name)
                              .tag(housemember.name)
                      }
                  }
                  Picker("Status", selection: $viewModel.room.Status) {
                      ForEach(RoomStatus.allCases, id: \.self) { value in
                          Text(value.localizedName)
                              .tag(value)
                      }
                  }
              }
              /*
              Section(header: Text("Last Status Update")) {
                  if #available(iOS 15.0, *) {
                      Text("\(room.LastStatusUpdate.formatted(date: .long, time: .shortened))")
                  } else {
                      // Fallback on earlier versions
                  }
              } */
            if mode == .edit {
              Section {
                Button("Delete Meal") { self.presentActionSheet.toggle() }
                  .foregroundColor(.red)
              }
            }
          }
          .navigationTitle(mode == .new ? "New Room" : viewModel.room.Name)
          .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
          .navigationBarItems(
            leading: cancelButton,
            trailing: saveButton
          )
          .onAppear() {
              self.membersViewModel.subscribe()
          }
          .actionSheet(isPresented: $presentActionSheet) {
            ActionSheet(title: Text("Are you sure?"),
                        buttons: [
                          .destructive(Text("Delete Room"),
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

struct RoomEditView_Previews: PreviewProvider {
    static var previews: some View {
        RoomEditView()
    }
}
