import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            TabView {
                noteList
                itemList
            }
        }
    }
    
    var noteList: some View {
        NavigationStack {
            ZStack{
                NoteListView()
            }
            .background(colorScheme == .dark ? .clear : Color("bg.gray6"))
        }
        .tabItem { Label("Notes", systemImage: "note") }
    }
    
    var itemList: some View {
        NavigationStack {
            ZStack{
                Text("Test")
            }
            .background(colorScheme == .dark ? .clear :  Color("bg.gray6"))
        }
        .tabItem { Label("Items", systemImage: "tag") }
    }
    
    
}

#Preview {
    HomeView()
}
