//
//  SceneDelegate.m
//  lunight-objc
//
//  Created by lunight on 1/13/25.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

//- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
//    // UIWindowScene 확인 및 설정
//    if (scene && [scene isKindOfClass:[UIWindowScene class]]) {
//        NSLog(@"???");
//        UIWindowScene *windowScene = (UIWindowScene *)scene;
//
//        // UIWindow 생성 및 초기화
//        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
//
//        // XIB 기반의 ViewController를 루트 뷰 컨트롤러로 설정
//        ViewController *rootVC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//        self.window.rootViewController = rootVC;
//        if(rootVC) {
//            NSLog(@"???");
//        }
//        // UIWindow 표시
//        [self.window makeKeyAndVisible];
//    }
//}


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    NSLog(@"SceneDelegate: scene:willConnectToSession called");
    if ([scene isKindOfClass:[UIWindowScene class]]) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];

        ViewController *rootVC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootVC];
        self.window.rootViewController = navController;

        [self.window makeKeyAndVisible];
    }
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Scene이 시스템에 의해 연결 해제될 때 호출됩니다.
    // 백그라운드 전환 시 자원을 정리하거나 필요한 상태를 저장.
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Scene이 비활성 상태에서 활성 상태로 전환될 때 호출됩니다.
    // 중단되었던 작업을 재개합니다.
}

- (void)sceneWillResignActive:(UIScene *)scene {
    // Scene이 활성 상태에서 비활성 상태로 전환되기 직전에 호출됩니다.
    // 일시적인 중단(예: 전화 수신) 시 필요한 작업을 처리.
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Scene이 백그라운드에서 포그라운드로 전환될 때 호출됩니다.
    // 백그라운드 진입 시 적용된 변경 사항을 되돌립니다.
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Scene이 포그라운드에서 백그라운드로 전환될 때 호출됩니다.
    // 데이터를 저장하거나 공유 리소스를 해제합니다.
    [(AppDelegate *)UIApplication.sharedApplication.delegate saveContext];
}

@end
