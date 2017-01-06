//
//  FolderLoader.swift
//  iSub
//
//  Created by Benjamin Baron on 1/4/17.
//  Copyright © 2017 Ben Baron. All rights reserved.
//

import Foundation

class FolderLoader: ISMSLoader, ItemLoader {
    let folderId: Int
    let mediaFolderId: Int
    
    var folders = [ISMSFolder]()
    var songs = [ISMSSong]()
    var songsDuration = 0.0
    
    var items: [ISMSItem] {
        return folders as [ISMSItem] + songs as [ISMSItem]
    }
    
    init(folderId: Int, mediaFolderId: Int) {
        self.folderId = folderId
        self.mediaFolderId = mediaFolderId
        super.init()
    }
    
    override func createRequest() -> URLRequest? {
        let parameters = ["id": "\(folderId)"]
        return NSMutableURLRequest(susAction: "getMusicDirectory", parameters: parameters) as URLRequest
    }
    
    override func processResponse() {
        guard let root = RXMLElement(fromXMLData: self.receivedData), root.isValid else {
            let error = NSError(ismsCode: ISMSErrorCode_NotXML)
            self.informDelegateLoadingFailed(error)
            return
        }
        
        if let error = root.child("error"), error.isValid {
            let code = error.attribute("code") ?? "-1"
            let message = error.attribute("message")
            self.subsonicErrorCode(Int(code) ?? -1, message: message)
        } else {
            var songsDurationTemp = 0.0
            var foldersTemp = [ISMSFolder]()
            var songsTemp = [ISMSSong]()
            
            let serverId = SavedSettings.sharedInstance().currentServerId
            root.iterate("directory.child") { child in
                if (child.attribute("isDir") as NSString).boolValue {
                    if child.attribute("title") != ".AppleDouble" {
                        let aFolder = ISMSFolder(rxmlElement: child, serverId: serverId, mediaFolderId: self.mediaFolderId)
                        foldersTemp.append(aFolder)
                    }
                } else {
                    let aSong = ISMSSong(rxmlElement: child, serverId: serverId)
                    if let duration = aSong.duration as? Double {
                        songsDurationTemp += duration
                    }
                    songsTemp.append(aSong)
                }
            }
            folders = foldersTemp
            songs = songsTemp
            songsDuration = songsDurationTemp
            
            self.persistModels()
            
            self.informDelegateLoadingFinished()
        }
    }
    
    func persistModels() {
        folders.forEach({$0.replace()})
        songs.forEach({$0.replace()})
    }
    
    func loadModelsFromCache() -> Bool {
        if let folder = associatedObject as? ISMSFolder {
            folder.reloadSubmodels()
            folders = folder.folders
            songs = folder.songs
            songsDuration = songs.reduce(0.0) { totalDuration, song -> Double in
                if let duration = song.duration as? Double {
                    return totalDuration + duration
                }
                return totalDuration
            }
            return items.count > 0
        }
        return false
    }
    
    var associatedObject: Any? {
        return ISMSFolder(folderId: folderId, serverId: SavedSettings.sharedInstance().currentServerId, loadSubmodels: false)
    }
}