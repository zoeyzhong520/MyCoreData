//
//  Person+CoreDataProperties.swift
//  MyCoreData
//
//  Created by JOE on 2017/6/28.
//  Copyright © 2017年 ZZJ. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: String?

}
