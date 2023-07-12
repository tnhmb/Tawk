//
//  CoreDataHelper.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation
import CoreData

class CoreDataHelper: NSObject {
    
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    private lazy var writeContext: NSManagedObjectContext = {
        return coreDataStack.writeContext
    }()
    
    private lazy var mainContext: NSManagedObjectContext = {
        return coreDataStack.mainContext
    }()
    
    func getUsers() -> [UserEntityElement]? {
        var users: [UserEntityElement]?
        
        let managedContext = mainContext
        
        let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            let userMOs = try managedContext.fetch(fetchRequest)
            users = userMOs.compactMap { UserEntityElement(user: $0) }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return users
    }
    
    func saveUsers(_ users: [UserEntityElement], completion: (() -> Void)?) {
        let writeContext = self.writeContext
        
        let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        
        do {
            let existingUsers = try writeContext.fetch(fetchRequest)
            
            for user in users {
                if let existingUser = existingUsers.first(where: { $0.id == user.id ?? 0 }) {
                    setValueForUser(existingUser, withProfile: user, managedContext: writeContext)
                } else {
                    let newUser = UserMO(context: writeContext)
                    setValueForUser(newUser, withProfile: user, managedContext: writeContext)
                }
            }
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        coreDataStack.saveWriteContext()
        completion?()
    }
    
    func getUser(withLogin login: String) -> UserMO? {
        let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        
        do {
            let existingUsers = try mainContext.fetch(fetchRequest)
            return existingUsers.first
        } catch let error as NSError {
            print("Could not fetch user. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    
    func saveUser(_ user: UserEntityElement) {
        let writeContext = self.writeContext
        
        let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        do {
            let data = try writeContext.fetch(fetchRequest)
            if data.isEmpty {
                let userMO = UserMO(context: writeContext)
                setValueForUser(userMO, withProfile: user, managedContext: writeContext)
            } else {
                let existingUser = data.first!
                setValueForUser(existingUser, withProfile: user, managedContext: writeContext)
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        coreDataStack.saveWriteContext()
        
    }
    
    func saveProfile(_ profile: ProfileEntity) {
        let writeContext = self.writeContext
        
        let profileMO = ProfileMO(context: writeContext)
        
        setValueForProfile(profileMO, withProfile: profile, managedContext: writeContext) 
        
        coreDataStack.saveWriteContext()
    }
    
    func getProfile(withLogin login: String) -> ProfileMO? {
        let fetchRequest: NSFetchRequest<ProfileMO> = ProfileMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        
        do {
            let existingUsers = try mainContext.fetch(fetchRequest)
            return existingUsers.first
        } catch let error as NSError {
            print("Could not fetch user. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    
    func updateUser(withLogin login: String, newData: UserEntityElement) {
        let writeContext = self.writeContext
        
        let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        
        do {
            let existingUsers = try writeContext.fetch(fetchRequest)
            
            if let existingUser = existingUsers.first {
                setValueForUser(existingUser, withProfile: newData, managedContext: writeContext)
            }
        } catch let error as NSError {
            print("Could not update user. \(error), \(error.userInfo)")
        }
        
        coreDataStack.saveWriteContext()
        
    }
    
    func updateProfile(withLogin login: String, newData: ProfileEntity) {
        let writeContext = self.writeContext
        
        let fetchRequest: NSFetchRequest<ProfileMO> = ProfileMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", login)
        
        
        do {
            let existingProfiles = try writeContext.fetch(fetchRequest)
            
            if let existingProfile = existingProfiles.first {
                setValueForProfile(existingProfile, withProfile: newData, managedContext: writeContext)
            }
        } catch let error as NSError {
            print("Could not update profile. \(error), \(error.userInfo)")
        }
        
        
    }
    
    
    
    private func setValueForUser(_ object: UserMO, withProfile user: UserEntityElement, managedContext: NSManagedObjectContext) {
        object.setValue(user.login, forKeyPath: "login")
        object.setValue(user.id, forKeyPath: "id")
        object.setValue(user.nodeID, forKeyPath: "nodeID")
        object.setValue(user.avatarURL, forKeyPath: "avatarURL")
        object.setValue(user.gravatarID, forKeyPath: "gravatarID")
        object.setValue(user.url, forKeyPath: "url")
        object.setValue(user.htmlURL, forKeyPath: "htmlURL")
        object.setValue(user.followersURL, forKeyPath: "followersURL")
        object.setValue(user.followingURL, forKeyPath: "followingURL")
        object.setValue(user.gistsURL, forKeyPath: "gistsURL")
        object.setValue(user.starredURL, forKeyPath: "starredURL")
        object.setValue(user.subscriptionsURL, forKeyPath: "subscriptionsURL")
        object.setValue(user.organizationsURL, forKeyPath: "organizationsURL")
        object.setValue(user.reposURL, forKeyPath: "reposURL")
        object.setValue(user.eventsURL, forKeyPath: "eventsURL")
        object.setValue(user.receivedEventsURL, forKeyPath: "receivedEventsURL")
        object.setValue(user.type?.rawValue, forKeyPath: "type")
        object.setValue(user.siteAdmin, forKeyPath: "siteAdmin")
    }
    
    private func setValueForProfile(_ object: ProfileMO, withProfile profile: ProfileEntity, managedContext: NSManagedObjectContext) {
        object.setValue(profile.login, forKeyPath: "login")
        object.setValue(profile.id, forKeyPath: "id")
        object.setValue(profile.note, forKeyPath: "note")
        object.setValue(profile.nodeID, forKeyPath: "nodeID")
        object.setValue(profile.avatarURL, forKeyPath: "avatarURL")
        object.setValue(profile.gravatarID, forKeyPath: "gravatarID")
        object.setValue(profile.url, forKeyPath: "url")
        object.setValue(profile.htmlURL, forKeyPath: "htmlURL")
        object.setValue(profile.followersURL, forKeyPath: "followersURL")
        object.setValue(profile.followingURL, forKeyPath: "followingURL")
        object.setValue(profile.gistsURL, forKeyPath: "gistsURL")
        object.setValue(profile.starredURL, forKeyPath: "starredURL")
        object.setValue(profile.subscriptionsURL, forKeyPath: "subscriptionsURL")
        object.setValue(profile.organizationsURL, forKeyPath: "organizationsURL")
        object.setValue(profile.reposURL, forKeyPath: "reposURL")
        object.setValue(profile.eventsURL, forKeyPath: "eventsURL")
        object.setValue(profile.receivedEventsURL, forKeyPath: "receivedEventsURL")
        object.setValue(profile.type?.rawValue, forKeyPath: "type")
        object.setValue(profile.siteAdmin, forKeyPath: "siteAdmin")
        object.setValue(profile.hireable, forKeyPath: "hireable")
        object.setValue(profile.name, forKeyPath: "name")
        object.setValue(profile.company, forKeyPath: "company")
        object.setValue(profile.blog, forKeyPath: "blog")
        object.setValue(profile.location, forKeyPath: "location")
        object.setValue(profile.email, forKeyPath: "email")
        object.setValue(profile.bio, forKeyPath: "bio")
        object.setValue(profile.twitterUsername, forKeyPath: "twitterUsername")
        object.setValue(profile.publicRepos, forKeyPath: "publicRepos")
        object.setValue(profile.publicGists, forKeyPath: "publicGists")
        object.setValue(profile.followers, forKeyPath: "followers")
        object.setValue(profile.following, forKeyPath: "following")
        object.setValue(profile.createdAt, forKeyPath: "createdAt")
        object.setValue(profile.updatedAt, forKeyPath: "updatedAt")
    }
    
}
