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
                Text(chore.Name)
            }
            Section(header: Text("User")) {
                Text(chore.Username)
            }
            Section(header: Text("Points")) {
                Text("\(chore.TotalPoints)")
            }
            Section(header: Text("Next Due Date")) {
                if #available(iOS 15.0, *) {
                    Text("\(chore.NextDueDate.formatted(date: .long, time: .shortened))")
                } else {
                    // Fallback on earlier versions
                }
            }
            Section(header: Text("Frequency")) {
                Text(chore.Frequency.localizedName)
            }
            Section(header: Text("Schedules")) {
                if (chore.ScheduleMonday) {
                    Text("Monday")
                }
                if (chore.ScheduleTuesday) {
                    Text("Tuesday")
                }
                if (chore.ScheduleWednesday) {
                    Text("Wednesday")
                }
                if (chore.ScheduleThursday) {
                    Text("Thursday")
                }
                if (chore.ScheduleFriday) {
                    Text("Friday")
                }
                if (chore.ScheduleSaturday) {
                    Text("Saturday")
                }
                if (chore.ScheduleSunday) {
                    Text("Sunday")
                }
            }
            
        }
        .navigationBarTitle(chore.Name)
        .navigationBarItems(trailing: editButton {
          self.presentEditBookSheet.toggle()
        })
        .onAppear() {
            print("ChoreDetailsView.onAppear() for \(self.chore.Name)")
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
        let chore = Chore(Name: "TEST1", Description: "", TotalPoints: 0, Frequency: .daily,Room: "", UserId: "", Username: "", NextDueDate: Date(), ScheduleSunday: false, ScheduleMonday: false, ScheduleTuesday: false, ScheduleWednesday: false, ScheduleThursday: false, ScheduleFriday: false, ScheduleSaturday: false)
        return
            NavigationView {
               ChoreDetailsView(chore: chore)
             }
    }
}
