// Demo in-memory catalog; you can later load from backend
const catalog = [
  // Food
  { id: 1, category: "Myanmar Food", name: "Mohinga", price: 3.5, img: "https://images.unsplash.com/photo-1543357480-c60d40007a7e" },
  { id: 2, category: "Thai Food", name: "Pad Thai", price: 4.2, img: "https://images.unsplash.com/photo-1604908176997-431e2385bf5e" },
  { id: 3, category: "Chinese Food", name: "Kung Pao Chicken", price: 5.0, img: "https://images.unsplash.com/photo-1544025162-d76694265947" },
  // Drinks
  { id: 4, category: "Cafe", name: "Iced Latte", price: 2.5, img: "https://images.unsplash.com/photo-1517705008128-361805f42e86" },
  { id: 5, category: "Fruit Juice & Yogurt", name: "Mango Yogurt", price: 2.2, img: "https://images.unsplash.com/photo-1563565375-f3fdfdbefa83" },
  { id: 6, category: "Bubble Tea & Smoothie", name: "Taro Bubble Tea", price: 2.8, img: "https://images.unsplash.com/photo-1611599539395-c4b9f0cb0c88" },
];

const itemsEl = document.getElementById('items');
const chips = document.querySelectorAll('.chip');

function render(list) {
  itemsEl.innerHTML = list.map(x => `
    <div class="card-item">
      <img src="${x.img}" alt="${x.name}"/>
      <div class="row"><strong>${x.name}</strong><span>$${x.price.toFixed(2)}</span></div>
      <small>${x.category}</small>
      <button class="btn" onclick="addToCart(${x.id})">Add to cart</button>
    </div>
  `).join('');
}

chips.forEach(c => c.addEventListener('click', () => {
  const cat = c.dataset.category;
  render(catalog.filter(x => x.category === cat));
}));

// default render all
render(catalog);

function addToCart(id) {
  const item = catalog.find(x => x.id === id);
  const cart = JSON.parse(localStorage.getItem('cart') || '[]');
  const exists = cart.find(x => x.id === id);
  if (exists) exists.qty += 1; else cart.push({ ...item, qty: 1 });
  localStorage.setItem('cart', JSON.stringify(cart));
  alert('Added to cart');
}
