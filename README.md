# 🍽️ SmartMeal - AI-Powered Ingredient & Recipe App

SmartMeal is a SwiftUI-based iOS application that uses Core ML and Vision to identify ingredients from photos and generate personalized recipes with the help of AI.
Built for people who want to cook smarter, healthier, and faster.

## 📱 Features

- 📸 **Ingredient Scanner** – Snap a photo or pick from gallery to detect ingredients using a trained Core ML model.
- 🧠 **AI-Powered Recipe Generator** – Generates unique recipes based on your detected ingredients and dietary preferences.
- 🍲 **Nutrition Breakdown** – Displays estimated nutritional info for each recipe.
- ❤️ **Favorites & Profile** – Save your favorite recipes and manage your cooking preferences.
- ⚙️ **Offline Ingredient Detection** – Works without internet using Core ML on device.

## 🧠 Tech Stack

| Layer        | Technology         |
|--------------|--------------------|
| UI/UX        | SwiftUI, Combine   |
| ML & CV      | Core ML, Vision, Create ML |
| Backend/API  | REST API (Flask or OpenAI) |
| Data Storage | UserDefaults, Core Data (optional) |
| Tools        | Xcode, Create ML, GitHub |



## 🚀 Getting Started

### Prerequisites
- macOS with **Xcode 15+**
- Swift 5+
- Optional: Python (for API or model training)

### Run the App

git clone https://github.com/ifrahMoh24/SmartMeal.git
cd SmartMeal
open SmartMeal.xcodeproj
Build and run the project on simulator or a real device.

For ingredient detection, use sample food images.

For full functionality, ensure the Core ML model is added to MLModels/.

🧪 Model Training (Optional)
If you'd like to train your own ingredient classifier, see ModelTraining.md for full instructions using Create ML.
