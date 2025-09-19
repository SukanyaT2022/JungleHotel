
//  Created by TS2 on 8/26/25.
//

import SwiftUI
import MapKit

struct HotelDetailView: View {
    let room: Room
    let hotel: HotelModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorite = false
    @State private var currentImageIndex = 0
    @State private var showingShareSheet = false
    
    // Date picker states
    @State private var checkInDate = Date()
    @State private var checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var showingCheckInPicker = false
    @State private var showingCheckOutPicker = false
    
    // Sample property highlights data
    private let propertyHighlights = [
        PropertyHighlight(icon: "cup.and.saucer.fill", title: "Breakfast", subtitle: "Good breakfast"),
        PropertyHighlight(icon: "car.fill", title: "Parking", subtitle: "Free parking, Private parking, On-site parking, Accessible"),
        PropertyHighlight(icon: "mountain.2.fill", title: "Views", subtitle: "Sea view, Balcony, View, Garden view")
    ]
    
    init(room: Room = HotelModel.sampleHotel.roomObj[0], hotel: HotelModel = HotelModel.sampleHotel) {
        self.room = room
        self.hotel = hotel
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Main content
                ScrollView {
                    VStack(spacing: 0) {
                        // Image Gallery with top padding to push below navigation
                        imageGallerySection(geometry: geometry)
                            .padding(.top, 140) // Push image gallery below sticky navigation and room header
                        
                        // Content Section
                        VStack(alignment: .leading, spacing: 20) {
                            // Hotel name
                            hotelNameSection
                            
                            // Property highlights
                            propertyHighlightsSection
                            
                            // Contact information section
                            contactInformationSection
                            
                            // Map section
                            mapSection
                            
                            // Check-in/Check-out section
                            checkInOutSection
                            
                            // Book button
                            bookingButton
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    }
                }
                .scrollIndicators(.hidden)
                .ignoresSafeArea(.all, edges: .top)
                
                // Sticky navigation and room header
                VStack(spacing: 0) {
                    // Navigation icons
                    navigationIconsSection
                        .padding(.horizontal, 16)
                        .padding(.top, 10) // Minimal space above navigation bar
                        .padding(.bottom, 0)
                        .background(Color.white)
//                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    
                    // Room name and rating - sticky below navigation
                    VStack(alignment: .leading, spacing: 8) {
                        roomHeaderSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Navigation Icons Section
    private var navigationIconsSection: some View {
        HStack {
            // Back button
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
//                    .frame(width: 36, height: 36)
//                    .background(Color(.systemGray6))
//                    .clipShape(Circle())
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                // Favorite button
                Button(action: {
                    isFavorite.toggle()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isFavorite ? .red : .primary)
//                        .frame(width: 36, height: 36)
//                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                
                // Share button
                Button(action: {
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
//                        .frame(width: 36, height: 36)
//                        .background(Color(.systemGray6))
//                        .clipShape(Circle())
                }
            }
        }
    }
    
    // MARK: - Image Gallery Section
    private func imageGallerySection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 2) {
            // Top row - 2 large images
            HStack(spacing: 2) {
                let totalWidth = max(geometry.size.width, 100) // Ensure minimum width
                let topImageWidth = max((totalWidth - 2) / 2, 50) // Minimum 50px per image
                
                // First large image
                AsyncImage(url: URL(string: room.roomImage.first ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: topImageWidth, height: 200)
                        .clipped()
                } placeholder: {
                    Image("waterfall")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: topImageWidth, height: 200)
                        .clipped()
                }
                
                // Second large image
                AsyncImage(url: URL(string: room.roomImage.count > 1 ? room.roomImage[1] : room.roomImage.first ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: topImageWidth, height: 200)
                        .clipped()
                } placeholder: {
                    Image("waterfall")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: topImageWidth, height: 200)
                        .clipped()
                }
            }
            
            // Bottom row - 3 smaller images
            HStack(spacing: 2) {
                let totalWidth = max(geometry.size.width, 100) // Ensure minimum width
                let bottomImageWidth = max((totalWidth - 4) / 3, 30) // Minimum 30px per image
                
                // Third image
                AsyncImage(url: URL(string: room.roomImage.count > 2 ? room.roomImage[2] : room.roomImage.first ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: bottomImageWidth, height: 120)
                        .clipped()
                } placeholder: {
                    Image("waterfall")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: bottomImageWidth, height: 120)
                        .clipped()
                }
                
                // Fourth image
                AsyncImage(url: URL(string: room.roomImage.count > 3 ? room.roomImage[3] : room.roomImage.first ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: bottomImageWidth, height: 120)
                        .clipped()
                } placeholder: {
                    Image("waterfall")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: bottomImageWidth, height: 120)
                        .clipped()
                }
                
                // Fifth image with overlay
                ZStack {
                    AsyncImage(url: URL(string: room.roomImage.count > 4 ? room.roomImage[4] : room.roomImage.first ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: bottomImageWidth, height: 120)
                            .clipped()
                    } placeholder: {
                        Image("waterfall")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: bottomImageWidth, height: 120)
                            .clipped()
                    }
                    
                    // Overlay with "+37" or remaining count
                    Rectangle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: bottomImageWidth, height: 120)
                    
                    Text("+\(max(0, room.roomImage.count - 4))")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .frame(height: 322) // 200 + 120 + 2 spacing
    }
    
