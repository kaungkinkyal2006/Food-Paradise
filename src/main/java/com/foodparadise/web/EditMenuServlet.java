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
        String stockStr = request.getParameter("stock"); // get stock from form
        int stock = 0;
        try {
            stock = Integer.parseInt(stockStr);
        } catch (NumberFormatException e) {
            stock = 0; // fallback
        }

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

        MenuDAO dao = new MenuDAO();
        MenuItem existingItem = dao.getMenuItemById(id); // fetch existing item from DB
        if (existingItem == null) {
            response.getWriter().println("Item not found.");
            return;
        }

        // use old image if no new image uploaded
        imgUrl = existingItem.getImgUrl();

        if(filePart != null && filePart.getSize() > 0){
            String fileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/uploads/");
            File uploadDir = new File(uploadPath);
            if(!uploadDir.exists()) uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + fileName);
            imgUrl = "uploads/" + fileName;
        }

        // create updated MenuItem including stock
        MenuItem item = new MenuItem(id, categoryId, name, price, imgUrl, description, stock);
        boolean success = dao.updateMenuItem(item);

        if(success){
            response.sendRedirect("admin.jsp");
        } else {
            response.getWriter().println("Failed to update item.");
        }
    }
}
