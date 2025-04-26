from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    ingredients = data.get('ingredients', '')

    if 'banana' in ingredients.lower():
        meal = "Healthy Banana Smoothie"
    elif 'chicken' in ingredients.lower():
        meal = "Grilled Chicken Bowl"
    else:
        meal = "Mixed Veggie Salad"

    return jsonify({'meal': meal})

if __name__ == '__main__':
    app.run(debug=True)
