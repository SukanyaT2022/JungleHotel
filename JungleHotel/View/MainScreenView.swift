
//  HotelListView
//
//  Created by TS2 on 8/26/25.
//
import SwiftUI

struct MainScreenView: View {
    @StateObject private var viewModel = HotelViewModel()
    @State private var searchText = ""
    @State private var showingFilterOptions = false
    
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
            .sheet(isPresented: $showingFilterOptions) {
                FilterOptionsView()
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
        // Always use the search function to ensure consistency
        return viewModel.searchHotels(with: searchText)
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
            NavigationLink(destination: HotelDetailView()) {
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
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Filter Options")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Coming Soon...")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
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

