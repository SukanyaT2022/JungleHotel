//
//  BookingBottomView.swift
//  JungleHotel
//
//  Created by TS2 on 12/29/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// MARK: - Booking Model
struct BookingModel: Identifiable {
    var id: String
    var checkinDate: String
    var checkoutDate: String
    var pricePerNight: Int64
    var totalPrice: Int64
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.checkinDate = data["checkinDate"] as? String ?? ""
        self.checkoutDate = data["checkoutDate"] as? String ?? ""
        self.pricePerNight = data["pricePerNight"] as? Int64 ?? 0
        self.totalPrice = data["totalPrice"] as? Int64 ?? 0
    }
}

// MARK: - Booking Bottom View
struct BookingBottomView: View {
    @State private var bookings: [BookingModel] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = Auth.auth().currentUser != nil
    @State private var showLoginSheet = false
    
    private let db = Firestore.firestore()
    
    var body: some View {
        NavigationStack {
            Group {
                if !isLoggedIn {
                    notLoggedInView
                } else if isLoading {
                    loadingView
                } else if !errorMessage.isEmpty {
                    errorView
                } else if bookings.isEmpty {
                    emptyBookingsView
                } else {
                    bookingListView
                }
            }
//            .navigationTitle("My Bookings")
//            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            checkAuthAndFetch()
        }
        .onReceive(NotificationCenter.default.publisher(for: .AuthStateDidChange)) { _ in
            // Update login state when auth changes
            isLoggedIn = Auth.auth().currentUser != nil
            if isLoggedIn {
                fetchBookings()
            } else {
                bookings = []
            }
        }
    }
    
    private func checkAuthAndFetch() {
        isLoggedIn = Auth.auth().currentUser != nil
        if isLoggedIn {
            fetchBookings()
        }
    }
    
    private func fetchBookings() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Please log in to view your bookings"
            isLoggedIn = false
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        // Fetch all bookings for the current user
        db.collection("booking")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                isLoading = false
                
                if let error = error {
                    // If index not created yet, try without ordering
                    print("❌ Booking fetch error: \(error.localizedDescription)")
                    // Fallback: fetch without order
                    fetchBookingsSimple(userId: userId)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    bookings = []
                    return
                }
                
                bookings = documents.map { doc in
                    BookingModel(id: doc.documentID, data: doc.data())
                }
                print("✅ Fetched \(bookings.count) bookings for user: \(userId)")
            }
    }
    
    // Fallback fetch without composite index requirement
    private func fetchBookingsSimple(userId: String) {
        db.collection("booking")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                isLoading = false
                
                if let error = error {
                    errorMessage = "Failed to fetch bookings: \(error.localizedDescription)"
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    bookings = []
                    return
                }
                
                bookings = documents.map { doc in
                    BookingModel(id: doc.documentID, data: doc.data())
                }
            }
    }
    
    // MARK: - Sign in to your account
    private var notLoggedInView: some View {
       
        VStack(spacing: 40) {
            Text("Welcome to Jungle Hotel")
                .font(.title2)
                .fontWeight(.semibold)
            Image("waterfalllogin")
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 300)
                .cornerRadius(30
                )
            
            VStack(spacing: 15){
                Text("Sign in to your account")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Button {
                    showLoginSheet = true
                } label: {
                    Text("Log In")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 45)
                        .background(Colors.primary)
                        .cornerRadius(26)
//                        
                }//close button
            }
         
        }
        .padding(.bottom,100)
        .fullScreenCover(isPresented: $showLoginSheet) {
            PopUpLoginView()
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading bookings...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Error View
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(errorMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                fetchBookings()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    // MARK: - Empty Bookings View
    private var emptyBookingsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "suitcase")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Bookings Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Your booking history will appear here once you make a reservation")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
    }
    
    // MARK: - Booking List View
    private var bookingListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(bookings) { booking in
                    BookingCardView(booking: booking)
                }
            }
            .padding()
        }
        .refreshable {
            fetchBookings()
        }
    }
}

// MARK: - Booking Card View
struct BookingCardView: View {
    let booking: BookingModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "building.2.fill")
                    .foregroundColor(.green)
                
                Text("Jungle Hotel")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Status badge
                Text("Confirmed")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.green)
                    .cornerRadius(12)
            }
            
            Divider()
            
            // Check-in date
            HStack {
                Image(systemName: "calendar.badge.plus")
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                Text("Check-in:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(booking.checkinDate)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            // Check-out date
            HStack {
                Image(systemName: "calendar.badge.minus")
                    .foregroundColor(.orange)
                    .frame(width: 20)
                
                Text("Check-out:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(booking.checkoutDate)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Divider()
            
            // Price details
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Price per night")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("$\(booking.pricePerNight)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("$\(booking.totalPrice)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    BookingBottomView()
}
