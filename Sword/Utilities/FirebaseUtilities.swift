//
//  FirebaseUtilities.swift
//  Sword
//
//  Created by Muhammed Karakul on 28.10.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseUtilities {
    
    // MARK: - User
    
    /**
     Gets user data from firestore with id.
     - parameter completion: Firestore completion block.
     */
    public static func getUsers(completion: @escaping FIRQuerySnapshotBlock) {
        FirebaseHelper.getCollection(withName: FirebaseHelper.collection(withType: .User), withCompletion: completion)
    }
    
    public static func getUser(withId id: String?, completion: @escaping FIRQuerySnapshotBlock) {
        
    }
    
    /**
     Saves user data to firestore by id with user data.
     - parameter user: User information to be saved.
     - parameter completion: Firestore completion block.
     */
    public static func saveUser(user: User, completion: @escaping ((Error?) -> Void)) {
        FirebaseHelper.saveCollection(withName: FirebaseHelper.collection(withType: .User), withId: user.getId(), withData: user.getData(), withCompletion: completion)
    }
    
    // MARK: - Topic
    
    /**
     Gets topics data form firestore.
     - parameter completion: Firestore completion block.
     */
    public static func getTopics(completion: @escaping FIRQuerySnapshotBlock) {
        FirebaseHelper.getCollection(withName: FirebaseHelper.collection(withType: .Topic), withCompletion: completion)
    }
    
    // MARK: - Level
    
    /**
     Gets levels data form firestore.
     - parameter completion: Firestore completion block.
     */
    public static func getLevels(completion: @escaping FIRQuerySnapshotBlock) {
        FirebaseHelper.getCollection(withName: FirebaseHelper.collection(withType: .Level), withCompletion: completion)
    }
    
    // MARK: - Word
    
    /**
     Gets words data form firestore.
     - parameter completion: Firestore completion block.
     */
    public static func getWords(completion: @escaping FIRQuerySnapshotBlock) {
        FirebaseHelper.getCollection(withName: FirebaseHelper.collection(withType: .Word), withCompletion: completion)
    }
    
    /**
     Saves word data to firestore by id with word data.
     - parameter user: User information to be saved.
     - parameter completion: Firestore completion block.
     */
    public static func saveWord(word: Word, completion: @escaping ((Error?) -> Void)) {
        FirebaseHelper.saveCollection(withName: FirebaseHelper.collection(withType: .User), withId: word.getId(), withData: word.getData(), withCompletion: completion)
    }
    
    // MARK: - Game
    
    /**
     Gets games data form firestore.
     - parameter completion: Firestore completion block.
     */
    public static func getGames(completion: @escaping FIRQuerySnapshotBlock) {
        FirebaseHelper.getCollection(withName: FirebaseHelper.collection(withType: .Game), withCompletion: completion)
    }
    
    // MARK: - Error
    
    /**
     Gets errors data form firestore.
     - parameter completion: Firestore completion block.
     */
    public static func getErrors(completion: @escaping FIRQuerySnapshotBlock) {
        FirebaseHelper.getCollection(withName: FirebaseHelper.collection(withType: .Error), withCompletion: completion)
    }
    
    // MARK: - Feedback
    
    /**
     Gets feedbacks data form firestore.
     - parameter completion: Firestore completion block.
     */
    public static func getFeedbacks(completion: @escaping FIRQuerySnapshotBlock) {
        FirebaseHelper.getCollection(withName: FirebaseHelper.collection(withType: .Feedback), withCompletion: completion)
    }
    
    // MARK: - Invite
    
    /**
     Gets invites data form firestore.
     - parameter completion: Firestore completion block.
     */
    public static func getInvites(completion: @escaping FIRQuerySnapshotBlock) {
        FirebaseHelper.getCollection(withName: FirebaseHelper.collection(withType: .Invite), withCompletion: completion)
    }
    
    // MARK: - Reward
    
    /**
     Gets rewards data form firestore.
     - parameter completion: Firestore completion block.
     */
    public static func getRewards(completion: @escaping FIRQuerySnapshotBlock) {
        FirebaseHelper.getCollection(withName: FirebaseHelper.collection(withType: .Reward), withCompletion: completion)
    }
    
    // MARK: - Authentication -
    
    /**
      This method controls user sign in.
     */
    public static func signIn(withEmail email: String?, andPassword password: String?, completion: AuthDataResultCallback?) {
        if let email = email, let password = password {
            Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        }
    }
    
}
