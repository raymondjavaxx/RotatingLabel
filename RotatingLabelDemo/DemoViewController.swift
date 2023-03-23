//
//  DemoViewController.swift
//  RotatingLabelDemo
//
//  Created by Ramon Torres on 3/16/23.
//

import UIKit
import RotatingLabel

final class DemoViewController: UIViewController {

    private var value: Double = 1_300

    private lazy var rotatingLabel: RotatingLabel = {
        let label = RotatingLabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title1)
        label.value = formatter.string(for: value)
        return label
    }()

    private lazy var button: UIButton = {
        var configuration: UIButton.Configuration = .borderedProminent()
        configuration.buttonSize = .large

        let button = UIButton(configuration: configuration)
        button.setTitle("Update", for: [])
        button.addTarget(self, action: #selector(updateTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.directionalLayoutMargins = .init(top: 16, leading: 16, bottom: 16, trailing: 16)

        rotatingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rotatingLabel)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            rotatingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rotatingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            button.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    @objc
    func updateTapped(_ button: UIButton) {
        let delta = Double.random(in: -200...500)

        // Determine the direction.
        let direction: RotatingLabel.Direction = delta > 0 ? .increment : .decrement

        value += delta

        rotatingLabel.setValue(formatter.string(for: value), animated: true, direction: direction)
    }
}
