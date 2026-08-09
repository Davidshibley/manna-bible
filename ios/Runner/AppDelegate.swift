import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // 👇 ADD THESE 3 LINES TO KILL THE WHITE FLASH 👇
    if let window = self.window {
        window.backgroundColor = UIColor(red: 40/255.0, green: 42/255.0, blue: 42/255.0, alpha: 1.0)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}