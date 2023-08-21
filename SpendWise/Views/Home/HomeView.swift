import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
//            TabView {
                NoteListView()
                    .tabItem { Label("Notes", systemImage: "list.bullet.clipboard") }
//                DailyDealsView()
//                    .tabItem { Label("Daily Deals", systemImage: "tag") }
//                CommercialView()
//                    .tabItem { Label("Commercial", systemImage: "storefront") }
//            }
//            .background(colorScheme == .dark ? .clear : Color("bg.gray6"))
        }
    }
}

#Preview {
    HomeView()
}
