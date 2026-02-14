//
//  TripSheetView.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import SwiftUI

// MARK: - Travel Style Model
enum TravelStyle: String, CaseIterable {
    case solo
    case couple
    case family
    case group

    var title: String {
        switch self {
        case .solo: return "Solo"
        case .couple: return "Couple"
        case .family: return "Family"
        case .group: return "Group"
        }
    }
}

// MARK: - Style Row
struct StyleRow: View {
    let style: TravelStyle
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(style.title)
                    .foregroundColor(isSelected ? .white : .primary)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(isSelected ? Color.blue : Color.clear)
        }
        .buttonStyle(.plain)
    }
}

struct CreateTripView: View {
    @ObservedObject var viewModel: TripListViewModel
    @Binding var isPresented: Bool

    @State private var tripName: String = ""
    @State private var tripDescription: String = ""
    @State private var showStylePicker = false
    @State private var selectedStyle: TravelStyle? = .solo

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                    Image("profile")
                        .foregroundColor(.blue)
                        .frame(width: 36, height: 36)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)

                    Spacer()

                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                }

                // Title
                VStack(alignment: .leading, spacing: 6) {
                    Text("Create a Trip")
                        .font(.title3.bold())

                    Text("Let's Go! Build Your Next Adventure")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Trip name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Trip Name")
                        .font(.subheadline.weight(.medium))

                    TextField("Enter the trip name", text: $tripName)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4))
                        )
                }

                // Travel style dropdown
                VStack(alignment: .leading, spacing: 8) {
                    Text("Travel Style")
                        .font(.subheadline.weight(.medium))

                    Button {
                        withAnimation {
                            showStylePicker.toggle()
                        }
                    } label: {
                        HStack {
                            Text(selectedStyle?.title ?? "Select your travel style")
                                .foregroundColor(selectedStyle == nil ? .gray : .primary)

                            Spacer()

                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                                .rotationEffect(.degrees(showStylePicker ? 180 : 0))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4))
                        )
                    }

                    if showStylePicker {
                        VStack(spacing: 0) {
                            ForEach(TravelStyle.allCases, id: \.self) { style in
                                StyleRow(
                                    style: style,
                                    isSelected: style == selectedStyle
                                ) {
                                    selectedStyle = style
                                    withAnimation {
                                        showStylePicker = false
                                    }
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
                        )
                        .padding(.top, 4)
                    }
                }

                // Trip Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Trip Description")
                        .font(.subheadline.weight(.medium))

                    ZStack(alignment: .topLeading) {
                        if tripDescription.isEmpty {
                            Text("Tell us more about the trip")
                                .foregroundColor(Color(.placeholderText))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 8)
                        }
                        TextEditor(text: $tripDescription)
                            .frame(minHeight: 88)
                            .padding(4)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4))
                    )
                }

                Spacer(minLength: 10)

                // Next button
                Button(action: submitAndDismiss) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.4), Color.blue.opacity(0.25)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white.opacity(0.8))
                        .cornerRadius(10)
                }
                .disabled(tripName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(22)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden, axes: .vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(18)
            .shadow(radius: 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
    }

    private func submitAndDismiss() {
        let name = tripName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 7, to: startDate) ?? startDate
        let trip = Trip(
            id: UUID().uuidString,
            name: name,
            destination: name,
            startDate: startDate,
            endDate: endDate,
            activities: [],
            hotels: [],
            flights: [],
            imageURL: nil
        )
        viewModel.createTrip(trip: trip)
        isPresented = false
    }
}

// MARK: - Preview
#Preview {
    CreateTripView(
        viewModel: TripListViewModel(tripService: TripService(), coordinator: nil),
        isPresented: .constant(true)
    )
}
