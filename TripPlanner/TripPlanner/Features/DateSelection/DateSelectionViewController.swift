//
//  DateSelectionViewController.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import UIKit

final class DateSelectionViewController: UIViewController {

    var initialStartDate: Date = Date()
    var initialEndDate: Date = Date()
    var onChoose: ((Date, Date) -> Void)?

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE, MMM d"
        return f
    }()

    private lazy var closeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "xmark"), for: .normal)
        b.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Date"
        l.font = .systemFont(ofSize: 20, weight: .semibold)
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.showsVerticalScrollIndicator = false
        return s
    }()

    private let contentStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 20
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private lazy var startDatePicker: UIDatePicker = {
        let p = UIDatePicker()
        p.datePickerMode = .date
        p.preferredDatePickerStyle = .inline
        p.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()

    private lazy var endDatePicker: UIDatePicker = {
        let p = UIDatePicker()
        p.datePickerMode = .date
        p.preferredDatePickerStyle = .inline
        p.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()

    private let startDateLabel: UILabel = {
        let l = UILabel()
        l.text = "Start Date"
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let startDateField: UITextField = {
        let t = UITextField()
        t.borderStyle = .none
        t.backgroundColor = .white
        t.font = .systemFont(ofSize: 16)
        t.textColor = .label
        t.isUserInteractionEnabled = false
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()

    private let endDateLabel: UILabel = {
        let l = UILabel()
        l.text = "End Date"
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let endDateField: UITextField = {
        let t = UITextField()
        t.borderStyle = .none
        t.backgroundColor = .white
        t.font = .systemFont(ofSize: 16)
        t.textColor = .label
        t.isUserInteractionEnabled = false
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()

    private lazy var chooseButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Choose Date", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        b.backgroundColor = .systemBlue
        b.layer.cornerRadius = 10
        b.addTarget(self, action: #selector(chooseTapped), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let today = Calendar.current.startOfDay(for: Date())
        let start = max(initialStartDate, today)
        let end = max(initialEndDate, start)

        startDatePicker.minimumDate = today
        startDatePicker.date = start
        endDatePicker.minimumDate = start
        endDatePicker.date = end

        updateFieldLabels()
        // Add choose button first so scrollView can be constrained above it
        setupChooseButton()
        setupHeader()
        setupScrollContent()
    }

    private func setupHeader() {
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    private func setupScrollContent() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        contentStack.addArrangedSubview(startDatePicker)
        contentStack.addArrangedSubview(endDatePicker)
        
        let startColumn = UIStackView(arrangedSubviews: [startDateLabel, wrappedField(startDateField)])
        startColumn.axis = .vertical
        startColumn.spacing = 8
        startColumn.translatesAutoresizingMaskIntoConstraints = false

        let endColumn = UIStackView(arrangedSubviews: [endDateLabel, wrappedField(endDateField)])
        endColumn.axis = .vertical
        endColumn.spacing = 8
        endColumn.translatesAutoresizingMaskIntoConstraints = false

        let fieldsRow = UIStackView(arrangedSubviews: [startColumn, endColumn])
        fieldsRow.axis = .horizontal
        fieldsRow.spacing = 16
        fieldsRow.distribution = .fillEqually
        fieldsRow.alignment = .top
        fieldsRow.translatesAutoresizingMaskIntoConstraints = false

        contentStack.addArrangedSubview(fieldsRow)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: chooseButton.topAnchor, constant: -20),
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 0),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),
        ])
    }

    private func wrappedField(_ field: UITextField) -> UIView {
        let wrap = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.backgroundColor = .white
        wrap.layer.cornerRadius = 10
        wrap.layer.borderWidth = 1
        wrap.layer.borderColor = UIColor.systemGray4.cgColor
        wrap.addSubview(field)
        let icon = UIImageView(image: UIImage(systemName: "calendar"))
        icon.tintColor = .systemGray
        icon.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(icon)
        NSLayoutConstraint.activate([
            field.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: 12),
            field.centerYAnchor.constraint(equalTo: wrap.centerYAnchor),
            field.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -8),
            icon.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -12),
            icon.centerYAnchor.constraint(equalTo: wrap.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 22),
            icon.heightAnchor.constraint(equalToConstant: 22),
            wrap.heightAnchor.constraint(equalToConstant: 48),
        ])
        return wrap
    }

    private func setupChooseButton() {
        view.addSubview(chooseButton)
        NSLayoutConstraint.activate([
            chooseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chooseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chooseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            chooseButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func updateFieldLabels() {
        startDateField.text = dateFormatter.string(from: startDatePicker.date)
        endDateField.text = dateFormatter.string(from: endDatePicker.date)
    }

    @objc private func startDateChanged() {
        if endDatePicker.date < startDatePicker.date {
            endDatePicker.date = startDatePicker.date
        }
        endDatePicker.minimumDate = startDatePicker.date
        updateFieldLabels()
    }

    @objc private func endDateChanged() {
        updateFieldLabels()
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func chooseTapped() {
        onChoose?(startDatePicker.date, endDatePicker.date)
        dismiss(animated: true)
    }
}
