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
    git clone https://github.com/toanthienla/OiShipFoodOrdering.git
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
DATABASE_NAME=YOUR_DATABASE_NAME
DATABASE_USERNAME=YOUR_DATABASE_USERNAME
DATABASE_PASSWORD=YOUR_DATABASE_PASSWORD
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

## 📝 Notes

-   JSP files must be placed in the `WEB-INF/views/` folder.
-   Include Bootstrap 5 in JSP files as follows:
    ```html
    <link rel="stylesheet" href="css/bootstrap.css" />
    <script src="js/bootstrap.bundle.js"></script>
    ```
