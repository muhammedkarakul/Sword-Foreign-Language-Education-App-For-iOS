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
    
    /**
     
     */
    static public func getUserFromFirebase(withDocumentId id: String?) -> User {
        
        var db = Firestore.firestore()
        
        var user = User()
        
        db.document("Users").getDocument { (snapshot, error) in
            if let error = error {
                
            } else {
                
            }
        }
        
        return user
    }
}
