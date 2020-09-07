//
//  Task+CoreDataProperties.swift
//  ToDoList
//
//  Created by Yura Geyts on 07.09.2020.
//  Copyright © 2020 Yura Geyts. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var isDone: Bool
    @NSManaged public var title: String?

}
