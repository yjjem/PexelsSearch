//
//  FilterOptionViewModel.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/18/25.
//


import Foundation

final class SearchParameterViewModel: Identifiable {
    
    // MARK: Property(s)
    
    var isSelected: Bool
    let id: UUID = UUID()
    let value: String
    
    init(value: String, isSelected: Bool = false) {
        self.value = value
        self.isSelected = isSelected
    }
    
    // MARK: Function(s)
    
    func deselect() {
        self.isSelected = false
    }
    
    func select() {
        self.isSelected = true
    }
}
