//
//  ProfileEntity.swift
//  Tawk
//
//  Created by Tareq Bashuaib on 08/06/2023.
//

import Foundation

// MARK: - ProfileEntity
struct ProfileEntity: Codable, Equatable {
    var login: String?
    var id: Int?
    var note: String?
    var nodeID: String?
    var avatarURL: String?
    var gravatarID: String?
    var url, htmlURL, followersURL: String?
    var followingURL, gistsURL, starredURL: String?
    var subscriptionsURL, organizationsURL, reposURL: String?
    var eventsURL: String?
    var receivedEventsURL: String?
    var type: TypeEnum?
    var siteAdmin, hireable: Bool?
    var name, company: String?
    var blog: String?
    var location: String?
    var email, bio: String?
    var twitterUsername: String?
    var publicRepos, publicGists, followers, following: Int?
    var createdAt, updatedAt: String?

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
        case name, company, blog, location, email, hireable, bio
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers, following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(login: String, name: String) {
        self.login = login
        self.name = name
    }
    
    init(profile: ProfileMO) {
        self.login = profile.login
        self.id = Int(profile.id)
        self.nodeID = profile.nodeID
        self.avatarURL = profile.avatarURL
        self.gravatarID = profile.gravatarID
        self.url = profile.url
        self.htmlURL = profile.htmlURL
        self.followersURL = profile.followersURL
        self.followingURL = profile.followingURL
        self.gistsURL = profile.gistsURL
        self.starredURL = profile.starredURL
        self.subscriptionsURL = profile.subscriptionsURL
        self.organizationsURL = profile.organizationsURL
        self.reposURL = profile.reposURL
        self.eventsURL = profile.eventsURL
        self.receivedEventsURL = profile.receivedEventsURL
        self.type = TypeEnum(rawValue: profile.type ?? "User")
        self.siteAdmin = profile.siteAdmin
        self.note = profile.note
        self.hireable = profile.hireable
        self.name = profile.name
        self.company = profile.company
        self.blog = profile.blog
        self.location = profile.location
        self.email = profile.email
        self.bio = profile.bio
        self.twitterUsername = profile.twitterUsername
        self.publicRepos = Int(profile.publicRepos)
        self.publicGists = Int(profile.publicGists)
        self.followers = Int(profile.followers)
        self.following = Int(profile.following)
        self.createdAt = profile.createdAt
        self.updatedAt = profile.updatedAt
    }

}
