package com.foodparadise.web;

import com.foodparadise.dao.OrderDAO;
import com.foodparadise.model.User;
import com.foodparadise.model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/MyOrdersServlet")
public class MyOrdersServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if(user == null){
            response.sendRedirect("login.jsp");
            return;
        }
        System.out.println("Logged-in user ID: " + user.getId());


        OrderDAO dao = new OrderDAO();
        List<Order> orders = dao.getOrdersByUser(user.getId());

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("myorders.jsp").forward(request, response);
    }
}
