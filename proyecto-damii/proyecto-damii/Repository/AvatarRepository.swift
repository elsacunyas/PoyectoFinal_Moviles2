//
//  AvatarRepository.swift
//  proyecto-damii
//
//  Created by Elsa on 14/12/24.
//
import Foundation

struct AvatarRequest: Codable {
    let username: String
    let password: String
    let email: String
}

struct AvatarResponse: Codable {
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case image = "Image"
    }
}

class AvatarRepository {
    
    private let session: URLSession
    private let username = "elsapatricia"
    private let password = "123456"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getAvatar(email: String, completion: @escaping (Result<AvatarResponse, Error>) -> Void) {
        let url = URL(string: "https://avatarapi.com/v2/api.aspx")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var avatarRequest = AvatarRequest(username: username, password: password, email: email)
        let jsonData = try! JSONEncoder().encode(avatarRequest)
        request.httpBody = jsonData
        
        session.dataTask(with: request) { data, response, error in
            guard let data else {
                completion(.failure(error ?? URLError(.badURL)))
                return
            }
            do {
                let avatarResponse = try JSONDecoder().decode(AvatarResponse.self, from: data)
                completion(.success(avatarResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
