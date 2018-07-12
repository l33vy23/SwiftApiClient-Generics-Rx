import Foundation
import RxSwift
import RxCocoa

protocol Networking {
    var baseURL: URL! { get set }
    func request<Response>(_ enpoint: Endpoint<Response>) -> Single<(response: HTTPURLResponse, result: Response)>
}


final class ApiClient: Networking {
    var baseURL: URL!
    var session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<(response: HTTPURLResponse, result: Response)> {
        var request = URLRequest(url: self.url(from: endpoint.path))
        request.httpMethod = endpoint.method.description
        
        if let parameters = endpoint.parameters {
            for (key, value) in parameters {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return self.session.rx.response(request: request)
            .map { (response, data) -> (HTTPURLResponse, Response) in
                let result = try endpoint.decode(data)
                return (response: response, result: result)
            }
            .asSingle()
    }
    
    private func url(from path: Path) -> URL {
        return baseURL.appendingPathComponent(path)
    }
}

