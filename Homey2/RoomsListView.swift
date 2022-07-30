//
//  RoomsListView.swift
//  Homey2
//
//  Created by jonathan laroco on 5/20/22.
//

import SwiftUI

struct RoomsListView: View {
    
    @StateObject var viewModel = RoomsViewModel()
    @State var presentAddBookSheet = false
    @State private var searchText = ""
    
    private var addButton: some View {
        Button(action: { self.presentAddBookSheet.toggle() }) {
          Image(systemName: "plus")
        }
    }
    
    @available(iOS 15.0, *)
    private func itemRowView(room: Room) -> some View {
        NavigationLink(destination: RoomDetailsView(room: room)) {
            VStack(alignment: .leading) {
                Text(room.Name)
                    .font(.headline.weight(.heavy))
                Text("User: " + room.User)
                    .font(.subheadline.weight(.heavy))
                Text(room.Status.localizedName)
                    .font(.subheadline.weight(.heavy))
                    .background(backgroundColor(for: room.Status))
                /*Text("Last Status Update: \(room.LastStatusUpdate.formatted(date: .long, time: .shortened))")
                 .font(.subheadline)*/
            }
        }
    }
    
    private func backgroundColor(for statusType: RoomStatus) -> Color {
        switch (statusType) {
        case .cleaned: return .green
        case .semidirty: return .orange
        case .dirty: return .red
        }
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                List {
                    ForEach (searchResults) { roomitem in
                        itemRowView(room: roomitem)
                            //.background(backgroundColor(for: roomitem.Status))
                    }
                    .onDelete() { indexSet in
                        viewModel.removeRoomItems(atOffsets: indexSet)
                    }
                    
                }
                .navigationBarTitle("Room Statuses")
                .navigationBarItems(trailing: addButton)
                .searchable(text: $searchText)
                .onAppear() {
                    print("RoomsListView appears. Subscribing to data updates.")
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
                    RoomEditView()
                }
            } else {
                Text("You need to upgrade to iOS version 15 or greater.");
                //print("Search is not working because you aren't upgraded to iOS version 15.")
            }
        }
    }
    
    var searchResults: [Room] {
        if searchText.isEmpty {
            return viewModel.room
        } else {
            return viewModel.room.filter { $0.Name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct RoomsListView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsListView()
    }
}
