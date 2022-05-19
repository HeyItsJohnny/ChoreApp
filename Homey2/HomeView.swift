//
//  HomeView.swift
//  Homey2
//
//  Created by jonathan laroco on 11/16/21.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = TasksViewModel()
    @State var presentAddBookSheet = false
    
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
                    ForEach (viewModel.task) { taskitem in
                        itemRowView(task: taskitem)
                        .swipeActions(allowsFullSwipe: false) {
                            Button("Confirm") {
                                viewModel.confirmTaskItems(taskitem)
                            }
                            .tint(.green)
                        }
                    }
                }
                .navigationBarTitle("Up Coming Chores")
                .onAppear() {
                    print("TasksListView appears. Subscribing to data updates.")
                    self.viewModel.subscribeByNextDueDate()
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
