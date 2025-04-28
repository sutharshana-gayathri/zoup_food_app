require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// MongoDB Connection
mongoose.connect(process.env.MONGODB_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('MongoDB connection error:', err));

// Food Item Schema
const foodSchema = new mongoose.Schema({
  id: String,
  name: String,
  description: String,
  price: Number,
  imageUrl: String,
});
const FoodItem = mongoose.model('FoodItem', foodSchema);

// Routes
app.get('/food-items', async (req, res) => {
  try {
    const foodItems = await FoodItem.find();
    res.json(foodItems);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.post('/food-items', async (req, res) => {
  try {
    const foodItem = new FoodItem(req.body);
    const savedItem = await foodItem.save();
    res.status(201).json(savedItem);
  } catch (err) {
    res.status(400).send(err);
  }
});

app.put('/food-items/:id', async (req, res) => {
  try {
    const updatedItem = await FoodItem.findOneAndUpdate({ id: req.params.id }, req.body, { new: true });
    if (!updatedItem) return res.status(404).send('Item not found');
    res.json(updatedItem);
  } catch (err) {
    res.status(400).send(err);
  }
});

app.delete('/food-items/:id', async (req, res) => {
  try {
    const deletedItem = await FoodItem.findOneAndDelete({ id: req.params.id });
    if (!deletedItem) return res.status(404).send('Item not found');
    res.status(204).send();
  } catch (err) {
    res.status(500).send(err);
  }
});

app.get('/', (req, res) => {
  res.send('Food App Backend is running');
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});