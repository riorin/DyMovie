//
//  Profile+CoreDataClass.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 28/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Profile)
public class Profile: NSManagedObject, Decodable {

    enum CodingKeys: String, CodingKey {
        case avatar
        case includeAdult = "include_adult"
        case iso_639_1
        case iso_3166_1
        case name
        case profileId = "id"
        case username
        
        enum Avatar: String, CodingKey {
            case gravatar
            
            enum Gravatar: String, CodingKey {
                case hash
            }
        }
    }
    
    public required convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Profile", in: context) else {
                fatalError("Failed to decode Profile")
        }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let avatarContainer = try container.nestedContainer(keyedBy: CodingKeys.Avatar.self, forKey: .avatar)
        let gravatarContainer = try avatarContainer.nestedContainer(keyedBy: CodingKeys.Avatar.Gravatar.self, forKey: .gravatar)
        
        avatar = try gravatarContainer.decodeIfPresent(String.self, forKey: .hash)
        includeAdult = NSNumber(value: try container.decodeIfPresent(Bool.self, forKey: .includeAdult) ?? false)
        iso_639_1 = try container.decodeIfPresent(String.self, forKey: .iso_639_1)
        iso_3166_1 = try container.decodeIfPresent(String.self, forKey: .iso_3166_1)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        profileId = (try container.decodeIfPresent(Int64.self, forKey: .profileId)) ?? 0
        username = try container.decodeIfPresent(String.self, forKey: .username)
        
    }
    
    class func currentProfile(in context: NSManagedObjectContext) -> Profile? {
        let request: NSFetchRequest<Profile> = Profile.fetchRequest()
        
        do {
            let profiles = try context.fetch(request)
            
            if profiles.count > 0 {
                return profiles[0]
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    var avatarUrl: URL? {
        
        if let avatar = avatar {
            return URL(string: "https://www.gravatar.com/avatar/\(avatar)?s=180")
        }
        else {
            return nil
        }
    }
}
