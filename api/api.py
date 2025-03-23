from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import joblib
import numpy as np
import uvicorn
import sys

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"], 
    allow_headers=["*"],  
)

try:
    print("Attempting to load model...")
    model = joblib.load("./best_model.pkl") 
    print("Model loaded successfully.")
except Exception as e:
    print(f"Error loading model: {e}")
    sys.exit(1)  

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
    
    input_features = np.array([[
        data.Age, data.Gender, data.Ethnicity, data.ParentalEducation,
        data.StudyTimeWeekly, data.Absences, data.Tutoring,
        data.ParentalSupport, data.Extracurricular, data.Sports,
        data.Music, data.Volunteering
    ]])

    print(f"Input features for prediction: {input_features}")
    
    try:
        prediction = model.predict(input_features) 
        print(f"Prediction: {prediction}")
        return {"predicted_GPA": float(prediction[0])}
    except Exception as e:
        print(f"Error during prediction: {e}")
        return {"error": str(e)}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
