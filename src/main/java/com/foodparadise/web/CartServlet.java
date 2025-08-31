package com.foodparadise.web;

import com.foodparadise.model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if(cart == null) cart = new ArrayList<>();

        // Check if item already exists
        boolean exists = false;
        for(CartItem item : cart){
            if(item.getId() == id){
                item.setQuantity(item.getQuantity() + quantity);
                exists = true;
                break;
            }
        }

        if(!exists){
            cart.add(new CartItem(id, name, price, quantity));
        }

        session.setAttribute("cart", cart);
        response.sendRedirect("cart.jsp");
    }
}
