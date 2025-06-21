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
import model.Customer;
import java.io.IOException;
import java.net.URLEncoder;
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
                    System.out.println("DEBUG: No account found for ID: " + id + ", Time: " + new java.util.Date());
                } else {
                    System.out.println("DEBUG: Retrieved account ID: " + account.getAccountID() + ", Role: " + account.getRole() + ", Customer: " + (account.getCustomer() != null ? "exists" : "null") + ", Time: " + new java.util.Date());
                    if ("customer".equals(account.getRole()) && account.getCustomer() != null) {
                        System.out.println("DEBUG: Phone: " + account.getCustomer().getPhone() + ", Address: " + account.getCustomer().getAddress() + ", Time: " + new java.util.Date());
                    } else if ("customer".equals(account.getRole())) {
                        System.out.println("DEBUG: Customer data not found for ID: " + id + ", Time: " + new java.util.Date());
                    }
                }
                request.setAttribute("account", account);
                request.getRequestDispatcher(jspPath).forward(request, response);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                System.out.println("DEBUG: Attempting to delete account with ID: " + id);
                if (accountDAO.deleteAccount(id)) {
                    System.out.println("DEBUG: Successfully deleted account with ID: " + id);
                    response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + URLEncoder.encode("Account deleted successfully.", "UTF-8"));
                } else {
                    System.out.println("DEBUG: Failed to delete account with ID: " + id);
                    response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + URLEncoder.encode("Failed to delete account. Please try again.", "UTF-8"));
                }
            } else if ("updateStatus".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int status = Integer.parseInt(request.getParameter("status"));
                System.out.println("DEBUG: Attempting to update status for accountID: " + id + " to status: " + status);
                if (!accountDAO.updateStatus(id, status)) {
                    System.out.println("DEBUG: Failed to update status for accountID: " + id);
                    response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + URLEncoder.encode("Failed to update status. Please try again.", "UTF-8"));
                    return;
                }
                System.out.println("DEBUG: Successfully updated status for accountID: " + id);
                response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + URLEncoder.encode("Status updated successfully.", "UTF-8"));
            } else {
                String search = request.getParameter("search");
                String statusParam = request.getParameter("status");
                int status = statusParam != null && !statusParam.isEmpty() ? Integer.parseInt(statusParam) : -1; // -1 nghĩa là tất cả
                List<Account> staffAccounts, customerAccounts;
                if (search != null && !search.isEmpty()) {
                    if (status >= 0) {
                        staffAccounts = accountDAO.searchAccountsByStatus("staff", search, status);
                        customerAccounts = accountDAO.searchAccountsByStatus("customer", search, status);
                    } else {
                        staffAccounts = accountDAO.searchAccounts("staff", search);
                        customerAccounts = accountDAO.searchAccounts("customer", search);
                    }
                } else {
                    if (status >= 0) {
                        staffAccounts = accountDAO.getAccountsByStatus("staff", status);
                        customerAccounts = accountDAO.getAccountsByStatus("customer", status);
                    } else {
                        staffAccounts = accountDAO.getAllStaff();
                        customerAccounts = accountDAO.getAllCustomers();
                    }
                }
                request.setAttribute("staffAccounts", staffAccounts);
                request.setAttribute("customerAccounts", customerAccounts);
                String message = request.getParameter("message");
                if (message != null) {
                    request.setAttribute("message", java.net.URLDecoder.decode(message, "UTF-8"));
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
            if ("insert".equals(action)) {
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");

                // Kiểm tra các trường bắt buộc
                if (fullName == null || fullName.trim().isEmpty() || email == null || email.trim().isEmpty() || 
                    password == null || password.trim().isEmpty() || role == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + 
                        URLEncoder.encode("All required fields are missing.", "UTF-8"));
                    return;
                }
                if ("customer".equals(role) && (phone == null || phone.trim().isEmpty() || address == null || address.trim().isEmpty())) {
                    response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + 
                        URLEncoder.encode("Phone and address are required for customer.", "UTF-8"));
                    return;
                }
                if (accountDAO.findByEmail(email) != null) {
                    response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + 
                        URLEncoder.encode("Email already exists.", "UTF-8"));
                    return;
                }

                // Hash password và tạo tài khoản
                String hashedPassword = SecurityDAO.hashPassword(password);
                Account account = new Account(0, fullName, email, hashedPassword, 1, role, new Timestamp(System.currentTimeMillis()));
                int accountID = accountDAO.insertAccount(account);

                if (accountID > 0) {
                    if ("customer".equals(role)) {
                        // Tạo và cập nhật Customer với phone và address
                        Customer customer = new Customer();
                        customer.setCustomerID(accountID);
                        customer.setPhone(phone.trim());
                        customer.setAddress(address.trim());
                        System.out.println("DEBUG: Attempting to update Customer for accountID: " + accountID + ", phone: " + phone + ", address: " + address);
                        if (!accountDAO.updateCustomer(customer)) {
                            System.out.println("DEBUG: Failed to update Customer for accountID: " + accountID);
                            response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + 
                                URLEncoder.encode("Failed to update Customer record. Please try again.", "UTF-8"));
                            return;
                        }
                        System.out.println("DEBUG: Successfully updated Customer for accountID: " + accountID);
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + 
                        URLEncoder.encode("Account added successfully.", "UTF-8"));
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + 
                        URLEncoder.encode("Failed to add account. Please try again.", "UTF-8"));
                }
//            } else if ("edit".equals(action)) {
//                int id = Integer.parseInt(request.getParameter("id"));
//                String fullName = request.getParameter("fullName");
//                Account existingAccount = accountDAO.getAccountById(id);
//                if (existingAccount != null) {
//                    existingAccount.setFullName(fullName);
//
//                    if ("customer".equals(existingAccount.getRole())) {
//                        String phone = request.getParameter("phone");
//                        String address = request.getParameter("address");
//                        accountDAO.updateAccount(existingAccount, null, 0, phone, address, null);
//                    } else {
//                        accountDAO.updateAccount(existingAccount, null, 0, null, null, null);
//                    }
//                    response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + 
//                        URLEncoder.encode("Account updated successfully.", "UTF-8"));
//                } else {
//                    System.out.println("DEBUG: Existing account not found for ID: " + id + ", Time: " + new java.util.Date());
//                    response.sendRedirect(request.getContextPath() + "/admin/accounts?message=" + 
//                        URLEncoder.encode("Account not found.", "UTF-8"));
//                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}