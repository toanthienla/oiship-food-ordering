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
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import com.google.gson.Gson;

@WebServlet(name = "AccountManagementServlet", urlPatterns = {"/admin/accounts"})
public class AccountManagementServlet extends HttpServlet {

    private AccountDAO accountDAO = new AccountDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String adminRole = (String) session.getAttribute("role");

        // Kiểm tra quyền admin
        if (adminRole == null || !adminRole.equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action");
        String jspPath = "/WEB-INF/views/admin/admin_account_management.jsp";

        try {
            if ("details".equals(action)) {
                // Hiển thị chi tiết tài khoản
                int id = Integer.parseInt(request.getParameter("id"));
                Account account = accountDAO.getAccountById(id);
                if (account == null) {
                    request.setAttribute("message", "Account not found.");
                    redirectWithParams(request, response);
                    return;
                }
                request.setAttribute("account", account);
                request.getRequestDispatcher(jspPath).forward(request, response);
            } else if ("delete".equals(action)) {
                // Xóa một tài khoản (dựa trên vai trò của tài khoản)
                int id = Integer.parseInt(request.getParameter("id"));
                Account account = accountDAO.getAccountById(id);
                if (account == null) {
                    request.setAttribute("message", "Account not found.");
                } else {
                    boolean success = false;
                    if ("customer".equals(account.getRole())) {
                        success = accountDAO.deleteCustomerById(id);
                    } else if ("staff".equals(account.getRole())) {
                        success = accountDAO.deleteStaffById(id);
                    } else {
                        request.setAttribute("message", "Deletion not allowed for this role.");
                    }

                    if (success) {
                        request.setAttribute("message", "Account deleted successfully.");
                    } else {
                        List<String> constraints = accountDAO.checkForeignKeyConstraints(id);
                        if (!constraints.isEmpty()) {
                            request.setAttribute("message", "Failed to delete account: Related records found in tables: " + String.join(", ", constraints));
                        } else {
                            request.setAttribute("message", "Failed to delete account: Unknown error.");
                        }
                    }
                }
                redirectWithParams(request, response);
            } else if ("deleteSelected".equals(action)) {
                // Xóa nhiều tài khoản
                String[] ids = request.getParameter("ids").split(",");
                List<String> errors = new ArrayList<>();
                for (String idStr : ids) {
                    try {
                        int id = Integer.parseInt(idStr);
                        Account account = accountDAO.getAccountById(id);
                        if (account != null) {
                            boolean success = false;
                            if ("customer".equals(account.getRole())) {
                                success = accountDAO.deleteCustomerById(id);
                            } else if ("staff".equals(account.getRole())) {
                                success = accountDAO.deleteStaffById(id);
                            } else {
                                errors.add("Account ID " + id + ": Deletion not allowed for this role.");
                                continue;
                            }

                            if (!success) {
                                List<String> constraints = accountDAO.checkForeignKeyConstraints(id);
                                if (!constraints.isEmpty()) {
                                    errors.add("Account ID " + id + ": Related records in " + String.join(", ", constraints));
                                } else {
                                    errors.add("Account ID " + id + ": Unknown error.");
                                }
                            }
                        } else {
                            errors.add("Account ID " + id + ": Not found.");
                        }
                    } catch (NumberFormatException e) {
                        errors.add("Invalid ID: " + idStr);
                    }
                }
                if (errors.isEmpty()) {
                    request.setAttribute("message", "Selected accounts deleted successfully.");
                } else {
                    request.setAttribute("message", "Failed to delete some accounts: " + String.join("; ", errors));
                }
                redirectWithParams(request, response);
            } else if ("updateStatus".equals(action)) {
                // Cập nhật trạng thái tài khoản
                int id = Integer.parseInt(request.getParameter("id"));
                int status = Integer.parseInt(request.getParameter("status"));
                if (status != 1 && status != 0 && status != -1) {
                    status = 0;
                    System.out.println("Invalid status value " + request.getParameter("status") + " for accountID " + id + ". Defaulting to 0 (inactive).");
                }
                Account account = accountDAO.getAccountById(id);
                if (account != null) {
                    account.setStatus(status);
                    accountDAO.updateAccount(account, null, 0, null, null, null);
                    request.setAttribute("message", "Status updated successfully.");
                } else {
                    request.setAttribute("message", "Account not found.");
                }
                redirectWithParams(request, response);
            } else {
                // Hiển thị danh sách tài khoản với lọc
                String search = request.getParameter("search");
                String filterStatus = request.getParameter("filterStatus");
                System.out.println("Filter Status: " + filterStatus + ", Search: " + search);

                List<Account> staffAccounts;
                List<Account> customerAccounts;

                // Lấy danh sách tài khoản dựa trên tìm kiếm
                if (search != null && !search.trim().isEmpty()) {
                    staffAccounts = accountDAO.searchAccounts("staff", search.trim());
                    customerAccounts = accountDAO.searchAccounts("customer", search.trim());
                } else {
                    staffAccounts = accountDAO.getAccountsByRole("staff");
                    customerAccounts = accountDAO.getAccountsByRole("customer");
                }

                // Áp dụng lọc theo trạng thái
                if (filterStatus != null && !filterStatus.isEmpty()) {
                    try {
                        int statusValue = Integer.parseInt(filterStatus);
                        staffAccounts = staffAccounts.stream()
                                .filter(a -> a.getStatus() == statusValue)
                                .collect(Collectors.toList());
                        customerAccounts = customerAccounts.stream()
                                .filter(a -> a.getStatus() == statusValue)
                                .collect(Collectors.toList());
                    } catch (NumberFormatException e) {
                        System.out.println("Invalid filterStatus value: " + filterStatus);
                        // Không áp dụng lọc nếu filterStatus không hợp lệ
                    }
                }

                request.setAttribute("staffAccounts", staffAccounts);
                request.setAttribute("customerAccounts", customerAccounts);
                request.getRequestDispatcher(jspPath).forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid ID or status format: " + e.getMessage());
            redirectWithParams(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            redirectWithParams(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        try {
            if ("insert".equals(action)) {
                // Thêm tài khoản mới
                String role = request.getParameter("role");
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                if (fullName == null || fullName.trim().isEmpty() || email == null || email.trim().isEmpty()
                        || password == null || password.trim().isEmpty()) {
                    if (isAjax) {
                        sendJsonResponse(response, false, "All fields are required.");
                    } else {
                        request.setAttribute("message", "All fields are required.");
                    }
                } else if (accountDAO.findByEmail(email) != null) {
                    if (isAjax) {
                        sendJsonResponse(response, false, "Email already exists.");
                    } else {
                        request.setAttribute("message", "Email already exists.");
                    }
                } else {
                    String hashedPassword = SecurityDAO.hashPassword(password);
                    Account account = new Account(0, fullName.trim(), email.trim(), hashedPassword, 1, role,
                            new Timestamp(System.currentTimeMillis()));

                    if ("customer".equals(role)) {
                        String phone = request.getParameter("phone");
                        String address = request.getParameter("address");
                        if (phone == null || phone.trim().isEmpty() || address == null || address.trim().isEmpty()) {
                            if (isAjax) {
                                sendJsonResponse(response, false, "Phone and address are required for customer.");
                            } else {
                                request.setAttribute("message", "Phone and address are required for customer.");
                            }
                        } else {
                            // Gọi phương thức insertAccount với phone và address
                            int accountId = accountDAO.insertAccount(account, phone.trim(), address.trim());
                            if (accountId > 0) {
                                if (isAjax) {
                                    sendJsonResponse(response, true, role + " added successfully.");
                                } else {
                                    request.setAttribute("message", role + " added successfully.");
                                }
                            } else {
                                if (isAjax) {
                                    sendJsonResponse(response, false, "Failed to add customer.");
                                } else {
                                    request.setAttribute("message", "Failed to add customer.");
                                }
                            }
                        }
                    } else {
                        // Gọi phương thức insertAccount cho staff mà không cần phone và address
                        int accountId = accountDAO.insertAccount(account, null, null);
                        if (accountId > 0) {
                            if (isAjax) {
                                sendJsonResponse(response, true, role + " added successfully.");
                            } else {
                                request.setAttribute("message", role + " added successfully.");
                            }
                        } else {
                            if (isAjax) {
                                sendJsonResponse(response, false, "Failed to add staff.");
                            } else {
                                request.setAttribute("message", "Failed to add staff.");
                            }
                        }
                    }
                }
                
            } else if ("edit".equals(action)) {
                // Sửa tài khoản
                int id = Integer.parseInt(request.getParameter("id"));
                String fullName = request.getParameter("fullName");
                int status = Integer.parseInt(request.getParameter("status"));
                String role = request.getParameter("role");

                if (status != 1 && status != 0 && status != -1) {
                    status = 0;
                    System.out.println("Invalid status value " + request.getParameter("status") + " for accountID " + id + ". Defaulting to 0 (inactive).");
                }

                if (fullName == null || fullName.trim().isEmpty()) {
                    if (isAjax) {
                        sendJsonResponse(response, false, "Full name is required.");
                    } else {
                        request.setAttribute("message", "Full name is required.");
                    }
                } else {
                    Account account = accountDAO.getAccountById(id);
                    if (account == null) {
                        if (isAjax) {
                            sendJsonResponse(response, false, "Account not found.");
                        } else {
                            request.setAttribute("message", "Account not found.");
                        }
                    } else {
                        account.setFullName(fullName.trim());
                        account.setStatus(status);

                        if ("customer".equals(role)) {
                            String phone = request.getParameter("phone");
                            String address = request.getParameter("address");
                            if (phone == null || phone.trim().isEmpty() || address == null || address.trim().isEmpty()) {
                                if (isAjax) {
                                    sendJsonResponse(response, false, "Phone and address are required for customer.");
                                } else {
                                    request.setAttribute("message", "Phone and address are required for customer.");
                                }
                            } else {
                                Customer customer = account.getCustomer();
                                if (customer == null) {
                                    customer = new Customer();
                                    customer.setCustomerID(id);
                                    account.setCustomer(customer);
                                }
                                customer.setPhone(phone.trim());
                                customer.setAddress(address.trim());
                                accountDAO.updateAccount(account, null, 0, phone.trim(), address.trim(), null);
                                if (isAjax) {
                                    sendJsonResponse(response, true, "Customer account updated successfully.");
                                } else {
                                    request.setAttribute("message", "Customer account updated successfully.");
                                }
                            }
                        } else {
                            accountDAO.updateAccount(account, null, 0, null, null, null);
                            if (isAjax) {
                                sendJsonResponse(response, true, "Staff account updated successfully.");
                            } else {
                                request.setAttribute("message", "Staff account updated successfully.");
                            }
                        }
                    }
                }
            } else if ("deleteCustomer".equals(action)) {
                // Xóa khách hàng
                int customerId = Integer.parseInt(request.getParameter("id"));
                boolean success = accountDAO.deleteCustomerById(customerId); // Gọi phương thức xóa khách hàng riêng
                if (success) {
                    if (isAjax) {
                        sendJsonResponse(response, true, "Customer deleted successfully.");
                    } else {
                        request.setAttribute("message", "Customer deleted successfully.");
                    }
                } else {
                    List<String> constraints = accountDAO.checkForeignKeyConstraints(customerId);
                    if (!constraints.isEmpty()) {
                        if (isAjax) {
                            sendJsonResponse(response, false, "Failed to delete customer: Related records found in tables: " + String.join(", ", constraints));
                        } else {
                            request.setAttribute("message", "Failed to delete customer: Related records found in tables: " + String.join(", ", constraints));
                        }
                    } else {
                        if (isAjax) {
                            sendJsonResponse(response, false, "Failed to delete customer: Unknown error.");
                        } else {
                            request.setAttribute("message", "Failed to delete customer: Unknown error.");
                        }
                    }
                }
            } else if ("deleteStaff".equals(action)) {
                // Xóa nhân viên
                int staffId = Integer.parseInt(request.getParameter("id"));
                boolean success = accountDAO.deleteStaffById(staffId); // Gọi phương thức xóa nhân viên riêng
                if (success) {
                    if (isAjax) {
                        sendJsonResponse(response, true, "Staff deleted successfully.");
                    } else {
                        request.setAttribute("message", "Staff deleted successfully.");
                    }
                } else {
                    List<String> constraints = accountDAO.checkForeignKeyConstraints(staffId);
                    if (!constraints.isEmpty()) {
                        if (isAjax) {
                            sendJsonResponse(response, false, "Failed to delete staff: Related records found in tables: " + String.join(", ", constraints));
                        } else {
                            request.setAttribute("message", "Failed to delete staff: Related records found in tables: " + String.join(", ", constraints));
                        }
                    } else {
                        if (isAjax) {
                            sendJsonResponse(response, false, "Failed to delete staff: Unknown error.");
                        } else {
                            request.setAttribute("message", "Failed to delete staff: Unknown error.");
                        }
                    }
                }
            }

            if (!isAjax) {
                redirectWithParams(request, response);
            }
        } catch (NumberFormatException e) {
            if (isAjax) {
                sendJsonResponse(response, false, "Invalid ID format: " + e.getMessage());
            } else {
                request.setAttribute("message", "Invalid ID format: " + e.getMessage());
                redirectWithParams(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax) {
                sendJsonResponse(response, false, "Error: " + e.getMessage());
            } else {
                request.setAttribute("message", "Error: " + e.getMessage());
                redirectWithParams(request, response);
            }
        }
    }

    // Phương thức hỗ trợ chuyển hướng với các tham số
    private void redirectWithParams(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String filterStatus = request.getParameter("filterStatus");
        String search = request.getParameter("search");
        String tab = request.getParameter("tab");
        String redirectUrl = request.getContextPath() + "/admin/accounts?filterStatus="
                + (filterStatus != null ? filterStatus : "")
                + "&search=" + (search != null ? search : "")
                + "&tab=" + (tab != null ? tab : "staff-tab");
        response.sendRedirect(redirectUrl);
    }

    // Phương thức gửi phản hồi JSON
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        String jsonResponse = gson.toJson(new ResponseMessage(success, message));
        out.print(jsonResponse);
        out.flush();
    }

    // Lớp nội bộ để tạo đối tượng JSON
    private static class ResponseMessage {

        private boolean success;
        private String message;

        public ResponseMessage(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        // Getters (required for Gson)
        public boolean isSuccess() {
            return success;
        }

        public String getMessage() {
            return message;
        }
    }
}
