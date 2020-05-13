//
//  TagService.swift
//  DreamBook
//
//  Created by moesmoesie on 30/04/2020.
//  Copyright © 2020 moesmoesie. All rights reserved.
//

import Foundation
import CoreData
public class TagService{
    private let managedObjectContext : NSManagedObjectContext
    
    init(managedObjectContext : NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
}

extension TagService{
    func getTag(text: String) -> Tag?{
        let fetchRequest : NSFetchRequest<Tag> = Tag.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K = %@",
            argumentArray: [#keyPath(Tag.text), text]
        )
        
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count == 0{
                return nil
            }
            return results.first
        }catch{
            return nil
        }
    }
    
    func createTag(tagViewModel : TagViewModel) throws -> Tag{
        let tag = Tag(context: self.managedObjectContext)
        tag.text = tagViewModel.text
        self.managedObjectContext.insert(tag)
        
        do {
            try tag.validateForInsert()
            self.managedObjectContext.insert(tag)
            try self.managedObjectContext.save()
            return tag
        } catch let error as NSError{
            throw TagError.invalidSave(error: error.localizedDescription)
        }
    }
    
    func deleteDreamlessTags(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        fetchRequest.predicate = NSPredicate(
            format: "dream == nil"
        )
        do{
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try managedObjectContext.execute(batchDeleteRequest)
        }catch{
            print("error fetching tags to delete")
        }
    }
}

extension TagService {
    enum TagError : Error {
        case invalidUpdate(error : String)
        case invalidSave(error : String)
        case invalidDelete(error : String)
    }
}