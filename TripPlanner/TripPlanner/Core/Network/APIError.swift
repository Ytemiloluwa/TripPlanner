//
//  APIError.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, body: String?)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server."
        case .httpError(let statusCode, _):
            return "Request failed (HTTP \(statusCode))."
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}
