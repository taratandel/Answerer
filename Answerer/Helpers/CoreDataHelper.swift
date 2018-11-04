//
//  CoreDataHelper.swift
//  Answerer
//
//  Created by Tara Tandel on 7/29/1397 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    func fetchUserFromCoreDate() -> Teacher?{
        var useDatas = [NSManagedObject]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //fetching Datas
        
        let fechtRequest  = NSFetchRequest<NSManagedObject>(entityName: "Teacher")
        
        //check if data exists or not
        do {
            //if exists fill the array
            useDatas = try managedContext.fetch(fechtRequest)
            let useInfo = Teacher()
            if useDatas.count > 0 {
                useInfo.email = useDatas[0].value(forKey: "email") as? String ?? ""
                useInfo.password = useDatas[0].value(forKey: "password") as? String ?? ""
                useInfo.phone = useDatas[0].value(forKey: "phone") as? String ?? ""
                useInfo.userName = useDatas[0].value(forKey: "userName") as? String ?? ""
                
                return useInfo
            }
            else {
                return nil
            }
        }
        catch let error as NSError {
            //if not shows the error
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
        
        
    }
    func saveUserToCoreData(info : Teacher) -> Bool{
        var useDatas = [NSManagedObject]()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName:"Teacher",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        
        person.setValue(info.email , forKeyPath: "email")
        person.setValue(info.userName, forKey: "userName")
        person.setValue(info.phone, forKey: "phone")
        person.setValue(info.password, forKey: "password")
        
        // 4
        do {
            try managedContext.save()
            useDatas.append(person)
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
    }
//    func saveChatToTheCoreData(newInfo : Informations , pastInfo : Informations) -> Bool {
//        self.deleteCoreData()
//        var useDatas = [NSManagedObject]()
//        guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//                return false
//        }
//        let managedContext =
//            appDelegate.persistentContainer.viewContext
//
//        // 2
//        let entity =
//            NSEntityDescription.entity(forEntityName:"UsersInfo",
//                                       in: managedContext)!
//
//        let person = NSManagedObject(entity: entity,
//                                     insertInto: managedContext)
//        person.setValue(pastInfo.activated , forKeyPath: "activated")
//        person.setValue(pastInfo.cityName, forKey: "cityName")
//        person.setValue(pastInfo.counter, forKey: "counter")
//        person.setValue(pastInfo.groupCode, forKey: "groupCode")
//        person.setValue(pastInfo.id, forKey: "id")
//        person.setValue(pastInfo.isBoorsieh, forKey: "isBoorsieh")
//        person.setValue(pastInfo.lastNmae, forKey: "lastName")
//        person.setValue(pastInfo.mobile, forKey: "mobile")
//        person.setValue(pastInfo.name, forKey: "name")
//        person.setValue(pastInfo.stateName, forKey: "stateName")
//        person.setValue(pastInfo.totalYearStudent, forKey: "totalYearStudent")
//        person.setValue(newInfo.sahmie, forKey: "sahmie")
//        person.setValue(newInfo.kanoonYear, forKey: "kanoonYear")
//        person.setValue(newInfo.totalRank, forKey: "totalRank")
//        person.setValue(newInfo.areaRank, forKey: "areaRank")
//
//
//
//
//
//        // 4
//        do {
//            try managedContext.save()
//            useDatas.append(person)
//            return true
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//            return false
//        }
//
//    }
    
    func deleteCoreData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //fetching Datas
        
        let fechtRequest  = NSFetchRequest<NSManagedObject>(entityName: "UsersInfo")
        
        //check if data exists or not
        do {
            //if exists fill the array
            let nationalCode = try managedContext.fetch(fechtRequest)
            for managedObject in nationalCode
            {
                let managedObjectData:NSManagedObject = managedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in IsLoggedIn error : \(error) \(error.userInfo)")
        }
    }
}

