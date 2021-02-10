//
//  ViewController.swift
//  FlickrClient
//
//  Created by Laurentiu Rogean on 06/02/2021.
//

import UIKit
import KRProgressHUD
import RxSwift

class PhotosViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = PhotosViewModel(repository: PhotosRepositoryImpl())
    private(set) var bag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUI()
    }
    
    func setupUI() {
        searchBar.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCollectionViewCell.nib, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        
        // Setup collectionView Flow Layout
        let flowLayout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 10
        flowLayout.itemSize = CGSize(width:screenWidth / 2 - 10, height: screenWidth / 2 - 10)
        collectionView.collectionViewLayout = flowLayout
    }
    
    func bindViewModel() {
        viewModel.event.bind { event in
            switch event {
            case .receivedData:
                self.collectionView.reloadData()
                self.searchBar.isLoading = false
                if KRProgressHUD.isVisible { KRProgressHUD.dismiss() }
               
            case .showPhoto(url: let url):
                KRProgressHUD.dismiss()
                self.displaySinglePhotoViewer(with: url)
                
            case .failed(error: let error):
                self.searchBar.isLoading = false
                if KRProgressHUD.isVisible { KRProgressHUD.dismiss() }
                self.showAlert(title: "Error", message: error.message)
                
            default: break
            }
        }.disposed(by: bag)
    }
    
    private func showAlert(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertViewController.addAction(action)
        
        navigationController?.present(alertViewController, animated: true, completion: nil)
    }
    
    private func displaySinglePhotoViewer(with photoURL: URL) {
        let singlePhotoVC = SinglePhotoViewController()
        singlePhotoVC.modalPresentationStyle = .fullScreen
        singlePhotoVC.imageURL = photoURL
        
        navigationController?.present(singlePhotoVC, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell {
            cell.configure(with: viewModel.photos?[indexPath.row].imageUrl)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension PhotosViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > collectionView.contentSize.height - scrollView.frame.height {
            guard !viewModel.isPaginating,
                  let text = searchBar.text,
                  !text.isEmpty,
                  text.count > 1 else { return }
            
            KRProgressHUD.show()
            viewModel.paginate()
            viewModel.searchPhotos(tags: text)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = viewModel.photos?[indexPath.row].id else {
            showAlert(title: "Error", message: "We have encountered an error, please try again later.")
            return
        }
        
        KRProgressHUD.show()
        viewModel.getSizes(for: id)
    }
}

// MARK: - UISearchBarDelegate

extension PhotosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.prepareForNewRequest()
        
        guard let text = searchBar.text, !text.isEmpty, text.count > 1 else { return }
        
        searchBar.isLoading = true
        viewModel.searchPhotos(tags: text)
    }
}
