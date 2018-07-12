import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let podcastsService = SomeService()
        
        podcastsService.fetchPosts()
            .subscribe(
                onSuccess: { posts in
                    print(posts)
            },
                onError: { error in
                    print(error)
            })
            .disposed(by: bag)
        
        podcastsService.fetchPost(with: 1)
            .subscribe(onSuccess: { post in
                print(post)
            },
                       onError: { error in
                        print(error)
            })
            .disposed(by: bag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

