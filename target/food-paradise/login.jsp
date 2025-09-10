<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login — Food Paradise</title>
  <link rel="stylesheet" href="assets/login.css?v=1.0">
</head>
<body>


  <!-- Floating Veggies -->
  <div class="veggie" style="top:-50px; left:10%;"></div>
  <div class="veggie" style="top:-50px; left:30%;"></div>
  <div class="veggie" style="top:-50px; left:50%;"></div>
  <div class="veggie" style="top:-50px; left:70%;"></div>
  <div class="veggie" style="top:-50px; left:90%;"></div>

  <!-- Steam behind card -->
  <div class="steam" style="top:60%; left:50%;"></div>
  <div class="steam" style="top:65%; left:55%;"></div>
  <div class="steam" style="top:62%; left:45%;"></div>

  <!-- Floating Leaves -->
  <div class="floating-leaf" style="top:-50px; left:15%;"></div>
  <div class="floating-leaf" style="top:-50px; left:50%;"></div>
  <div class="floating-leaf" style="top:-50px; left:85%;"></div>

  <!-- Sparkles -->
  <div class="floating-sparkle" style="top:30%; left:10%;"></div>
  <div class="floating-sparkle" style="top:50%; left:70%;"></div>
  <div class="floating-sparkle" style="top:40%; left:40%;"></div>

  <!-- Login Card -->
  <div class="card">
    <h2>Login</h2>
    <form method="post" action="login">
      <label>Email
        <input name="email" type="email" required />
      </label>
      <label>Password
        <input name="password" type="password" required />
      </label>
      <button class="btn" type="submit">Login</button>
      <p>New here? <a href="register.jsp">Create an account</a></p>
    </form>
    <p class="error"><%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %></p>
    <p class="success"><%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %></p>
  </div>

</body>
</html>
