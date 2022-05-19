//
//  RestaurantDetailsView.swift
//  Homey2
//
//  Created by jonathan laroco on 4/7/22.
//

import SwiftUI

struct RestaurantDetailsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var presentEditBookSheet = false
    
    var restaurant: Restaurant
    
    private func editButton(action: @escaping () -> Void) -> some View {
        Button(action: { action() }) {
          Text("Edit")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Restaurant")) {
                Text(restaurant.name)
            }
            Section(header: Text("Type")) {
                Text(restaurant.type)
            }
            Section(header: Text("Distance (Miles)")) {
                Text("\(restaurant.distance, specifier: "%.2f") miles")
            }
            Section(header: Text("Healthy Meter")) {
                Text(restaurant.healthyMeter.localizedName)
            }
        }
        .navigationBarTitle(restaurant.name)
        .navigationBarItems(trailing: editButton {
          self.presentEditBookSheet.toggle()
        })
        .onAppear() {
            print("RestaurantDetailsView.onAppear() for \(self.restaurant.name)")
        }
        .onDisappear() {
          print("RestaurantDetailsView.onDisappear()")
        }
        .sheet(isPresented: self.$presentEditBookSheet) {
          RestaurantEditView(viewModel: RestaurantViewModel(restaurant: restaurant), mode: .edit) { result in
            if case .success(let action) = result, action == .delete {
              self.presentationMode.wrappedValue.dismiss()
            }
          }
        }
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let restaurant = Restaurant(name: "TEST1", type: "", distance: 0, healthyMeter: .healthy)
        return
            NavigationView {
               RestaurantDetailsView(restaurant: restaurant)
             }
    }
}
