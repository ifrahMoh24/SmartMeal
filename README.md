# SmartMeal — AI‑Powered iOS Meal Planner

## 📍 Overview
SmartMeal is an AI-driven iOS app that generates meal plans and recipes from photos of food ingredients. Point your camera at your ingredients or upload a photo, and SmartMeal will identify items using a custom CoreML model and suggest recipes with portion sizes and nutritional info.

## 🚀 Features
- Capture or upload images of ingredients via your iPhone
- Ingredient recognition using a trained CoreML model
- Recipe generation with portion sizes and nutrition breakdown
- Meal planning: assemble weekly meal plans based on user goals
- Save favourite recipes locally
- Clean SwiftUI interface for iOS 14+

## 💙 Tech Stack
- **Frontend (iOS):** Swift, SwiftUI, UIKit (for some components)
- **Backend:** Python, Flask REST API
- **ML/AI:** CoreML model (trained using YOLOv8), OpenCV
- **Database:** Local storage (CoreData); optionally Firebase for cloud sync
- **Tools:** Xcode, Docker, Postman

## 📱 Screenshots / Demo
(Add your existing screenshots here)

## ⚙️ Installation & Setup
1. Clone the repo
2. Install Python dependencies for the backend
3. Build and run the iOS project in Xcode
4. Ensure your device can reach the Flask API

## 🗂️ Folder Structure
- `SmartMeal1.xcodeproj` — Xcode project for the iOS app
- `SmartMeal1/` — Swift source code (Views, ViewModels, Models)
- `backend/` — Flask API and ML scripts
- `README.md` — Project documentation

## 📍 Status
Active — feature complete for MVP, with plans to enhance meal‑planning algorithms.

## 👤 Author
Ifrah Mohamed  
[LinkedIn](https://linkedin.com/in/ifrah-mohamed-4233b7225) | [GitHub](https://github.com/ifrahMoh24)
