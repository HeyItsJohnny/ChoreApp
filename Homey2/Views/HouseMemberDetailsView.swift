//
//  HouseMemberDetailsView.swift
//  Homey2
//
//  Created by jonathan laroco on 1/31/22.
//

import SwiftUI

struct HouseMemberDetailsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var presentEditBookSheet = false
    
    var housemember: HouseMember
    
    private func editButton(action: @escaping () -> Void) -> some View {
        Button(action: { action() }) {
          Text("Edit")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                Text(housemember.name)
            }
        }
        .navigationBarTitle(housemember.name)
        .navigationBarItems(trailing: editButton {
          self.presentEditBookSheet.toggle()
        })
        .onAppear() {
            print("HouseMembersDetailsView.onAppear() for \(self.housemember.name)")
        }
        .onDisappear() {
          print("HouseMemberDetailsView.onDisappear()")
        }
        .sheet(isPresented: self.$presentEditBookSheet) {
          HouseMemberEditView(viewModel: HouseMemberViewModel(housemember: housemember), mode: .edit) { result in
            if case .success(let action) = result, action == .delete {
              self.presentationMode.wrappedValue.dismiss()
            }
          }
        }
    }
}

struct HouseMemberDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let housemember = HouseMember(name: "JOHN DOE")
        return
            NavigationView {
               HouseMemberDetailsView(housemember: housemember)
             }
    }
}
