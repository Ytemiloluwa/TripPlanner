//
//  APIClient.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import Foundation

class TripService: TripServiceProtocol {
   
    private let session: URLSession
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    private let baseURL: URL = {
        guard let url = URL(string: "https://caa580355b32f90cfff0.free.beeceptor.com") else {
            fatalError("Invalid base URL")
        }
        return url
    }()
    
    nonisolated private static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private static let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    private func sendRequest<T: Decodable>(_ request: URLRequest, decoder: JSONDecoder = TripService.jsonDecoder) async throws -> T {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw APIError.invalidResponse
        }
        return try decoder.decode(T.self, from: data)
    }
    
    func fetchTrips() async throws -> [Trip] {
        let url = baseURL.appendingPathComponent("trips")
        let request = URLRequest(url: url)
        return try await sendRequest(request)
    }
    
    func createTrip(_ trip: Trip) async throws -> Trip {
        var request = URLRequest(url: baseURL.appendingPathComponent("trips"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try Self.jsonEncoder.encode(trip)

        return try await sendRequest(request)
    }
    
    func updateTrip(_ trip: Trip) async throws -> Trip {
        var request = URLRequest(url: baseURL.appendingPathComponent("trips/\(trip.id)"))
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try Self.jsonEncoder.encode(trip)

        return try await sendRequest(request)
    }
    
    func deleteTrip(id: String) async throws {
        var request = URLRequest(url: baseURL.appendingPathComponent("trips/\(id)"))
        request.httpMethod = "DELETE"
        _ = try await session.data(for: request)
    }
    
    func fetchFlights(for destination: String?) async throws -> [Flight] {
        var components = URLComponents(url: baseURL.appendingPathComponent("flights"), resolvingAgainstBaseURL: false)

        if let destination, !destination.isEmpty {
            components?.queryItems = [
                URLQueryItem(name: "destination", value: destination)
            ]
        }

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        let request = URLRequest(url: url)
        return try await sendRequest(request)
    }
    
}
