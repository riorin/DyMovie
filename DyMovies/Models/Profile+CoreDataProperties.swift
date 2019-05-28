//
//  Profile+CoreDataProperties.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 28/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var avatar: String?
    @NSManaged public var profileId: Int64
    @NSManaged public var iso_639_1: String?
    @NSManaged public var iso_3166_1: String?
    @NSManaged public var name: String?
    @NSManaged public var includeAdult: NSNumber?
    @NSManaged public var username: String?

}
