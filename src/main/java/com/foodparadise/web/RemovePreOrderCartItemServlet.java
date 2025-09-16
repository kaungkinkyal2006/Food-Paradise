package com.foodparadise.web;

import com.foodparadise.model.CartItem;
import com.foodparadise.model.PreOrderCartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/RemovePreOrderCartItemServlet")
public class RemovePreOrderCartItemServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        List<PreOrderCartItem> cart = (List<PreOrderCartItem>) session.getAttribute("preorderCart"); // ✅
        if(cart != null){
            int index = Integer.parseInt(req.getParameter("index"));
            if(index >= 0 && index < cart.size()){
                cart.remove(index);
                session.setAttribute("preorderCart", cart); // ✅ Fixed attribute name
            }
        }
        resp.sendRedirect("preorder.jsp"); // ✅ Fixed redirect
    }
}