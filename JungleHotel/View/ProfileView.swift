//
//  ProfileView.swift
//  JungleHotel
//
//  Created by TS2 on 12/29/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    // Individual state properties for binding to InputCompView
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var country: String = ""
    @State var enableFieldEditing : Bool = false
    func updateUserDetails(){
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser?.uid ?? " ").updateData(
        (["firstName": self.firstName, "lastName": self.lastName, "email": self.email, "username": self.username, "country": self.country , "city": "NYC"] as [String : Any]))
     
    }
    func getUserDetails() {
        let db = Firestore.firestore()
        db.collection("users").document(Auth.auth().currentUser?.uid ?? " ").getDocument() { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                print("dataDescription: \(dataDescription ?? [:])")
                let data = dataDescription ?? [:]
                self.firstName = data["firstName"] as? String ?? ""
                self.lastName = data["lastName"] as? String ?? ""
                self.email = data["email"] as? String ?? ""
                self.username = data["username"] as? String ?? ""
                self.country = data["country"] as? String ?? ""
            } else {
                print("Document does not exist")
            }
        }
     
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Profile")
                .font(.title2)

            // start  Image circle and camera
            ZStack(alignment: .bottomTrailing) {
                // Round profile image
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                    )

                // Camera icon button
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 36, height: 36)

                    Image(systemName: "camera.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
                .offset(x: -5, y: -5)
            }
            HStack{
                Spacer()
                // end  Image circle and camera- zstack
                ButtonCompView(textBtn: "Edit") {
                    //when click edut btn it true so we can change info
                   enableFieldEditing = true
                }
                .frame(width: 100)
                
            }
          
            VStack{
                InputCompView(
                    textLabel: "First Name",
                    textValue: $firstName,
                    placeholder: "Enter your first name",
                    icon: "person",
                    enableEditing: enableFieldEditing
                    
//                    enableEditing: enableFieldEditing
                    //enableediting from input compnent : on the back from var on the top of this scrren
                )
                InputCompView(
                    textLabel: "Last Name",
                    textValue: $lastName,
                    placeholder: "Enter your last name",
                    icon: "person",
                    enableEditing: enableFieldEditing
                )
                InputCompView(
                    textLabel: "Email",
                    textValue: $email,
                    placeholder: "Enter your email",
                    icon: "envelope",
                    enableEditing: enableFieldEditing
                )
                InputCompView(
                    textLabel: "Username",
                    textValue: $username,
                    placeholder: "Enter your username",
                    icon: "person",
                    enableEditing: enableFieldEditing
                )
                InputCompView(
                    textLabel: "Country",
                    textValue: $country,
                    placeholder: "Enter your country",
                    icon: "globe",
                    enableEditing: enableFieldEditing
                )
                ButtonCompView(textBtn: "Submit") {
                   updateUserDetails()
                }
            }
        }// close paernt
        .padding()
       
        //on appear is method in every view load when first time load-- on appear when we need to get data or animation- call third party sdk
        .onAppear{
//            below function help to get datat from firebase
            getUserDetails()
        }
    }
}

#Preview {
    ProfileView()
}
