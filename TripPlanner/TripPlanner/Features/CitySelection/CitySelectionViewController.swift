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
    
    @IBOutlet private weak var instructionLabel: UILabel!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var tableView: UITableView!

    private var allCities: [CityOption] = [
        CityOption(title: "Laghouat Algeria", subtitle: "Laghouat", countryCode: "AG"),
        CityOption(title: "Lagos, Nigeria", subtitle: "Muritala Muhammed", countryCode: "NG"),
        CityOption(title: "Doha, Qatar", subtitle: "Doha", countryCode: "QA"),
        CityOption(title: "Lagos, Nigeria", subtitle: "Murtala Mohammed International", countryCode: "NG"),
        CityOption(title: "Lagos, Nigeria", subtitle: "Larnaca", countryCode: "NG"),
    ]
    private var filteredCities: [CityOption] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        filteredCities = allCities
        setupNavigationBar()
        configureUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.reuseId)
        tableView.separatorColor = .separator
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
    }

    private func setupNavigationBar() {
        navigationItem.title = "Where"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
            .foregroundColor: UIColor.label
        ]
    }

    private func configureUI() {
        searchField.borderStyle = .none
        searchField.backgroundColor = .white
        searchField.layer.cornerRadius = 10
        searchField.layer.borderWidth = 1
        searchField.layer.borderColor = UIColor.systemBlue.cgColor
        searchField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        searchField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        searchField.leftViewMode = .always
        searchField.rightViewMode = .always
    }

    @IBAction private func closeTapped(_ sender: Any) {
        if let nav = navigationController, nav.presentingViewController != nil {
            nav.dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @IBAction private func searchDidChange(_ sender: UITextField) {
        let query = (sender.text ?? "").trimmingCharacters(in: .whitespaces).lowercased()
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
        if let nav = navigationController, nav.presentingViewController != nil {
            nav.dismiss(animated: true)
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
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let flagImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private static let flagAssetNames: [String: String] = [
        "AG": "algeria",
        "NG": "nigeria",
        "QA": "qatar",
    ]

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
        flagContainer.addSubview(flagImageView)
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

            flagImageView.topAnchor.constraint(equalTo: flagContainer.topAnchor),
            flagImageView.leadingAnchor.constraint(equalTo: flagContainer.leadingAnchor),
            flagImageView.trailingAnchor.constraint(equalTo: flagContainer.trailingAnchor),
            flagImageView.bottomAnchor.constraint(equalTo: flagContainer.bottomAnchor),

            countryCodeLabel.topAnchor.constraint(equalTo: flagContainer.bottomAnchor, constant: 4),
            countryCodeLabel.centerXAnchor.constraint(equalTo: flagContainer.centerXAnchor),
            countryCodeLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    func configure(title: String, subtitle: String, countryCode: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        countryCodeLabel.text = countryCode
        let assetName = Self.flagAssetNames[countryCode.uppercased()]
        flagImageView.image = assetName.flatMap { UIImage(named: $0) }
    }
}
