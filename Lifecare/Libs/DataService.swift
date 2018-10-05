//
//  DataService.swift
//  Lifecare
//
//  Created by cagri calis on 6.08.2018.
//  Copyright © 2018 Cagri Mehmet Calis. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()


class DataService {
    
    static let ds = DataService()
    
    // DB references
    fileprivate var _REF_BASE = DB_BASE
    //private var _REF_POSTS = DB_BASE.child("posts")
    fileprivate var _REF_USERS = DB_BASE.child("users")
//    fileprivate var _REF_INVITE = DB_BASE.child("invitationCodes")
//    fileprivate var _REF_LOCKS = DB_BASE.child("locks")
//    fileprivate var _REF_LOGS = DB_BASE.child("logs")
//    fileprivate var _REF_FURNITURE = DB_BASE.child("furniture")
    
//    var REF_FURNITURE: DatabaseReference {
//
//        return _REF_FURNITURE
//
//    }
//
//
//    var REF_LOGS: DatabaseReference {
//        return _REF_LOGS
//    }
//
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
//
//    var REF_LOCKS: DatabaseReference {
//        return _REF_LOCKS
//    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: "uid")
        let user = REF_USERS.child(uid!)
        return user
    }
    
//    var REF_INVITE:DatabaseReference {
//        return _REF_INVITE
//    }
    
    
    func createFirebaseDBUser(_ uid: String, userData: Dictionary<String, Any>) {
        
        REF_USERS.child(uid).updateChildValues(userData)
        print("CAGRI: \(userData)")
    }
    
    func createFirebaseDBWithSubData(_ uid:String, child: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).child(child).updateChildValues(userData)
    }
    
    func createUserInfoInDB(_ uid:String, signUpData: Dictionary<String, Any>) {
        
        REF_USERS.child(uid).updateChildValues(signUpData)
    }
    
    func setLockUnlockInfo(_ uid:String, lockData:Dictionary<String,Any>) {
        REF_USERS.child(uid).updateChildValues(lockData)
    }
    
    
}
