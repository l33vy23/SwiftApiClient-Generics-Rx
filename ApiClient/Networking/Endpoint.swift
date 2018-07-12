import Foundation

typealias Path = String
typealias Parameters = [String: String]

enum Method {
    case get, post
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}

class Endpoint<Response> {
    let method: Method
    let parameters: Parameters?
    let path: Path
    let decode: (Data) throws -> Response
    
    init(method: Method,
         path: Path,
         parameters: Parameters?,
         decode: @escaping (Data) throws -> Response) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.decode = decode
    }
}

extension Endpoint where Response: Swift.Decodable {
    convenience init(method: Method = .get,
                     path: Path,
                     parameters: Parameters? = nil) {
        self.init(method: method,
                  path: path,
                  parameters: parameters,
                  decode: { data in
                    try JSONDecoder().decode(Response.self, from: data)
        })
    }
}
