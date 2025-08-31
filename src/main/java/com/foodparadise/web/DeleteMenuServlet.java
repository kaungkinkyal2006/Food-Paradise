package com.foodparadise.web;

import com.foodparadise.dao.MenuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/DeleteMenuServlet")
public class DeleteMenuServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if(idStr == null){
            response.sendRedirect("admin.jsp");
            return;
        }

        int id = Integer.parseInt(idStr);
        MenuDAO dao = new MenuDAO();
        boolean success = dao.deleteMenuItem(id);

        if(success){
            response.sendRedirect("admin.jsp");
        } else {
            response.getWriter().println("Failed to delete item.");
        }
    }
}
