import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyAy_mJBud5e6rmyzGpxOJOzKOIjx5q5ZwA")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
