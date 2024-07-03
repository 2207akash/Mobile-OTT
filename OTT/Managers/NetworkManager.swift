//
//  NetworkManager.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import Foundation

class NetworkManager {
    
    private static var shared: NetworkManager!
    private static let semaphore = DispatchSemaphore(value: 1)  // To handle case for multithreading
    
    
    // MARK: Private methods
    private init() { }
    
    // MARK: Public methods
    static func getInstance() -> NetworkManager {
        semaphore.wait()    // To avoid multiple threads to access critical section
        if shared == nil {
            shared = NetworkManager()
        }
        semaphore.signal()
        return shared
    }
    
}


extension NetworkManager {
    
    func fetchVideos(completion: @escaping (Result<[Video], Error>) -> Void) {
        guard let url = URL(string: Constants.ServerUrls.videosListUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let videos = try decoder.decode([Video].self, from: data)
                completion(.success(videos))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
