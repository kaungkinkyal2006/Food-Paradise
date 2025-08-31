package com.foodparadise.web;

import com.foodparadise.dao.MenuDAO;
import com.foodparadise.model.MenuItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.Map;

@WebServlet("/EditMenuServlet")
@MultipartConfig
public class EditMenuServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String categoryName = request.getParameter("category");
        String priceStr = request.getParameter("price");
        String description = request.getParameter("description");

        double price = Double.parseDouble(priceStr);

        // map category name to ID
        Map<String,Integer> categoryMap = Map.of(
                "Myanmar Food",1, "Thai Food",2, "Chinese Food",3,
                "Cafe",4, "Fruit Juice & Yogurt",5, "Bubble Tea & Smoothie",6
        );
        int categoryId = categoryMap.getOrDefault(categoryName, 0);

        // handle image
        Part filePart = request.getPart("image");
        String imgUrl = null;
        if(filePart != null && filePart.getSize() > 0){
            String fileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/uploads/");
            File uploadDir = new File(uploadPath);
            if(!uploadDir.exists()) uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + fileName);
            imgUrl = "uploads/" + fileName;
        }

        MenuDAO dao = new MenuDAO();
        MenuItem item = new MenuItem(id, categoryId, name, price, imgUrl, description);
        boolean success = dao.updateMenuItem(item);

        if(success){
            response.sendRedirect("admin.jsp");
        } else {
            response.getWriter().println("Failed to update item.");
        }
    }
}
