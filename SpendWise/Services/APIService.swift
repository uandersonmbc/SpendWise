import Foundation

struct APIService {
    static let shared = APIService()
    
    private func performRequest<T: Decodable>(url: URL, httpMethod: String, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let emptyDataError = NSError(domain: "com.spend.wise.Spend-Wise", code: 0, userInfo: nil)
                completion(.failure(emptyDataError))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func performRequestWithBody<T: Codable>(url: URL, httpMethod: String, body: Data, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let emptyDataError = NSError(domain: "com.spend.wise.Spend-Wise", code: 0, userInfo: nil)
                completion(.failure(emptyDataError))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func get<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        let endpointURL = baseURL.appendingPathComponent(endpoint)
        performRequest(url: endpointURL, httpMethod: "GET", completion: completion)
    }
    
    func post<T: Codable>(endpoint: String, body: Data, completion: @escaping (Result<T, Error>) -> Void) {
        let endpointURL = baseURL.appendingPathComponent(endpoint)
        performRequestWithBody(url: endpointURL, httpMethod: "POST", body: body, completion: completion)
    }
    
    func put<T: Codable>(endpoint: String, body: Data, completion: @escaping (Result<T, Error>) -> Void) {
        let endpointURL = baseURL.appendingPathComponent(endpoint)
        performRequestWithBody(url: endpointURL, httpMethod: "PUT", body: body, completion: completion)
    }
    
    func delete<T: Codable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        let endpointURL = baseURL.appendingPathComponent(endpoint)
        performRequest(url: endpointURL, httpMethod: "DELETE", completion: completion)
    }
}
