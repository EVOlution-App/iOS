import Foundation

struct GitHubService {
    
    typealias CompletionUserProfile = (ServiceResult<GitHubProfile>) -> Swift.Void
    
    @discardableResult
    static func profile(from username: String, completion: @escaping CompletionUserProfile) -> URLSessionDataTask? {
        let url = "\(Config.Base.URL.GitHub.users)/\(username)"
        let request = RequestSettings(url)
        
        let task = Service.dispatch(request) { result in
            let newResult = result.flatMap { try JSONDecoder().decode(GitHubProfile.self, from: $0) }
            completion(newResult)
        }
        return task
    }
}
