//
//  PlaylistLoader.swift
//  iSub
//
//  Created by Benjamin Baron on 1/16/17.
//  Copyright © 2017 Ben Baron. All rights reserved.
//

import Foundation

class PlaylistLoader: ApiLoader, ItemLoader {
    let playlistId: Int64
    
    var songs = [Song]()
    
    var items: [Item] {
        return songs
    }
    
    init(playlistId: Int64) {
        self.playlistId = playlistId
        super.init()
    }
    
    override func createRequest() -> URLRequest {
        return URLRequest(subsonicAction: .getPlaylist, parameters: ["id": playlistId])
    }
    
    override func processResponse(root: RXMLElement) -> Bool {
        var songsTemp = [Song]()
        
        let serverId = SavedSettings.si.currentServerId
        root.iterate("playlist.entry") { song in
            if let aSong = Song(rxmlElement: song, serverId: serverId) {
                songsTemp.append(aSong)
            }
        }
        songs = songsTemp
        
        persistModels()
        
        return true
    }
    
    func persistModels() {
        // Save the new songs
        songs.forEach({_ = $0.replace()})
        
        // Update the playlist table
        // TODO: This will need to be rewritten to handle two way syncing
        if var playlist = associatedObject as? Playlist {
            playlist.overwriteSubItems()
        }
        
        // Make sure all artist and album records are created if needed
        var folderIds = Set<Int64>()
        var artistIds = Set<Int64>()
        var albumIds = Set<Int64>()
        for song in songs {
            func performOperation(folderId: Int64, mediaFolderId: Int64) {
                if !folderIds.contains(folderId) {
                    folderIds.insert(folderId)
                    let loader = FolderLoader(folderId: folderId, mediaFolderId: mediaFolderId)
                    let operation = ItemLoaderOperation(loader: loader)
                    ApiLoader.backgroundLoadingQueue.addOperation(operation)
                }
            }
            
            if let folder = song.folder, let mediaFolderId = folder.mediaFolderId, !folder.isPersisted {
                performOperation(folderId: folder.folderId, mediaFolderId: mediaFolderId)
            } else if song.folder == nil, let folderId = song.folderId, let mediaFolderId = song.mediaFolderId {
                performOperation(folderId: folderId, mediaFolderId: mediaFolderId)
            }
            
            if let artist = song.artist, !artist.isPersisted {
                artistIds.insert(artist.artistId)
            } else if song.artist == nil, let artistId = song.artistId {
                artistIds.insert(artistId)
            }
            
            if let album = song.album, !album.isPersisted {
                albumIds.insert(album.albumId)
            } else if song.album == nil, let albumId = song.albumId {
                albumIds.insert(albumId)
            }
        }
        
        for artistId in artistIds {
            let loader = ArtistLoader(artistId: artistId)
            let operation = ItemLoaderOperation(loader: loader)
            ApiLoader.backgroundLoadingQueue.addOperation(operation)
        }
        
        for albumId in albumIds {
            let loader = AlbumLoader(albumId: albumId)
            let operation = ItemLoaderOperation(loader: loader)
            ApiLoader.backgroundLoadingQueue.addOperation(operation)
        }
    }
    
    func loadModelsFromDatabase() -> Bool {
        if let playlist = associatedObject as? Playlist {
            playlist.loadSubItems()
            songs = playlist.songs
            return songs.count > 0
        }
        return false
    }
    
    var associatedObject: Any? {
        let serverId = SavedSettings.si.currentServerId
        return PlaylistRepository.si.playlist(playlistId: playlistId, serverId: serverId)
    }
}