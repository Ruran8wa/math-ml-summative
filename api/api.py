from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import joblib
import numpy as np
import uvicorn
import sys

# Initialize FastAPI
app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],  # Explicitly list all methods
    allow_headers=["*"],  # Allows all headers
)

# Load the saved model at the start of the app
try:
    print("Attempting to load model...")
    model = joblib.load("./best_model.pkl")  # Ensure correct model path
    print("Model loaded successfully.")
except Exception as e:
    print(f"Error loading model: {e}")
    sys.exit(1)  # Exit the application if model loading fails

# Define the input schema using Pydantic
class InputData(BaseModel):
    Age: int
    Gender: int
    Ethnicity: int
    ParentalEducation: int
    StudyTimeWeekly: float
    Absences: int
    Tutoring: int
    ParentalSupport: int
    Extracurricular: int
    Sports: int
    Music: int
    Volunteering: int

@app.get("/")
def read_root():
    return {"message": "API is working!"}

@app.post("/predict")
async def predict(data: InputData):
    print(f"Received data: {data}")
    
    # Convert input data to NumPy array
    input_features = np.array([[
        data.Age, data.Gender, data.Ethnicity, data.ParentalEducation,
        data.StudyTimeWeekly, data.Absences, data.Tutoring,
        data.ParentalSupport, data.Extracurricular, data.Sports,
        data.Music, data.Volunteering
    ]])

    print(f"Input features for prediction: {input_features}")
    
    # Make prediction
    try:
        prediction = model.predict(input_features)  # Ensure model is loaded
        print(f"Prediction: {prediction}")
        return {"predicted_GPA": float(prediction[0])}
    except Exception as e:
        print(f"Error during prediction: {e}")
        return {"error": str(e)}

# For direct execution
if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
