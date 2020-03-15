//
//  DatabaseServices.swift
//  FirebaseAuthLab
//
//  Created by Matthew Ramos on 3/14/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService {
  
  static let itemsCollection = "items" // collection
  static let usersCollection = "users"
  static let commentsCollection = "comments" // sub-collection on an item document
  static let favoritesCollection = "favorites" // sub-collection on a user docment
  

  
  private let db = Firestore.firestore()
  
  private init() {}
  static let shared = DatabaseService()

  public func createDatabaseUser(authDataResult: AuthDataResult,
                                 completion: @escaping (Result<Bool, Error>) -> ()) {
    guard let email = authDataResult.user.email else {
      return
    }
    db.collection(DatabaseService.usersCollection)
      .document(authDataResult.user.uid)
      .setData(["email" : email,
                "createdDate": Timestamp(date: Date()),
                "userId": authDataResult.user.uid]) { (error) in
      
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
  }
  
  func updateDatabaseUser(displayName: String,
                          photoURL: String,
                          completion: @escaping (Result<Bool, Error>) -> ()) {
    guard let user = Auth.auth().currentUser else { return }
    db.collection(DatabaseService.usersCollection)
      .document(user.uid).updateData(["photoURL" : photoURL,
                                      "displayName" : displayName]) { (error) in
            if let error = error {
              completion(.failure(error))
            } else {
              completion(.success(true))
      }
    }
  }
}
