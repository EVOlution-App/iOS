import Foundation

import ModelsLibrary

public enum Stubs {
  enum Error: Swift.Error {
    case notFound
    case invalidConversion
  }
  
  enum File: String {
    case proposals = "Proposals"
    case githubProfile = "GitHubProfile"
  }

  static func makeJSONDummy<T: Decodable>(_ type: T.Type = T.self, for file: File) -> T {
    do {
      let fileURL = FileLoader.url(for: file.rawValue, type: .json)
      let data = DataLoader.load(from: fileURL)
      
      let decoder = JSONDecoder()
      let object = try decoder.decode(type, from: data)
      
      return object
    }
    catch {
      fatalError("\(#function): \(error.localizedDescription)")
    }
  }
  
  private static func load(_ filename: String) -> String {
    let fileURL = FileLoader.url(for: filename, type: .markdown)
    let data = DataLoader.load(from: fileURL)
    
    guard let markdownString = String(data: data, encoding: .utf8) else {
      return ""
    }
    
    return markdownString
  }
  
  static var makeDummyForProposals: [Proposal] {
    let response: ProposalResponse = Stubs.makeJSONDummy(for: .proposals)
    
    return response.proposals
  }
  
  static var makeDummyForProposal: Proposal {
    makeDummyForProposals[12]
  }
  
  static var makeDummyForRandomProposal: Proposal {
    guard let proposal = makeDummyForProposals.randomElement() else {
      return Proposal(identifier: 0, link: "")
    }
    
    return proposal
  }
  
  static let makeDummyForProposalDetails = load("Proposal")

  static var makeDummyForGitHubProfile: GitHubProfile {
    Stubs.makeJSONDummy(for: .githubProfile)
  }
}
