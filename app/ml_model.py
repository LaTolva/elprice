import numpy as np
from datetime import datetime

class ElectricityPricePredictor:
    def __init__(self):
        # Mock model parameters
        self.base_price = 100
        self.daily_variation = 50
        self.weekly_variation = 30
        
    def predict(self, timestamps):
        """
        Generate mock electricity prices based on time of day and day of week
        """
        prices = []
        for ts in timestamps:
            # Convert to numpy datetime64 for easier manipulation
            ts = np.datetime64(ts)
            
            # Get hour of day (0-23)
            hour = ts.astype('datetime64[h]').astype(int) % 24
            
            # Get day of week (0-6)
            day = ts.astype('datetime64[D]').astype(int) % 7
            
            # Generate price with some randomness
            price = (
                self.base_price +
                self.daily_variation * np.sin(2 * np.pi * hour / 24) +
                self.weekly_variation * np.sin(2 * np.pi * day / 7) +
                np.random.normal(0, 10)
            )
            
            # Ensure price is positive
            price = max(0, price)
            
            prices.append(price)
            
        return np.array(prices) 