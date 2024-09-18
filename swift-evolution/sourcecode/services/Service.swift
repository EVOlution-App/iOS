import UIKit

@available(*, deprecated, message: "Use NetworkLibrary instead")
protocol RequestProtocol {
  var url: String { get }
  var method: ServiceMethod { get }
  var headers: [Header: String]? { get }
  var params: [String: Any]? { get }
}

// MARK: - Service Result

@available(*, deprecated, message: "Use NetworkLibrary instead")
enum ServiceResult<T> {
  case failure(Error)
  case success(T)

  var value: T? {
    switch self {
    case let .success(value):
      value
    case .failure:
      nil
    }
  }

  var error: Error? {
    switch self {
    case .success:
      nil
    case let .failure(error):
      error
    }
  }

  func flatMap<U>(closure: (T) throws -> U?) -> ServiceResult<U> {
    switch self {
    case let .failure(error):
      return .failure(error)
    case let .success(value):
      do {
        if let newValue = try closure(value) {
          return .success(newValue)
        }
        else {
          return .failure(ServiceError.invalidResponse)
        }
      }
      catch {
        return .failure(error)
      }
    }
  }
}

// MARK: - Errors

@available(*, deprecated, message: "Use NetworkLibrary instead")
enum ServiceError: Error {
  case unknownState
  case invalidURL(String)
  case invalidResponse

  static func fail<T>(with error: ServiceError = .unknownState, _ closure: (ServiceResult<T>) -> Void) {
    assertionFailure("we should get an error or a data here")
    closure(.failure(error))
  }
}

// MARK: - Method

@available(*, deprecated, message: "Use NetworkLibrary instead")
enum ServiceMethod: String {
  case get
  case post
  case put
}

// MARK: -

@available(*, deprecated, message: "Use NetworkLibrary instead")
class Service {
  typealias JSONDictionary = [String: Any]

  @discardableResult
  static func requestList(_ url: String,
                          completion: @escaping (ServiceResult<[JSONDictionary]>) -> Void) -> URLSessionDataTask?
  {
    let request = RequestSettings(url)

    let task = dispatch(request) { result in
      let newResult = result.flatMap { data in
        try JSONSerialization.jsonObject(with: data, options: []) as? [JSONDictionary]
      }
      completion(newResult)
    }
    return task
  }

  @discardableResult
  static func requestKeyValue(_ url: String,
                              completion: @escaping (ServiceResult<JSONDictionary>) -> Void) -> URLSessionDataTask?
  {
    let request = RequestSettings(url)

    let task = dispatch(request) { result in
      let newResult = result.flatMap { data in
        try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
      }
      completion(newResult)
    }
    return task
  }

  @discardableResult
  static func requestText(_ url: String,
                          completion: @escaping (ServiceResult<String>) -> Void) -> URLSessionDataTask?
  {
    let request = RequestSettings(url, headers: [.contentType: MimeType.textPlain.rawValue])

    let task = dispatch(request) { result in
      let newResult = result.flatMap { String(data: $0, encoding: .utf8) }
      completion(newResult)
    }
    return task
  }

  @discardableResult
  static func requestImage(_ url: String,
                           completion: @escaping (ServiceResult<UIImage>) -> Void) -> URLSessionDownloadTask?
  {
    guard let URL = URL(string: url) else {
      completion(.failure(ServiceError.invalidURL(url)))
      return nil
    }

    let cache = URLCache.shared
    let request = URLRequest(url: URL)

    if let cachedResponse = cache.cachedResponse(for: request),
       let image = UIImage(data: cachedResponse.data)
    {
      completion(.success(image))
    }
    else {
      let session = URLSession(configuration: .default)
      let task = session.downloadTask(with: URL) { url, response, error in
        if let error {
          completion(.failure(error))
        }
        else if let validURL = url,
                let response,
                let data = try? Data(contentsOf: validURL),
                let image = UIImage(data: data)
        {
          let cachedData = CachedURLResponse(response: response, data: data)
          cache.storeCachedResponse(cachedData, for: request)
          completion(.success(image))
        }
        else {
          ServiceError.fail(completion)
        }
      }
      task.resume()
      return task
    }

    return nil
  }

  // MARK: - Base Request

  @discardableResult
  static func dispatch(
    _ settings: RequestProtocol,
    useLoadingMonitor: Bool = true,
    completion: @escaping (ServiceResult<Data>) -> Void
  ) -> URLSessionDataTask? {
    guard let baseURL = URL(string: settings.url) else {
      completion(.failure(ServiceError.invalidURL(settings.url)))
      return nil
    }

    var request = URLRequest(url: baseURL)
    request.httpMethod = settings.method.rawValue.uppercased()

    // Configure body based on method
    switch settings.method {
    case .post,
         .put:
      if let parameters = settings.params {
        do {
          let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
          request.httpBody = data
        }
        catch {
          print("[Request URL] Error: \(error.localizedDescription)")
        }
      }

    default:
      break
    }

    // Configure Headers
    if let headers = settings.headers {
      for arg in headers {
        request.addValue(arg.value, forHTTPHeaderField: arg.key.rawValue)
      }
    }

    let config = URLSessionConfiguration.default

    if useLoadingMonitor {
      config.protocolClasses = [LoadingMonitor.self]
    }

    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { data, _, error in
      if let error {
        completion(.failure(error))
      }
      else if let data {
        completion(.success(data))
      }
      else {
        ServiceError.fail(completion)
      }
    }
    task.resume()
    return task
  }
}
