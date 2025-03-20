from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime
from typing import List
import numpy as np
from .ml_model import ElectricityPricePredictor

app = FastAPI(title="Electricity Price API")
predictor = ElectricityPricePredictor()

class PriceRequest(BaseModel):
    start_time: datetime
    end_time: datetime

class PriceResponse(BaseModel):
    timestamp: datetime
    price: float

@app.get("/")
async def root():
    return {"message": "Electricity Price API is running"}

@app.post("/prices", response_model=List[PriceResponse])
async def get_prices(request: PriceRequest):
    try:
        # Generate hourly timestamps between start and end time
        timestamps = np.arange(
            request.start_time,
            request.end_time,
            np.timedelta64(1, 'h')
        )
        
        # Get predictions for each timestamp
        prices = predictor.predict(timestamps)
        
        # Combine timestamps and prices into response
        return [
            PriceResponse(timestamp=ts, price=float(price))
            for ts, price in zip(timestamps, prices)
        ]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) 