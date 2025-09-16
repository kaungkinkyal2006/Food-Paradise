package com.foodparadise.web;

import com.foodparadise.model.PreOrderCartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/PreOrderCartServlet")
public class PreOrderCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Add null checks for parameters
            String idParam = request.getParameter("id");
            String name = request.getParameter("name");
            String priceParam = request.getParameter("price");
            String quantityParam = request.getParameter("quantity");
            
            if (idParam == null || name == null || priceParam == null || quantityParam == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Missing required parameters");
                return;
            }

            int id = Integer.parseInt(idParam);
            double price = Double.parseDouble(priceParam);
            int quantity = Integer.parseInt(quantityParam);

            HttpSession session = request.getSession();
            List<PreOrderCartItem> cart = (List<PreOrderCartItem>) session.getAttribute("preorderCart");
            if (cart == null) cart = new ArrayList<>();

            // Check if item already exists in cart
            boolean exists = false;
            for (PreOrderCartItem item : cart) {
                if (item.getId() == id) {
                    item.setQuantity(item.getQuantity() + quantity);
                    exists = true;
                    break;
                }
            }

            // If not exists, add new item
            if (!exists) {
                // Use constructor without expectedDate
                cart.add(new PreOrderCartItem(id, name, price, quantity));
            }

            session.setAttribute("preorderCart", cart); // store separately from normal cart
            
            // Redirect back to preorder page
            response.sendRedirect("preorder.jsp");
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid number format: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace(); // Log the full stack trace
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Server error: " + e.getMessage());
        }
    }
}
