import SwiftUI

struct AboutAppView: View {
  private let version = Environment.Release.version
  private let build = Environment.Release.build
  
  @ScaledMetric
  private var scale = 1
  
  var body: some View {
    HStack(alignment: .center) {
      Spacer()
      
      VStack(alignment: .center) {
        Spacer()
        
        Image("logo-evolution-splash")
        
        Text(verbatim: "EVO App")
          .font(.helveticaThin(size: scale * 36))

        if let version, let build {
          Text(verbatim: "v\(version) (\(build))")
            .font(.helveticaLight(size: scale * 17))
        }
        
        Spacer()
      }
      
      Spacer()
    }
  }
}

#Preview("About App", traits: .fixedLayout(width: 500, height: 300)) {
  AboutAppView()
}
