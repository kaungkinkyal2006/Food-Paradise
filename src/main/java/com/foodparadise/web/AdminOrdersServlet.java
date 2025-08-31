package com.foodparadise.web;

import com.foodparadise.dao.OrderDAO;
import com.foodparadise.model.Order;
import com.foodparadise.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/AdminOrdersServlet")
public class AdminOrdersServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        OrderDAO dao = new OrderDAO();
        List<Order> orders = dao.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("adminOrders.jsp").forward(request, response);
    }
}
