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
    @State private var showingCreateTrip = false
    @State private var newTripName = ""
    @State private var newTripDestination = ""
    @State private var selectedCity = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var showStartDatePicker = false
    @State private var showEndDatePicker = false
    @State private var showingCreateTripSheet = false
    
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()
    
    var plan: some View {
        
        HStack {
            Text("Plan a Trip")
                .font(.system(size: 17, weight: .bold))
            
            Spacer()
            
        }.padding()
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 5){
                
                plan
                
                Color("bgColor")
                    .ignoresSafeArea()
            
                VStack(alignment: .leading, spacing: 12) {
                    Text("Plan Your Dream Trip in Minutes")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(white: 0.2))
                    Text("Build, personalize, and optimize your itineraries with our trip planner. Perfect for getaways, remote workcations, and any spontaneous escapade.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding()
                
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        HStack {
                            Image("hotel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)

                        }
                        .frame(maxWidth: .infinity)
                        Image("Group 229211")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    }
                    CardView
                        .offset(y: 60)
                }
                .padding(.bottom, 80)
                
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
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
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
        .onAppear {
            viewModel.loadTrips()
        }
    }
    var CardView: some View {
        VStack(spacing: 16) {
            // City Input
            HStack(spacing: 12) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Where to?")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    TextField("Select City", text: $selectedCity)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            
            // Date Pickers
            HStack(spacing: 12) {
                // Start Date
                Button(action: { showStartDatePicker = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Start Date")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text("Enter a date")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
                
                // End Date
                Button(action: { showEndDatePicker = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("End Date")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text("Enter a date")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
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
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .sheet(isPresented: $showingCreateTripSheet) {
            CreateTripView(viewModel: viewModel, isPresented: $showingCreateTripSheet)
        }
        .sheet(isPresented: $showStartDatePicker) {
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showEndDatePicker) {
            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .presentationDetents([.medium])
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
            endDate: endDate,
            activities: [],
            hotels: [],
            flights: [],
            imageURL: nil
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
            endDate: end,
            activities: [],
            hotels: [],
            flights: [],
            imageURL: nil
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
                Image("OBJECTS") 
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
                
                Button(action: {
                  
                    
                }) {
                    Text("View")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
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
