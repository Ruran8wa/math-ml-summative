# Student Performance Prediction

## Mission

This project aims to predict student performance based on various demographic, academic, and extracurricular factors. The model provides insights into expected academic outcomes and suggests study improvements.

## Dataset

The dataset used for training and evaluation comes from Kaggle: [Students Performance Dataset](https://www.kaggle.com/datasets/rabieelkharoua/students-performance-dataset).

## Visualizations

Two key visualizations were used to analyze the dataset before training the model:

1. **Correlation Heatmap**: Displays how different features correlate with student performance, helping in feature selection.
2. **Histograms**: Show the distribution of key variables, allowing us to understand data trends and balance.

## Model Selection

The best-performing model for this task was **Linear Regression**, as it provided a balance between interpretability and predictive accuracy.

## API Integration

A FastAPI service was developed to expose the trained model as an endpoint. The Flutter app interacts with this API to send student data and receive performance predictions in real time.

## How to Run the Project

### Backend (FastAPI)

1. Ensure dependencies are installed:
   ```bash
   cd api
   pip install -r requirements.txt
   ```
2. Run the API server:
   ```bash
   uvicorn api:app --reload
   ```

### Frontend (Flutter App)

1. Navigate to the Flutter project directory.
2. Run the app:
   ```bash
   cd app
   flutter run
   ```

## Future Improvements

- Enhance model performance with additional features.
- Improve API robustness and error handling.
- Expand the Flutter UI for better user experience.

---

This project was developed as part of a Machine Learning summative assessment.
