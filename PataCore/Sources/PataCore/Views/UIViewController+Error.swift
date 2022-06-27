//
//  UIViewController+Error.swift
//  
//
//  Created by Franco on 27/06/22.
//

import UIKit

public extension UIViewController {
    func showErrorView(message: String, action: (() -> Void)?) {
        DispatchQueue.main.async {
            let errorView = ErrorView(message: message, retryAction: nil)
            errorView.translatesAutoresizingMaskIntoConstraints = false
            var errorParent: UIView = self.view
            if let scrollParent = self.view as? UIScrollView, let parentView = scrollParent.subviews.first {
                errorParent = parentView
            }
            
            errorParent.addSubview(errorView)
            
            NSLayoutConstraint.activate([
                errorView.topAnchor.constraint(equalTo: errorParent.topAnchor),
                errorView.leadingAnchor.constraint(equalTo: errorParent.leadingAnchor),
                errorView.trailingAnchor.constraint(equalTo: errorParent.trailingAnchor),
                errorView.bottomAnchor.constraint(equalTo: errorParent.bottomAnchor),
            ])
            
            errorView.retryHandler = { [weak self] in
                action?()
                self?.removeErrorView()
            }
        }
    }
    
    func removeErrorView() {
        for view in view.subviews {
            if view.isKind(of: ErrorView.self) {
                view.removeFromSuperview()
            }
        }
    }
}
