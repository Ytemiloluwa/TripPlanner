//
//  TripDetailsView.swift
//  TripPlanner
//
//  Created by Temiloluwa on 15-02-2026.
//

import SwiftUI

struct TripDetailsView: View {
    let trip: Trip

    private static let dateRangeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMMM yyyy"
        return f
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                heroSection
                tripDetailsCard
                actionButtonsRow
                planningSections
                TripItinerariesView()
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Plan a Trip")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var heroSection: some View {
        ZStack(alignment: .topTrailing) {
            Image("Rectangle 3448")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipped()
        }
        .frame(maxWidth: .infinity)
    }

    private var tripDetailsCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                Text("\(Self.dateRangeFormatter.string(from: trip.startDate)) → \(Self.dateRangeFormatter.string(from: trip.endDate))")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            Text(trip.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            Text("\(trip.destination) | Trip")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(.systemBackground))
    }

    private var actionButtonsRow: some View {
        HStack(spacing: 12) {
            actionButton(title: "Trip Collaboration", icon: "globe")
            actionButton(title: "Share Trip", icon: "square.and.arrow.up")
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
                    .frame(width: 44, height: 44)
            }
            .background(Color(.systemBackground))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue.opacity(0.5), lineWidth: 1))
            .cornerRadius(10)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
    }

    private func actionButton(title: String, icon: String) -> some View {
        Button(action: {}) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.blue)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(Color(.systemBackground))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue.opacity(0.5), lineWidth: 1))
        .cornerRadius(10)
    }

    private var planningSections: some View {
        VStack(spacing: 16) {
            PlanningCardView(
                title: "Activities",
                buttonTitle: "Add Activities",
                cardBackgroundColor: Color("backgroundBlue"),
                textColor: .white,
                buttonBackgroundColor: .blue,
                buttonTextColor: .white
            )
            PlanningCardView(
                title: "Hotels",
                buttonTitle: "Add Hotels",
                cardBackgroundColor: Color("Hotelbackground"),
                textColor: .black,
                buttonBackgroundColor: .blue,
                buttonTextColor: .white
            )
            PlanningCardView(
                title: "Flights",
                buttonTitle: "Add Flights",
                cardBackgroundColor: Color("FlightBackground"),
                textColor: .white,
                buttonBackgroundColor: .white,
                buttonTextColor: .blue
            )
        }
        .padding(20)
    }

}

// MARK: - Reusable Planning Card

struct PlanningCardView: View {
    let title: String
    let buttonTitle: String
    let cardBackgroundColor: Color
    let textColor: Color
    let buttonBackgroundColor: Color
    let buttonTextColor: Color

    private let description = "Build, personalize, and optimize your itineraries with our trip planner."

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(textColor)
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(textColor.opacity(0.9))
            Button(action: {}) {
                Text(buttonTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(buttonTextColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.plain)
            .tint(buttonTextColor)
            .foregroundColor(buttonTextColor)
            .background(buttonBackgroundColor)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(cardBackgroundColor)
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        TripDetailsView(trip: Trip(
            id: "1",
            name: "Bahamas Family Trip",
            destination: "New York, United States of America",
            startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 21))!,
            endDate: Calendar.current.date(from: DateComponents(year: 2024, month: 4, day: 21))!
        ))
    }
}
