package com.foodparadise.web;

import com.foodparadise.dao.PreOrderDao;
import com.foodparadise.model.PreOrder;
import com.foodparadise.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/AdminPreOrderServlet")
public class AdminPreOrderServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        PreOrderDao dao = new PreOrderDao();
        List<PreOrder> orders = dao.getAllPreOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("adminPreOrders.jsp").forward(request, response);
    }
}
