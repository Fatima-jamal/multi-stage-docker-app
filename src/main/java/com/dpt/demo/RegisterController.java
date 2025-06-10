package com.dpt.demo;

import java.sql.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class RegisterController {

    @Value("${spring.datasource.url}")
    private String url;

    @Value("${spring.datasource.username}")
    private String DBusername;

    @Value("${spring.datasource.password}")
    private String DBpassword;

    @RequestMapping(value = "register", method = RequestMethod.GET)
    public ModelAndView registerform() {
        return new ModelAndView("register");
    }

    @RequestMapping(value = "register", method = RequestMethod.POST)
    public ModelAndView register(String email, String userName, String password) {

        ModelAndView mv = new ModelAndView("register");

        String sql = "INSERT INTO users (username, email, password, created_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";

        try (Connection con = DriverManager.getConnection(url, DBusername, DBpassword);
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, userName);
            ps.setString(2, email);
            ps.setString(3, password);

            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                mv.addObject("message", "User account created successfully for " + userName + "!");
            } else {
                mv.addObject("message", "Failed to create user.");
            }

        } catch (SQLException ex) {
            mv.addObject("message", "Database error: " + ex.getMessage());
        }

        return mv;
    }
}
