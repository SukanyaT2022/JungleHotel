//  HotelListView
//
//  Created by TS2 on 8/26/25.
//
import SwiftUI
//donot forrget to add import swift data

import SwiftData
//struct is value type pass a to b - it's just a copy  - class is refrence type
struct MainScreenView: View {
    @StateObject private var viewModel = HotelViewModel()
    //above becasue HotelViewModel() is class so we use @StateObject --bring from outside
    //environment like global variable var that use for the whole app
    @Environment(\.modelContext) private var modelContext
    
    //@state can use only in this view -- private means use var this view only- for secure noone can access this variable
    // public private internal and fileprivate -- we call them access modify
    
    @State private var searchText = ""
    @State private var showingFilterOptions = false
    @State private var isOnline: Bool = true
  
    // Filter state variables
    @State private var minPrice: Double = 0
    @State private var maxPrice: Double = 1000
    @State private var minRating: Double = 0
    @State private var selectedRoomTypes: Set<String> = []
    
    // Date picker states
    @State private var checkInDate = Date()
    @State private var checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    
    var body: some View {
        NavigationStack {
            
            GeometryReader { geometry in
                ScrollView{
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
             
                
            }//close screlol view
            
            .task {
                await loadData()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                Task { await loadData() }
            }
        }
        .background(Color.clear)
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
            // Real-time listener handles updates automatically
            // Just trigger a manual refresh if needed
            await loadData()
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
            
            // Native date pickers
            nativeDatePickerSection
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
                    print("🔄 MainScreenView: User tapped retry, attempting manual fetch")
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
        let hotels = filteredHotels
        print("🏨 MainScreenView: Rendering hotel list with \(hotels.count) hotels")
        
        return LazyVStack(spacing: 16) {
            ForEach(hotels) { hotel in
                HotelSectionView(hotel: hotel, checkInDate:checkInDate, checkOutDate: checkOutDate)
            }
            PracticeSwiftData()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .scrollIndicators(.hidden)
    }
 
    
    // MARK: - Filter Button
    private var filterButton: some View {
        Button {
            showingFilterOptions.toggle()
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
    }
    
    // MARK: - Native Date Picker Section
    private var nativeDatePickerSection: some View {
        let dateRange: ClosedRange<Date> = {
            let calendar = Calendar.current
            let startDate = Date()
            let endDate = calendar.date(byAdding: .year, value: 2, to: startDate) ?? startDate
            return startDate...endDate
        }()
        
         return VStack(spacing: 12) {
             // Check-in and Check-out side by side
             HStack(spacing: 20) {
                 // Check-in DatePicker
                 VStack(alignment: .leading, spacing: 4) {
                     Text("Check-in")
                         .font(.system(size: 14, weight: .medium))
                         .foregroundColor(.secondary)
                     
                     DatePicker(
                         "",
                         selection: $checkInDate,
                         in: dateRange,
                         displayedComponents: [.date]
                     )
                     .datePickerStyle(.compact)
                     .onChange(of: checkInDate) { oldValue, newValue in
                         // Ensure check-out is at least 1 day after check-in
                         if checkOutDate <= newValue {
                             checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: newValue) ?? newValue
                         }
                     }
                 }
                 .frame(maxWidth: .infinity, alignment: .leading)
                 
                 // Check-out DatePicker
                 VStack(alignment: .leading, spacing: 4) {
                     Text("Check-out")
                         .font(.system(size: 14, weight: .medium))
                         .foregroundColor(.secondary)
                     
                     DatePicker(
                         "",
                         selection: $checkOutDate,
                         in: Calendar.current.date(byAdding: .day, value: 1, to: checkInDate)!...dateRange.upperBound,
                         displayedComponents: [.date]
                     )
                     .datePickerStyle(.compact)
                 }
                 .frame(maxWidth: .infinity, alignment: .leading)
             }
             
             // Duration display
             HStack {
                 Text("Duration:")
                     .font(.system(size: 14, weight: .medium))
                     .foregroundColor(.secondary)
                 
                 Spacer()
                 
                 Text("\(numberOfNights) night\(numberOfNights == 1 ? "" : "s")")
                     .font(.system(size: 14, weight: .semibold))
                     .foregroundColor(.blue)
             }
         }
         .padding(.horizontal, 16)
         .padding(.vertical, 12)
         .background(Color(.systemGray6))
         .cornerRadius(12)
         .padding(.horizontal, 16)
    }
    
    // MARK: - Computed Properties
    private var numberOfNights: Int {
        let calendar = Calendar.current
        let startOfCheckIn = calendar.startOfDay(for: checkInDate)
        let startOfCheckOut = calendar.startOfDay(for: checkOutDate)
        let components = calendar.dateComponents([.day], from: startOfCheckIn, to: startOfCheckOut)
        return max(components.day ?? 1, 1)
    }
    
    private var filteredHotels: [HotelModel] {
        // Start with search results
        var hotels = viewModel.searchHotels(with: searchText)
        print("🔍 MainScreenView: filteredHotels called, found \(hotels.count) hotels after search")
        
        // Apply price filter
        hotels = hotels.compactMap { hotel in
            let filteredRooms = hotel.roomObj.filter { room in
                let price = Double(room.roomPrice)
                return price >= minPrice && price <= maxPrice
            }
            
            if filteredRooms.isEmpty {
                return nil
            }
            
            return HotelModel(
                id: hotel.id,
                hotelNameType: hotel.hotelNameType,
                latitude: hotel.latitude,
                longitude: hotel.longitude,
                contactNumber: hotel.contactNumber,
                address: hotel.address,
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
                
                return HotelModel(
                    id: hotel.id,
                    hotelNameType: hotel.hotelNameType,
                    latitude: hotel.latitude,
                    longitude: hotel.longitude,
                    contactNumber: hotel.contactNumber,
                    address: hotel.address,
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
                
                return HotelModel(
                    id: hotel.id,
                    hotelNameType: hotel.hotelNameType,
                    latitude: hotel.latitude,
                    longitude: hotel.longitude,
                    contactNumber: hotel.contactNumber,
                    address: hotel.address,
                    roomObj: filteredRooms
                )
            }
        }
        
        return hotels
    }
    
    // MARK: - Data Loading
    private func updateOnlineStatus() {
        #if os(iOS)
        // Very simple heuristic; consider replacing with NWPathMonitor in your app's network layer
        if let reachability = try? awaitCheckReachability() {
            isOnline = reachability
        } else {
            isOnline = true // default to online
        }
        #else
        isOnline = true
        #endif
    }

    @MainActor
    private func loadData() async {
        // Update connectivity state
        updateOnlineStatus()

        if isOnline {
            // Online: Real-time listener is already set up in viewModel init
            // Just persist to SwiftData for offline use when data arrives
            if !viewModel.hotels.isEmpty {
                viewModel.saveHotelsToSwiftData(context: modelContext)
            }
        } else {
            // Offline: load from SwiftData
            viewModel.loadHotelsFromSwiftData(context: modelContext)
        }
    }

    // Lightweight async reachability placeholder. Swap with NWPathMonitor-based service.
    private func awaitCheckReachability() throws -> Bool {
        // TODO: Replace with a real reachability check using NWPathMonitor in your networking layer.
        return true
    }
}

// MARK: - Hotel Section View
struct HotelSectionView: View {
    let hotel: HotelModel
    let checkInDate: Date
    let checkOutDate: Date
    
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
            NavigationLink(destination: HotelDetailView(room: room, hotel: hotel, checkInDate: checkInDate, checkOutDate: checkOutDate  )) {
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

// MARK: - Range Slider Component - price range on the filter
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

