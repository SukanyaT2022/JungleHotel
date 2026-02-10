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
    @State private var selectedCategory: String = "Popular"
  
    // Filter state variables
    @State private var minPrice: Double = 0
    @State private var maxPrice: Double = 1000
    @State private var minRating: Double = 0
    @State private var selectedRoomTypes: Set<String> = []
    
    // Date picker states (used for detail screen defaults)
    @State private var checkInDate = Date()
    @State private var checkOutDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                homeContent
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
            }
            .background(liquidBackground)
            .navigationBarHidden(true)
            .task {
                await loadData()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                Task { await loadData() }
            }
        }
        .fullScreenCover(isPresented: $showingFilterOptions) {
            FilterOptionsView(
                minPrice: $minPrice,
                maxPrice: $maxPrice,
                minRating: $minRating,
                selectedRoomTypes: $selectedRoomTypes
            )
        }
        .refreshable {
            await loadData()
        }
    }
    
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello Sara")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Colors.textSecondary)
                
                Text("Welcome to Jungle hotel!")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Colors.textPrimary)
            }
            
            Spacer()
            
            Button(action: {}) {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                        .overlay(
                            Image(systemName: "bell")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Colors.textPrimary)
                        )
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: -3, y: 3)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Colors.textSecondary)
                .font(.system(size: 16, weight: .medium))
            
            TextField("Search hotel", text: $searchText)
                .font(.system(size: 14))
                .foregroundColor(Colors.textPrimary)
            
            Spacer()
            
            Button {
                showingFilterOptions.toggle()
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Colors.textPrimary)
                    .padding(10)
                    .background(Colors.chipBackground.opacity(0.8))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
    }
    
    private var categoryChips: some View {
        let categories = ["Popular", "Modern", "Beach", "Mountain"]
        
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Text(category)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(selectedCategory == category ? .white : Colors.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(selectedCategory == category ? Colors.primary : Colors.chipBackground.opacity(0.7))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Colors.textPrimary)
            
            Spacer()
            
            Button("See all") { }
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Colors.primary)
        }
    }
    
    private var homeContent: some View {
        Group {
            if viewModel.isLoading {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Loading hotels...")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Colors.textSecondary)
                }
                .frame(maxWidth: .infinity, minHeight: 240)
            } else if !viewModel.errorMessage.isEmpty {
                ErrorView(
                    message: viewModel.errorMessage,
                    onRetry: {
                        viewModel.fetchHotels()
                    }
                )
                .frame(maxWidth: .infinity, minHeight: 240)
            } else {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    searchBar
                    categoryChips
                    
                    sectionHeader(title: "All hotels")
                    allHotelsList
                }
            }
        }
    }

    private var liquidBackground: some View {
        LinearGradient(
            colors: [
                Color(hex: "#F4FBF8"),
                Color(hex: "#EAF3FF"),
                Color(hex: "#F7F2FF")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var displayHotels: [HotelModel] {
        if viewModel.hotels.isEmpty && viewModel.errorMessage.isEmpty && !viewModel.isLoading {
            return [HotelModel.sampleHotel]
        }
        return filteredHotels
    }
    
    private var displayRooms: [(hotel: HotelModel, room: Room)] {
        displayHotels.flatMap { hotel in
            hotel.roomObj.map { room in
                (hotel: hotel, room: room)
            }
        }
    }
    
    private var allHotelsList: some View {
        let rooms = displayRooms
        
        return VStack(spacing: 16) {
            ForEach(rooms, id: \.room.id) { item in
                NavigationLink(
                    destination: HotelDetailView(
                        room: item.room,
                        hotel: item.hotel,
                        pricePerNightDetail: item.room.roomPrice,
                        checkInDateSecond: checkInDate,
                        checkOutDateSecond: checkOutDate
                    )
                ) {
                    HotelCardView(room: item.room, hotelName: item.hotel.hotelNameType)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Native Date Picker Section
    private var nativeDatePickerSection: some View {
        let dateRange: ClosedRange<Date> = {
            let calendar = Calendar.current
            let startDate = Date()
            let endDate = calendar.date(byAdding: .year, value: 2, to: startDate) ?? startDate
            return startDate...endDate
        }()
        //parent date picker
        return VStack(alignment: . center, spacing: 12) {
             // Check-in and Check-out side by side
          
             HStack(spacing: 20) {
                 // Check-in DatePicker
                 VStack(alignment: .leading, spacing: 4) {
//                     Text("Check-in")
//                         .font(.system(size: 14, weight: .medium))
//                         .foregroundColor(.secondary)
//                     
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
                     .frame(height: 64)
                 }
                
                 
                 // Check-out DatePicker
                 VStack(alignment: .leading, spacing: 4) {
//                     Text("Check-out")
//                         .font(.system(size: 14, weight: .medium))
//                         .foregroundColor(.secondary)
//                     
                     DatePicker(
                         "",
                         selection: $checkOutDate,
                         in: Calendar.current.date(byAdding: .day, value: 1, to: checkInDate)!...dateRange.upperBound,
                         displayedComponents: [.date]
                     )
                     .datePickerStyle(.compact)
                 }
                 .frame(maxWidth: .infinity, alignment: .trailing)
             }
             
//              Duration display
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
         .padding(.vertical, 14)
         .background(Color(.systemGray6))
         .cornerRadius(12)

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

// MARK: - Nearby Hotel Row View
struct NearbyHotelRowView: View {
    let hotel: HotelModel
    let room: Room
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: room.roomImage.first ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image("waterfall")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(hotel.hotelNameType)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Colors.textPrimary)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Colors.textSecondary)
                    Text(room.roomDetail)
                        .font(.system(size: 11))
                        .foregroundColor(Colors.textSecondary)
                        .lineLimit(1)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", room.roomRating))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Colors.textSecondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("$\(room.roomPrice)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Colors.textPrimary)
                Text("/ night")
                    .font(.system(size: 11))
                    .foregroundColor(Colors.textSecondary)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.6), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 6)
    }
}

// MARK: - Hotel Section View
struct HotelSectionView: View {
    let hotel: HotelModel
    let checkInDate: Date
    let checkOutDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
//            hotelHeader
            roomsList
               
        }
        .padding(.vertical, 8)
        
        
    }
    
//    private var hotelHeader: some View {
//        HStack {
//            Text(hotel.hotelNameType)
//                .font(.title)
//                .fontWeight(.bold)
//            
//            Spacer()
//            
//            //            Text("\(hotel.roomObj.count) rooms")
//            //                .font(.caption)
//            //                .foregroundColor(.secondary)
//        }
//        .padding(.horizontal)
//    }
//    
    private var roomsList: some View {
        ForEach(hotel.roomObj) { room in
            NavigationLink(destination: HotelDetailView(room: room, hotel: hotel, pricePerNightDetail: room.roomPrice, checkInDateSecond: checkInDate, checkOutDateSecond: checkOutDate  )) {
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

// MARK: - Custom Date Picker View
struct DatePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date
    let title: String
    let minimumDate: Date
    let onDateSelected: (Date) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    in: minimumDate...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Spacer()
                
                Button("Done") {
                    onDateSelected(selectedDate)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Guest Picker View
struct GuestPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var numberOfRooms: Int
    @Binding var numberOfAdults: Int
    @Binding var numberOfChildren: Int
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    // Rooms
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Rooms")
                                .font(.system(size: 18, weight: .semibold))
                            Text("How many rooms do you need?")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                if numberOfRooms > 1 {
                                    numberOfRooms -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .font(.title2)
                                    .foregroundColor(numberOfRooms > 1 ? .blue : .gray)
                            }
                            .disabled(numberOfRooms <= 1)
                            
                            Text("\(numberOfRooms)")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(minWidth: 30)
                            
                            Button(action: {
                                numberOfRooms += 1
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Adults
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Adults")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Ages 13 or above")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                if numberOfAdults > 1 {
                                    numberOfAdults -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .font(.title2)
                                    .foregroundColor(numberOfAdults > 1 ? .blue : .gray)
                            }
                            .disabled(numberOfAdults <= 1)
                            
                            Text("\(numberOfAdults)")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(minWidth: 30)
                            
                            Button(action: {
                                numberOfAdults += 1
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Children
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Children")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Ages 2-12")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                if numberOfChildren > 0 {
                                    numberOfChildren -= 1
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .font(.title2)
                                    .foregroundColor(numberOfChildren > 0 ? .blue : .gray)
                            }
                            .disabled(numberOfChildren <= 0)
                            
                            Text("\(numberOfChildren)")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(minWidth: 30)
                            
                            Button(action: {
                                numberOfChildren += 1
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("Guests")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MainScreenView()
}

