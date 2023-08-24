import SwiftUI

struct ItemRowCount: View {
    var item: ItemSearch
    @State private var quantity = 1
    var body: some View {
        VStack{
            HStack{
                
                Text("\(item.name)")
                    .lineLimit(1)
                
                Spacer()
                Button {
                    if quantity - 1 > 0 {
                        quantity -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                }
                Text("\(quantity)")
                Button {
                    quantity += 1
                } label: {
                    Image(systemName: "plus")
                }
            }
            .padding()
            .background(Color("bg.grid.sub"))
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ItemRowCount(item: ItemSearch(id: UUID().uuidString, name: "Creme de Leite", code: ""))
}
