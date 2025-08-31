package com.foodparadise.web;

import com.foodparadise.dao.AuthDAO;
import com.foodparadise.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/login", "/logout", "/register"})
public class AuthServlet extends HttpServlet {
    private AuthDAO authDAO = new AuthDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/login":
                handleLogin(req, resp);
                break;
            case "/register":
                handleRegister(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("/logout".equals(req.getServletPath())) {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        try {
            User user = authDAO.login(email, password);
            if (user != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("user", user);
                if ("ADMIN".equals(user.getRole())) {
                    resp.sendRedirect(req.getContextPath() + "/admin.jsp");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/menu.jsp");
                }
            } else {
                req.setAttribute("error", "Invalid credentials");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String role = req.getParameter("role"); // ADMIN or USER
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String address = req.getParameter("address");
        String phone = req.getParameter("phone");

        try {
            if (authDAO.emailExists(email)) {
                req.setAttribute("error", "Email already registered");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }
            int id = authDAO.registerUser(name, email, password, role, address, phone);
            req.setAttribute("success", "Registered! Please login.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
