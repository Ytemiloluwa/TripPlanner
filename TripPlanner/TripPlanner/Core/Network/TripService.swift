//
//  TripService.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import Foundation

class TripService: TripServiceProtocol {
    private let session: URLSession
    private let baseURL = URL(string: "https://ca822a0cdc84845bcd25.free.beeceptor.com/api/users")!
    private static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    private static let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchTrips() async throws -> [Trip] {
        try await request(URLRequest(url: baseURL))
    }

    func createTrip(_ trip: Trip) async throws -> Trip {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try Self.encoder.encode(trip)
        return try await self.request(request)
    }

    private func request<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw APIError.httpError(statusCode: code, body: String(data: data, encoding: .utf8))
        }
        do {
            return try Self.decoder.decode(T.self, from: data)
        } catch {
            throw APIError.invalidResponse
        }
    }
}
