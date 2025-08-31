package com.foodparadise.web;

import com.foodparadise.dao.OrderDAO;
import com.foodparadise.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/UpdateOrderStatusServlet")
public class UpdateOrderStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if(user == null){
            response.sendRedirect("login.jsp");
            return;
        }

        String orderIdParam = request.getParameter("orderId");
        if(orderIdParam == null || orderIdParam.isEmpty()){
            response.sendRedirect("MyOrdersServlet");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            OrderDAO dao = new OrderDAO();
            boolean updated = dao.updateOrderStatus(orderId, "ARRIVED");

            if(updated){
                response.sendRedirect("MyOrdersServlet");
            } else {
                System.out.println("Failed to update orderId=" + orderId);
                response.getWriter().write("Failed to update status. Please try again.");
            }
        } catch(Exception e){
            e.printStackTrace();
            response.getWriter().write("Invalid request.");
        }
    }
}
