//
//  SettingsView.swift
//  Homey2
//
//  Created by jonathan laroco on 1/22/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = HouseMembersViewModel()
    @State var presentAddBookSheet = false
    @State private var searchText = ""
    
    private var addMemberButton: some View {
        Button(action: { self.presentAddBookSheet.toggle() }) {
          Image(systemName: "plus")
        }
    }
    
    private func itemRowView(housemember: HouseMember) -> some View {
        NavigationLink(destination: HouseMemberDetailsView(housemember: housemember)) {
            VStack(alignment: .leading) {
                Text(housemember.Name)
                    .font(.headline)
            }
        }
    }
    
    private var signOutButton: some View {
        Button(action: { authViewModel.SignOut() }) {
            Text("Sign Out")
        }
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                Form {
                    Section(header: Text("House Members")) {
                        List {
                            ForEach (viewModel.housemember) { hm in
                                itemRowView(housemember: hm)
                            }
                            .onDelete() { indexSet in
                                viewModel.removeHouseMembers(atOffsets: indexSet)
                            }
                        }
                    }
                }
                .navigationBarTitle("Settings")
                .navigationBarItems(leading: signOutButton,trailing: addMemberButton)
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
