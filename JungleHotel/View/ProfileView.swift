//
//  ProfileView.swift
//  JungleHotel
//
//  Created by TS2 on 12/29/25.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
//photoui help to select photos from gallery
import PhotosUI

struct ProfileView: View {
    @State private var selectedImage: PhotosPickerItem?
    @State private var profileImage: UIImage?
    
    // Individual state properties for binding to InputCompView
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var country: String = ""
    @State var enableFieldEditing : Bool = false
    @State private var logoutError: String?
    @State private var showLogoutConfirm = false
    @State private var showLoginSheet = false
    
    // Track if user is logged in - this will update when auth state changes
    @State private var isLoggedIn: Bool = Auth.auth().currentUser != nil
    func logoutFunc(){
        do {
            try Auth.auth().signOut()
            // Clear user data
            firstName = ""
            lastName = ""
            email = ""
            username = ""
            country = ""
            profileImage = nil
            // isLoggedIn will be updated by the auth state listener
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
            logoutError = error.localizedDescription
        }
    }
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
    // Convert selection to UIImage
    func loadImage() {
        Task {
            if let data = try? await selectedImage?.loadTransferable(type: Data.self) {
                profileImage = UIImage(data: data)
            }
        }
    }
    
    //uploadImageFunc connecto camera icon -forebase-- can be reuse for other project.
    func uploadImageFunc(){
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No authenticated user.")
            return
        }
        //if use click camera and select image or not - check if image there - if image there go to imageData
        guard let uiImage = self.profileImage else {
            //if no image donot go beyound - if have image go beyond to return
            print("No profile image selected.")
            return
        }
        guard let imageData = uiImage.jpegData(compressionQuality: 0.8) else {
            print("Failed to create JPEG data from image.")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileName = UUID().uuidString + ".jpg"
        let imageRef = storageRef.child("profile_images/\(userId)/\(fileName)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        //below is method imageRef create a path to upload to firebase storage
        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Upload failed: \(error.localizedDescription)")
                return
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Failed to get download URL: \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    print("Image uploaded successfully. URL: \(url.absoluteString)")
                    // Optionally, update Firestore user document with the image URL
                    let db = Firestore.firestore()
                    db.collection("users").document(userId).updateData(["profileImageURL": url.absoluteString]) { err in
                        if let err = err {
                            print("Failed to save image URL to Firestore: \(err.localizedDescription)")
                        } else {
                            print("Saved image URL to Firestore.")
                        }
                    }
                }
            }
        }
    }
    var body: some View {
        NavigationStack {
            
            if !isLoggedIn {
                // Not logged in - show login prompt
                VStack(spacing: 20) {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                        .font(.system(size: 80))
                        .foregroundColor(.gray)
                    
                    Text("Not Logged In")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Please log in to view your profile")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button {
                        showLoginSheet = true
                    } label: {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                }
                .fullScreenCover(isPresented: $showLoginSheet) {
                    PopUpLoginView()
                }
                
            } else {
                
                VStack(spacing: 16) {
                    //            Text("Profile")
                    //                .font(.title2)
                    
                    // start  Image circle and camera
                    ZStack(alignment: .bottomTrailing) {
                        // Round profile image
                        Image(uiImage: profileImage ?? UIImage(imageLiteralResourceName: "dog"))
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
                        
                        //help to change image when click camera
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 36, height: 36)
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                            .offset(x: -5, y: -5)
                            //help to change image when click camera
                            .onChange(of: selectedImage) { newValue in
                                loadImage()
                            }
                            
                        }
                        
                    }
                    HStack{
                        
                        // end  Image circle and camera- zstack
                        ButtonCompView(textBtn: "Edit") {
                            //when click edut btn it true so we can change info
                            enableFieldEditing = true
                        }
                        .frame(width:70, height: 44)
                        Spacer()
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.green)
                            .onTapGesture {
                                showLogoutConfirm = true
                            }
                        
                    }//close hstack
                    ButtonCompView(textBtn: "Upload Image") {
                        uploadImageFunc()
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
                }// close v stack
                .padding()
                
                
                //on appear is method in every view load when first time load-- on appear when we need to get data or animation- call third party sdk
                .onAppear{
                    //            below function help to get datat from firebase
                    getUserDetails()
                }
            }
        }
        // Auth state listener - updates isLoggedIn when user logs in or out
        .onAppear {
            // Check current auth state
            isLoggedIn = Auth.auth().currentUser != nil
            if isLoggedIn {
                getUserDetails()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .AuthStateDidChange)) { _ in
            // Update login state when auth changes
            isLoggedIn = Auth.auth().currentUser != nil
            if isLoggedIn {
                getUserDetails()
            }
        }
        .alert("Logout Failed", isPresented: .constant(logoutError != nil), presenting: logoutError) { _ in
            Button("OK") { logoutError = nil }
        } message: { error in
            Text(error)
        }
        .alert("Are you sure you want to log out?", isPresented: $showLogoutConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                logoutFunc()
            }
        }
    }
}
