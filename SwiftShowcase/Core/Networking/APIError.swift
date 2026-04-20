import Foundation

enum APIError: Error, Equatable {
    case invalidURL
    case transport(URLError.Code)
    case badStatus(Int)
    case decoding
    case unknown

    var userMessage: String {
        switch self {
        case .invalidURL:
            "The request could not be created. Please try again."
        case .transport:
            "A network error occurred. Check your connection and try again."
        case .badStatus(let code):
            "The server returned an error (HTTP \(code)). Please try again later."
        case .decoding:
            "We couldn't read the server's response. Please try again later."
        case .unknown:
            "Something went wrong. Please try again."
        }
    }
}
