
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
            contentView
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText, prompt: "Search hotels or rooms")
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        navigationTitleView
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        filterButton
                    }
                }
                .sheet(isPresented: $showingFilterOptions) {
                    FilterOptionsView()
                }
                .refreshable {
                    viewModel.fetchHotels()
                }
        }
    }
    
    // MARK: - Custom Navigation Title View
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
            .padding()
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
            
            Text("\(hotel.roomObj.count) rooms")
                .font(.caption)
                .foregroundColor(.secondary)
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

