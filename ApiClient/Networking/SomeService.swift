import Foundation
import RxSwift

protocol SomeServiceType {
    func fetchPosts() -> Single<[Post]>
    func fetchPost(with id: Int) -> Single<Post>
}

final class SomeService: SomeServiceType {
    private let apiClient: ApiClient
    private let parameters: Parameters = ["Accept": "application/json"]
    
    init(apiClient: ApiClient = ApiClient()) {
        self.apiClient = apiClient
        self.apiClient.baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    func fetchPosts() -> Single<[Post]> {
        let endpoint = Endpoint<[Post]>(path: "posts", parameters: parameters)
        return self.request(endpoint)
    }
    
    func fetchPost(with id: Int) -> Single<Post> {
        let endpoint = Endpoint<Post>(path: "posts/1", parameters: parameters)
        return self.request(endpoint)
    }
    
    private func request<Result>(_ endpoint: Endpoint<Result>) -> Single<Result> {
        return self.apiClient.request(endpoint)
            .map { (response: HTTPURLResponse, result: Result) in
                // do stuff with the result if needed
                print(response)
                
                return result
            }
    }
}
