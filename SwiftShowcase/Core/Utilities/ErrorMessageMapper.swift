//
//  ErrorMessageMapper.swift
//  SwiftShowcase
//
//  Created by Òscar Muntal on 22/4/26.
//

import Foundation

enum ErrorMessageMapper {
    static func message(from error: Error) -> String {
        if let apiError = error as? APIError {
            return apiError.userMessage
        }
        return "Something went wrong. Please try again."
    }
}
