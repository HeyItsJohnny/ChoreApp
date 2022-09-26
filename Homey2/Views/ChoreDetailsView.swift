//
//  ChoreDetailsView.swift
//  Homey2
//
//  Created by jonathan laroco on 8/1/22.
//

import SwiftUI

struct ChoreDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var presentEditBookSheet = false
    
    var chore: Chore
    
    private func editButton(action: @escaping () -> Void) -> some View {
        Button(action: { action() }) {
          Text("Edit")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Name")) {
                Text(chore.name)
            }
            Section(header: Text("User")) {
                Text(chore.username)
            }
            Section(header: Text("Points")) {
                Text("\(chore.totalpoints)")
            }
            Section(header: Text("Next Due Date")) {
                if #available(iOS 15.0, *) {
                    Text("\(chore.nextduedate.formatted(date: .long, time: .shortened))")
                } else {
                    // Fallback on earlier versions
                }
            }
            Section(header: Text("Frequency")) {
                Text(chore.frequency.localizedName)
            }
            Section(header: Text("Schedules")) {
                if (chore.schedulemonday) {
                    Text("Monday")
                }
                if (chore.scheduletuesday) {
                    Text("Tuesday")
                }
                if (chore.schedulewednesday) {
                    Text("Wednesday")
                }
                if (chore.schedulethursday) {
                    Text("Thursday")
                }
                if (chore.schedulefriday) {
                    Text("Friday")
                }
                if (chore.schedulesaturday) {
                    Text("Saturday")
                }
                if (chore.schedulesunday) {
                    Text("Sunday")
                }
            }
            
        }
        .navigationBarTitle(chore.name)
        .navigationBarItems(trailing: editButton {
          self.presentEditBookSheet.toggle()
        })
        .onAppear() {
            print("ChoreDetailsView.onAppear() for \(self.chore.name)")
        }
        .onDisappear() {
          print("ChoreDetailsView.onDisappear()")
        }
        .sheet(isPresented: self.$presentEditBookSheet) {
          ChoreEditView(viewModel: ChoreViewModel(chore: chore), mode: .edit) { result in
            if case .success(let action) = result, action == .delete {
              self.presentationMode.wrappedValue.dismiss()
            }
          }
        }
    }
}

struct ChoreDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let chore = Chore(name: "TEST1", description: "", totalpoints: 0, frequency: .daily,room: "", userId: "", username: "", nextduedate: Date(), schedulesunday: false, schedulemonday: false, scheduletuesday: false, schedulewednesday: false, schedulethursday: false, schedulefriday: false, schedulesaturday: false)
        return
            NavigationView {
               ChoreDetailsView(chore: chore)
             }
    }
}
