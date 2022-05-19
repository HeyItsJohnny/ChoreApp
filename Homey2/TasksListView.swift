//
//  TasksListView.swift
//  Homey2
//
//  Created by jonathan laroco on 11/16/21.
//

import SwiftUI

struct TasksListView: View {
    
    @StateObject var viewModel = TasksViewModel()
    @State var presentAddBookSheet = false
    @State private var searchText = ""
    
    private var addButton: some View {
        Button(action: { self.presentAddBookSheet.toggle() }) {
          Image(systemName: "plus")
        }
    }
    
    @available(iOS 15.0, *)
    private func itemRowView(task: Task) -> some View {
        NavigationLink(destination: TaskDetailsView(task: task)) {
            VStack(alignment: .leading) {
                Text(task.name)
                    .font(.headline)
                Text("User: " + task.username)
                    .font(.subheadline)
                Text("Next Due Date: \(task.nextduedate.formatted(date: .long, time: .shortened))")
                    .font(.subheadline)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 15.0, *) {
                List {
                    ForEach (searchResults) { taskitem in
                        itemRowView(task: taskitem)
                    }
                    .onDelete() { indexSet in
                        viewModel.removeTaskItems(atOffsets: indexSet)
                    }
                }
                .navigationBarTitle("House Chores")
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
                    TaskEditView()
                }
            } else {
                Text("You need to upgrade to iOS version 15 or greater.");
                //print("Search is not working because you aren't upgraded to iOS version 15.")
            }
        }
    }
    var searchResults: [Task] {
        if searchText.isEmpty {
            return viewModel.task
        } else {
            return viewModel.task.filter { $0.username.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct TasksListView_Previews: PreviewProvider {
    static var previews: some View {
        TasksListView()
    }
}
