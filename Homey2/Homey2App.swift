//
//  Homey2App.swift
//  Homey2
//
//  Created by jonathan laroco on 11/16/21.
//

import SwiftUI
import Firebase

@main
struct Homey2App: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            let viewModel = AuthViewModel()
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
