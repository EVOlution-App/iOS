import Foundation

enum NotificationsService {
  typealias AddSuccessClosure = (ServiceResult<Notifications.Device>) -> Swift.Void
  typealias UpdateTagsClosure = (ServiceResult<User>) -> Swift.Void
  typealias TrackingClosure = (ServiceResult<Response>) -> Swift.Void
  typealias ListTagsClosure = (ServiceResult<[Notifications.Tag]>) -> Swift.Void

  static var authorizationHeader: [Header: String] {
    let key = Environment.Keys.notification ?? ""
    return [.authorization: key, .contentType: MimeType.applicationJSON.rawValue]
  }

  // MARK: - Device

  @discardableResult
  static func add(_ device: Notifications.Device, completion: @escaping AddSuccessClosure) -> URLSessionDataTask? {
    guard var params = device.asDictionary() else {
      return nil
    }

    params["platform"] = "ios"
    let url = Config.Base.URL.Notifications.add
    let request = RequestSettings(
      url,
      method: .post,
      params: params,
      headers: NotificationsService.authorizationHeader
    )

    let task = Service.dispatch(request) { result in
      let value = result.flatMap { try JSONDecoder().decode(Notifications.Device.self, from: $0) }
      completion(value)
    }

    return task
  }

  // MARK: - User

  @discardableResult
  static func getDetails(from user: User, completion: @escaping UpdateTagsClosure) -> URLSessionDataTask? {
    let request = RequestSettings(
      Config.Base.URL.Notifications.user(identifier: user.identifier),
      method: .get,
      params: nil,
      headers: NotificationsService.authorizationHeader
    )

    let task = Service.dispatch(request, useLoadingMonitor: false) { result in
      let value: ServiceResult<User> = result.flatMap {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Config.Date.Formatter.custom("yyyy-MM-dd'T'HH:mm:ss.SSSZ"))

        return try decoder.decode(User.self, from: $0)
      }
      completion(value)
    }

    return task
  }

  // MARK: - Tags

  @discardableResult
  static func listTags(completion: @escaping ListTagsClosure) -> URLSessionDataTask? {
    let request = RequestSettings(
      Config.Base.URL.Notifications.tags,
      method: .get,
      params: nil,
      headers: NotificationsService.authorizationHeader
    )

    let task = Service.dispatch(request) { result in
      let value = result.flatMap { try JSONDecoder().decode([Notifications.Tag].self, from: $0) }
      completion(value)
    }

    return task
  }

  @discardableResult
  static func updateTags(to user: User, completion: @escaping UpdateTagsClosure) -> URLSessionDataTask? {
    guard let params = user.asDictionary() else {
      return nil
    }

    let url = Config.Base.URL.Notifications.user(
      identifier: user.identifier
    )
    let request = RequestSettings(
      url,
      method: .put,
      params: params,
      headers: NotificationsService.authorizationHeader
    )

    let task = Service.dispatch(request, useLoadingMonitor: false) { result in
      let value: ServiceResult<User> = result.flatMap {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Config.Date.Formatter.custom("yyyy-MM-dd'T'HH:mm:ss.SSSZ"))

        return try decoder.decode(User.self, from: $0)
      }
      completion(value)
    }

    return task
  }

  // MARK: - Tracking

  @discardableResult
  static func track(_ track: Notifications.Track, completion: TrackingClosure? = nil) -> URLSessionDataTask? {
    guard let params = track.asDictionary() else {
      return nil
    }

    let url = Config.Base.URL.Notifications.track
    let request = RequestSettings(
      url,
      method: .post,
      params: params,
      headers: NotificationsService.authorizationHeader
    )

    let task = Service.dispatch(request) { result in
      let value = result.flatMap { try JSONDecoder().decode(Response.self, from: $0) }
      completion?(value)
    }

    return task
  }
}
