//
//  Error+Combine.swift
//  PexelsSearch
//
//  Created by Remy Park on 8/25/25.
//

import Combine

extension Error {
    func toFailurePublisher<Output>() -> Fail<Output, Self> {
        return Fail(error: self)
    }
}
