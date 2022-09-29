//
//  LogsListView.swift
//  Homey2
//
//  Created by jonathan laroco on 9/26/22.
//

import SwiftUI

struct LogsListView: View {
    @StateObject var viewModel = LogsViewModel()
    @State var presentAddBookSheet = false
    @State private var searchText = ""
    //@State private var isPresentingConfirm: Bool = false
     
    
    @available(iOS 15.0, *)
    private func itemRowView(log: Log) -> some View {
        NavigationLink(destination: LogDetailsView(log: log)) {
            VStack(alignment: .leading) {
                Text(log.LogType)
                    .font(.headline)
                Text("Summary: " + log.Name)
                    .font(.subheadline)
                Text("User: " + log.Username)
                    .font(.subheadline)
                Text("Date: \(log.DateCompleted.formatted(date: .long, time: .shortened))")
                    .font(.subheadline)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                List {
                    ForEach (searchResults) { item in
                        itemRowView(log: item)
                    }
                    .onDelete() { indexSet in
                        viewModel.removeLogItems(atOffsets: indexSet)
                    }
                }
                .navigationBarTitle("Logs")
                .searchable(text: $searchText)
                .onAppear() {
                    self.viewModel.subscribeByLatestDateCompleted()
                }
                .onDisappear() {
                    self.viewModel.unsubscribe()
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
    var searchResults: [Log] {
        if searchText.isEmpty {
            return viewModel.log
        } else {
            return viewModel.log.filter { $0.Username.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct LogsListView_Previews: PreviewProvider {
    static var previews: some View {
        LogsListView()
    }
}
