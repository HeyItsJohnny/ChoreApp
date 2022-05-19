//
//  RestaurantsListView.swift
//  Homey2
//
//  Created by jonathan laroco on 4/7/22.
//

import SwiftUI

struct RestaurantsListView: View {
    
    @State private var selectedHealth = "All"
    let health = ["All", "Healthy", "Semi-Healthy", "Un-Healthy"]
    
    @StateObject var viewModel = RestaurantsViewModel()
    @State var presentAddBookSheet = false
            
    private var addButton: some View {
        Button(action: { self.presentAddBookSheet.toggle() }) {
          Image(systemName: "plus")
        }
    }
    
    private func itemRowView(restaurant: Restaurant) -> some View {
        NavigationLink(destination: RestaurantDetailsView(restaurant: restaurant)) {
            VStack(alignment: .leading) {
                Text(restaurant.name + " - " + restaurant.type)
                    .font(.headline)
                Text("\(restaurant.distance, specifier: "%.2f") miles")
                    .font(.subheadline)
                Text(restaurant.healthyMeter.localizedName)
                    .font(.subheadline)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                Form {
                    Section(header: Text("Healthy Meter")) {
                        Picker("Selection", selection: $selectedHealth) {
                            ForEach(health, id: \.self) {
                                Text($0)
                            }
                        }
                            
                    }
                    
                    Section(header: Text("Choose for me")) {
                        Text("Your Randomized Selection Here")
                    }
                    
                    Section(header: Text("Restaurant List")) {
                        List {
                            ForEach (filteredHealthyMeter) { restaurantitem in
                                itemRowView(restaurant: restaurantitem)
                            }
                            .onDelete() { indexSet in
                                viewModel.removeRestaurantItems(atOffsets: indexSet)
                            }
                        }
                    }
                }
                .navigationBarTitle("Restaurants")
                .navigationBarItems(trailing: addButton)
                .onAppear() {
                    print("RestaurantsListView appears. Subscribing to data updates.")
                    self.viewModel.subscribe()
                }
                .onDisappear() {
                    // By unsubscribing from the view model, we prevent updates coming in from
                    // Firestore to be reflected in the UI. Since we do want to receive updates
                    // when the user is on any of the child screens, we keep the subscription active!
                    //
                    // print("BooksListView disappears. Unsubscribing from data updates.")
                    // self.viewModel.unsubscribe()
                }
                .sheet(isPresented: self.$presentAddBookSheet) {
                    RestaurantEditView()
                }
            } else {
                Text("You need to upgrade to iOS version 15 or greater.");
                //print("Search is not working because you aren't upgraded to iOS version 15.")
            }
        }
    }
    
    var filteredHealthyMeter: [Restaurant] {
        switch selectedHealth {
            case "All":
                return viewModel.restaurant
            case "Healthy":
                return viewModel.restaurant.filter { $0.healthyMeter.rawValue.lowercased() == "healthy" }
            case "Semi-Healthy":
                return viewModel.restaurant.filter { $0.healthyMeter.rawValue.lowercased() == "semi-healthy" }
            case "Un-Healthy":
                return viewModel.restaurant.filter { $0.healthyMeter.rawValue.lowercased() == "un-healthy" }
        default:
            return viewModel.restaurant
        }
    }
}

struct RestaurantsListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsListView()
    }
}
