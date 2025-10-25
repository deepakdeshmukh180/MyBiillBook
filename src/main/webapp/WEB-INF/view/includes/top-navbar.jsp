<style>
    /* Top navbar */
    .top-navbar {
        height: var(--navbar-height);
        background: var(--card-bg);
        backdrop-filter: blur(20px);
        border-bottom: 1px solid var(--border-color);
        padding: 0 1.5rem;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: sticky;
        top: 0;
        z-index: 999;
    }

    .navbar-left {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .sidebar-toggle {
        background: none;
        border: none;
        color: var(--text-color);
        font-size: 1.2rem;
        cursor: pointer;
        padding: 0.5rem;
        border-radius: 8px;
        transition: all 0.2s ease;
    }

    .sidebar-toggle:hover {
        background: var(--glass-bg);
        color: var(--primary-color);
    }

    .navbar-right {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .theme-toggle {
        background: none;
        border: none;
        color: var(--text-color);
        font-size: 1.1rem;
        cursor: pointer;
        padding: 0.5rem;
        border-radius: 8px;
        transition: all 0.2s ease;
    }

    .theme-toggle:hover {
        background: var(--glass-bg);
        color: var(--primary-color);
    }
</style>

<!-- Top navbar -->
<header class="top-navbar">
    <div class="navbar-left">
        <button class="sidebar-toggle" id="sidebarToggle">
            <i class="fas fa-bars"></i>
        </button>
        <h1 class="h5 mb-0" id="pageTitle">Dashboard</h1>
    </div>
    <div class="navbar-right">
        <button class="theme-toggle" id="themeToggle" title="Toggle theme">
            <i class="fas fa-moon"></i>
        </button>
        <div class="dropdown">
            <button class="btn btn-link text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
                <i class="fas fa-user-circle fs-5"></i>
            </button>
            <ul class="dropdown-menu dropdown-menu-end">
                <li><a class="dropdown-item nav-link-dropdown" href="#" data-page="profile">Profile</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="#" onclick="logout()">Logout</a></li>
            </ul>
        </div>
    </div>
</header>