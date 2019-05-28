//
//  Services.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 25/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//

import UIKit

class Services: NSObject {
    
    private let imageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
    
    class var shared: Services {
        struct Static {
            static let instance: Services = Services()
        }
        return Static.instance
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        
        if let image = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        }
        else {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async {
                    
                    if let data = data, let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        completion(image)
                    }
                    else {
                        completion(nil)
                    }
                }
            }.resume()
        }
    }
    
    func discoverMovies(year: Int, sortBy: MovieSortBy = .popularityDesc, page: Int = 1, completion: @escaping (Movies?, Error?) -> Void) {
        
        var urlString = "\(kBaseUrl)\(kMovieDiscoverPathUrl)"
        let parameters: [String: Any] = [
            "api_key": kTmdbApiKeyV3,
            "region": Locale.current.regionCode ?? "ID",
            "year": year,
            "sort_by": sortBy.rawValue,
            "page": page
        ]
        
        urlString = urlString + "?" + parameters.map({ "\($0)=\($1)" }).joined(separator: "&")
        
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    completion(nil, error)
                }
                else {
                    
                    if let data = data, let response = response as? HTTPURLResponse {
                        guard 200...299 ~= response.statusCode else {
                            
                            do {
                                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.errorMessage])
                                completion(nil, error)
                            }
                            catch {
                                completion(nil, error)
                            }
                            return
                        }
                        
                        do {
                            let movies = try JSONDecoder().decode(Movies.self, from: data)
                            completion(movies, nil)
                        }
                        catch {
                            completion(nil, error)
                        }
                    }
                    else {
                        completion(nil, nil)
                    }
                }
            }}
            .resume()
    }
    
    func createRequestToken(completion: @escaping (RequestToken?, Error?) -> Void) {
        
        let urlString = "\(kBaseUrl)\(kCreateRequestTokenPathUrl)?api_key=\(kTmdbApiKeyV3)"
        
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    completion(nil, error)
                }
                else {
                    
                    if let data = data, let response = response as? HTTPURLResponse {
                        guard 200...299 ~= response.statusCode else {
                            
                            do {
                                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.errorMessage])
                                completion(nil, error)
                            }
                            catch {
                                completion(nil, error)
                            }
                            return
                        }
                        
                        do {
                            let requestToken = try JSONDecoder().decode(RequestToken.self, from: data)
                            completion(requestToken, nil)
                        }
                        catch {
                            completion(nil, error)
                        }
                    }
                    else {
                        completion(nil, nil)
                    }
                }
            }}
            .resume()
    }
    
    func createSession(requestToken: String, completion: @escaping (Session?, Error?) -> Void) {
        
        let urlString = "\(kBaseUrl)\(kCreateSessionPathUrl)?api_key=\(kTmdbApiKeyV3)&request_token=\(requestToken)"
        
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    completion(nil, error)
                }
                else {
                    
                    if let data = data, let response = response as? HTTPURLResponse {
                        guard 200...299 ~= response.statusCode else {
                            
                            do {
                                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.errorMessage])
                                completion(nil, error)
                            }
                            catch {
                                completion(nil, error)
                            }
                            return
                        }
                        
                        do {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = appDelegate.persistentContainer.viewContext
                            
                            let decoder = JSONDecoder()
                            decoder.userInfo[.managedObjectContext] = context
                            
                            let session = try decoder.decode(Session.self, from: data)
                            completion(session, nil)
                        }
                        catch {
                            completion(nil, error)
                        }
                    }
                    else {
                        completion(nil, nil)
                    }
                }
            }}
            .resume()
    }
    
    func accountDetail(sessionId: String, completion: @escaping (Profile?, Error?) -> Void)  {
        
        let urlString = "\(kBaseUrl)\(kAccountDetailPathUrl)?api_key=\(kTmdbApiKeyV3)&session_id=\(sessionId)"
        
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    completion(nil, error)
                }
                else {
                    
                    if let data = data, let response = response as? HTTPURLResponse {
                        guard 200...299 ~= response.statusCode else {
                            
                            do {
                                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.errorMessage])
                                completion(nil, error)
                            }
                            catch {
                                completion(nil, error)
                            }
                            return
                        }
                        
                        do {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = appDelegate.persistentContainer.viewContext
                            
                            let decoder = JSONDecoder()
                            decoder.userInfo[.managedObjectContext] = context
                            
                            let profile = try decoder.decode(Profile.self, from: data)
                            completion(profile, nil)
                        }
                        catch {
                            completion(nil, error)
                        }
                    }
                    else {
                        completion(nil, nil)
                    }
                }
            }}
            .resume()
    }
    
    func favoritedMovies(profileId: Int64, sessionId: String, page: Int = 1, completion: @escaping (Movies?, Error?) -> Void)  {
        
        let pathUrl = String(format: kFavoritedMoviesPathUrl, profileId)
        var urlString = "\(kBaseUrl)\(pathUrl)"
        
        let parameters: [String: Any] = [
            "api_key": kTmdbApiKeyV3,
            "session_id": sessionId,
            "sort_by": "created_at.desc",
            "page": page
        ]
        
        urlString = urlString + "?" + parameters.map({ "\($0)=\($1)" }).joined(separator: "&")
        
        let request = URLRequest(url: URL(string: urlString)!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                if error != nil {
                    completion(nil, error)
                }
                else {
                    
                    if let data = data, let response = response as? HTTPURLResponse {
                        guard 200...299 ~= response.statusCode else {
                            
                            do {
                                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.errorMessage])
                                completion(nil, error)
                            }
                            catch {
                                completion(nil, error)
                            }
                            return
                        }
                        
                        do {
                            let movies = try JSONDecoder().decode(Movies.self, from: data)
                            completion(movies, nil)
                        }
                        catch {
                            completion(nil, error)
                        }
                    }
                    else {
                        completion(nil, nil)
                    }
                }
            }}
            .resume()
    }
}



