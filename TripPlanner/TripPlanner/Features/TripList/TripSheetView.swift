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
    @Binding var selectedCity: String
    @Binding var startDate: Date
    @Binding var endDate: Date

    @State private var tripName: String = ""
    @State private var tripDescription: String = ""
    @State private var showStylePicker = false
    @State private var selectedStyle: TravelStyle? = .solo
    @State private var isSubmitting = false
    @State private var submitErrorMessage: String?
    @State private var showSubmitError = false
    @FocusState private var focusedField: FocusedField?

    private enum FocusedField {
        case tripName
        case tripDescription
    }

    private var isFormValid: Bool {
        let nameOk = !tripName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let destinationOk = !selectedCity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return nameOk && destinationOk && !isSubmitting
    }

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
                        .focused($focusedField, equals: .tripName)
                        .submitLabel(.done)
                        .onSubmit { focusedField = nil }
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
                            .focused($focusedField, equals: .tripDescription)
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
                Button(action: submitTapped) {
                    Group {
                        if isSubmitting {
                            ProgressView()
                                .tint(.white.opacity(0.9))
                        } else {
                            Text("Next")
                        }
                    }
                        .frame(maxWidth: .infinity)
                        .padding()
                    .background(isFormValid ? Color.blue : Color.gray.opacity(0.35))
                    .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isFormValid)
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
        .contentShape(Rectangle())
        .onTapGesture { focusedField = nil }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
        .alert("Something went wrong", isPresented: $showSubmitError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(submitErrorMessage ?? "Please try again.")
        }
    }

    private func submitTapped() {
        focusedField = nil
        let name = tripName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        let destination = selectedCity.trimmingCharacters(in: .whitespaces)
        guard !destination.isEmpty else {
            submitErrorMessage = "Please select a city."
            showSubmitError = true
            return
        }
        guard !isSubmitting else { return }
        isSubmitting = true
        let start = startDate
        let end = max(endDate, start)
        let trip = Trip(
            id: UUID().uuidString,
            name: name,
            destination: destination,
            startDate: start,
            endDate: end
        )
        Task {
            do {
                try await viewModel.createTripAndRefresh(trip: trip)
                await MainActor.run {
                    isSubmitting = false
                    isPresented = false
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    submitErrorMessage = error.localizedDescription
                    showSubmitError = true
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    CreateTripView(
        viewModel: TripListViewModel(tripService: TripService(), coordinator: nil),
        isPresented: .constant(true),
        selectedCity: .constant("Doha, Qatar"),
        startDate: .constant(Date()),
        endDate: .constant(Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date())
    )
}
