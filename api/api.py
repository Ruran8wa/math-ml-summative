from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import joblib
import numpy as np
import uvicorn

# Initialize FastAPI
app = FastAPI()

# Add CORS middleware - this must be added before any routes
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],  # Explicitly list all methods
    allow_headers=["*"],  # Allows all headers
)

# Load the saved model
try:
    model = joblib.load("best_model.pkl")
except Exception as e:
    print(f"Error loading model: {e}")
    # Provide a fallback or exit gracefully

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
    # Convert input data to NumPy array
    input_features = np.array([[
        data.Age, data.Gender, data.Ethnicity, data.ParentalEducation,
        data.StudyTimeWeekly, data.Absences, data.Tutoring,
        data.ParentalSupport, data.Extracurricular, data.Sports,
        data.Music, data.Volunteering
    ]])
    
    # Make prediction
    prediction = model.predict(input_features)
    return {"predicted_GPA": float(prediction[0])}

# For direct execution
if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)