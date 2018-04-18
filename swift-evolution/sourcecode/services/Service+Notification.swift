import Foundation

struct NotificationsService {
    typealias AddSuccessClosure = (ServiceResult<Notifications.Device>) -> Swift.Void
    typealias UpdateTagsClosure = (ServiceResult<User>) -> Swift.Void
    typealias TrackingClosure = (ServiceResult<Response>) -> Swift.Void
    
    static var authorizationHeader: [Header: String] {
        let key = Environment.Keys.notification ?? ""
        return [.authorization: key, .contentType: MimeType.applicationJSON.rawValue]
    }
    
    @discardableResult
    static func add(_ device: Notifications.Device, completion: @escaping AddSuccessClosure) -> URLSessionDataTask? {
        guard var params = device.asDictionary() else {
            return nil
        }
        
        params["platform"] = "ios"
        let url = Config.Base.URL.Notifications.add
        let request = RequestSettings(url,
                                      method: .post,
                                      params: params,
                                      headers: NotificationsService.authorizationHeader)
        
        let task = Service.dispatch(request) { result in
            let value = result.flatMap { try JSONDecoder().decode(Notifications.Device.self, from: $0) }
            completion(value)
        }
        
        return task
    }
    
    @discardableResult
    static func updateTags(to user: User, completion: @escaping UpdateTagsClosure) -> URLSessionDataTask? {
        guard let params = user.asDictionary() else {
            return nil
        }
        
        let url = Config.Base.URL.Notifications.user(id: user.id)
        let request = RequestSettings(url,
                                      method: .put,
                                      params: params,
                                      headers: NotificationsService.authorizationHeader)
        
        let task = Service.dispatch(request) { result in
            let value = result.flatMap { try JSONDecoder().decode(User.self, from: $0) }
            completion(value)
        }
        
        return task
    }
    
    @discardableResult
    static func track(_ track: Notifications.Track, completion: @escaping TrackingClosure) -> URLSessionDataTask? {
        guard let params = track.asDictionary() else {
            return nil
        }
        
        let url = Config.Base.URL.Notifications.track
        let request = RequestSettings(url,
                                      method: .post,
                                      params: params,
                                      headers: NotificationsService.authorizationHeader)
        
        let task = Service.dispatch(request) { result in
            let value = result.flatMap { try JSONDecoder().decode(Response.self, from: $0) }
            completion(value)
        }
        
        return task
    }
}
