//
//  SceneDelegate.swift
//  MixItPlaylists
//
//  Created by Jackson Sorrells on 9/29/19.
//  Copyright © 2019 MixIt. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate, SPTAppRemoteDelegate, SPTSessionManagerDelegate, SPTAppRemotePlayerStateDelegate {

    var window: UIWindow?
    
    /// MARK: Global vars
    var userData: UserDataModel = UserDataModel()
    
    
    /// MARK: Spotify vars
    
    // redirect access token param
    private var spotifyReturnAccessCodeKey = "code"
    
    // session manager scopes
    private var sessionManagerScopes: SPTScope = [
        .appRemoteControl,
        .userTopRead,
        .playlistModifyPublic,
        .ugcImageUpload
    ]
    
    // web auth scopes
    private var webAuthScopes: [String] = [
        "user-top-read",
        "playlist-modify-public",
        "ugc-image-upload"
    ]
    
    
    // spotify client id and redirect URL
    let SpotifyClientID = "1755b121e86047ccb05d3b100954fd13"
    let SpotifyRedirectURL = URL(string: "mixitplaylists://spotify-login-callback")!
    
    // spotify access token urls
    let SpotifyTokenSwapURL = URL(string: "https://ella-application.herokuapp.com/api/token")!
    let SpotifyTokenRefreshURL = URL(string: "https://ella-application.herokuapp.com/api/refresh_token")!
    
    // access token stored as
    static private let spotAccessTokenKey = "spotify-token-key"
    static private let kAccessTokenKey = "access-token-key"
    
    // spotify auth controller
    private var spotifyAuthController = SpotifyAuthController()

    
    // spotify API config
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    
    // spotify app remote
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    // spotify session manager
    lazy var sessionManager: SPTSessionManager = {

        self.configuration.tokenSwapURL = self.SpotifyTokenSwapURL
        self.configuration.tokenRefreshURL = self.SpotifyTokenRefreshURL
        self.configuration.playURI = "spotify:track:"

        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    
    // spotify access token
    var accessToken = UserDefaults.standard.string(forKey: spotAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: SceneDelegate.spotAccessTokenKey)
        }
    }
    
    // mix it playlists server token
    var mixItToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(mixItToken, forKey: SceneDelegate.kAccessTokenKey)
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        
        
        
        // launch screen
        let startup = RootView()
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: startup)
            self.window = window
            window.makeKeyAndVisible()
        }
                  
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            print("url error")
            return
        }
    
        let parameters = appRemote.authorizationParameters(from: url)
            
        if let access_code = parameters?[self.spotifyReturnAccessCodeKey] {
            // send request to get token
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
                self.getSpotifyAccessToken(code: access_code)
            })
        }else if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            print("CONNECTED WITH AUTHORIZE AND PLAY")
            
            // set new parameters
            self.appRemote.connectionParameters.accessToken = access_token
            self.accessToken = access_token
            
            // connect app remote
            self.appRemote.connect()
            
        }else if let err = parameters?[SPTAppRemoteErrorDescriptionKey] {
            // Show the error
            print(err)
        }else{
            print("UNKNOWN ERROR AFTER SPOTIFY RETURNED")
        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
//        if self.appRemote.connectionParameters.accessToken != nil {
//            self.appRemote.connect()
//        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
//        if self.appRemote.isConnected {
//          self.appRemote.disconnect()
//        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // connect to spotify api
    //  to get access token
    func connect() {
        // if spotify app installed
        if self.sessionManager.isSpotifyAppInstalled {
            // auth through the app
            sessionManager.initiateSession(with: self.sessionManagerScopes, options: .default)
        // Spotify app not installed
        }else{
            // auth through web view
            //print("Web Auth")
            
            // get redirect url
            let redirect: String = self.SpotifyRedirectURL.absoluteString
            
            // build scopes
            var scope: String = ""
            for i in 0...(self.webAuthScopes.count-1) {
                // add scope
                scope = scope + webAuthScopes[i]
                
                // add + if not last item
                if (i != self.webAuthScopes.count-1){
                    scope = scope + "+"
                }
            }
            
            // build url
            let webAuthURL = "https://accounts.spotify.com/authorize" +
                "?response_type=" + self.spotifyReturnAccessCodeKey +
                "&client_id=" + self.SpotifyClientID +
                "&redirect_uri=" + redirect +
                "&scope=" + scope
                        
            // open the url
            if let url = URL(string: webAuthURL) {
                UIApplication.shared.open(url)
            }else{
                // error
                print("ERROR: spotify auth URL")
            }
            
        }
    }
    
    // get access token with code
    func getSpotifyAccessToken(code: String){
        // post to swap for access token
        spotifyAuthController.authUser(type: .swap, code: code, callback: { resp in
            if (resp.authed){
                // parse resp data
                
                // access token
                self.accessToken = resp.accessToken
                print(self.accessToken)
                
                // refresh token
                
                // expire time
                
                // send notification
                let notifData: [String: String] = ["status": "connected"]
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "spotifyConnected"), object: nil, userInfo: notifData)
            }else{
                // send notification
                let notifData: [String: String] = ["error": resp.errorMsg]
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "spotifyConnected"), object: nil, userInfo: notifData)
            }
        })
    }
    
    
    /// MARK: App remote
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("APP REMOTE CONNECTED")
        
        // send notification
        self.sendAppRemoteStatus(connected: true)
        
        // start player api
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
          if let error = error {
            debugPrint(error.localizedDescription)
          }
        })
    
    }
    
    // app remote disconnected
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
      print("disconnected")
    }
    
    // app remote failed
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("APP REMOTE FAILED")
        
        // send notification
        self.sendAppRemoteStatus(connected: false)
    }
    
    // send app remote notification
    private func sendAppRemoteStatus(connected: Bool){
        // set status connected
        let notifData: [String: Bool] = ["connected": connected]
        
        // send notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "appRemoteConnected"), object: nil, userInfo: notifData)
    }

    
    /// MARK: PlayerState
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        // set playerState data
        let notifData: [String: SPTAppRemotePlayerState] = ["playerState": playerState]
        
        // send notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playerStateChange"), object: nil, userInfo: notifData)
    }
    
    
    /// MARK: session manager (unused)
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("Session Manager Connected")
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("Session Manager ERROR", error)
    }
    
    
}



