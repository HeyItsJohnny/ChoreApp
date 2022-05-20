//
//  RoomDetailsView.swift
//  Homey2
//
//  Created by jonathan laroco on 5/20/22.
//

import SwiftUI

struct RoomDetailsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var presentEditBookSheet = false
    
    var room: Room
    
    private func editButton(action: @escaping () -> Void) -> some View {
        Button(action: { action() }) {
          Text("Edit")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Room")) {
                Text(room.Name)
            }
            Section(header: Text("Assigned User")) {
                Text(room.User)
            }
            Section(header: Text("Status")) {
                Text(room.Status.localizedName)
            }
            Section(header: Text("Last Status Update")) {
                if #available(iOS 15.0, *) {
                    Text("\(room.LastStatusUpdate.formatted(date: .long, time: .shortened))")
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        .navigationBarTitle(room.Name)
        .navigationBarItems(trailing: editButton {
          self.presentEditBookSheet.toggle()
        })
        .onAppear() {
            print("RoomDetailsView.onAppear() for \(self.room.Name)")
        }
        .onDisappear() {
          print("RoomDetailsView.onDisappear()")
        }
        .sheet(isPresented: self.$presentEditBookSheet) {
          RoomEditView(viewModel: RoomViewModel(room: room), mode: .edit) { result in
            if case .success(let action) = result, action == .delete {
              self.presentationMode.wrappedValue.dismiss()
            }
          }
        }
    }
}

struct RoomDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let room = Room(Name: "", User: "", Status: .dirty, LastStatusUpdate: Date())
        return
            NavigationView {
               RoomDetailsView(room: room)
             }
    }
}
