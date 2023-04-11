//
//  File.swift
//  testGame
//
//  Created by Tyler Radke on 3/27/23.
//

import Foundation
import SpriteKit

enum SaveGameKeys: String {
    case exp = "exp"
    case level = "level"
}

class GameData: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var currentSaveFile: String? = nil
    var exp = 0 
    var level = 1
    //Formula used to calculate exp rewarded in game: level * (100 + level)
    
    internal static let sharedInstance = GameData()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init()
        self.exp = coder.decodeInteger(forKey: "exp")
        self.level = coder.decodeInteger(forKey: "level")
            }
    
    func encode(with coder: NSCoder) {
        coder.encode(exp, forKey: SaveGameKeys.exp.rawValue)
        coder.encode(level, forKey: SaveGameKeys.level.rawValue)
    }
    
    func resetData() {
        self.level = 1
        self.exp = 1
    }
    
    //MARK: Saving and Loading Data
    
    //loads an existing game
    func loadGame(saveFile: String) -> Bool {
        self.resetData()
        
        self.currentSaveFile = saveFile
        
        if let saveData = self.loadGameData(file: saveFile) {
            self.level = saveData.level
            self.exp = saveData.exp
            return true
        }
        
        return false
    }
    
    //actually loads file
    private func loadGameData(file: String) -> GameData? {
        
        let path = GameData.getFilePathName(name: file)
        print(path)
        if GameData.fileExistsAtPath(path: path, create: true) {
            if let rawData = NSData(contentsOfFile: path) {
                do {
                    //returns data as GameData instance. Might not work, look at later
                    if let data = try NSKeyedUnarchiver.unarchivedObject(ofClass: GameData.self, from: rawData as Data) {
                        return data
                    }
                } catch {
                    print("failed to get raw data")
                    return nil
                }
            }
        }
        return nil
    }
    
    func save() {
        guard let saveFile = self.currentSaveFile else { return }
        
        DispatchQueue.global(qos: .background).async {
            do {
                let saveData = try NSKeyedArchiver.archivedData(withRootObject: GameData.sharedInstance, requiringSecureCoding: true)
                let path = GameData.getFilePathName(name: saveFile)
                
                do {
                    let location = URL(filePath: path)
                    try saveData.write(to: location, options: .atomic)
                    print("saved successfully")
                } catch {
                    print("failed to save data")
                }
                
            } catch {
                print("Failed to fetch saveData")
            }
        }
    }
    
    //MARK: Files
    
    class func getFilePathName(name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        let fileName = "/GameData\(name)"
        let path = documentsDirectory + "\(fileName).plist"
        return path
    }
    
    class func fileExistsAtPath(path: String, create: Bool) -> Bool {
        let fileManager = FileManager.default
             if !fileManager.fileExists(atPath: path) {
                 // create an empty file if it doesn't exist and create is true
                 if(create) {
                     if let bundle = Bundle.main.path(forResource: "testGame", ofType: "plist") {
                         do {
                             try fileManager.copyItem(atPath: bundle, toPath: path)
                         } catch _ {
                             print("Unable to create base save file")
                         }
                     }
                     else {
                         print("Bundle not found")
                     }
                 }
                 return false
             }
             return true
    }
    
    class func deleteFileAtPath(_ path: String) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
        } catch _ {
            print("failed to delete file")
        }
    }
}
