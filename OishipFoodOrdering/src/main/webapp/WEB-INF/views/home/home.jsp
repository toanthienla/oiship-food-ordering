<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Home - Oiship</title>

        <!-- Bootstrap 5 -->
        <link rel="stylesheet" href="css/bootstrap.css" />
        <script src="js/bootstrap.bundle.js"></script>
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
            />

        <style>
            /* Custom CSS for Oiship Food Ordering System */
            :root {
                --primary-color: #EE5D11;
                --secondary-color: #EE5D11;
                --dark-color: #292F36;
                --light-color: #F7FFF7;
                --success-color: #2ECC71;
                --warning-color: #FFC107;
                --danger-color: #E74C3C;
            }

            body {
                font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                color: #333;
                background-color: white;
            }

            /* Navigation */
            .navbar-brand {
                font-weight: 700;
                font-size: 1.8rem;
                color: var(--primary-color);
            }

            .navbar-nav .nav-link {
                font-weight: 600;
                color: var(--dark-color);
                transition: all 0.3s ease;
            }

            .navbar-nav .nav-link:hover {
                color: var(--primary-color);
            }

            .navbar-nav .btn-order {
                background-color: var(--primary-color);
                color: white;
                padding: 8px 20px;
                transition: all 0.3s ease;
            }

            /* Hero Section */
            .hero {
                background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('images/food_1.webp');
                background-size: cover;
                background-position: center;
                color: white;
                padding: 100px 0;
                text-align: center;
            }

            .hero h1 {
                font-weight: 700;
                margin-bottom: 20px;
                font-size: 3.5rem;
            }

            .hero p {
                font-size: 1.2rem;
                margin-bottom: 30px;
                max-width: 600px;
                margin-left: auto;
                margin-right: auto;
            }

            /* Category Section */
            .category-section {
                padding: 80px 0;
            }

            .category-card {
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
                margin-bottom: 30px;
                cursor: pointer;
            }

            .category-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            }

            .category-card img {
                width: 100%;
                height: 200px;
                object-fit: cover;
            }

            .category-card .card-body {
                padding: 20px;
            }

            .category-card .card-title {
                font-weight: 600;
                margin-bottom: 10px;
            }

            /* How It Works Section */
            .how-it-works {
                background-color: #f2f2f2;
                padding: 80px 0;
            }

            .step-box {
                text-align: center;
                padding: 30px;
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
                height: 100%;
            }

            .step-box .step-number {
                display: inline-block;
                width: 60px;
                height: 60px;
                background-color: var(--secondary-color);
                color: white;
                font-size: 1.8rem;
                font-weight: 700;
                border-radius: 50%;
                line-height: 60px;
                margin-bottom: 20px;
            }

            .step-box h3 {
                margin-bottom: 15px;
                font-weight: 600;
            }

            /* Popular Items Section */
            .popular-items {
                padding: 80px 0;
            }

            .food-card {
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
                margin-bottom: 30px;
            }

            .food-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            }

            .food-card img {
                width: 100%;
                height: 200px;
                object-fit: cover;
            }

            .food-card .card-body {
                padding: 20px;
            }

            .food-card .card-title {
                font-weight: 600;
                margin-bottom: 5px;
            }

            .food-card .price {
                color: var(--primary-color);
                font-weight: 700;
                font-size: 1.2rem;
                margin-bottom: 15px;
            }

            .food-card .btn-order {
                background-color: var(--primary-color);
                color: white;
                border: none;
                border-radius: 25px;
                padding: 8px 20px;
                transition: all 0.3s ease;
            }

            /* Testimonials Section */
            .testimonials {
                background-color: var(--light-color);
                padding: 80px 0;
            }

            .testimonial-card {
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                padding: 30px;
                margin-bottom: 30px;
                height: 100%;
            }

            .testimonial-card .quote {
                font-size: 2rem;
                color: var(--primary-color);
                margin-bottom: 20px;
            }

            .testimonial-card .rating {
                color: #FFD700;
                margin-bottom: 15px;
            }

            .testimonial-card .customer-info {
                display: flex;
                align-items: center;
                margin-top: 20px;
            }

            .testimonial-card .customer-info img {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 15px;
            }

            .testimonial-card .customer-name {
                font-weight: 600;
                margin-bottom: 0;
            }

            /* Footer */
            .footer {
                background-color: var(--dark-color);
                color: white;
                padding: 60px 0 30px;
            }

            .footer h5 {
                font-weight: 600;
                margin-bottom: 20px;
                color: var(--secondary-color);
            }

            .footer p, .footer ul {
                opacity: 0.8;
            }

            .footer ul {
                list-style: none;
                padding-left: 0;
            }

            .footer ul li {
                margin-bottom: 10px;
            }

            .footer ul li a {
                color: white;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .footer ul li a:hover {
                color: white;
                text-decoration: none;
            }

            .social-icons {
                display: flex;
                margin-top: 20px;
            }

            .social-icons a {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background-color: rgba(255, 255, 255, 0.1);
                display: flex;
                justify-content: center;
                align-items: center;
                margin-right: 10px;
                color: white;
                transition: all 0.3s ease;
            }

            .social-icons a:hover {
                background-color: var(--secondary-color);
                color: white;
            }

            .copyright {
                text-align: center;
                margin-top: 40px;
                padding-top: 20px;
                border-top: 1px solid rgba(255, 255, 255, 0.1);
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .hero h1 {
                    font-size: 2.5rem;
                }

                .hero p {
                    font-size: 1rem;
                }
            }
            
            .logo {
                height: 50px;
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-light sticky-top bg-white">
            <div class="container">
                <a class="navbar-brand" href="home">
                    <img src="images/logo_1.png" alt="Oiship Logo" class="logo" />
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link active" href="">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="menu">Menu</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="contact">Contact</a>
                        </li>
                        <li class="nav-item ms-lg-3">
                            <a class="btn btn-order" href="login">
                                <i class="fas fa-shopping-cart me-1"></i> Order Now
                                <span class="badge bg-white text-primary rounded-pill ms-1 cart-badge d-none">0</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <section class="hero">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h1>Welcome to Oiship</h1>
                        <p>Discover delicious meals from your favorite restaurants, order with ease, and enjoy lightning-fast delivery.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- How It Works Section -->
        <section class="how-it-works" id="how-it-works">
            <div class="container">
                <div class="row mb-5">
                    <div class="col-md-12 text-center">
                        <h2 class="fw-bold">How It Works</h2>
                        <p class="text-muted">Simple steps to enjoy our delicious food at your doorstep</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 mb-4">
                        <div class="step-box">
                            <div class="step-number">1</div>
                            <h3>Choose Your Food</h3>
                            <p>Browse our menu and select your favorite Japanese dishes.</p>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="step-box">
                            <div class="step-number">2</div>
                            <h3>Place Your Order</h3>
                            <p>Easily place your order with just a few clicks.</p>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="step-box">
                            <div class="step-number">3</div>
                            <h3>Enjoy Your Meal</h3>
                            <p>We'll deliver right to your doorstep in minutes!</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Popular Items Section -->
        <section class="popular-items">
            <div class="container">
                <div class="row mb-5">
                    <div class="col-md-12 text-center">
                        <h2 class="fw-bold">Most Popular Items</h2>
                        <p class="text-muted">Loved by our customers, prepared by our expert chefs</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-3 col-md-6 col-sm-6 mb-4 food-item" data-category="sushi">
                        <div class="food-card">
                            <img src="https://cdn.pixabay.com/photo/2021/01/01/15/31/sushi-balls-5878892_640.jpg" class="card-img-top" alt="California Roll">
                            <div class="card-body">
                                <h5 class="card-title">California Roll</h5>
                                <p class="card-text">Crab, avocado and cucumber wrapped in seaweed and rice.</p>
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <span class="price">$12.99</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 col-sm-6 mb-4 food-item" data-category="ramen">
                        <div class="food-card">
                            <img src="https://cdn.pixabay.com/photo/2023/07/07/17/47/sushi-8113165_640.jpg" class="card-img-top" alt="Tonkotsu Ramen">
                            <div class="card-body">
                                <h5 class="card-title">Tonkotsu Ramen</h5>
                                <p class="card-text">Rich pork broth with tender chashu, soft-boiled egg, and noodles.</p>
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <span class="price">$15.99</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 col-sm-6 mb-4 food-item" data-category="sushi">
                        <div class="food-card">
                            <img src="https://cdn.pixabay.com/photo/2017/06/04/03/41/sushi-2370272_640.jpg" class="card-img-top" alt="Dragon Roll">
                            <div class="card-body">
                                <h5 class="card-title">Dragon Roll</h5>
                                <p class="card-text">Eel and cucumber topped with avocado and eel sauce.</p>
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <span class="price">$14.99</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 col-sm-6 mb-4 food-item" data-category="bento">
                        <div class="food-card">
                            <img src="https://cdn.pixabay.com/photo/2021/01/03/19/53/sushi-5885530_640.jpg" class="card-img-top" alt="Teriyaki Chicken Bento">
                            <div class="card-body">
                                <h5 class="card-title">Teriyaki Chicken Bento</h5>
                                <p class="card-text">Grilled chicken with teriyaki sauce, rice, and sides.</p>
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <span class="price">$16.99</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

<!--         Testimonials Section 
        <section class="testimonials" id="testimonials">
            <div class="container">
                <div class="row mb-5">
                    <div class="col-md-12 text-center">
                        <h2 class="fw-bold">What Our Customers Say</h2>
                        <p class="text-muted">Read reviews from our satisfied customers</p>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 mb-4">
                        <div class="testimonial-card">
                            <i class="fas fa-quote-left quote"></i>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                            <p>"The California rolls were absolutely delicious! Fresh ingredients and perfect delivery time. Will definitely order again!"</p>
                            <div class="customer-info">
                                <img src="https://randomuser.me/api/portraits/women/45.jpg" alt="Customer">
                                <div>
                                    <h5 class="customer-name">Sarah Johnson</h5>
                                    <small>Regular Customer</small>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="testimonial-card">
                            <i class="fas fa-quote-left quote"></i>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                            <p>"I ordered the Tonkotsu Ramen and it was incredible! The broth was rich and flavorful just like in Japan. Fast delivery too!"</p>
                            <div class="customer-info">
                                <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Customer">
                                <div>
                                    <h5 class="customer-name">Michael Chen</h5>
                                    <small>Food Enthusiast</small>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="testimonial-card">
                            <i class="fas fa-quote-left quote"></i>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                            </div>
                            <p>"The bento box was perfect for lunch! Great variety and portion size. The packaging kept everything fresh. Highly recommend!"</p>
                            <div class="customer-info">
                                <img src="https://randomuser.me/api/portraits/women/68.jpg" alt="Customer">
                                <div>
                                    <h5 class="customer-name">Emily Rodriguez</h5>
                                    <small>New Customer</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

         Footer 
        <footer class="footer">
            <div class="container">
                <div class="row">
                    <div class="col-lg-3 col-md-6 mb-4">
                        <h5>Oiship</h5>
                        <p>Delivering authentic Japanese cuisine straight to your doorstep, ensuring a delightful dining experience every time.</p>
                        <div class="social-icons">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-4">
                        <h5>Quick Links</h5>
                        <ul>
                            <li><a href="#">Home</a></li>
                            <li><a href="#menu">Menu</a></li>
                            <li><a href="#how-it-works">How It Works</a></li>
                            <li><a href="#testimonials">Testimonials</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-4">
                        <h5>Contact Us</h5>
                        <ul>
                            <li><i class="fas fa-map-marker-alt me-2"></i> 123 Sushi Street, Tokyo</li>
                            <li><i class="fas fa-phone me-2"></i> (123) 456-7890</li>
                            <li><i class="fas fa-envelope me-2"></i> info@oiship.com</li>
                        </ul>
                    </div>
                    <div class="col-lg-3 col-md-6 mb-4">
                        <h5>Opening Hours</h5>
                        <ul>
                            <li>Monday - Friday: 11am - 10pm</li>
                            <li>Saturday - Sunday: 10am - 11pm</li>
                        </ul>
                    </div>
                </div>
                <div class="copyright">
                    <p>&copy; 2023 Oiship. All rights reserved.</p>
                </div>
            </div>
        </footer>-->
    </body>

<!--    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Initialize Bootstrap tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });

            // Initialize Bootstrap carousels
            var testimonialCarousel = document.querySelector('#testimonialCarousel');
            if (testimonialCarousel) {
                new bootstrap.Carousel(testimonialCarousel);
            }

            // Add to cart functionality
            const addToCartButtons = document.querySelectorAll('.btn-order');
            let cartCount = 0;

            addToCartButtons.forEach(button => {
                button.addEventListener('click', function () {
                    cartCount++;
                    updateCartBadge(cartCount);

                    // Get product information
                    const card = this.closest('.food-card');
                    const productName = card.querySelector('.card-title').textContent;
                    const productPrice = card.querySelector('.price').textContent;

                    // Show notification
                    showNotification(`Added ${productName} to cart`);
                });
            });

            // Update cart badge function
            function updateCartBadge(count) {
                const cartBadge = document.querySelector('.cart-badge');
                if (cartBadge) {
                    cartBadge.textContent = count;
                    cartBadge.classList.remove('d-none');
                }
            }

            // Show notification function
            function showNotification(message) {
                const notification = document.createElement('div');
                notification.className = 'notification';
                notification.textContent = message;

                document.body.appendChild(notification);

                // Show the notification
                setTimeout(() => {
                    notification.classList.add('show');
                }, 10);

                // Remove the notification after 3 seconds
                setTimeout(() => {
                    notification.classList.remove('show');
                    setTimeout(() => {
                        document.body.removeChild(notification);
                    }, 300);
                }, 3000);
            }

            // Filter functionality for food categories
            const categoryButtons = document.querySelectorAll('.category-filter');

            categoryButtons.forEach(button => {
                button.addEventListener('click', function () {
                    const category = this.getAttribute('data-category');

                    // Remove active class from all buttons
                    categoryButtons.forEach(btn => btn.classList.remove('active'));

                    // Add active class to clicked button
                    this.classList.add('active');

                    // Filter food items
                    const foodItems = document.querySelectorAll('.food-item');

                    foodItems.forEach(item => {
                        if (category === 'all' || item.getAttribute('data-category') === category) {
                            item.style.display = 'block';
                        } else {
                            item.style.display = 'none';
                        }
                    });
                });
            });
        });
    </script>-->
</html>
