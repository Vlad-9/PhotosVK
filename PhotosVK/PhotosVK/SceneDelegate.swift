//
//  SceneDelegate.swift
//  PhotosVK
//
//  Created by Влад on 06.04.2022.
//

import UIKit
import VK_ios_sdk

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AuthServiceDelegate {

    var window: UIWindow?
    var authService: AuthService!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        authService = AuthService()
        authService.delegate = self
        authService.isAlreadyAuthorized()

        let viewController = AuthAssembly().createNoteViewController()
        let navController = UINavigationController()

        navController.viewControllers = [viewController]
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    func failedAuth() {
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("authFail", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    func authServiceLogout() {
        let viewController = AuthAssembly().createNoteViewController()
        let navController = UINavigationController()
        navController.viewControllers = [viewController]
        window?.rootViewController?.navigationController?.popViewController(animated: true)
    }

    func authServiceShould(viewController: UIViewController) {
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }

    func authServiceSignIn() {
        let viewController = GalleryCollectionViewAssembly().createGalleryCollectionViewController()
        let navController = UINavigationController()
        let viewController1 = AuthAssembly().createNoteViewController()
        navController.viewControllers = [viewController1, viewController]
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    func authServiceSignInDidFail() {
        print(#function)
    }

    static func shared() -> SceneDelegate {
        let scene = UIApplication.shared.connectedScenes.first
        let sd: SceneDelegate = (((scene?.delegate as? SceneDelegate)!))
        return sd
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            // Handle URL
            VKSdk.processOpen(url, fromApplication: nil)
        }
    }

}
