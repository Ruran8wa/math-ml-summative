from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import numpy as np

# Load the saved model
model = joblib.load("best_model.pkl")

# Initialize FastAPI
app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "API is working!"}


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

@app.post("/predict")
def predict(data: InputData):
    # Convert input data to NumPy array
    input_features = np.array([[data.Age, data.Gender, data.Ethnicity, data.ParentalEducation, 
                                data.StudyTimeWeekly, data.Absences, data.Tutoring, 
                                data.ParentalSupport, data.Extracurricular, data.Sports, 
                                data.Music, data.Volunteering]])
    
    # Make prediction
    prediction = model.predict(input_features)
    
    return {"predicted_GPA": float(prediction[0])}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
