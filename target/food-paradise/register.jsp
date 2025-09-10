<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Register — Food Paradise</title>
  <link rel="stylesheet" href="assets/register.css?v=1.0">
</head>
<body>
  <!-- Veggies floating around -->
<div class="veggie carrot" style="left:10%; top:-50px;"></div>
<div class="veggie tomato" style="left:40%; top:-50px;"></div>
<div class="veggie chili" style="left:70%; top:-50px;"></div>
<div class="floating-leaf" style="left:20%; top:-50px;"></div>
<div class="floating-leaf" style="left:50%; top:-50px;"></div>
<div class="floating-leaf" style="left:80%; top:-50px;"></div>
<div class="floating-sparkle" style="left:10%; top:30%;"></div>
<div class="floating-sparkle" style="left:70%; top:50%;"></div>

  <div class="card">
    <h2>Create Account</h2>
    <form method="post" action="register">
      <label>Role
        <select name="role" required>
          <option value="USER">Customer</option>
          <option value="ADMIN">Admin</option>
        </select>
      </label>
      <label>Name
        <input name="name" required />
      </label>
      <label>Email
        <input name="email" type="email" required />
      </label>
      <label>Password
        <input name="password" type="password" required />
      </label>
      <label>Address (Customers only)
        <input name="address" placeholder="optional for Admin" />
      </label>
      <label>Phone (Customers only)
        <input name="phone" placeholder="optional for Admin" />
      </label>
      <button class="btn" type="submit">Register</button>
      <p>Have an account? <a href="login.jsp">Login</a></p>
    </form>
    <p class="error"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></p>
    <p class="success"><%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %></p>
  </div>
</body>
</html>
