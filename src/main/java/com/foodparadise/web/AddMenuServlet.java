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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/AddMenuServlet")
@MultipartConfig(fileSizeThreshold = 1024*1024, maxFileSize = 1024*1024*5, maxRequestSize = 1024*1024*10)
public class AddMenuServlet extends HttpServlet {

    private static final Map<String, Integer> CATEGORY_MAP = new HashMap<>();
    static {
        CATEGORY_MAP.put("Myanmar Food", 1);
        CATEGORY_MAP.put("Thai Food", 2);
        CATEGORY_MAP.put("Chinese Food", 3);
        CATEGORY_MAP.put("Cafe", 4);
        CATEGORY_MAP.put("Fruit Juice & Yogurt", 5);
        CATEGORY_MAP.put("Bubble Tea & Smoothie", 6);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Get form parameters
        String name = request.getParameter("name");
        String categoryName = request.getParameter("category");
        String priceStr = request.getParameter("price");
        String description = request.getParameter("description");

        if (name == null || categoryName == null || priceStr == null || name.trim().isEmpty()) {
            response.getWriter().println("Missing required fields.");
            return;
        }

        Integer categoryId = CATEGORY_MAP.get(categoryName);
        if (categoryId == null) {
            response.getWriter().println("Invalid category.");
            return;
        }

        double price;
        try {
            price = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            response.getWriter().println("Invalid price.");
            return;
        }

        // Handle image upload
        Part filePart = request.getPart("image");
        String imgUrl = null;
        if (filePart != null && filePart.getSize() > 0) {
            String originalFileName = Path.of(filePart.getSubmittedFileName()).getFileName().toString();
            String uniqueFileName = System.currentTimeMillis() + "_" + originalFileName;

            String uploadPath = "/Users/7c/WorkSpace/food_paradise_uploads";

            // These are for windows try one if one does not work and there is one more to fix in imageServlet
            //String uploadPath = "C:\\Users\\YourUsername\\WorkSpace\\food_paradise_uploads";
            //String uploadPath = "C:/Users/7c/WorkSpace/food_paradise_uploads";


            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            File file = new File(uploadDir, uniqueFileName);
            filePart.write(file.getAbsolutePath());

            imgUrl = "uploads/" + uniqueFileName; // Relative path for database
        }

        // Create MenuItem and save
        MenuItem item = new MenuItem(0, categoryId, name, price, imgUrl, description);
        MenuDAO dao = new MenuDAO();
        boolean success = dao.addMenuItem(item);

        if (success) {
            response.sendRedirect("admin.jsp"); // back to admin dashboard
        } else {
            response.getWriter().println("Failed to add item.");
        }
    }
}
