import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil

    private let db = Firestore.firestore()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Create your account")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Sign up to book your jungle adventure")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)

                    // Error Message
                    if let errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                    }

                    // Form Fields using InputCompView
                    VStack(spacing: 16) {
                        InputCompView(
                            textLabel: "First Name",
                            textValue: $firstName,
                            placeholder: "Enter your first name",
                            icon: "person"
                        )
                        
                        InputCompView(
                            textLabel: "Last Name",
                            textValue: $lastName,
                            placeholder: "Enter your last name",
                            icon: "person"
                        )

                        InputCompView(
                            textLabel: "Email",
                            textValue: $email,
                            placeholder: "Emal",
                            keyboardType: .emailAddress,
                            icon: "envelope"
                        )

                        InputCompView(
                            textLabel: "Password",
                            textValue: $password,
                            placeholder: "Minimum 6 characters",
                            isSecure: true,
                            icon: "lock",
                            showPasswordToggle: true
                        )

                        InputCompView(
                            textLabel: "Confirm Password",
                            textValue: $confirmPassword,
                            placeholder: "Re-enter your password",
                            isSecure: true,
                            icon: "lock.fill",
                            showPasswordToggle: true
                        )
                    }
                    .padding(.vertical, 8)

                    // Sign Up Button
                    Button(action: {
                        if !isLoading {
                            signUp()
                        }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(isLoading ? "Creating account..." : "Create Account")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(isLoading ? Color.gray : Color.accentColor)
                        .cornerRadius(12)
                    }
                    .disabled(isLoading)
                    .padding(.top, 8)
                    
                    // Terms and Privacy
                    VStack(spacing: 4) {
                        Text("By signing up, you agree to our")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack(spacing: 4) {
                            Text("Terms of Service")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text("and")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("Privacy Policy")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 8)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Sign Up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }

    // MARK: - Validation
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    
    private func validateForm() -> Bool {
        errorMessage = nil
        
        let trimmedFirst = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLast = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if all fields are filled
        guard !trimmedFirst.isEmpty else {
            errorMessage = "Please enter your first name."
            return false
        }
        
        guard !trimmedLast.isEmpty else {
            errorMessage = "Please enter your last name."
            return false
        }
        
        guard !trimmedEmail.isEmpty else {
            errorMessage = "Please enter your email address."
            return false
        }
        
        // Validate email format
        guard isValidEmail(trimmedEmail) else {
            errorMessage = "Please enter a valid email address."
            return false
        }
        
        // Validate password
        guard !password.isEmpty else {
            errorMessage = "Please enter a password."
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        
        // Check if passwords match
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }
        
        return true
    }

    // MARK: - Sign Up Function
    private func signUp() {
        // Validate form
        guard validateForm() else {
            return
        }
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedFirst = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLast = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        isLoading = true
        errorMessage = nil
        
        // Create user with Firebase Authentication
        Auth.auth().createUser(withEmail: trimmedEmail, password: password) { result, error in
            if let error = error as NSError? {
                isLoading = false
                
                if let authError = AuthErrorCode(_bridgedNSError: error) {
                    switch authError.code {
                    case .emailAlreadyInUse:
                        errorMessage = "An account already exists with this email."
                    case .invalidEmail:
                        errorMessage = "The email address is badly formatted."
                    case .weakPassword:
                        errorMessage = "Password is too weak. Please use a stronger password."
                    case .networkError:
                        errorMessage = "Network error. Please check your connection and try again."
                    default:
                        errorMessage = "Sign up failed: \(error.localizedDescription)"
                    }
                } else {
                    errorMessage = "Sign up failed: \(error.localizedDescription)"
                }
                
                print("❌ Firebase Auth Error: \(error.localizedDescription)")
                return
            }

            // Get user UID
            guard let uid = result?.user.uid else {
                isLoading = false
                errorMessage = "Could not retrieve user information."
                print("❌ Error: Could not get user UID")
                return
            }
            
            print("✅ User created successfully with UID: \(uid)")

            // Save user data to Firestore
            let now = Timestamp(date: Date())
            let userData: [String: Any] = [
                "uid": uid,
                "firstName": trimmedFirst,
                "lastName": trimmedLast,
                "email": trimmedEmail.lowercased(),
                "createdAt": now,
                "updatedAt": now
            ]

            db.collection("users").document(uid).setData(userData, merge: true) { err in
                isLoading = false
                
                if let err = err {
                    errorMessage = "Account created but failed to save profile: \(err.localizedDescription)"
                    print("❌ Firestore Error: \(err.localizedDescription)")
                    return
                }
                
                print("✅ User profile saved to Firestore successfully")
                // Dismiss the sign-up view on success
                dismiss()
            }
        }
    }
}

#Preview {
    SignUpView()
}
