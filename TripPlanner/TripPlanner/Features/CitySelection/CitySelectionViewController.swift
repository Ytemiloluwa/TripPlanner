//
//  CitySelectionViewController.swift
//  TripPlanner
//
//  Created by Temiloluwa on 14-02-2026.
//

import UIKit

struct CityOption {
    let title: String
    let subtitle: String
    let countryCode: String
}

final class CitySelectionViewController: UIViewController {

    var onSelect: ((String) -> Void)?

    private let instructionLabel: UILabel = {
        let l = UILabel()
        l.text = "Please select a city"
        l.font = .systemFont(ofSize: 14)
        l.textColor = .systemGray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let searchField: UITextField = {
        let t = UITextField()
        t.placeholder = "Select City"
        t.font = .systemFont(ofSize: 16)
        t.borderStyle = .none
        t.backgroundColor = .white
        t.layer.cornerRadius = 10
        t.layer.borderWidth = 1
        t.layer.borderColor = UIColor.systemBlue.cgColor
        t.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        t.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        t.leftViewMode = .always
        t.rightViewMode = .always
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()

    private let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 64
        t.separatorColor = .separator
        return t
    }()

    private var allCities: [CityOption] = [
        CityOption(title: "Laghouat Algeria", subtitle: "Laghouat", countryCode: "DZ"),
        CityOption(title: "Lagos, Nigeria", subtitle: "Muritala Muhammed", countryCode: "NG"),
        CityOption(title: "Doha, Qatar", subtitle: "Doha", countryCode: "QA"),
        CityOption(title: "Lagos, Nigeria", subtitle: "Murtala Mohammed International", countryCode: "NG"),
        CityOption(title: "Lahore, Pakistan", subtitle: "Lahore", countryCode: "PK"),
        CityOption(title: "Larnaca, Cyprus", subtitle: "Larnaca", countryCode: "CY"),
    ]
    private var filteredCities: [CityOption] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        filteredCities = allCities
        setupNavigationBar()
        setupLayout()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.reuseId)
        searchField.addTarget(self, action: #selector(searchDidChange), for: .editingChanged)
    }

    private func setupNavigationBar() {
        navigationItem.title = "Where"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
            .foregroundColor: UIColor.label
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
    }

    private func setupLayout() {
        view.addSubview(instructionLabel)
        view.addSubview(searchField)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            searchField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 12),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchField.heightAnchor.constraint(equalToConstant: 48),

            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc private func closeTapped() {
        if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func searchDidChange() {
        let query = (searchField.text ?? "").trimmingCharacters(in: .whitespaces).lowercased()
        if query.isEmpty {
            filteredCities = allCities
        } else {
            filteredCities = allCities.filter {
                $0.title.lowercased().contains(query) ||
                $0.subtitle.lowercased().contains(query) ||
                $0.countryCode.lowercased().contains(query)
            }
        }
        tableView.reloadData()
    }
}

extension CitySelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.reuseId, for: indexPath) as! CityCell
        let city = filteredCities[indexPath.row]
        cell.configure(title: city.title, subtitle: city.subtitle, countryCode: city.countryCode)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = filteredCities[indexPath.row]
        onSelect?(city.title)
        if presentingViewController != nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - City cell (programmatic)
final class CityCell: UITableViewCell {

    static let reuseId = "CityCell"

    private let pinImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "MapPin"))
        v.tintColor = .systemGray
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = .label
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let countryCodeLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .systemGray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let flagContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray5
        v.layer.cornerRadius = 4
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        contentView.addSubview(pinImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(flagContainer)
        contentView.addSubview(countryCodeLabel)

        NSLayoutConstraint.activate([
            pinImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pinImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pinImageView.widthAnchor.constraint(equalToConstant: 24),
            pinImageView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: pinImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: flagContainer.leadingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            flagContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            flagContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagContainer.widthAnchor.constraint(equalToConstant: 28),
            flagContainer.heightAnchor.constraint(equalToConstant: 20),

            countryCodeLabel.topAnchor.constraint(equalTo: flagContainer.bottomAnchor, constant: 4),
            countryCodeLabel.centerXAnchor.constraint(equalTo: flagContainer.centerXAnchor),
            countryCodeLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    func configure(title: String, subtitle: String, countryCode: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        countryCodeLabel.text = countryCode
    }
}
