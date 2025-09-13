//
//  UISearchController+Combine.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/13/25.
//


import UIKit
import Combine

extension UISearchController {
    var searchTextPublisher: AnyPublisher<String, Never> {
        return NotificationCenter.default
            .publisher(
                for: UITextField.textDidChangeNotification,
                object: self.searchBar.searchTextField
            )
            .map { notification in
                let textField = notification.object as? UITextField
                return textField?.text
            }
            .replaceNil(with: "")
            .eraseToAnyPublisher()
    }
}
