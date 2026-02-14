//
//  TripListViewModel.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import Foundation
import Combine

@MainActor
class TripListViewModel: ObservableObject {
    
    @Published var trips: [Trip] = []
    @Published var isloading: Bool = false
    @Published var errorMessage: String?
    
    private let tripService: TripServiceProtocol
    private weak var coordinator: AppCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    init(tripService: TripServiceProtocol, coordinator: AppCoordinator?) {
        
        self.tripService = tripService
        self.coordinator = coordinator
    }
    
    func loadTrips() {
        
        isloading = true
        errorMessage = nil
        
        Task {
            do {
                let trips = try await tripService.fetchTrips()
                self.trips = trips
                self.isloading = false
            }catch {
                self.errorMessage = error.localizedDescription
                self.isloading = false
            }
        }
    }
    
    func createTrip(trip: Trip) {
        Task {
            do {
                let createdTrip = try await tripService.createTrip(trip)
                self.trips.append(createdTrip)
            }catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func deleteTrip(at index: Int) {
        guard index < trips.count else { return }
        let trip = trips[index]
        
        Task {
            do {
                try await tripService.deleteTrip(id: trip.id)
                self.trips.remove(at: index)
            }catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
