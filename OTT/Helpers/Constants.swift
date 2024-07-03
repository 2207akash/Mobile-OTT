//
//  Constants.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import Foundation

final class Constants {
    
    private init() {}
    
    // MARK: Don't remove: have extensions built for these in other classes
    enum Preferences {
        
    }
    
}


extension Constants {
    
    enum AlertMessages {
        static let ok = "Ok"
        static let cancel = "Cancel"
        static let error = "Error"
        static let sorry = "Sorry"
        static let noInternet = "Unable to connect to the internet, please ensure you are connected to a network."
        static let unableToFetchServerData = "Unable to fetch data from the server, please try again later!"
    }
    
}


extension Constants {
    
    enum ServerUrls {
        static let videosListUrl = "https://interview-e18de.firebaseio.com/media.json?print=pretty"
    }
    
}
