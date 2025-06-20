package controller.admin;

import dao.AccountDAO;
import dao.SecurityDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "AccountManagementServlet", urlPatterns = {"/admin/accounts"})
public class AccountManagementServlet extends HttpServlet {

    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String adminRole = (String) session.getAttribute("role");

        if (adminRole == null || !adminRole.equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action");
        String jspPath = "/WEB-INF/views/admin/admin_account_management.jsp";

        try {
            if ("details".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Account account = accountDAO.getAccountById(id);
                request.setAttribute("account", account);
                request.getRequestDispatcher("/WEB-INF/views/admin/account_details.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Account account = accountDAO.getAccountById(id);
                if (account == null) {
                    System.out.println("DEBUG: No account found for ID: " + id + ", Time: 10:10 PM +07 Wed Jun 18 2025");
                } else {
                    System.out.println("DEBUG: Retrieved account ID: " + account.getAccountID() + ", Role: " + account.getRole() + ", Customer: " + (account.getCustomer() != null ? "exists" : "null") + ", Time: 10:10 PM +07 Wed Jun 18 2025");
                    if ("customer".equals(account.getRole()) && account.getCustomer() != null) {
                        System.out.println("DEBUG: Phone: " + account.getCustomer().getPhone() + ", Address: " + account.getCustomer().getAddress() + ", Time: 10:10 PM +07 Wed Jun 18 2025");
                    } else if ("customer".equals(account.getRole())) {
                        System.out.println("DEBUG: Customer data not found for ID: " + id + ", Time: 10:10 PM +07 Wed Jun 18 2025");
                    }
                }
                request.setAttribute("account", account);
                request.getRequestDispatcher(jspPath).forward(request, response);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                accountDAO.deleteAccount(id);
                request.setAttribute("message", "Account deleted successfully.");
                doGet(request, response);
            } else {
                String search = request.getParameter("search");
                List<Account> staffAccounts, customerAccounts;
                if (search != null && !search.isEmpty()) {
                    staffAccounts = accountDAO.searchAccounts("staff", search);
                    customerAccounts = accountDAO.searchAccounts("customer", search);
                } else {
                    staffAccounts = accountDAO.getAllStaff();
                    customerAccounts = accountDAO.getAllCustomers();
                }
                request.setAttribute("staffAccounts", staffAccounts);
                request.setAttribute("customerAccounts", customerAccounts);
                String message = request.getParameter("message");
                if (message != null) {
                    request.setAttribute("message", message);
                }
                request.getRequestDispatcher(jspPath).forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String role = request.getParameter("role");

        try {
            if ("add".equals(action)) {
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                if (fullName == null || email == null || password == null) {
                    request.setAttribute("message", "All fields are required.");
                } else if (accountDAO.findByEmail(email) != null) {
                    request.setAttribute("message", "Email already exists.");
                } else {
                    String hashedPassword = SecurityDAO.hashPassword(password);
                    Account account = new Account(0, fullName, email, hashedPassword, 1, role, new Timestamp(System.currentTimeMillis()));
                    int accountID = accountDAO.insertAccount(account);
                    if (accountID > 0 && "customer".equals(role)) {
                        // Ensure Customer record is created (if not handled in insertAccount)
                        String sql = "INSERT INTO Customer (customerID, phone, address) VALUES (?, ?, ?)";
                        try (var conn = accountDAO.getConnection(); var ps = conn.prepareStatement(sql)) {
                            ps.setInt(1, accountID);
                            ps.setString(2, ""); // Default phone
                            ps.setString(3, ""); // Default address
                            ps.executeUpdate();
                        } catch (SQLException e) {
                            System.out.println("Error creating Customer record for ID: " + accountID + ", Time: 10:10 PM +07 Wed Jun 18 2025");
                            e.printStackTrace();
                        }
                    }
                    request.setAttribute("message", "Account added successfully.");
                }
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String fullName = request.getParameter("fullName");
                Account existingAccount = accountDAO.getAccountById(id);
                if (existingAccount != null) {
                    existingAccount.setFullName(fullName);

                    // Handle Staff-specific fields
                    if ("staff".equals(existingAccount.getRole())) {
                        accountDAO.updateAccount(existingAccount, null, 0, null, null, null);
                    }
                    // Handle Customer-specific fields
                    else if ("customer".equals(existingAccount.getRole())) {
                        String phone = request.getParameter("phone");
                        String address = request.getParameter("address");
                        accountDAO.updateAccount(existingAccount, null, 0, phone, address, null);
                    } else {
                        accountDAO.updateAccount(existingAccount, null, 0, null, null, null);
                    }
                    // Redirect with success message instead of forwarding
                    response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + java.net.URLEncoder.encode("Account updated successfully.", "UTF-8"));
                    return;
                } else {
                    System.out.println("DEBUG: Existing account not found for ID: " + id + ", Time: 10:10 PM +07 Wed Jun 18 2025");
                }
            } else if ("updateStatus".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int status = Integer.parseInt(request.getParameter("status"));
                Account account = accountDAO.getAccountById(id);
                if (account != null) {
                    account.setStatus(status);
                    accountDAO.updateAccount(account, null, 0, null, null, null);
                    request.setAttribute("message", "Status updated successfully.");
                }
            }

            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}