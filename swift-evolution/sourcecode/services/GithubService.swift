import Foundation

struct GithubService {
    
    typealias CompletionUserProfile = (ServiceResult<GithubProfile>) -> Swift.Void
    
    @discardableResult
    static func profile(from username: String, completion: @escaping CompletionUserProfile) -> URLSessionDataTask? {
        let url = "\(Config.Base.URL.githubUser)/\(username)"
        let task = Service.request(url: url) { result in
            let newResult = result.flatMap { try JSONDecoder().decode(GithubProfile.self, from: $0) }
            completion(newResult)
        }
        return task
    }
}
