<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Contact - Oiship</title>

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

            /* Additional CSS for contact page */
            .contact-form {
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
                padding: 40px;
                margin-bottom: 30px;
            }

            .contact-info {
                background-color: #FF6B6B;
                border-radius: 10px;
                color: white;
                padding: 40px;
                height: 100%;
            }

            .contact-info h4 {
                margin-bottom: 20px;
                font-weight: 600;
            }

            .contact-info i {
                margin-right: 10px;
                font-size: 18px;
            }

            .contact-info .info-item {
                margin-bottom: 20px;
            }

            .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.25rem rgba(255, 107, 107, 0.25);
            }

            .btn-submit {
                background-color: var(--primary-color);
                color: white;
                border: none;
                border-radius: 5px;
                padding: 10px 25px;
                font-weight: 600;
                transition: all 0.3s ease;
            }
            .btn-submit:hover {
                background-color: var(--primary-color);
                color: white;
            }

            .contact-hero {
                background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('https://cdn.pixabay.com/photo/2017/06/05/18/58/sushi-2374913_640.jpg');
                background-size: cover;
                background-position: center;
                color: white;
                padding: 80px 0;
                text-align: center;
                margin-bottom: 60px;
            }
            .logo {
                height: 50px;
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top">
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
                            <a class="nav-link active" href="home">Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="menu">Menu</a>
                        </li>
                        <li class="nav-item active">
                            <a class="nav-link" href="">Contact</a>
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

        <!-- Contact Hero Section -->
        <section class="contact-hero">
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h1>Get in Touch with Oiship</h1>
                        <p>Have a question, feedback, or need support? We're here to help! Fill out the form below and our team will get back to you as soon as possible.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Contact Section -->
        <section class="contact-section mb-5">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12 mb-4">
                        <div class="contact-form">
                            <h3 class="mb-4">Send us a Message</h3>
                            <form id="contactForm">
                                <div class="mb-3">
                                    <label for="name" class="form-label">Full Name</label>
                                    <input type="text" class="form-control" id="name" placeholder="Enter your name" required>
                                    <div class="invalid-feedback">Please enter your name</div>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="email" placeholder="Enter your email" required>
                                    <div class="invalid-feedback">Please enter a valid email</div>
                                </div>
                                <div class="mb-3">
                                    <label for="subject" class="form-label">Subject</label>
                                    <input type="text" class="form-control" id="subject" placeholder="Enter subject" required>
                                    <div class="invalid-feedback">Please enter a subject</div>
                                </div>
                                <div class="mb-4">
                                    <label for="message" class="form-label">Message</label>
                                    <textarea class="form-control" id="message" rows="5" placeholder="Enter your message" required></textarea>
                                    <div class="invalid-feedback">Please enter your message</div>
                                </div>
                                <button type="submit" class="btn btn-submit">Send Message</button>
                                <div class="mt-3" id="formMessage"></div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="row mt-5">
                    <div class="col-12">
                        <h3 class="mb-4 text-center">Our Location</h3>
                        <div class="map-container">
                            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3929.053290299664!2d105.72985131148342!3d10.012457072777169!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31a0882139720a77%3A0x3916a227d0b95a64!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBGUFQgQ-G6p24gVGjGoQ!5e0!3m2!1sen!2s!4v1747302767234!5m2!1sen!2s" width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>

                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
<!--        <footer class="footer mt-5">
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
                            <li><a href="index.html">Home</a></li>
                            <li><a href="index.html#menu">Menu</a></li>
                            <li><a href="contact.html">Contact</a></li>
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

        <script>
            // Contact Form Validation and Submission
            document.addEventListener('DOMContentLoaded', function () {
                const contactForm = document.getElementById('contactForm');
                const formMessage = document.getElementById('formMessage');

                contactForm.addEventListener('submit', function (event) {
                    event.preventDefault();

                    // Simple validation
                    let isValid = true;
                    const name = document.getElementById('name');
                    const email = document.getElementById('email');
                    const subject = document.getElementById('subject');
                    const message = document.getElementById('message');

                    // Check each field
                    if (!name.value.trim()) {
                        name.classList.add('is-invalid');
                        isValid = false;
                    } else {
                        name.classList.remove('is-invalid');
                        name.classList.add('is-valid');
                    }

                    if (!email.value.trim() || !isValidEmail(email.value)) {
                        email.classList.add('is-invalid');
                        isValid = false;
                    } else {
                        email.classList.remove('is-invalid');
                        email.classList.add('is-valid');
                    }

                    if (!subject.value.trim()) {
                        subject.classList.add('is-invalid');
                        isValid = false;
                    } else {
                        subject.classList.remove('is-invalid');
                        subject.classList.add('is-valid');
                    }

                    if (!message.value.trim()) {
                        message.classList.add('is-invalid');
                        isValid = false;
                    } else {
                        message.classList.remove('is-invalid');
                        message.classList.add('is-valid');
                    }

                    // If form is valid, submit (simulate)
                    if (isValid) {
                        formMessage.innerHTML = '<div class="alert alert-success">Your message has been sent successfully! We\'ll get back to you soon.</div>';
                        contactForm.reset();

                        // Remove validation classes
                        document.querySelectorAll('.is-valid').forEach(element => {
                            element.classList.remove('is-valid');
                        });

                        // Hide success message after 5 seconds
                        setTimeout(() => {
                            formMessage.innerHTML = '';
                        }, 5000);
                    } else {
                        formMessage.innerHTML = '<div class="alert alert-danger">Please fill all required fields correctly.</div>';
                    }
                });

                // Email validation helper function
                function isValidEmail(email) {
                    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    return emailPattern.test(email);
                }
            });
        </script>

    </body>
</html>
