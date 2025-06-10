package com.dpt.demo;

import java.sql.*;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class LoginController {

    @Value("${spring.datasource.url}")
    private String url;

    @Value("${spring.datasource.username}")
    private String DBusername;

    @Value("${spring.datasource.password}")
    private String DBpassword;

    // GET: Show login form
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView showLoginForm() {
        return new ModelAndView("login"); // Maps to /WEB-INF/pages/login.jsp
    }

    // POST: Handle login attempt
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public ModelAndView login(String userName, String password) {
        ModelAndView mv = new ModelAndView("login");
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";

        try (Connection con = DriverManager.getConnection(url, DBusername, DBpassword);
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, userName);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                mv = new ModelAndView("user"); // user.jsp
                mv.addObject("username", rs.getString("username"));
            } else {
                mv.addObject("errorMessage", "Invalid username or password.");
            }

        } catch (SQLException e) {
            mv.addObject("errorMessage", "Database error: " + e.getMessage());
        }

        return mv;
    }
}
