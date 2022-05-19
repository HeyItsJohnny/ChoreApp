//
//  RestaurantEditView.swift
//  Homey2
//
//  Created by jonathan laroco on 4/7/22.
//

import SwiftUI

enum RestaurantMode {
  case new
  case edit
}

enum RestaurantAction {
  case delete
  case done
  case cancel
}


struct RestaurantEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
    
    @ObservedObject var viewModel = RestaurantViewModel()
    
    var mode: RestaurantMode = .new
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
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
    }()
    
    var body: some View {
        NavigationView {
          Form {
              Section(header: Text("Name")) {
                  TextField("Name", text: $viewModel.restaurant.name)
              }
              Section(header: Text("Type")) {
                  TextField("Type", text: $viewModel.restaurant.type)
              }
              Section(header: Text("Distance (Miles)")) {
                  TextField("Distance", value: $viewModel.restaurant.distance, formatter: formatter)
              }
              Section(header: Text("Healthy Meter")) {
                  Picker("Healthy Meter", selection: $viewModel.restaurant.healthyMeter) {
                      ForEach(HealthyMeter.allCases, id: \.self) { value in
                          Text(value.localizedName)
                              .tag(value)
                      }
                  }
              }
            if mode == .edit {
              Section {
                Button("Delete Restaurant") { self.presentActionSheet.toggle() }
                  .foregroundColor(.red)
              }
            }
          }
          .navigationTitle(mode == .new ? "New Restaurant" : viewModel.restaurant.name)
          .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
          .navigationBarItems(
            leading: cancelButton,
            trailing: saveButton
          )
          .onAppear() {
              //Subscribing to Members View Model
          }
          .actionSheet(isPresented: $presentActionSheet) {
            ActionSheet(title: Text("Are you sure?"),
                        buttons: [
                          .destructive(Text("Delete Restaurant"),
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


struct RestaurantEditView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantEditView()
    }
}
