import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // UIWindowScene check
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // UIWindow init
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = ViewController() // set rootviewcontroller
        self.window = window
        
        // UIWindow의 hidden 속성을 false로 설정하여 화면에 표시 & 루트뷰 랜더링 처리
        window.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Scene이 시스템에 의해 연결 해제될 때 호출됩니다.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Scene이 비활성 상태에서 활성 상태로 전환될 때 호출됩니다.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Scene이 활성 상태에서 비활성 상태로 전환될 때 호출됩니다.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Scene이 백그라운드에서 포그라운드로 전환될 때 호출됩니다.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Scene이 포그라운드에서 백그라운드로 전환될 때 호출됩니다.
    }
}
