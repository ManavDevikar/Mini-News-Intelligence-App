# Mini-News-Intelligence-App
Note: Application screenshots have been added to the screenshots folder.

A clean and scalable Flutter application that provides a business news intelligence experience using a public News API.

The application allows users to browse news by category, search for articles, view article details, save favorite articles, and maintain authentication and favorite data locally.

---

##  Features

###  Authentication

- Simple login flow
- Email and password validation
- Persistent login state using Hive
- Automatic login restoration after app restart
- Logout functionality
- Protected application flow

###  News Feed

- Business-focused news experience
- Category-based news browsing
- Supported categories:
  - Business
  - Technology
  - Science
  - Health
  - Sports
  - Entertainment
- Pagination / load more
- Pull-to-refresh
- Loading states
- Error states
- Empty states

###  Search

- Search articles using the News API
- Debounced API requests
- Clear search functionality
- Loading state
- Error state
- Empty result state

###  Article Details

- Article title
- Source
- Published date
- Description
- Article content
- Article image
- Open original article externally
- Add/remove article from favorites

###  Favorites

- Save articles as favorites
- Remove saved articles
- Persistent favorite storage using Hive
- Favorites remain available after application restart
- Favorites can be accessed from the News Feed

---

#  Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter | Application framework |
| Dart | Programming language |
| Riverpod | State management |
| Dio | HTTP/API communication |
| Hive | Local persistence |
| GoRouter | Navigation |
| News API | News data source |

---

#  Architecture

The application follows **Clean Architecture principles** with feature-based organization.

The main goal of this architecture is to keep:

- UI independent from API implementation
- Business logic separate from UI
- Data sources replaceable
- Code easier to test and maintain
- Features isolated and scalable

The application is divided into three main layers:

```text
Presentation
     ↓
Domain
     ↓
Data layer

## Presentation Layer
The Presentation layer is responsible for the application's UI and user interaction.
It contains:
- Screens
- Widgets
- Riverpod controllers
- UI state
- Loading states
- Error states
- Empty states
Example:
presentation/
├── controllers/
├── screens/
└── widgets/

The UI does not directly communicate with the API or Hive.
Instead, the Presentation layer communicates with the Domain layer through Riverpod controllers and repository contracts.

# Domain Layer
The Domain layer contains the application's core business concepts and repository contracts.
It is independent of external technologies such as:
- Dio
- Hive
- Flutter UI
- News API
It contains:
domain/
├── entities/
└── repositories/

Entities
Entities represent the core objects used by the application.
For example:
Article

The Article entity represents a news article independently of how it is retrieved from the API.
Repository Contracts
Repository interfaces define what operations the application needs.

For example:
abstract class NewsRepository {
  Future<List<Article>> getNews({
    required String category,
    required int page,
  });

  Future<List<Article>> searchNews({
    required String query,
    int page = 1,
  });
}

The Domain layer only defines the contract.
The actual implementation is provided by the Data layer.

# Data Layer
The Data layer is responsible for communication with external data sources and local persistence.
It contains:
data/
├── datasources/
├── models/
└── repositories/

Data Sources
Data sources communicate with:
- News API
- Hive local storage
For example:
news_api_service.dart
auth_local_data_source.dart
favorites_local_data_source.dart

Models
Models are responsible for converting API JSON responses into Dart objects.
Example:
ArticleModel

The model handles JSON parsing and can convert itself into the Domain Article entity.
Repository Implementations
Repository implementations connect the Domain layer to the actual data sources.
For example:
NewsRepository
       ↑
NewsRepositoryImpl
       ↓
NewsApiService
       ↓
News API

This keeps API implementation details outside the UI.
# Architecture Flow
For a news API request, the flow is:
User
  ↓
News Feed Screen
  ↓
News Controller
  ↓
News Repository
  ↓
News API Service
  ↓
Dio
  ↓
News API

The response follows the reverse direction:
News API
  ↓
Dio
  ↓
News API Service
  ↓
Article Model
  ↓
News Repository
  ↓
News Controller
  ↓
News Feed UI

This separation makes the application easier to maintain and allows the API implementation to be replaced without modifying the UI.

## Requirements
Before running the project, make sure the following are installed:
- Flutter 3+
- Dart
- Android Studio or VS Code
- Android Emulator / physical Android device
- Internet connection
- News API key
Verify the Flutter installation:
flutter doctor

## How to Run the Project
1. Clone the Repository
git clone <YOUR_GITHUB_REPOSITORY_URL>

Replace the URL with the GitHub repository URL.
2. Navigate to the Project
cd mini_news_intelligence

3. Install Dependencies
flutter pub get

4. Configure the API Key
Configure the News API key according to the API configuration used by the project.
If the project uses environment variables, create:
.env

and add:
NEWS_API_KEY=your_api_key_here

Make sure .env is included in .gitignore.

5. Run the Application
Connect an emulator or physical device and run:
flutter run

For a specific device:
flutter devices

Then:
flutter run -d <device_id>


## Manual Testing Checklist
The following scenarios should be verified before submission:
Authentication
- [ ] Login with valid credentials
- [ ] Invalid email validation
- [ ] Empty password validation
- [ ] Login state persists after restart
- [ ] Logout works correctly
- [ ] Logged-out user is redirected to Login
News Feed
- [ ] News loads successfully
- [ ] Category selection works
- [ ] Pagination works
- [ ] Pull-to-refresh works
- [ ] Loading state appears
- [ ] Error state appears when API fails
- [ ] Empty state is displayed when there are no results
Article
- [ ] Article details open correctly
- [ ] Article image loads
- [ ] Broken image is handled
- [ ] Full article opens externally
- [ ] Favorite button works
Favorites
- [ ] Article can be added to favorites
- [ ] Article can be removed from favorites
- [ ] Favorites screen displays saved articles
- [ ] Favorites survive application restart
- [ ] Favorite state stays synchronized across screens
Search
- [ ] Search request works
- [ ] Search is debounced
- [ ] Loading state works
- [ ] Empty state works
- [ ] Error state works
- [ ] Clear search works
- [ ] Search results can open article details













