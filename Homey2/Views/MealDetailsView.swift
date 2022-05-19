//
//  MealDetailsView.swift
//  Homey2
//
//  Created by jonathan laroco on 1/22/22.
//

import SwiftUI

struct MealDetailsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var presentEditBookSheet = false
    
    var meal: Meal
    
    private func editButton(action: @escaping () -> Void) -> some View {
        Button(action: { action() }) {
          Text("Edit")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Meal")) {
                Text(meal.name)
            }
            Section(header: Text("Description")) {
                Text(meal.description)
            }
            Section(header: Text("User")) {
                Text(meal.user)
            }
            Section(header: Text("Day of Meal")) {
                Text(meal.dayofmeal.localizedName)
            }
        }
        .navigationBarTitle(meal.name)
        .navigationBarItems(trailing: editButton {
          self.presentEditBookSheet.toggle()
        })
        .onAppear() {
            print("MealDetailsView.onAppear() for \(self.meal.name)")
        }
        .onDisappear() {
          print("MealDetailsView.onDisappear()")
        }
        .sheet(isPresented: self.$presentEditBookSheet) {
          MealEditView(viewModel: MealViewModel(meal: meal), mode: .edit) { result in
            if case .success(let action) = result, action == .delete {
              self.presentationMode.wrappedValue.dismiss()
            }
          }
        }
    }
    
}

struct MealDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let meal = Meal(name: "TEST1", description: "", dayofmeal: .monday, user: "")
        return
            NavigationView {
               MealDetailsView(meal: meal)
             }
    }
}
