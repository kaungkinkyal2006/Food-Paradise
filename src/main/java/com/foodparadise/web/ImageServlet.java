package com.foodparadise.web;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet("/uploads/*")
public class ImageServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "/Users/7c/WorkSpace/food_paradise_uploads";
    //private static final String UPLOAD_DIR = "C:/Users/7c/WorkSpace/food_paradise_uploads";


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String filename = req.getPathInfo().substring(1); // /uploads/xxx.jpg -> xxx.jpg
        File file = new File(UPLOAD_DIR, filename);
        if (file.exists()) {
            resp.setContentType(getServletContext().getMimeType(filename));
            Files.copy(file.toPath(), resp.getOutputStream());
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
