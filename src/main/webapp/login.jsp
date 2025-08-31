<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login — Food Paradise</title>
  <link rel="stylesheet" href="assets/login.css">
</head>
<body>
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
