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

// MARK: - Booking View Model
@MainActor
class BookingViewModel: ObservableObject {
    @Published var bookings: [BookingModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        checkAuthStatus()
    }
    
    deinit {
        listener?.remove()
    }
    
    func checkAuthStatus() {
        isLoggedIn = Auth.auth().currentUser != nil
        if isLoggedIn {
            fetchBookings()
        }
    }
    
    func fetchBookings() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Please log in to view your bookings"
            isLoggedIn = false
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        // Remove existing listener
        listener?.remove()
        
        // Set up real-time listener for user's bookings
        // Option 1: Single document approach (current structure in PaymentView)
        listener = db.collection("booking").document(userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Failed to fetch bookings: \(error.localizedDescription)"
                    print("❌ Booking fetch error: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot, snapshot.exists,
                      let data = snapshot.data() else {
                    self.bookings = []
                    return
                }
                
                // Single booking document
                let booking = BookingModel(id: snapshot.documentID, data: data)
                self.bookings = [booking]
                print("✅ Fetched booking for user: \(userId)")
            }
    }
    
    // Alternative: Fetch from subcollection (if you change the structure later)
    func fetchBookingsFromSubcollection() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Please log in to view your bookings"
            isLoggedIn = false
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        listener?.remove()
        
        // Listen to bookings subcollection
        listener = db.collection("users").document(userId).collection("bookings")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Failed to fetch bookings: \(error.localizedDescription)"
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.bookings = []
                    return
                }
                
                self.bookings = documents.map { doc in
                    BookingModel(id: doc.documentID, data: doc.data())
                }
            }
    }
}

// MARK: - Booking Bottom View
struct BookingBottomView: View {
    @StateObject private var viewModel = BookingViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if !viewModel.isLoggedIn {
                    notLoggedInView
                } else if viewModel.isLoading {
                    loadingView
                } else if !viewModel.errorMessage.isEmpty {
                    errorView
                } else if viewModel.bookings.isEmpty {
                    emptyBookingsView
                } else {
                    bookingListView
                }
            }
            .navigationTitle("My Bookings")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.checkAuthStatus()
            }
        }
    }
    
    // MARK: - Not Logged In View
    private var notLoggedInView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Not Logged In")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Please log in to view your bookings")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
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
            
            Text(viewModel.errorMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                viewModel.fetchBookings()
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
                ForEach(viewModel.bookings) { booking in
                    BookingCardView(booking: booking)
                }
            }
            .padding()
        }
        .refreshable {
            viewModel.fetchBookings()
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
