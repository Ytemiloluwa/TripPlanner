//
//  FlightSelectionViewModel.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import Foundation
import Combine

class FlightSelectionViewModel {
    @Published var flights: [Flight] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedFlight: Flight?
    
    private let trip: Trip
    private let tripService: TripServiceProtocol
    private weak var coordinator: AppCoordinator?

    init(trip: Trip, tripService: TripServiceProtocol,coordinator: AppCoordinator?) {
        self.trip = trip
        self.tripService = tripService
        self.coordinator = coordinator
        loadFlights()
    }

    func loadFlights() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let flights = try await tripService.fetchFlights(for: trip.destination)
                await MainActor.run {
                    self.flights = flights
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

}
