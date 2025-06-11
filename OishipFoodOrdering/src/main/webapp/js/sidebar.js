// adminSidebar.js

document.addEventListener('DOMContentLoaded', () => {
    const sidebar = document.getElementById('sidebar');
    const main = document.getElementById('main');
    const menuToggle = document.getElementById('menuToggle');
    const closeSidebar = document.getElementById('closeSidebar');
    const notificationIcon = document.getElementById('notificationIcon');
    const notificationPopup = document.getElementById('notificationPopup');
    const closeNotification = document.getElementById('closeNotification');

    function toggleSidebar() {
        sidebar.classList.toggle('active');
        main.classList.toggle('sidebar-active');
    }

    function closeSidebarFunc() {
        sidebar.classList.remove('active');
        main.classList.remove('sidebar-active');
    }

    function toggleNotification() {
        notificationPopup.classList.toggle('active');
    }

    function closeNotificationFunc() {
        notificationPopup.classList.remove('active');
    }

    if (menuToggle) menuToggle.addEventListener('click', toggleSidebar);
    if (closeSidebar) closeSidebar.addEventListener('click', closeSidebarFunc);
    if (notificationIcon) {
        notificationIcon.addEventListener('click', (e) => {
            e.stopPropagation();
            toggleNotification();
        });
    }
    if (closeNotification) closeNotification.addEventListener('click', closeNotificationFunc);

    document.addEventListener('click', function (event) {
        if (window.innerWidth <= 768 && sidebar?.classList.contains('active')) {
            if (!sidebar.contains(event.target) && !menuToggle.contains(event.target)) {
                closeSidebarFunc();
            }
        }
        if (!notificationPopup.contains(event.target) && !notificationIcon.contains(event.target)) {
            closeNotificationFunc();
        }
    });
});
