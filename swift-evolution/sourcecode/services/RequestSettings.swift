import Foundation

enum Header: String {
    case accept = "Accept"
    case authorization = "Authorization"
    case contentType = "Content-Type"
}

enum MimeType: String {
    case applicationJSON = "application/json"
    case formUrlEncoded = "application/x-www-form-urlencoded"
    case textPlain = "text/plain"
}

struct RequestSettings: RequestProtocol {
    var url: String
    var method: ServiceMethod
    var params: [String: Any]?
    var headers: [Header: String]?
    
    init(_ url: String, method: ServiceMethod = .get, params: [String: Any]? = nil, headers: [Header: String]? = nil) {
        self.url = url
        self.method = method
        self.params = params
        self.headers = headers
    }
}
