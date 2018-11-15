//
//  FirebaseUtilities.swift
//  Sword
//
//  Created by Muhammed Karakul on 28.10.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirebaseUtilities {
    
    enum FirebaseCollectionTypes {
        case User
        case Word
        case Game
        case Topic
        case Level
        case Reward
        case Invite
        case Error
        case feedback
    }
    
    /**
     Gets user data from firebase firestore database by id.
     - parameter id: ID of the user to be retrieved.
     */
    static public func getUserFromFirebase(withDocumentId id: String?) -> User {
        
        var tempUser = User()
        
        Firestore.firestore().collection("Users").getDocuments { (snapshot, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            } else {
                    if let users = snapshot?.documents {
                        
                        for user in users {
                            
                            var date = Date()
                            let timestampOptional = user.get("createdDay") as? Timestamp
                            if let timestamp = timestampOptional {
                                date = timestamp.dateValue()
                            }
                            
                            if user.documentID == id {
                                tempUser = User(
                                    id: user.documentID,
                                    name: user.data()["name"] as? String,
                                    email: user.data()["email"] as? String,
                                    diamond: user.data()["diamond"] as? Int,
                                    createdDate: date,
                                    hearth: user.data()["hearth"] as? Int,
                                    profilePhotoURL: user.data()["profilePhotoURL"] as? String,
                                    score: user.data()["score"] as? Int
//                                    level: user.data()["level"] as? String,
//                                    topics: user.data()["topics"] as? [String]
                                )
                            }
                        }
                    }
                }
        }
        
        return tempUser
    }
    
    public func getUser(withId id: String?, completion: @escaping FIRQuerySnapshotBlock) {
        getCollection(withName: collection(withType: .User), withCompletion: completion)
    }
    
    public func saveUser(user: User, completion: @escaping ((Error?) -> Void)) {
        saveCollection(withName: collection(withType: .User), withId: user.getId(), withData: user.getData(), withCompletion: completion)
    }
    
    private func collection(withType type: FirebaseCollectionTypes) -> String {
        switch type {
        case .User:
            return "User"
        case .Error:
            return "Error"
        case .feedback:
            return "feedback"
        case .Game:
            return "Game"
        case .Invite:
            return "Invite"
        case .Level:
            return "Level"
        case .Reward:
            return "Reward"
        case .Topic:
            return "Topic"
        case .Word:
            return "Word"
        }
    }
    
    /**
     This method saves user data to Firebase Firestore Database.
     
     - parameter user: The user to be registered to the database.
     - parameter completion: Firestore completion block.
     */
    private func saveCollection(withName name: String?, withId id: String?, withData data: [String : Any]? , withCompletion completion: ((Error?) -> Void)? ) {
        if let collectionName = name, let collectionId = id, let collectionData = data {
            Firestore.firestore().collection(collectionName).document(collectionId).setData(collectionData, completion: completion)
        }
    }
    
    /**
      This method get document from firestore database with document name.
     
     - parameter documentName: The name of the document from the database.
     - parameter completion: Firestore completion block.
     */
    private func getCollection(withName name: String?, withCompletion completion: @escaping FIRQuerySnapshotBlock) {
        if let collectionName = name {
            Firestore.firestore().collection(collectionName).getDocuments(completion: completion)
        }
    }
    
}
