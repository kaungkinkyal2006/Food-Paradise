package com.foodparadise.web;

import com.foodparadise.dao.PreOrderDao;
import com.foodparadise.model.User;
import com.foodparadise.model.PreOrder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/MyPreorderServlet")
public class MyPreorderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        System.out.println("Logged-in user ID (Preorder): " + user.getId());

        PreOrderDao dao = new PreOrderDao();
        List<PreOrder> orders = dao.getPreOrdersByUser(user.getId()); 
        // 👆 make sure PreOrderDao has this method

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("preorder.jsp").forward(request, response);
    }
}
