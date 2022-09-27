//
//  HouseMemberEditView.swift
//  Homey2
//
//  Created by jonathan laroco on 1/31/22.
//

import SwiftUI

enum HouseMemberMode {
  case new
  case edit
}

enum HouseMemberAction {
  case delete
  case done
  case cancel
}

struct HouseMemberEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
    
    @ObservedObject var viewModel = HouseMemberViewModel()
    var mode: HouseMemberMode = .new
    var completionHandler: ((Result<HouseMemberAction, Error>) -> Void)?
        
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
                  TextField("Name", text: $viewModel.housemember.Name)
              }
            if mode == .edit {
              Section {
                Button("Delete Member") { self.presentActionSheet.toggle() }
                  .foregroundColor(.red)
              }
            }
          }
          .navigationTitle(mode == .new ? "New Member" : viewModel.housemember.Name)
          .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
          .navigationBarItems(
            leading: cancelButton,
            trailing: saveButton
          )
          .actionSheet(isPresented: $presentActionSheet) {
            ActionSheet(title: Text("Are you sure?"),
                        buttons: [
                          .destructive(Text("Delete Member"),
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

struct HouseMemberEditView_Previews: PreviewProvider {
    static var previews: some View {
        HouseMemberEditView()
    }
}
