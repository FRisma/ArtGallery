//
//  ErrorView.swift
//  
//
//  Created by Franco on 27/06/22.
//

import UIKit

public final class ErrorView: UIView {
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Retry", for: .normal)
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        return button
    }()
    
    public var retryHandler: (() -> Void)?
    
    public init(message: String, retryAction: (() -> Void)?) {
        retryHandler = retryAction
        super.init(frame: .zero)
        errorLabel.text = message
        backgroundColor = .white
        
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let containerStackView = makeContainerStackView()
        addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIEdgeInsets.contentInsets.left),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIEdgeInsets.contentInsets.right),
            
            retryButton.widthAnchor.constraint(equalToConstant: .retryButtonSize.width),
            retryButton.heightAnchor.constraint(equalToConstant: .retryButtonSize.height),
        ])
    }
    
    @objc private func didTapRetry() {
        retryHandler?()
    }
    
    private func makeContainerStackView() -> UIStackView {
        let containerStackView = UIStackView(arrangedSubviews: [errorLabel, retryButton])
        containerStackView.axis = .vertical
        containerStackView.spacing = .stackViewSpacing
        containerStackView.distribution = .fill
        containerStackView.alignment = .center
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.setCustomSpacing(.customSpacingForRetryButton, after: errorLabel)
        
        return containerStackView
    }
}

private extension CGFloat {
    static var retryButtonSize: CGSize = .init(width: 122, height: 40)
}

private extension CGFloat {
    static var stackViewSpacing: CGFloat = 14
    static var customSpacingForRetryButton: CGFloat = 24
}

private extension UIEdgeInsets {
    static var contentInsets: UIEdgeInsets {
        .init(top: 20, left: 20, bottom: 20, right: 20)
    }
}
