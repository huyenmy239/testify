function toggleSidebar() {
  const sidebar = document.getElementById("sidebar");
  const main = document.getElementById("main");
  const logo = document.querySelector(".sidebar-logo .logo");
  const logo_text = document.querySelector(".sidebar-logo .logo-text");
  const links = document.querySelectorAll(".sidebar .menu-a");

  if (sidebar.style.width === "80px") {
    sidebar.style.width = "200px";
    main.style.marginLeft = "200px";
    logo_text.style.display = "block";
    links.forEach((link) => (link.style.display = "block"));
  } else {
    sidebar.style.width = "80px";
    main.style.marginLeft = "80px";
    logo_text.style.display = "none";
    links.forEach((link) => (link.style.display = "none"));
  }
}

function toggleUserMenu() {
  const userMenu = document.getElementById("userMenu");
  userMenu.style.display =
    userMenu.style.display === "block" ? "none" : "block";
}

window.onclick = function (event) {
  if (!event.target.matches(".user-icon")) {
    const userMenu = document.getElementById("userMenu");
    if (userMenu.style.display === "block") {
      userMenu.style.display = "none";
    }
  }
};
