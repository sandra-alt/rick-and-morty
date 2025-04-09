# Rick and Morty Characters App

A modular iOS app that fetches and displays characters from the Rick and Morty API (https://rickandmortyapi.com/api), with offline support, Core Data caching, using Clean Swift architecture.

## Features

- List of characters from Rick and Morty API
- Character detail screen
- Offline mode with Core Data caching
- Character images downloaded and stored locally

## Tech Stack

- Swift + UIKit
- Clean Swift Architecture (http://clean-swift.com)
- Core Data – local caching for offline support
- Kingfisher – async image downloading
- URLSession – native networking

## Prerequisites

- Xcode 14+
- iOS 15+

## Installation

1. Clone the repo:
```
   git clone https://github.com/sandra-alt/rick-and-morty.git
   cd rick-and-morty
```


2. Open `RickAndMorty.xcodeproj` in Xcode.
3. Run the app on Simulator or your iOS device.

## Offline Mode

The app saves both character data and image files:

1. Character data is stored via Core Data (CharacterEntity).
2. Images are downloaded once and saved to the app’s local file system (CharactersImages directory).
3. On next launch, if there is no network, the app loads from local storage.

## Dependencies

This project uses Swift Package Manager (SPM) to manage its dependencies.
