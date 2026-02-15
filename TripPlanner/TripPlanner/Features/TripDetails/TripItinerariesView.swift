//
//  TripItinerariesView.swift
//  TripPlanner
//
//  Created by Temiloluwa on 15-02-2026.
//

import SwiftUI

struct TripItinerariesView: View {
    @State private var isFlightsPopulated = false
    @State private var isHotelsPopulated = false
    @State private var isActivitiesPopulated = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trip itineraries")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)

            Text("Your trip itineraries are placed here")
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            VStack(spacing: 12) {
                ItinerarySectionView(kind: .flights, isPopulated: $isFlightsPopulated)
                ItinerarySectionView(kind: .hotels, isPopulated: $isHotelsPopulated)
                ItinerarySectionView(kind: .activities, isPopulated: $isActivitiesPopulated)
            }
            .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }
}

private enum ItineraryKind {
    case flights
    case hotels
    case activities

    var title: String {
        switch self {
        case .flights: return "Flights"
        case .hotels: return "Hotels"
        case .activities: return "Activities"
        }
    }

    var sectionIcon: String {
        switch self {
        case .flights: return "box"
        case .hotels: return "box-2"
        case .activities: return "box-3"
        }
    }

    var emptyIllustration: String {
        switch self {
        case .flights: return "chat"
        case .hotels: return "chat-2"
        case .activities: return "chat-3"
        }
    }

    var addButtonTitle: String {
        switch self {
        case .flights: return "Add Flight"
        case .hotels: return "Add Hotel"
        case .activities: return "Add Activity"
        }
    }

    var sectionBackground: Color {
        switch self {
        case .flights: return Color(red: 0.88, green: 0.89, blue: 0.92)
        case .hotels: return Color(red: 0.30, green: 0.35, blue: 0.44)
        case .activities: return Color("FlightBackground")
        }
    }
}

private struct ItinerarySectionView: View {
    let kind: ItineraryKind
    @Binding var isPopulated: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(kind.sectionIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                Text(kind.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)

            Group {
                if isPopulated {
                    PopulatedItineraryCard(
                        kind: kind,
                        onRemove: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isPopulated = false
                            }
                        }
                    )
                } else {
                    EmptyItineraryCard(
                        kind: kind,
                        onAdd: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isPopulated = true
                            }
                        }
                    )
                }
            }
            .padding(10)
            .padding(.top, -4)
        }
        .background(kind.sectionBackground)
        .cornerRadius(6)
    }
}

private struct EmptyItineraryCard: View {
    let kind: ItineraryKind
    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Image(kind.emptyIllustration)
                .resizable()
                .scaledToFit()
                .frame(width: 118, height: 118)
                .padding(.top, 6)

            Text("No request yet")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black.opacity(0.75))

            Button(action: onAdd) {
                Text(kind.addButtonTitle)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
            .background(Color.blue)
            .cornerRadius(4)
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(4)
    }
}

private struct PopulatedItineraryCard: View {
    let kind: ItineraryKind
    let onRemove: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            switch kind {
            case .flights:
                FlightDetailsCard()
            case .hotels:
                HotelDetailsCard()
            case .activities:
                ActivityDetailsCard()
            }

            Button(action: onRemove) {
                HStack {
                    Text("Remove")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.red.opacity(0.85))
                    Text("✕")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.red.opacity(0.85))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(red: 0.98, green: 0.93, blue: 0.93))
            }
            .buttonStyle(.plain)
        }
        .background(Color(.systemBackground))
        .cornerRadius(4)
    }
}

private struct FlightDetailsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image("american_airlines_symbol.svg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                VStack(alignment: .leading, spacing: 2) {
                    Text("American Airlines")
                        .font(.system(size: 14, weight: .semibold))
                    Text("AA-829")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("08:35")
                        .font(.system(size: 20, weight: .semibold))
                    Text("Sun, 20 Aug")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    HStack {
                        Text("LOS")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.primary)
                        
                    }.padding(.leading, 70)
                }
                Spacer()
                VStack(spacing: 3) {
                    HStack(spacing: 4) {
                        Image("cloud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                        Text("1h 45m")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                            .padding(.leading, -20)
                    }
                    Rectangle()
                        .fill(Color("FlightBackground"))
                        .frame(width: 66, height: 6)
                    
                    VStack {
                        Text("Direct")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }.padding(.top, 20)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("09:55")
                        .font(.system(size: 20, weight: .semibold))
                    Text("Sun, 20 Aug")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    HStack {
                        Text("SIN")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.primary)
                    }.padding(.trailing, 70)
                }
            }

            detailsActions(["Flight details", "Price details", "Edit details"])


            Text("₦123,450.00")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary)
        }
        .padding(12)
    }
}

private struct HotelDetailsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            detailImage(name: "Rectangle 3437")

            Text("Riviera Resort, Lekki")
                .font(.system(size: 22, weight: .semibold))

            Text("18, Kenneth Agbakuru Street, Off Access Bank Admiralty Way, Lekki Phase1")
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                iconLabel(icon: "MapPin", text: "Show in map")
                iconLabel(icon: "profile", text: "8.5 (436)")
                iconLabel(icon: "hotel", text: "King size room")
            }
            .font(.system(size: 11))
            .foregroundColor(.secondary)

            HStack(spacing: 8) {
                iconLabel(icon: "box-4", text: "In: 20-04-2024")
                iconLabel(icon: "box-4", text: "Out: 29-04-2024")
            }
            .font(.system(size: 11))
            .foregroundColor(.secondary)

            detailsActions(["Hotel details", "Price details", "Edit details"])

            Text("₦123,450.00")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary)
        }
        .padding(12)
    }
}

private struct ActivityDetailsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            detailImage(name: "Rectangle 3438")

            Text("The Museum of Modern Art")
                .font(.system(size: 20, weight: .semibold))

            Text("Works from Van Gogh to Warhol & beyond plus a sculpture garden, 2 cafes & The modern restaurant")
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                iconLabel(icon: "MapPin", text: "Melbourne, Australia")
                iconLabel(icon: "profile", text: "8.5 (436)")
                iconLabel(icon: "cloud", text: "1 hour")
            }
            .font(.system(size: 11))
            .foregroundColor(.secondary)

            Text("Change time")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.blue)

            HStack {
                Text("10:30 AM on Mar 19")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                Spacer()
                Text("Day 1 (Activity 1)")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(4)
            }

            detailsActions(["Hotel details", "Price details", "Edit details"])

            Text("₦123,450.00")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.primary)
        }
        .padding(12)
    }
}

private func detailsActions(_ items: [String]) -> some View {
    HStack(spacing: 16) {
        ForEach(items, id: \.self) { item in
            Button(action: {}) {
                Text(item)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
        }
    }
    .frame(maxWidth: .infinity)
}

private func detailImage(name: String) -> some View {
    ZStack(alignment: .bottom) {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 126)
            .frame(maxWidth: .infinity)
            .clipped()
            .cornerRadius(3)

        HStack(spacing: 8) {
            Image("CaretCircleRight")
                .resizable()
                .scaledToFit()
                .frame(width: 29, height: 29)
            Image("CaretCircleRight-1")
                .resizable()
                .scaledToFit()
                .frame(width: 29, height: 29)
        }
        .padding(.bottom, 8)
    }
}

private func iconLabel(icon: String, text: String) -> some View {
    HStack(spacing: 3) {
        Image(icon)
            .resizable()
            .scaledToFit()
            .frame(width: 11, height: 11)
        Text(text)
            .lineLimit(1)
    }
}

#Preview {
    ScrollView {
        TripItinerariesView()
    }
}
