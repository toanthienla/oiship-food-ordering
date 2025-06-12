// adminSidebar.js

document.addEventListener('DOMContentLoaded', () => {
    const sidebar = document.getElementById('sidebar');
    const main = document.getElementById('main');
    const menuToggle = document.getElementById('menuToggle');
    const closeSidebar = document.getElementById('closeSidebar');

    const navLinks = sidebar.querySelectorAll('a.nav-link');
    const currentUrl = window.location.href;

    // Sidebar
    function toggleSidebar() {
        sidebar.classList.toggle('active');
        main.classList.toggle('sidebar-active');
    }
    function closeSidebarFunc() {
        sidebar.classList.remove('active');
        main.classList.remove('sidebar-active');
    }
    if (menuToggle)
        menuToggle.addEventListener('click', toggleSidebar);
    if (closeSidebar)
        closeSidebar.addEventListener('click', closeSidebarFunc);
    document.addEventListener('click', function (event) {
        if (window.innerWidth <= 768 && sidebar?.classList.contains('active')) {
            if (!sidebar.contains(event.target) && !menuToggle.contains(event.target)) {
                closeSidebarFunc();
            }
        }
    });

    // Sidebar item active
    navLinks.forEach(link => {
        if (currentUrl.includes(link.href)) {
            link.classList.add('active'); // or use a custom class like 'current'
        }
    });
});
