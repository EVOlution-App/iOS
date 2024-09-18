import ModelsLibrary

enum Constants {
  enum URL {
    private static let evolution = "https://data.evoapp.io"
    private static let gitHub = "https://github.com"
    private static let gitHubAPI = "https://api.github.com"
    
    static let proposals = evolution + "/proposals"
    
    static func details(for identifier: String) -> String {
      "\(evolution)/proposal/\(identifier)/markdown"
    }
    
    static func details(for proposal: Proposal) -> String? {
      guard let path = proposal.link else {
        return nil
      }
      
      return "https://raw.githubusercontent.com/apple/swift-evolution/main/proposals/\(path)"
    }
  
    static func githubProfile(for username: String) -> String {
      "\(gitHubAPI)/users/\(username)"
    }
    
    static func avatar(for username: String, size: Int? = nil) -> String {
      let url = "\(gitHub)/\(username).png"
      
      guard let size = size else {
        return url
      }
      
      return "\(url)?size=\(size)"
    }
  }
}
