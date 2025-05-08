# 🍱 OiShip Food Ordering System

OiShip is an online food ordering platform inspired by ShopeeFood, built using Java Servlet and JSP technology. It enables customers to browse restaurants, order food, and track orders, while supporting restaurant partners, delivery drivers, and admin management.

## Tech Stack

-   **Frontend**: JSP (Java Server Pages), Bootstrap 5
-   **Backend**: Java Servlet
-   **Database**: Microsoft SQL Server
-   **Server**: Apache Tomcat
-   **IDE**: NetBeans

## 📁 Project Structure

```
 WEB-INF/views/        # JSP files
 java/model/           # Java object classes
 java/controller/      # Java Servlets
 java/dao/             # Database functions
 java/util/            # DB connection and reusable functions
```

## 🛠️ Setup Instructions

### 1. Clone the Repository

-   Clone the repository to your local machine:

    ```bash
    git clone https://github.com/toanthienla/oiship-food-ordering.git
    ```

-   Navigate to the project directory:
    ```bash
    cd OiShipFoodOrdering
    ```

### 2. Requirements

-   Java JDK 8 or later
-   NetBeans (with Apache Tomcat configured)
-   Microsoft SQL Server
-   Apache Tomcat 10
-   Git (for version control)

### 3. Database Setup

1. Run the SQL script from `OishipFoodOrdering_DBScript.sql` to initialize tables.
2. Insert sample data from `ExampleData.sql`.

### 4. Environment Configuration

Create an `.env` file in `src/main/resources` with the following structure:

```env
DATABASE_NAME=
DATABASE_USERNAME=
DATABASE_PASSWORD=

GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GOOGLE_REDIRECT_URI=
GOOGLE_GRANT_TYPE=
GOOGLE_LINK_GET_TOKEN=
GOOGLE_LINK_GET_USER_INFO=

EMAIL_HOST=
EMAIL_PORT=
EMAIL_NAME=
EMAIL_APP_PASSWORD=
```

Replace the placeholders with your actual database credentials.

![Environment Configuration](images/envSetup.png)

### 5. Run the Project

1. Open the project in NetBeans.
2. Clean and build the project.
3. Deploy to Apache Tomcat.
4. Access the application at: `http://localhost:8080/OiShipFoodOrdering/`

### 6. Push Changes to the Repository

1. Stage your changes:
    ```bash
    git add .
    ```
2. Commit your changes with a descriptive message:
    ```bash
    git commit -m "Your commit message here"
    ```
3. Push changes to the remote repository:
    ```bash
    git push origin main
    ```

## 📝 JSP & Bootstrap Integration Notes

-   ✅ **JSP File Location**  
    Place all JSP files in the `WEB-INF/views/` directory.

-   🎨 **Include Bootstrap 5** in JSP files:

    ```html
    <header>
        <!-- Bootstrap 5 CSS & JS -->
        <link rel="stylesheet" href="css/bootstrap.css" />
        <script src="js/bootstrap.bundle.js"></script>

        <!-- Include Bootstrap Icons if you need icons -->
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
        />
    </header>
    ```

-   🧹 Clean Up NetBeans Templates
    Remove any auto-generated comments such as author names, creation dates, etc., when creating new files.
