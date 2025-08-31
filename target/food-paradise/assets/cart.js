const cartEl = document.getElementById('cart');
function renderCart() {
  const cart = JSON.parse(localStorage.getItem('cart') || '[]');
  if (cart.length === 0) { cartEl.innerHTML = "<p>Your cart is empty.</p>"; return; }
  const total = cart.reduce((s,i)=> s + i.price*i.qty, 0);
  cartEl.innerHTML = `
    <div class="grid">
      ${cart.map(i => `
        <div class="card-item">
          <div class="row"><strong>${i.name}</strong><span>$${i.price.toFixed(2)}</span></div>
          <div class="row">
            <button class="btn" onclick="dec(${i.id})">-</button>
            <span>Qty: ${i.qty}</span>
            <button class="btn" onclick="inc(${i.id})">+</button>
          </div>
        </div>
      `).join('')}
    </div>
    <h3>Total: $${total.toFixed(2)}</h3>
  `;
}
function inc(id){ const cart = JSON.parse(localStorage.getItem('cart')||'[]'); const it = cart.find(x=>x.id===id); it.qty++; localStorage.setItem('cart', JSON.stringify(cart)); renderCart(); }
function dec(id){ const cart = JSON.parse(localStorage.getItem('cart')||'[]'); const it = cart.find(x=>x.id===id); it.qty--; if (it.qty<=0) cart.splice(cart.indexOf(it),1); localStorage.setItem('cart', JSON.stringify(cart)); renderCart(); }
document.getElementById('checkout').addEventListener('click', ()=> alert('Checkout demo only. Implement orders later.'));
renderCart();
