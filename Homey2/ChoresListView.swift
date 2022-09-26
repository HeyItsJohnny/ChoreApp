//
//  ChoresListView.swift
//  Homey2
//
//  Created by jonathan laroco on 5/20/22.
//

import SwiftUI

struct ChoresListView: View {
    @StateObject var viewModel = ChoresViewModel()
    @State var presentAddBookSheet = false
    @State private var searchText = ""
    
    private var addButton: some View {
        Button(action: { self.presentAddBookSheet.toggle() }) {
          Image(systemName: "plus")
        }
    }
    
    @available(iOS 15.0, *)
    private func itemRowView(chore: Chore) -> some View {
        NavigationLink(destination: ChoreDetailsView(chore: chore)) {
            VStack(alignment: .leading) {
                Text(chore.name)
                    .font(.headline)
                Text("User: " + chore.username)
                    .font(.subheadline)
                Text("Points: \(chore.totalpoints)")
                    .font(.subheadline)
                Text("Next Due Date: \(chore.nextduedate.formatted(date: .long, time: .shortened))")
                    .font(.subheadline)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                List {
                    ForEach (searchResults) { item in
                        itemRowView(chore: item)
                    }
                    .onDelete() { indexSet in
                        viewModel.removeChoreItems(atOffsets: indexSet)
                    }
                }
                .navigationBarTitle("Chores List")
                .navigationBarItems(trailing: addButton)
                .searchable(text: $searchText)
                .onAppear() {
                    print("TasksListView appears. Subscribing to data updates.")
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
                //.searchable(text: $searchText)
                .sheet(isPresented: self.$presentAddBookSheet) {
                    ChoreEditView()
                }
            } else {
                Text("You need to upgrade to iOS version 15 or greater.");
                //print("Search is not working because you aren't upgraded to iOS version 15.")
            }
        }
    }
    var searchResults: [Chore] {
        if searchText.isEmpty {
            return viewModel.chore
        } else {
            return viewModel.chore.filter { $0.username.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct ChoresListView_Previews: PreviewProvider {
    static var previews: some View {
        ChoresListView()
    }
}
