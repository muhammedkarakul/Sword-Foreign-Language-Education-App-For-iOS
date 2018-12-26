//
//  FirebaseHelper.swift
//  Sword
//
//  Created by Muhammed Karakul on 7.12.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation
import Firebase

class FirebaseHelper {
    
    init() {
        
    }
    
    enum FirebaseCollectionTypes {
        case User
        case Word
        case Game
        case Topic
        case Level
        case Reward
        case Invite
        case Error
        case Feedback
    }
    
    // MARK: - Utilities
    public static func collection(withType type: FirebaseCollectionTypes) -> String {
        switch type {
        case .User:
            return "User"
        case .Error:
            return "Error"
        case .Feedback:
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
    public static func saveCollection(withName name: String?, withId id: String?, withData data: [String : Any]? , withCompletion completion: ((Error?) -> Void)? ) {
        if let collectionName = name, let collectionId = id, let collectionData = data {
            Firestore.firestore().collection(collectionName).document(collectionId).setData(collectionData, completion: completion)
        }
    }
    
    /**
     This method gets collection from firestore database with document name.
     
     - parameter documentName: The name of the document from the database.
     - parameter completion: Firestore completion block.
     */
    public static func getCollection(withName name: String?, withCompletion completion: @escaping FIRQuerySnapshotBlock) {
        if let collectionName = name {
            Firestore.firestore().collection(collectionName).getDocuments(completion: completion)
        }
    }
    
    /**
     This method gets document from firebase database by document's id.
     */
    public static func getDocument(byDocumentPath documentPath: String?, collectionName: String?, completion: @escaping FIRDocumentSnapshotBlock) {
        if let name = collectionName, let path = documentPath {
            Firestore.firestore().collection(name).document(path).getDocument(completion: completion)
        }
    }
}
