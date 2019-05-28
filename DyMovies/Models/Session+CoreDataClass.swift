//
//  Session+CoreDataClass.swift
//  DyMovies
//
//  Created by Bayu Yasaputro on 27/06/18.
//  Copyright © 2018 DyCode. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Session)
public class Session: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionId = "session_id"
    }
    
    public required convenience init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Session", in: context) else {
                fatalError("Failed to decode Session")
        }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = NSNumber(value: try container.decodeIfPresent(Bool.self, forKey: .success) ?? false)
        sessionId = try container.decodeIfPresent(String.self, forKey: .sessionId)
    }
    
    class func currentSession(in context: NSManagedObjectContext) -> Session? {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        
        do {
            let sessions = try context.fetch(request)
            
            if sessions.count > 0 {
                return sessions[0]
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
