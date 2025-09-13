//
//  UIView+Extensions.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/3/25.
//


import UIKit

extension UIView {
    func layoutToSafeArea(of view: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func toHorizontalSafeArea(_ parentView: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentView.topAnchor),
            leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
        ])
    }
    
    func toCenter(_ parentView: UIView) {
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
        ])
    }
}
