//
//  PaddableLabel.swift
//  PexelsSearch
//
//  Created by Remy Park on 9/13/25.
//


import UIKit

final class PaddableLabel: UILabel {
    
    // MARK: Property(s)
    
    var textPadding = UIEdgeInsets(top: .zero, left: 8, bottom: .zero, right: .zero)
    
    private var paddingSize: CGSize {
        return CGSize(
            width: textPadding.left + textPadding.right,
            height: textPadding.top + textPadding.bottom
        )
    }
    
    // MARK: Override(s)
    
    override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        return CGSize(
            width: superSize.width + paddingSize.width,
            height: superSize.height + paddingSize.height
        )
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textPadding))
        
    }
}
