//
//  WebDAVClient.swift
//  NekoPlayer
//
//  WebDAV client implementation for NekoPlayer
//

import Foundation

class WebDAVClient {

    // MARK: - Singleton

    static let shared = WebDAVClient()

    // MARK: - Properties

    private var session: URLSession?
    private var baseURL: URL?
    private var credentials: URLCredential?
    private var servers: [WebDAVServer] = []

    private init() {
        setupSession()
    }

    // MARK: - Public Methods

    /// Add a new WebDAV server
    func addServer(name: String, url: String, username: String? = nil, password: String? = nil) {
        guard let serverURL = URL(string: url) else { return }

        let server = WebDAVServer(
            id: UUID().uuidString,
            name: name,
            url: serverURL,
            username: username,
            password: password
        )

        servers.append(server)
        saveServers()
    }

    /// Remove a WebDAV server
    func removeServer(at index: Int) {
        guard index < servers.count else { return }
        servers.remove(at: index)
        saveServers()
    }

    /// Get all saved servers
    func getServers() -> [WebDAVServer] {
        return servers
    }

    /// List files in a directory
    func listFiles(server: WebDAVServer, at path: String = "/", completion: @escaping (Result<[WebDAVFile], Error>) -> Void) {
        configureSession(for: server)

        guard let baseURL = baseURL else {
            completion(.failure(WebDAVError.invalidURL))
            return
        }

        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "PROPFIND"
        request.setValue("1", forHTTPHeaderField: "Depth")
        request.setValue("application/xml", forHTTPHeaderField: "Content-Type")

        session?.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(WebDAVError.noData))
                return
            }

            do {
                let files = try self.parseWebDAVResponse(data)
                completion(.success(files))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    /// Download or stream a file
    func getFile(server: WebDAVServer, path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        configureSession(for: server)

        guard let baseURL = baseURL else {
            completion(.failure(WebDAVError.invalidURL))
            return
        }

        let url = baseURL.appendingPathComponent(path)

        // Return the URL directly for streaming
        // The player will handle the actual download
        completion(.success(url))
    }

    // MARK: - Private Methods

    private func setupSession() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.httpAdditionalHeaders = [
            "User-Agent": "NekoPlayer/1.0",
            "Accept": "*/*"
        ]
        session = URLSession(configuration: config)
    }

    private func configureSession(for server: WebDAVServer) {
        baseURL = server.url
        credentials = nil

        if let username = server.username, let password = server.password {
            credentials = URLCredential(user: username, password: password, persistence: .forSession)

            let authString = "\(username):\(password)"
            if let authData = authString.data(using: .utf8) {
                let base64Auth = authData.base64EncodedString()
                session?.configuration.httpAdditionalHeaders?["Authorization"] = "Basic \(base64Auth)"
            }
        }
    }

    private func parseWebDAVResponse(_ data: Data) throws -> [WebDAVFile] {
        // Parse WebDAV XML response
        let xmlString = String(data: data, encoding: .utf8) ?? ""
        var files: [WebDAVFile] = []

        // Simple XML parsing (for production, use XMLParser)
        let hrefRegex = try NSRegularExpression(pattern: "<D:href>(.*?)</D:href>", options: [])
        let propRegex = try NSRegularExpression(pattern: "<D:getcontentlength>(.*?)</D:getcontentlength>", options: [])
        let displaynameRegex = try NSRegularExpression(pattern: "<D:displayname>(.*?)</D:displayname>", options: [])

        let hrefRange = NSRange(xmlString.startIndex..<xmlString.endIndex, in: xmlString)

        let hrefMatches = hrefRegex.matches(in: xmlString, options: [], range: hrefRange)

        for match in hrefMatches {
            guard let hrefRange = Range(match.range(at: 1), in: xmlString) else { continue }
            let href = String(xmlString[hrefRange])

            // Skip the directory itself
            if href.hasSuffix("/") && href.count == href.lastIndex(of: "/")!.encodedOffset + 1 {
                continue
            }

            // Extract name from href
            let name = URL(string: href)?.lastPathComponent ?? href

            // Extract size
            var size: Int64 = 0
            if let sizeMatch = propRegex.firstMatch(in: xmlString, options: [], range: NSRange(match.range, in: xmlString)),
               let sizeRange = Range(sizeMatch.range(at: 1), in: xmlString) {
                size = Int64(String(xmlString[sizeRange])) ?? 0
            }

            // Determine if it's a directory
            let isDirectory = href.hasSuffix("/")

            // Check if it's a video file
            let isVideo = isVideoFile(name: name)

            if isDirectory || isVideo {
                let file = WebDAVFile(
                    name: name,
                    path: href,
                    isDirectory: isDirectory,
                    size: isDirectory ? nil : size,
                    lastModified: nil
                )
                files.append(file)
            }
        }

        return files
    }

    private func isVideoFile(name: String) -> Bool {
        let videoExtensions = ["mp4", "mov", "m4v", "avi", "mkv", "webm"]
        return videoExtensions.contains(name.lowercased().split(separator: ".").last ?? "")
    }

    private func saveServers() {
        // Save servers to UserDefaults
        if let data = try? JSONEncoder().encode(servers) {
            UserDefaults.standard.set(data, forKey: "WebDAVServers")
        }
    }

    private func loadServers() {
        if let data = UserDefaults.standard.data(forKey: "WebDAVServers"),
           let savedServers = try? JSONDecoder().decode([WebDAVServer].self, from: data) {
            servers = savedServers
        }
    }
}

// MARK: - WebDAV Models

struct WebDAVServer: Codable {
    let id: String
    let name: String
    let url: URL
    let username: String?
    let password: String?

    init(id: String, name: String, url: URL, username: String? = nil, password: String? = nil) {
        self.id = id
        self.name = name
        self.url = url
        self.username = username
        self.password = password
    }
}

struct WebDAVFile {
    let name: String
    let path: String
    let isDirectory: Bool
    let size: Int64?
    let lastModified: Date?
}

// MARK: - WebDAV Errors

enum WebDAVError: LocalizedError {
    case invalidURL
    case noData
    case parsingError
    case authenticationFailed
    case serverError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .parsingError:
            return "Failed to parse server response"
        case .authenticationFailed:
            return "Authentication failed"
        case .serverError:
            return "Server error"
        }
    }
}
