import UIKit
import Flutter
import simd

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let methodChannel = FlutterMethodChannel(name: "pixel_image", binaryMessenger: controller.binaryMessenger)
        
        methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            
            if call.method == "shareImage" {
                if let args = call.arguments as? Dictionary<String, Any>,
                   let filePath = args["filePath"] as? String {
                    self.shareImage(filePath, controller, result)
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
            return
            
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    override func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    private func shareImage(_ filePath: String, _ controller: FlutterViewController, _ result: FlutterResult) {
        guard let image = imagePathToImage(filePath: filePath) else {
            return
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//        vc.excludedActivityTypes = [.saveToCameraRoll]
        
        controller.present(vc, animated: true, completion: nil)
        result(["result": "true"])
    }
    
    private func imagePathToImage(filePath: String) -> UIImage? {
        do {
            let imageData = try Data(contentsOf: URL(fileURLWithPath: filePath))
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
}
