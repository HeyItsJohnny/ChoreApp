//
//  ContentView.swift
//  Homey2
//
//  Created by jonathan laroco on 11/16/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.signedIn {
            DisplayMainView()
        } else {
            SignInView()
        }
        /*NavigationView {
            if viewModel.signedIn {
                DisplayMainView()
            } else {
                SignInView()
            }
        }.onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }*/
    }
}

struct SignInView: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Image("House")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                VStack {
                    TextField("Email Address", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    Button(action: {
                        guard !email.isEmpty, !password.isEmpty else {
                            //Don't sign in Maybe Error?
                            return
                        }
                        viewModel.SignIn(email: email, password: password)
                        
                    }, label: {
                        Text("Sign In")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(8)
                    })
                    
                    NavigationLink("Create Account", destination: SignUpView())
                        .padding()
                }
                .padding()
                Spacer()
            }
        }
        .navigationTitle("Sign In")
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Image("House")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                VStack {
                    TextField("Email Address", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                    Button(action: {
                        guard !email.isEmpty, !password.isEmpty else {
                            //Don't sign in Maybe Error?
                            return
                        }
                        viewModel.SignUp(email: email, password: password)
                        
                    }, label: {
                        Text("Create Account")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(8)
                    })
                }
                .padding()
                Spacer()
            }
        }
        .navigationTitle("Create Account")
    }
}

struct DisplayMainView: View {
    //@EnvironmentObject var viewModel: AuthViewModel
    /*private var signOutButton: some View {
        Button(action: { viewModel.SignOut() }) {
            Text("Sign Out")
        }
    }*/
    
    var body: some View {
        TabView() {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            /*MembersListView()
                .tabItem {
                    Label("Members", systemImage: "person")
                }*/
            TasksListView()
                .tabItem {
                    Label("Rooms", systemImage: "list.dash")
                }
            TasksListView()
                .tabItem {
                    Label("Chores", systemImage: "list.dash")
                }

            /*
             RestaurantsListView()
                .tabItem{
                    Label("Restaurants", systemImage: "paperplane.fill")
                }
            MealsListView()
                .tabItem{
                    Label("Meals", systemImage: "cart.fill")
                }
            ActivitiesListView()
                .tabItem{
                    Label("Activities", systemImage: "globe.americas.fill")
                }
             */
            SettingsView()
                .tabItem{
                    Label("Settings", systemImage: "gear")
                }
            
        }
        //.navigationBarItems(trailing: signOutButton)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
