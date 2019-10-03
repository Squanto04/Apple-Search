//
//  SearchController.swift
//  Apple Search
//
//  Created by Jordan Lamb on 10/3/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

struct StringConstants {
    fileprivate static let baseURL = URL(string: "https://itunes.apple.com/")
    fileprivate static let searchComponent = "search"
    fileprivate static let termKey = "term"
    fileprivate static let entityKey = "entity"
    fileprivate static let entityMusicValue = "musicTrack"
    fileprivate static let entityAppVaue = "software"
}

class SearchController {
    
    static func getMusicItemsWith(searchText: String, completion: @escaping ([MusicSearchResult]) -> Void) {
        guard var unwrappedURL = StringConstants.baseURL else {completion([]); return }
        unwrappedURL.appendPathComponent(StringConstants.searchComponent)
        guard var components = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true)
            else {completion([]); return }
        let searchQuery = URLQueryItem(name: StringConstants.termKey, value: searchText)
        let entityQuery = URLQueryItem(name: StringConstants.entityKey, value: StringConstants.entityMusicValue)
        components.queryItems = [searchQuery, entityQuery]
        guard let musicFinalURL = components.url else { return }
        print(musicFinalURL)
        
        let dataTask = URLSession.shared.dataTask(with: musicFinalURL) { (data, _, error) in
            if let error = error {
                print("Error decoding the Data: \(error.localizedDescription)")
            }
            guard let data = data else {
                print("No Music data was received")
                completion([])
                return
            }
            do {
                let TopLevelDictionary = try JSONDecoder().decode(MusicTLD.self, from: data)
                completion(TopLevelDictionary.results)
            } catch {
                print("Error decoding data into our TopLevelDictionary Object: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    static func getAppItemsWith(searchText: String, completion: @escaping ([AppSearchResult]) -> Void) {
        guard var unwrappedURL = StringConstants.baseURL else {completion([]); return }
        unwrappedURL.appendPathComponent(StringConstants.searchComponent)
        guard var components = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true)
            else {completion([]); return }
        let searchQuery = URLQueryItem(name: StringConstants.termKey, value: searchText)
        let entityQuery = URLQueryItem(name: StringConstants.entityKey, value: StringConstants.entityAppVaue)
        components.queryItems = [searchQuery, entityQuery]
        guard let appFinalURL = components.url else { return }
        print(appFinalURL)
        
        let dataTask = URLSession.shared.dataTask(with: appFinalURL) { (data, _, error) in
            if let error = error {
                print("There was an error decoding app data: \(error.localizedDescription)")
            }
            guard let data = data else {
                completion([])
                print("No App Data was received.");
                return
            }
            do {
                let TopLevelDictionary = try JSONDecoder().decode(AppTLD.self, from: data)
                completion(TopLevelDictionary.results)
            } catch {
                print("Error decoding app data into our TopLevelDictionary Object: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
    static func getMusicImage(item: MusicSearchResult, completion: @escaping (UIImage?) -> Void) {
        guard let imageURLAsString = item.artworkUrl100,
            let url = URL(string: imageURLAsString)
            else {
                print("Item did not have an image available at url provided")
                completion(nil)
                return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let data = data else {
                print("Could not retrieve music image data")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
        dataTask.resume()
    }
    
    static func getAppImage(item: AppSearchResult, completion: @escaping (UIImage?) -> Void) {
        guard let imageURLAsString = item.artworkUrl100,
            let url = URL(string: imageURLAsString)
            else {
                print("Item did not have an image available at url provided")
                completion(nil)
                return
            }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let data = data else {
                print("Could not retrieve music image data")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
        dataTask.resume()
    }
    
    
}
