//
//  AuthViewModel.swift
//  Homey2
//
//  Created by jonathan laroco on 12/30/21.
//

import Foundation
import FirebaseAuth
import CoreMedia

class AuthViewModel: ObservableObject {
    
    let auth = Auth.auth()
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func SignIn(email: String, password: String) {
        auth.signIn(withEmail: email,
                    password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                //Successful Sign In
                self?.signedIn = true
            }
            
        }
    }
    
    func SignUp(email: String, password: String) {
        auth.createUser(withEmail: email,
                    password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                //Successful Sign In
                self?.signedIn = true
            }
        }
    }
    
    func SignOut() {
        try? auth.signOut()
        self.signedIn = false
    }
}
