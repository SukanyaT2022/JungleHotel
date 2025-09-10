
//  HotelListView
//
//  Created by TS2 on 8/26/25.
//
import SwiftUI

struct MainScreenView: View {
    @StateObject private var viewModel = HotelViewModel()
    @State private var searchText = ""
    @State private var showingFilterOptions = false
    
    // Filter state variables
    @State private var minPrice: Double = 0
    @State private var maxPrice: Double = 1000
    @State private var minRating: Double = 0
    @State private var selectedRoomTypes: Set<String> = []
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    // Background content that can scroll
                    contentView
                        .padding(.top, 80) // Add padding to account for sticky header
                    
                    // Sticky header
                    VStack(spacing: 0) {
                        headerView
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
                .fullScreenCover(isPresented: $showingFilterOptions) {
                    FilterOptionsView(
                        minPrice: $minPrice,
                        maxPrice: $maxPrice,
                        minRating: $minRating,
                        selectedRoomTypes: $selectedRoomTypes
                    )
                }
            .refreshable {
                viewModel.fetchHotels()
            }
        }
    }
    
    // MARK: - Pinterest-style Header View
    private var headerView: some View {
        VStack(spacing: 12) {
            // Top section with logo and filter button
            HStack {
                navigationTitleView
                
                Spacer()
                
                filterButton
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            // Pinterest-style search bar
            pinterestSearchBar
                .padding(.bottom, 12)
        }
        .background(
            Color(.systemBackground)
                .ignoresSafeArea(.all, edges: .top)
        )
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 0)
        }
    }
    
    // MARK: - Edge-to-Edge Search Bar
    private var pinterestSearchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 16, weight: .medium))
            
            TextField("Search hotels, rooms...", text: $searchText)
                .font(.system(size: 16))
                .foregroundColor(.primary)
                .textFieldStyle(PlainTextFieldStyle()) // Remove underline
            
            Spacer()
            
            // Right side icons
            HStack(spacing: 8) {
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    }
                }
                
                // Microphone icon
                Button(action: {
                    // Add microphone functionality here
                    print("Microphone tapped")
                }) {
                    Image(systemName: "mic.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .medium))
                }
                
                // Camera icon
                Button(action: {
                    // Add camera functionality here
                    print("Camera tapped")
                }) {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .medium))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity) // Make full width
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    // MARK: - Custom Navigation Title View
    //target logo and navigation title
    private var navigationTitleView: some View {
        HStack(spacing: 8) {
            // Option 1: System Icon (current)
            Image(systemName: "leaf.fill")
                .foregroundColor(.green)
                .font(.title2)
            
            // Option 2: Custom Image (uncomment and add your logo to Assets.xcassets)
            // Image("your-logo-name")
            //     .resizable()
            //     .aspectRatio(contentMode: .fit)
            //     .frame(width: 24, height: 24)
            
            Text("Jungle Hotels")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
    
    // MARK: - Content View
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if !viewModel.errorMessage.isEmpty {
            ErrorView(
                message: viewModel.errorMessage,
                onRetry: {
                    //if user tap on retry button after show error -  it try to fetch data again
                    viewModel.fetchHotels()
                }
            )
        } else {
            hotelListContent
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        ProgressView("Loading Hotels...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Hotel List Content
    private var hotelListContent: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredHotels) { hotel in
                    HotelSectionView(hotel: hotel)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .scrollIndicators(.hidden)
        }
    }
    
    // MARK: - Filter Button
    private var filterButton: some View {
        Button {
            showingFilterOptions.toggle()
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
    }
    
    // MARK: - Computed Properties
    private var filteredHotels: [Hotel] {
        // Start with search results
        var hotels = viewModel.searchHotels(with: searchText)
        
        // Apply price filter
        hotels = hotels.compactMap { hotel in
            let filteredRooms = hotel.roomObj.filter { room in
                let price = Double(room.roomPrice)
                return price >= minPrice && price <= maxPrice
            }
            
            if filteredRooms.isEmpty {
                return nil
            }
            
            return Hotel(
                id: hotel.id,
                hotelNameType: hotel.hotelNameType,
                roomObj: filteredRooms
            )
        }
        
        // Apply rating filter
        if minRating > 0 {
            hotels = hotels.compactMap { hotel in
                let filteredRooms = hotel.roomObj.filter { room in
                    room.roomRating >= minRating
                }
                
                if filteredRooms.isEmpty {
                    return nil
                }
                
                return Hotel(
                    id: hotel.id,
                    hotelNameType: hotel.hotelNameType,
                    roomObj: filteredRooms
                )
            }
        }
        
        // Apply room type filter
        if !selectedRoomTypes.isEmpty {
            hotels = hotels.compactMap { hotel in
                let filteredRooms = hotel.roomObj.filter { room in
                    selectedRoomTypes.contains { roomType in
                        room.roomName.lowercased().contains(roomType.lowercased()) ||
                        room.roomDetail.lowercased().contains(roomType.lowercased())
                    }
                }
                
                if filteredRooms.isEmpty {
                    return nil
                }
                
                return Hotel(
                    id: hotel.id,
                    hotelNameType: hotel.hotelNameType,
                    roomObj: filteredRooms
                )
            }
        }
        
        return hotels
    }
}

// MARK: - Hotel Section View
struct HotelSectionView: View {
    let hotel: Hotel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            hotelHeader
            roomsList
        }
        .padding(.vertical, 8)
    }
    
    private var hotelHeader: some View {
        HStack {
            Text(hotel.hotelNameType)
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
//            Text("\(hotel.roomObj.count) rooms")
//                .font(.caption)
//                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
    
    private var roomsList: some View {
        ForEach(hotel.roomObj) { room in
            NavigationLink(destination: HotelDetailView(room: room, hotelName: hotel.hotelNameType)) {
                HotelCardView(
                    room: room,
                    hotelName: hotel.hotelNameType
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text("Error Loading Hotels")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry", action: onRetry)
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Filter Options View
struct FilterOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Filter binding variables
    @Binding var minPrice: Double
    @Binding var maxPrice: Double
    @Binding var minRating: Double
    @Binding var selectedRoomTypes: Set<String>
    
    // Available room types
    private let roomTypes = ["Single Room", "Double Room", "Suite", "Deluxe", "Family Room", "Presidential Suite"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom header
                VStack(spacing: 16) {
                    HStack {
                        Button("Reset") {
                            resetFilters()
                        }
                        .foregroundColor(.red)
                        .font(.system(size: 16, weight: .medium))
                        
                        Spacer()
                        
                        Text("Filters")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button("Apply") {
                            applyFilters()
                            dismiss()
                        }
                        .fontWeight(.semibold)
                        .font(.system(size: 16, weight: .semibold))
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 80)
                    .padding(.bottom, 10)
                }
                .background(Color(.systemBackground))
                
                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Price Filter Section
                        priceFilterSection
                          
                        Divider()
                        
                        // Rating Filter Section
                        ratingFilterSection
                        
                        Divider()
                        
                        // Room Type Filter Section
                        roomTypeFilterSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(30)
                }
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(.all, edges: .top)
        }
    }
    
    // MARK: - Price Filter Section
    private var priceFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Price Range")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                HStack {
                    Text("$\(Int(minPrice))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("$\(Int(maxPrice))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                // Price range slider
                VStack(spacing: 8) {
                    RangeSlider(
                        minValue: $minPrice,
                        maxValue: $maxPrice,
                        bounds: 0...1000
                    )
                    
                    HStack {
                        Text("$0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("$1000+")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    // MARK: - Rating Filter Section
    private var ratingFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Minimum Rating")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                HStack {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(minRating) ? "star.fill" : "star")
                            .foregroundColor(index < Int(minRating) ? .yellow : .gray)
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Text("\(minRating, specifier: "%.1f")+")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Slider(value: $minRating, in: 0...5, step: 0.5)
                    .accentColor(.yellow)
                
                HStack {
                    Text("Any")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("5.0")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    // MARK: - Room Type Filter Section
    private var roomTypeFilterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Room Type")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(roomTypes, id: \.self) { roomType in
                    roomTypeButton(roomType)
                }
            }
        }
    }
    
    // MARK: - Room Type Button
    private func roomTypeButton(_ roomType: String) -> some View {
        Button(action: {
            if selectedRoomTypes.contains(roomType) {
                selectedRoomTypes.remove(roomType)
            } else {
                selectedRoomTypes.insert(roomType)
            }
        }) {
            Text(roomType)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(selectedRoomTypes.contains(roomType) ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    selectedRoomTypes.contains(roomType) 
                    ? Color.blue 
                    : Color(.systemGray6)
                )
                .cornerRadius(20)
        }
    }
    
    // MARK: - Filter Actions
    private func resetFilters() {
        minPrice = 0
        maxPrice = 1000
        minRating = 0
        selectedRoomTypes.removeAll()
    }
    
    private func applyFilters() {
        // Filters are automatically applied through bindings
        print("Applied filters:")
        print("Price: $\(Int(minPrice)) - $\(Int(maxPrice))")
        print("Min Rating: \(minRating)")
        print("Room Types: \(selectedRoomTypes)")
    }
}

// MARK: - Range Slider Component
struct RangeSlider: View {
    @Binding var minValue: Double
    @Binding var maxValue: Double
    let bounds: ClosedRange<Double>
    
    var body: some View {
        GeometryReader { geometry in
            let sliderWidth = geometry.size.width
            let minPosition = CGFloat((minValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * sliderWidth
            let maxPosition = CGFloat((maxValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * sliderWidth
            
            ZStack(alignment: .leading) {
                // Track
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 4)
                    .cornerRadius(2)
                
                // Active track
                Rectangle()
                    .fill(Color.green)
                    .frame(width: maxPosition - minPosition, height: 4)
                    .cornerRadius(2)
                    .offset(x: minPosition)
                
                // Min thumb
                Circle()
                    .fill(Color.green)
                    .frame(width: 20, height: 20)
                    .offset(x: minPosition - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = Double(value.location.x / sliderWidth) * (bounds.upperBound - bounds.lowerBound) + bounds.lowerBound
                                minValue = min(max(newValue, bounds.lowerBound), maxValue - 10)
                            }
                    )
                
                // Max thumb
                Circle()
                    .fill(Color.green)
                    .frame(width: 20, height: 20)
                    .offset(x: maxPosition - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = Double(value.location.x / sliderWidth) * (bounds.upperBound - bounds.lowerBound) + bounds.lowerBound
                                maxValue = max(min(newValue, bounds.upperBound), minValue + 10)
                            }
                    )
            }
        }
        .frame(height: 20)
    }
      
}

#Preview {
    MainScreenView()
}

