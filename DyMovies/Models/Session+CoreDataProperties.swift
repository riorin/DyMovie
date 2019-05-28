//
//  Session+CoreDataProperties.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 27/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//
//

import Foundation
import CoreData

extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var success: NSNumber?
    @NSManaged public var sessionId: String?

}
