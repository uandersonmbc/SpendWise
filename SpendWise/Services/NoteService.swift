import Foundation

@MainActor
class NoteService: ObservableObject {
    @Published var notes: [Note]
    
    static let shared = NoteService()
    
    init(notes: [Note] = []) {
        self.notes = notes
    }
    
    func getData(){
        APIService().get(endpoint: "/notes") { (result: Result<[Note], Error>) in
            switch result {
            case .success(let response):
                self.notes = response
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func createNote(note: Note) async throws {
        print(note)
        self.notes.append(note)
    }
    
    func updateNote(id: String) {
//        if let index = notes.firstIndex(where: { $0.id == id }) {
//            //
//        }
    }
    
    func removeNote(offset: IndexSet) {
        self.notes.remove(atOffsets: offset)
    }
}
