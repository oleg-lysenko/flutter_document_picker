import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let channelName = "com.oleg.lysenko/documentPicker"
    let rootViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: rootViewController.binaryMessenger)
    
//    methodChannel.setMethodCallHandler {(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//      if (call.method == "start") {
//        let controller = DocumentPickerViewController(result: result)
//        rootViewController.present(controller, animated: true, completion: nil)
//      }
//    }
    
    methodChannel.setMethodCallHandler {(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if (call.method == "start") {
        let controller = DocumentBrowserViewController(result: result)
        rootViewController.present(controller, animated: true, completion: nil)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
