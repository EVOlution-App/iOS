import Foundation

@available(*, deprecated, message: "Use NetworkLibrary instead")
enum Header: String {
  case accept = "Accept"
  case authorization = "Authorization"
  case contentType = "Content-Type"
}

@available(*, deprecated, message: "Use NetworkLibrary instead")
enum MimeType: String {
  case applicationJSON = "application/json"
  case formURLEncoded = "application/x-www-form-urlencoded"
  case textPlain = "text/plain"
}

@available(*, deprecated, message: "Use NetworkLibrary instead")
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
