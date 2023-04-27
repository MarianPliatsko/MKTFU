//
//  NetworkingError.swift
//  MKTFU
//
//  Created by mac on 2023-04-26.
//

import Foundation

enum NetworkingError: Error {
    case invalidUrl
    case invalidData
    case urlIsMissing
    case notFound
    case badResponse
    case unknown
}
