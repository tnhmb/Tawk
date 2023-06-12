//
//  UserEntity.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation

struct UserEntityElement: Codable, Equatable {
    var login: String?
    var id: Int?
    var nodeID: String?
    var avatarURL, note: String?
    var gravatarID: String?
    var url, htmlURL, followersURL: String?
    var followingURL, gistsURL, starredURL: String?
    var subscriptionsURL, organizationsURL, reposURL: String?
    var eventsURL: String?
    var receivedEventsURL: String?
    var type: TypeEnum?
    var siteAdmin: Bool?

    enum CodingKeys: String, CodingKey {
        case login, id, note
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
    
    func hasNote() -> Bool {
        guard let note = self.note else {
            return false
        }
        return !note.isEmpty
    }
    
    init(id: Int, login: String) {
        self.id = id
        self.login = login
    }
    
    init(user: UserMO) {
        self.login = user.login
        self.id = Int(user.id)
        self.nodeID = user.nodeID
        self.avatarURL = user.avatarURL
        self.gravatarID = user.gravatarID
        self.url = user.url
        self.htmlURL = user.htmlURL
        self.followersURL = user.followersURL
        self.followingURL = user.followingURL
        self.gistsURL = user.gistsURL
        self.starredURL = user.starredURL
        self.subscriptionsURL = user.subscriptionsURL
        self.organizationsURL = user.organizationsURL
        self.reposURL = user.reposURL
        self.eventsURL = user.eventsURL
        self.receivedEventsURL = user.receivedEventsURL
        self.type = TypeEnum(rawValue: user.type ?? "User")
        self.siteAdmin = user.siteAdmin
        self.note = user.note
        
    }
    
    init(login: String? = nil, id: Int? = nil, nodeID: String? = nil, avatarURL: String? = nil, note: String? = nil, gravatarID: String? = nil, url: String? = nil, htmlURL: String? = nil, followersURL: String? = nil, followingURL: String? = nil, gistsURL: String? = nil, starredURL: String? = nil, subscriptionsURL: String? = nil, organizationsURL: String? = nil, reposURL: String? = nil, eventsURL: String? = nil, receivedEventsURL: String? = nil, type: TypeEnum? = nil, siteAdmin: Bool? = nil) {
            self.login = login
            self.id = id
            self.nodeID = nodeID
            self.avatarURL = avatarURL
            self.note = note
            self.gravatarID = gravatarID
            self.url = url
            self.htmlURL = htmlURL
            self.followersURL = followersURL
            self.followingURL = followingURL
            self.gistsURL = gistsURL
            self.starredURL = starredURL
            self.subscriptionsURL = subscriptionsURL
            self.organizationsURL = organizationsURL
            self.reposURL = reposURL
            self.eventsURL = eventsURL
            self.receivedEventsURL = receivedEventsURL
            self.type = type
            self.siteAdmin = siteAdmin
        }
}
