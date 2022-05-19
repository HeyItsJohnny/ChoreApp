//
//  MealsListView.swift
//  Homey2
//
//  Created by jonathan laroco on 1/21/22.
//

import SwiftUI

struct MealsListView: View {
    
    @StateObject var viewModel = MealsViewModel()
    @State var presentAddBookSheet = false
    @State private var searchText = ""
    
    private var addButton: some View {
        Button(action: { self.presentAddBookSheet.toggle() }) {
          Image(systemName: "plus")
        }
    }
    
    private func itemRowView(meal: Meal) -> some View {
        NavigationLink(destination: MealDetailsView(meal: meal)) {
            VStack(alignment: .leading) {
                Text(meal.name)
                    .font(.headline)
                Text(meal.user)
                    .font(.subheadline)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                List {
                    ForEach (searchResults) { mealitem in
                        itemRowView(meal: mealitem)
                    }
                    .onDelete() { indexSet in
                        viewModel.removeMealItems(atOffsets: indexSet)
                    }
                }
                .navigationBarTitle("Weekly Meals")
                .navigationBarItems(trailing: addButton)
                .searchable(text: $searchText)
                .onAppear() {
                    print("MealsListView appears. Subscribing to data updates.")
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
                    MealEditView()
                }
            } else {
                Text("You need to upgrade to iOS version 15 or greater.");
                //print("Search is not working because you aren't upgraded to iOS version 15.")
            }
        }
    }
        
    var searchResults: [Meal] {
        if searchText.isEmpty {
            return viewModel.meal
        } else {
            return viewModel.meal.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
}

struct MealsListView_Previews: PreviewProvider {
    static var previews: some View {
        MealsListView()
    }
}
