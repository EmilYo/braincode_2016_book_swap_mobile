//
//  BookViewModel.swift
//  Book Swap
//
//  Created by Kamil Powałowski on 18.03.2016.
//  Copyright © 2016 Book Swap Team. All rights reserved.
//

import Foundation
import Gloss

class BookViewModel {
    private let searchEndpoint = "/books/search/"
    private let offerEndpoint = "/books/offer/"
    private let wantEndpoint = "/books/want/"
    private let nearbyEndpoint = "/books/nearby"
    private let wantedEndpoint = "/books/wanted"
    private let offeredEndpoint = "/books/offered"
    private let barCodeEndpoint = "/books/search/barcode/"
    
    var books: [BookModel]?
    
    var selectedBook: BookModel?
    
    func searchBook(string: String, completion: (error: NSError?) -> Void) {
        NetworkHelper.request(.GET, endpoint: searchEndpoint + string.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!, parameters: nil) { (response) -> Void in
            if response.result.error != nil {
                completion(error: response.result.error)
            } else {
                if let json = response.result.value as? [JSON] {
                    self.books = [BookModel].fromJSONArray(json)
                    completion(error: nil)
                } else {
                    completion(error: ErrorHelper.error)
                }
            }
        }
    }
    
    func offerBook(completion: (error: NSError?) -> Void) {
        guard selectedBook != nil else {
            return completion(error: ErrorHelper.error)
        }
        
        NetworkHelper.authorizedRequest(.POST, endpoint: offerEndpoint + "\(selectedBook!.bookId!)", parameters: nil) { (response) -> Void in
            if response.result.error != nil {
                completion(error: response.result.error)
            } else {
                completion(error: nil)
            }
        }
    }
    
    func trashBook(completion: (error: NSError?) -> Void) {
        guard selectedBook != nil else {
            return completion(error: ErrorHelper.error)
        }
        
        NetworkHelper.authorizedRequest(.DELETE, endpoint: offerEndpoint + "\(selectedBook!.bookId!)", parameters: nil) { (response) -> Void in
            if response.result.error != nil {
                completion(error: response.result.error)
            } else {
                completion(error: nil)
            }
        }
    }
    
    func wantBook(completion: (error: NSError?) -> Void) {
        guard selectedBook != nil else {
            return completion(error: ErrorHelper.error)
        }
        
        NetworkHelper.authorizedRequest(.POST, endpoint: wantEndpoint + "\(selectedBook!.bookId!)", parameters: nil) { (response) -> Void in
            if response.result.error != nil {
                completion(error: response.result.error)
            } else {
                completion(error: nil)
            }
        }
    }
    
    func trashWantBook(completion: (error: NSError?) -> Void) {
        guard selectedBook != nil else {
            return completion(error: ErrorHelper.error)
        }
        
        NetworkHelper.authorizedRequest(.DELETE, endpoint: wantEndpoint + "\(selectedBook!.bookId!)", parameters: nil) { (response) -> Void in
            if response.result.error != nil {
                completion(error: response.result.error)
            } else {
                completion(error: nil)
            }
        }
    }
    
    func nearbyBooks(completion: (error: NSError?) -> Void) {
        NetworkHelper.authorizedRequest(.GET, endpoint: nearbyEndpoint, parameters: nil) { (response) -> Void in
            if response.result.error != nil {
                completion(error: response.result.error)
            } else {
                if let json = response.result.value as? [JSON] {
                    self.books = [BookModel].fromJSONArray(json)
                    completion(error: nil)
                } else {
                    completion(error: ErrorHelper.error)
                }
            }
        }
    }
    
    func wantedBooks(completion: (error: NSError?) -> Void) {
        NetworkHelper.authorizedRequest(.GET, endpoint: wantedEndpoint, parameters: nil) { (response) -> Void in
            if response.result.error != nil {
                completion(error: response.result.error)
            } else {
                if let json = response.result.value as? [JSON] {
                    self.books = [BookModel].fromJSONArray(json)
                    completion(error: nil)
                } else {
                    completion(error: ErrorHelper.error)
                }
            }
        }
    }
    
    func offeredBooks(completion: (error: NSError?) -> Void) {
        NetworkHelper.authorizedRequest(.GET, endpoint: offeredEndpoint, parameters: nil) { (response) -> Void in
            if response.result.error != nil {
                completion(error: response.result.error)
            } else {
                if let json = response.result.value as? [JSON] {
                    self.books = [BookModel].fromJSONArray(json)
                    completion(error: nil)
                } else {
                    completion(error: ErrorHelper.error)
                }
            }
        }
    }
    
    func searchBarCodeBook(barCode: String, completion: (error: NSError?) -> Void) {
        NetworkHelper.authorizedRequest(.GET, endpoint: barCodeEndpoint + barCode, parameters: nil) { (response) -> Void in
            if response.result.error != nil {
                completion(error: response.result.error)
            } else {
                if let json = response.result.value as? JSON {
                    self.selectedBook = BookModel(json: json)
                    completion(error: nil)
                } else {
                    completion(error: ErrorHelper.error)
                }
            }
        }
    }
    
}
