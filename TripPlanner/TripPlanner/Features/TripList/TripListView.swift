//
//  TripListView.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import SwiftUI
import UIKit
import Combine

struct TripListView: View {
    
    @ObservedObject var viewModel: TripListViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingCreateTrip = false
    @State private var newTripName = ""
    @State private var newTripDestination = ""
    @State private var selectedCity = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var showingCreateTripSheet = false
    
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()
    
    private var topBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "arrow.left")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)
            Text("Plan a Trip")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(Color(.systemBackground))
    }

    private var isSmallScreen: Bool {
        UIScreen.main.bounds.height < 700
    }
    
    private var heroHeight: CGFloat {
        isSmallScreen ? 400 : 480
    }
    
    private var cardTopPadding: CGFloat {
        isSmallScreen ? 200 : 260
    }
    
    private var spacerMinLength: CGFloat {
        isSmallScreen ? 100 : 150
    }

    private var planHeroSection: some View {
        ZStack(alignment: .top) {
            (colorScheme == .dark ? Color(.secondarySystemBackground) : Color("bgColor"))
                .frame(height: heroHeight)

            VStack(alignment: .leading, spacing: 12) {
                Text("Plan Your Dream Trip in Minutes")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                Text("Build, personalize, and optimize your itineraries with our trip planner. Perfect for getaways, remote workcations, and any spontaneous escapade.")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 36)

            VStack(spacing: 0) {
                Spacer(minLength: spacerMinLength)
                Image("hotel")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 24)
                Image("Group 229211")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 0)
                    .clipped()
            }
            .frame(height: heroHeight, alignment: .bottom)

            CardView
                .padding(.horizontal, 24)
                .padding(.top, cardTopPadding)
        }
        .padding(.bottom, 24)
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 0){
                topBar
                planHeroSection
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Trips")
                        .font(.system(size: 16, weight: .bold))
                    Text("Your trip itineraries and  planned trips are placed here")
                        .font(.system(size: 12, weight: .medium))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
                
                HStack {
                    Text("Planned Trips")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                if viewModel.isloading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                } else if viewModel.trips.isEmpty {
                    VStack(spacing: 16) {
                        Text("No trips planned yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.trips) { trip in
                            TripCard(trip: trip)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            viewModel.loadTrips()
        }
    }
    var CardView: some View {
        VStack(spacing: 16) {
            // City Input (button – presents UIKit city selection)
            Button(action: {
                viewModel.openCitySelection { city in
                    selectedCity = city
                }
            }) {
                HStack(spacing: 12) {
                    Image("MapPin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(.gray)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Where to?")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(selectedCity.isEmpty ? "Select City" : selectedCity)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(selectedCity.isEmpty ? .gray : .primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            
            // Date Pickers
            HStack(spacing: 12) {
                // Start Date
                Button(action: {
                    viewModel.openDateSelection(start: startDate, end: endDate) { newStart, newEnd in
                        startDate = newStart
                        endDate = newEnd
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Start Date")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text(dateFormatter.string(from: startDate))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.separator), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)

                // End Date
                Button(action: {
                    viewModel.openDateSelection(start: startDate, end: endDate) { newStart, newEnd in
                        startDate = newStart
                        endDate = newEnd
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("End Date")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text(dateFormatter.string(from: endDate))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.separator), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
            // Create Trip Button
            Button(action: { showingCreateTripSheet = true }) {
                Text("Create a Trip")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.25 : 0.1), radius: 10, x: 0, y: 5)
        .sheet(isPresented: $showingCreateTripSheet) {
            CreateTripView(
                viewModel: viewModel,
                isPresented: $showingCreateTripSheet,
                selectedCity: $selectedCity,
                startDate: $startDate,
                endDate: $endDate
            )
        }
    }
    
    private func submitCreateTripFromCard() {
        let city = selectedCity.trimmingCharacters(in: .whitespaces)
        guard !city.isEmpty else { return }
        let trip = Trip(
            id: UUID().uuidString,
            name: city,
            destination: city,
            startDate: startDate,
            endDate: endDate
        )
        viewModel.createTrip(trip: trip)
        selectedCity = ""
    }
    
    private func submitCreateTripFromSheet() {
        let start = startDate
        let end = endDate
        let trip = Trip(
            id: UUID().uuidString,
            name: newTripName,
            destination: newTripDestination,
            startDate: start,
            endDate: end
        )
        viewModel.createTrip(trip: trip)
        showingCreateTrip = false
        newTripName = ""
        newTripDestination = ""
    }
}

struct TripCard: View {
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack(alignment: .topTrailing) {
                Image("Rectangle 3448") 
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                
                Text(trip.destination)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(4)
                    .padding(12)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(trip.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                HStack {
                    Text(formatDate(trip.startDate))
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(daysBetween(start: trip.startDate, end: trip.endDate)) Days")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                NavigationLink(destination: TripDetailsView(trip: trip)) {
                    Text("View")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
            .padding(16)
            .background(Color.white)
        }
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
        let day = Int(dayFormatter.string(from: date)) ?? 1
        
        let suffix: String
        switch day {
        case 1, 21, 31: suffix = "st"
        case 2, 22: suffix = "nd"
        case 3, 23: suffix = "rd"
        default: suffix = "th"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d'\(suffix)' MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func daysBetween(start: Date, end: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: start, to: end)
        return components.day ?? 0
    }
}

// MARK: - Preview
#Preview {
    let viewModel = TripListViewModel(tripService: TripService(), coordinator: nil)
    return TripListView(viewModel: viewModel)
}

class TripListViewController: UIHostingController<TripListView> {
    private let viewModel: TripListViewModel
    
    init(viewModel: TripListViewModel) {
        self.viewModel = viewModel
        super.init(rootView: TripListView(viewModel: viewModel))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
