import Foundation

nonisolated enum APIError: Error, Equatable {
    case invalidURL
    case transport(URLError.Code)
    case badStatus(Int)
    case decoding
    case unknown

    var userMessage: String {
        switch self {
        case .invalidURL:
            "The request could not be created. Please try again."
        case .transport(let code):
            switch code {
            case .notConnectedToInternet:
                "You appear to be offline. Check your connection and try again."
            case .networkConnectionLost:
                "Your network connection was lost. Please try again."
            case .timedOut:
                "The request timed out. Please try again."
            case .cannotFindHost, .cannotConnectToHost:
                "The server could not be reached. Please try again later."
            default:
                "A network error occurred. Check your connection and try again."
            }
        case .badStatus(let code):
            "The server returned an error (HTTP \(code)). Please try again later."
        case .decoding:
            "We couldn't read the server's response. Please try again later."
        case .unknown:
            "Something went wrong. Please try again."
        }
    }
}
