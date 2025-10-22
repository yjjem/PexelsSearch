//
//  UIView+BuilderConvenience.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/28/25.
//


import UIKit

extension UIView {
    @discardableResult
    func withChild(_ childView: UIView) -> Self {
        if let stackView = self as? UIStackView {
            stackView.addArrangedSubview(childView)
        } else {
            self.addSubview(childView)
        }
        return self
    }
    
    @discardableResult
    func withActivatingConstraintsSet(_ constraintsSet: Set<NSLayoutConstraint>) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        constraintsSet.forEach { $0.isActive = true }
        return self
    }
}
