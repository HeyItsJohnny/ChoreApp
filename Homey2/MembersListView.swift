//
//  MembersListView.swift
//  Homey2
//
//  Created by jonathan laroco on 11/30/21.
//

import SwiftUI

struct MembersListView: View {
    
    @StateObject var viewModel = HouseMembersViewModel()
    @State var presentAddBookSheet = false
    @State private var searchText = ""
    
    private var addButton: some View {
        Button(action: { self.presentAddBookSheet.toggle() }) {
          Image(systemName: "plus")
        }
    }
    
    private func itemRowView(housemember: HouseMember) -> some View {
        NavigationLink(destination: HouseMemberDetailsView(housemember: housemember)) {
            VStack(alignment: .leading) {
                Text(housemember.name)
                    .font(.headline)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                List {
                    ForEach (viewModel.housemember) { hm in
                        itemRowView(housemember: hm)
                    }
                    .onDelete() { indexSet in
                        viewModel.removeHouseMembers(atOffsets: indexSet)
                    }
                }
                .navigationBarTitle("House Members")
                .navigationBarItems(trailing: addButton)
                .onAppear() {
                    print("HouseMembersListView appears. Subscribing to data updates.")
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
                    HouseMemberEditView()
                }
            } else {
                Text("You need to upgrade to iOS version 15 or greater.");
                //print("Search is not working because you aren't upgraded to iOS version 15.")
            }
        }
    }
}

struct MembersListView_Previews: PreviewProvider {
    static var previews: some View {
        MembersListView()
    }
}
