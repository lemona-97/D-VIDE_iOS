//
//  StreamError.swift
//  DIVIDE
//
//  Created by wooseob on 2023/08/10.
//

import Foundation

enum StreamError: Error {
    case firestoreError(Error?)
    case decodedError(Error?)
}
