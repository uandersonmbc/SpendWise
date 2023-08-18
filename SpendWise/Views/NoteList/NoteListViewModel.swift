import Foundation

class NoteListViewModel: ObservableObject {
    @Published var notes: [Note]
    
    init(notes: [Note] = []) {
        self.notes = [Note(id: UUID().uuidString, name: "Test", icon: "list.bullet", color: "#ed3212", notesItems: [
            NoteItem(id: UUID().uuidString, quantity: 5, item: Item(id: UUID().uuidString, name: "Creme de Leite", code: "", commercialEntities: []))
        ])]
    }
    
    func createNote() {
        self.notes.append(Note(id: UUID().uuidString, name: "Test", icon: "list.bullet", color: "#3e421d", notesItems: [
            NoteItem(id: UUID().uuidString, quantity: 3, item: Item(id: UUID().uuidString, name: "Creme de Leite", code: "", commercialEntities: [])),
            NoteItem(id: UUID().uuidString, quantity: 1, item: Item(id: UUID().uuidString, name: "Leite", code: "", commercialEntities: [])),
            NoteItem(id: UUID().uuidString, quantity: 5, item: Item(id: UUID().uuidString, name: "Mucirilho", code: "", commercialEntities: []))
        ]))
    }
    
    func updateNote() {
        
    }
    
    func removeNote() {
        
    }
}
