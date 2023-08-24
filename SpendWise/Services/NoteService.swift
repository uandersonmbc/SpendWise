import Foundation

@MainActor
class NoteService: ObservableObject {
    @Published var notes: [Note]
    @Published var noteItem: NoteItem?
    
    private let apiService = APIService()
    
    static let shared = NoteService()
    
    init(notes: [Note] = []) {
        self.notes = notes
    }
    
    func getData() {
        apiService.get(endpoint: "/notes") { (result: Result<[Note], Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.notes = response
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func updateNote(id: String) {
    }
    
    func removeNote(offset: IndexSet) {
    }
}
