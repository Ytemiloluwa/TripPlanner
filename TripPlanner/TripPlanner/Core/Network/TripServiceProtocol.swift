//
//  APIClientProtocol.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import Foundation

protocol TripServiceProtocol {
    func fetchTrips() async throws -> [Trip]
    func createTrip(_ trip: Trip) async throws -> Trip
    func updateTrip(_ trip: Trip) async throws -> Trip
    func deleteTrip(id: String) async throws
    func fetchFlights(for destination: String?) async throws -> [Flight]
}
