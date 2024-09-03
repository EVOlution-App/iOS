import SwiftUI

struct ListHeaderView: View {
    var count: Int
    
    init(with count: Int) {
        self.count = count
    }
    
    var body: some View {
        let plural = count != 1 ? "s" : ""
        let color = count > 0 ? UIColor(named: "SecBgColor") : UIColor(named: "BgColor")
        
        HStack(spacing: 10) {
            Text("\(count) proposal\(plural)")
            Spacer()
        }
        .padding(.all, 10)
        .background(Color(uiColor: color ?? .red))
    }
}

#Preview {
    ListHeaderView(with: 12)
}
