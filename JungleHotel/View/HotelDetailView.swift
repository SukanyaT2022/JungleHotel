
//  Created by TS2 on 8/26/25.
//

import SwiftUI

struct HotelDetailView: View {
    let room: Room
    let hotelName: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorite = false
    @State private var currentImageIndex = 0
    @State private var showingShareSheet = false
    
    // Sample property highlights data
    private let propertyHighlights = [
        PropertyHighlight(icon: "cup.and.saucer.fill", title: "Breakfast", subtitle: "Good breakfast"),
        PropertyHighlight(icon: "car.fill", title: "Parking", subtitle: "Free parking, Private parking, On-site parking, Accessible"),
        PropertyHighlight(icon: "mountain.2.fill", title: "Views", subtitle: "Sea view, Balcony, View, Garden view")
    ]
    
    init(room: Room = HotelModel.sampleHotel.roomObj[0], hotelName: String = "Chogogo Dive & Beach Resort Bonaire") {
        self.room = room
        self.hotelName = hotelName
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
            Text(hotelName)
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
    
    // MARK: - Check In/Out Section
    private var checkInOutSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Check-in")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Check-out")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
            
            Text("You won't be charged yet")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
        }
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