    // MARK: - Room Header Section (at top)
    private var roomHeaderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Room name
            Text(room.roomName)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            // Star rating
            HStack(spacing: 4) {
                ForEach(0..<Int(room.roomRating)) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.orange)
                }
               
                
                // Partial star if needed
                if room.roomRating.truncatingRemainder(dividingBy: 1) > 0 {
                    Image(systemName: "star.leadinghalf.filled")
                        .font(.system(size: 16))
                        .foregroundColor(.orange)
                }
                
                // Empty stars to complete 5 stars
                ForEach(Int(ceil(room.roomRating))..<5, id: \.self) { _ in
                    Image(systemName: "star")
                        .font(.system(size: 16))
                        .foregroundColor(.gray.opacity(0.3))
                }
                
                // Rating number
                Text(String(format: "%.1f", room.roomRating))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.leading, 4)
                
                Spacer()
                
            }
        }
    }
    
    // MARK: - Hotel Name Section (after images)
    private var hotelNameSection: some View {
        HStack(alignment: .top, spacing: 12) {
            
            // Hotel name on the right
            Text(hotel.hotelNameType)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
    
    // MARK: - Property Highlights Section
    private var propertyHighlightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Property highlights")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(spacing: 20) {
                ForEach(propertyHighlights, id: \.title) { highlight in
                    PropertyHighlightRow(highlight: highlight)
                }
            }
        }
    }
    
    // MARK: - Contact Information Section
    private var contactInformationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Contact Information")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                // Address
                if !hotel.address.isEmpty {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Address")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Text(hotel.address)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                    }
                }
                
                // Contact Number
                if !hotel.contactNumber.isEmpty {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.green)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Phone")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            Button(action: {
                                if let url = URL(string: "tel:\(hotel.contactNumber)") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                Text(hotel.contactNumber)
                                    .font(.system(size: 14))
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    // MARK: - Map Section
    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Location")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            if let latitude = Double(hotel.latitude),
               let longitude = Double(hotel.longitude),
               latitude != 0.0 && longitude != 0.0 {
                
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                
                Map(coordinateRegion: .constant(region), annotationItems: [MapLocation(coordinate: coordinate)]) { location in
                    MapPin(coordinate: location.coordinate, tint: .red)
                }
                .frame(height: 200)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 200)
                    .overlay(
                        VStack {
                            Image(systemName: "map")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("Location not available")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                    )
            }
        }
    }
    
    // MARK: - Check In/Out Section
    private var checkInOutSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Select Dates")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                // Check-in date picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Check-in")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        showingCheckInPicker.toggle()
                    }) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                                .font(.system(size: 18))
                            
                            Text(checkInDate, style: .date)
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                                .rotationEffect(.degrees(showingCheckInPicker ? 180 : 0))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if showingCheckInPicker {
                        DatePicker("", selection: $checkInDate, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding(.horizontal, 8)
                            .onChange(of: checkInDate) { oldValue, newValue in
                                // Ensure check-out is at least 1 day after check-in
                                if checkOutDate <= newValue {
                                    checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: newValue) ?? newValue
                                }
                                showingCheckInPicker = false
                            }
                    }
                }
                
                // Check-out date picker
                VStack(alignment: .leading, spacing: 8) {
                    Text("Check-out")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        showingCheckOutPicker.toggle()
                    }) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                                .font(.system(size: 18))
                            
                            Text(checkOutDate, style: .date)
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                                .rotationEffect(.degrees(showingCheckOutPicker ? 180 : 0))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if showingCheckOutPicker {
                        DatePicker("", selection: $checkOutDate, in: Calendar.current.date(byAdding: .day, value: 1, to: checkInDate)!..., displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding(.horizontal, 8)
                            .onChange(of: checkOutDate) { oldValue, newValue in
                                showingCheckOutPicker = false
                            }
                    }
                }
                
                // Stay duration and info
                VStack(spacing: 8) {
                    HStack {
                        Text("Duration:")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(numberOfNights) night\(numberOfNights == 1 ? "" : "s")")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 4)
                    
                    Text("You won't be charged yet")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    private var numberOfNights: Int {
        let calendar = Calendar.current
        let startOfCheckIn = calendar.startOfDay(for: checkInDate)
        let startOfCheckOut = calendar.startOfDay(for: checkOutDate)
        let components = calendar.dateComponents([.day], from: startOfCheckIn, to: startOfCheckOut)
        return max(components.day ?? 1, 1)
    }
    
    // MARK: - Booking Button
    private var bookingButton: some View {
        NavigationLink(destination: CheckoutView()) {
            Text("See your options")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .cornerRadius(12)
        }
        .padding(.top, 20)
    }
}

// MARK: - Map Location Model
struct MapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

// MARK: - Property Highlight Model
struct PropertyHighlight {
    let icon: String
    let title: String
    let subtitle: String
}

// MARK: - Property Highlight Row
struct PropertyHighlightRow: View {
    let highlight: PropertyHighlight
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icon
            Image(systemName: highlight.icon)
                .font(.system(size: 20))
                .foregroundColor(.primary)
                .frame(width: 24, height: 24)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(highlight.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(highlight.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        HotelDetailView()
    }
}
