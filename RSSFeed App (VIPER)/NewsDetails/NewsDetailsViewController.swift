//
//  NewsDetailsViewController.swift
//  RSSFeed App (VIPER)
//
//  Created by 19411109 on 10.08.2021.
//

import UIKit

/// Протокол экрана модуля NewsDetails
protocol NewsDetailsViewProtocol: AnyObject {

	/// Обновить  экран с помощью параметра
	///
	/// - Parameter rssItem: новость в формате модели RSSItemModel
	func update(with rssItem: RSSItemModel)
}

/// Экран модуля NewsDetails
final class NewsDetailsViewController: UIViewController {

	/// Презентер модуля NewsDetails
	var presenter: NewsDetailsPresenterProtocol?

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		setupButtons()
		setupConstraints()
		presenter?.viewDidLoad()
	}

	//MARK: - Private

	private let newsImage = UIImageView(image: #imageLiteral(resourceName: "rbk_logo.jpg"), contentMode: .scaleAspectFit)
	private let newsTitleLabel = UILabel(text: "Label with title",
										 font: .systemFont(ofSize: 24, weight: .medium),
										 numberOfLines: 0)
	private let newsPubDateLabel = UILabel(text: "Label with date",
										   font: .systemFont(ofSize: 24, weight: .medium),
										   numberOfLines: 1)
	private let goToNewsSourceButton = UIButton(title: "Перейти к источнику",
												titleColor: .white,
												backgroundColor: .orange,
												font: .systemFont(ofSize: 18, weight: .medium),
												isShadow: true,
												cornerRadius: 5)
	private var newsSourceURL: String?

	private func setupButtons() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
														   style: .plain,
														   target: self,
														   action: #selector(backButtonTapped))

		goToNewsSourceButton.addTarget(self, action: #selector(goToNewsSource), for: .touchUpInside)
	}
}

//MARK: - Button Actions

extension NewsDetailsViewController {

	@objc private func backButtonTapped() {
		presenter?.backButtonTapped()
	}

	@objc private func goToNewsSource() {
		guard let newsSourceURL = newsSourceURL,
			  let url = URL(string: newsSourceURL)
		else { return }
		presenter?.goToSourceButtonTapped(url: url)
	}
}

//MARK: - Setup Constraints

extension NewsDetailsViewController {

	private func setupConstraints() {

		[newsImage, newsTitleLabel, newsPubDateLabel, goToNewsSourceButton].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
		}

		[newsImage, newsTitleLabel, newsPubDateLabel, goToNewsSourceButton].forEach { view.addSubview($0) }

		NSLayoutConstraint.activate([
			newsImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			newsImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			newsImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

			newsTitleLabel.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 20),
			newsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			newsTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

			newsPubDateLabel.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor, constant: 20),
			newsPubDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			newsPubDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

			goToNewsSourceButton.topAnchor.constraint(equalTo: newsPubDateLabel.bottomAnchor, constant: 30),
			goToNewsSourceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			goToNewsSourceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			goToNewsSourceButton.heightAnchor.constraint(equalToConstant: 52)
		])
	}
}

// MARK: - Protocol Confirmation NewsDetailsViewProtocol

extension NewsDetailsViewController: NewsDetailsViewProtocol {

	func update(with rssItem: RSSItemModel) {

		DispatchQueue.main.async {
			if let rssItemImage = rssItem.image {
				self.newsImage.image = rssItemImage
			}
			self.newsTitleLabel.text = rssItem.title
			self.newsPubDateLabel.text = rssItem.pubDateBeautifulString
			self.newsSourceURL = rssItem.linkToSource
		}
	}
}
