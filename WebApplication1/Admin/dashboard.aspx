<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="dashboard.aspx.cs" Inherits="WebApplication1.Admin.dashboard" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Calorie Tracking System - Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <style>
        /* ===== Global Variables & Reset ===== */
        *{margin:0;padding:0;box-sizing:border-box}
        :root{
            --bg:#ffffff; --fg:#333; --muted:#777;
            --panel:#fff; --panel-border:#ddd; --topbar:#fff;
            --accent:#ff6f00; --accent-2:#ff9800; --shadow:0 2px 6px rgba(0,0,0,.06);
            --card-border:5px solid var(--accent); --table-grid:#eee;
        }
        body{ font-family:Arial,sans-serif; color:var(--fg); background:var(--bg); display:flex; height:100vh; overflow:hidden;}
        body.dark{--bg:#0f0f12;--fg:#f5f7fb;--muted:#b8beca;--panel:#17181c;--panel-border:#2b2d34;--topbar:#121318;--accent:#ff9800;--accent-2:#ffb74d;--shadow:0 10px 24px rgba(0,0,0,.35);--table-grid:#2a2d33;}


        table tbody tr {
    position: relative;
    overflow: hidden;
}

.table tbody tr::after {
    content: '';
    position: absolute;
    top: 0; left: 0;
    width: 100%; height: 100%;
    pointer-events: none;
    background: radial-gradient(circle, rgba(255,255,255,0.4) 0%, transparent 80%);
    opacity: 0;
    transform: scale(0.5);
    transition: opacity 0.3s ease, transform 0.3s ease;
}

.table tbody tr:hover::after {
    opacity: 1;
    transform: scale(1.5);
    animation: sparkle 1s infinite alternate;
}

@keyframes sparkle {
    0% {opacity: 0.6; transform: scale(1.3);}
    50% {opacity: 0.3; transform: scale(1.5);}
    100% {opacity: 0.6; transform: scale(1.2);}
}

/* Sidebar links hover glow */
.navlink {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px;
    text-decoration: none;
    color: #555;
    border-radius: 10px;
    transition: all 0.3s ease; /* smooth transition */
    font-weight: 600;
}
.navlink:hover {
    background: rgba(255, 111, 0, 0.12);
    color: var(--accent);
    transform: translateX(4px);
    box-shadow: 0 0 12px rgba(255, 111, 0, 0.5); /* subtle glow */
}
body.dark .navlink:hover {
    background: rgba(0, 255, 153, 0.12);
    box-shadow: 0 0 12px rgba(0, 255, 153, 0.5);
}

/* Sidebar collapse/expand transition */
.sidebar {
    transition: width 0.3s ease, transform 0.3s ease, box-shadow 0.3s ease;
}

.btn {
    padding: 8px 12px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 700;
    transition: all 0.25s ease;
    position: relative;
}

.btn-delete {
    background: #e74c3c;
    color: #fff;
}
.btn-delete:hover {
    background: #c0392b;
    box-shadow: 0 0 8px #e74c3c, 0 0 16px #e74c3c; /* red neon glow */
    transform: translateY(-2px);
}

.btn-confirm {
    background: #28a745;
    color: #fff;
}
.btn-confirm:hover {
    box-shadow: 0 0 8px #28a745, 0 0 16px #28a745;
    transform: translateY(-2px);
}

@keyframes pulse {
    0% { box-shadow: 0 0 4px rgba(255,255,255,0.2); }
    50% { box-shadow: 0 0 12px rgba(255,255,255,0.4); }
    100% { box-shadow: 0 0 4px rgba(255,255,255,0.2); }
}

.btn:hover {
    animation: pulse 1.5s infinite;
}


        /* Background canvas: No blur filter to keep particles sharp */
        #bg-canvas{position:fixed; inset:0; width:100%; height:100%; z-index:999; pointer-events:none;}

        /* ===== Sidebar & Navigation ===== */
        .sidebar{position:sticky; top:0; left:0; height:100vh; width:220px; background:var(--panel); border-right:1px solid var(--panel-border); display:flex; flex-direction:column; padding:16px; gap:8px; z-index:5; transition:width .25s;}
        .sidebar.collapsed{width:72px;}
        .sidebar .logo{display:flex;align-items:center;gap:10px;margin-bottom:16px;}
        .sidebar .logo img{width:44px;height:44px;border-radius:50%;box-shadow:0 4px 12px rgba(0,0,0,.12);}
        .sidebar .logo .brand{font-weight:700;color:var(--accent);white-space:nowrap;}
        .navlink{display:flex;align-items:center;gap:12px;padding:12px;text-decoration:none;color:#555;border-radius:10px;transition:.2s;font-weight:600;}
        body.dark .navlink{color:#cfd5e1;}
        .navlink i{width:22px;text-align:center;}
        .navlink:hover{background:rgba(255,111,0,.08); color:var(--accent); transform:translateX(2px);}
        .navlink.logout{margin-top:auto;color:#fff;background:#e74c3c;justify-content:center;}
        .navlink.logout:hover{background:#c0392b;transform:translateY(-1px);}
        .sidebar.collapsed .text{display:none;}
        /* Active link styles */
        .navlink.active {
            background: rgba(255,111,0,.15);
            color: var(--accent) !important;
            transform: translateX(4px);
            border-left: 3px solid var(--accent);
        }
        body.dark .navlink.active {
            background: rgba(0,255,153,.15);
            color: var(--accent) !important;
            border-left: 3px solid var(--accent);
        }

        /* ===== Top Controls ===== */
        .control-dock{display:none;}
        .ctrl{display:flex;align-items:center;gap:8px;}
        .btn-icon{display:inline-flex;align-items:center;justify-content:center;width:38px;height:38px;border-radius:10px;border:1px solid var(--panel-border);background:var(--panel);color:var(--fg);cursor:pointer;transition:.2s;box-shadow:var(--shadow);}
        .btn-icon:hover{transform:translateY(-1px);}
        .theme-wrap{display:flex;align-items:center;gap:10px;user-select:none;}
        .theme-label{font-weight:700;color:var(--fg);opacity:.9;}
        .theme{position:relative;width:58px;height:28px;border-radius:20px;background:#e4e7ee;border:1px solid var(--panel-border);cursor:pointer;transition:background .25s;}
        body.dark .theme{background:#23262d;}
        .thumb{position:absolute;top:2px;left:2px;width:24px;height:24px;border-radius:50%;background:#fff;display:grid;place-items:center;font-size:13px;box-shadow:0 4px 14px rgba(0,0,0,.25);transition:transform .25s ease, background .25s;}
        body.dark .thumb{transform:translateX(30px);background:#ffb84a;}
        .icon-sun{color:#f5a623;} .icon-moon{display:none;}
        body.dark .icon-sun{display:none;} body.dark .icon-moon{display:block;color:#1d1f26;}

        /* ===== Main Content & Topbar with new Flexbox alignment ===== */
        .main{flex:1; display:flex; flex-direction:column; overflow:auto; z-index:1; background:var(--bg);}
        .topbar{
            position: sticky;
            top: 0;
            z-index: 8;
            background: var(--topbar);
            border-bottom: 1px solid var(--panel-border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 16px;
            transition: background .25s, color .25s, border-color .25s;
        }
        .title{font-size:20px;font-weight:800;letter-spacing:.3px;color:var(--accent);}
        body.dark .title{color:#fff; position:relative; text-shadow:0 0 6px rgba(255,255,255,.25),0 0 12px rgba(255,255,255,.15);}
        body.dark .title::after{content:"✦ ✧ ✦ ✧";position:absolute;top:-14px;left:50%;transform:translateX(-50%);font-size:10px;letter-spacing:6px;color:#fff;opacity:.7;animation:twinkle 2.3s infinite alternate;}
        @keyframes twinkle{0%{opacity:.25;filter:blur(.2px);transform:translateX(-50%) translateY(0);}100%{opacity:.8;filter:blur(0);transform:translateX(-50%) translateY(-1px);}}
        .content{padding:18px; display:flex; flex-direction:column; gap:18px;}
        .cards{display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:16px;}
        .card{
            background:var(--panel);
            border:1px solid var(--panel-border);
            border-left:var(--card-border);
            border-radius:10px;
            padding:16px;
            box-shadow:var(--shadow), 0 0 15px rgba(255,111,0,0.4); /* Orange glow for light mode */
            text-align:center;
            transition:transform .2s, box-shadow .2s, background .25s, border-color .25s;
        }
        body.dark .card {
            box-shadow:var(--shadow), 0 0 15px rgba(0,255,153,0.4); /* Neon green glow for dark mode */
        }
        .card:hover{transform:translateY(-6px);box-shadow:0 14px 28px rgba(0,0,0,.12), 0 0 25px var(--accent);} /* Stronger glow on hover */
        body.dark .card:hover {
            box-shadow:0 14px 28px rgba(0,0,0,.12), 0 0 25px var(--accent); /* Uses the accent color for hover glow in dark mode */
        }
        .card h3{font-size:22px;color:var(--accent);margin-bottom:6px;}
        .card p{color:var(--muted);font-weight:600;}

        /* Food Category Cards */
        .cards.categories .cat{position:relative; overflow:hidden; border-radius:14px; padding:22px; color:#fff; text-align:center; font-weight:800; box-shadow:0 10px 22px rgba(0,0,0,.12);}
        .cards.categories .cat h4{font-size:18px;margin-bottom:4px;color:#fff;}
        .cards.categories .cat p{color:#f2f2f2;}
        .cat::after{content:"";position:absolute;inset:-60%;background:radial-gradient(circle, rgba(255,255,255,.25) 0%, transparent 60%);animation:floatGlow 4s ease-in-out infinite alternate;mix-blend-mode:screen;pointer-events:none;}
        @keyframes floatGlow{0%{transform:translate(-10px,-6px) rotate(0deg);opacity:.45;}100%{transform:translate(20px,16px) rotate(15deg);opacity:.65;}}
        .cat.cat1{background:linear-gradient(45deg,#28a745,#a8e063,#56ab2f,#c8e060,#7ed957);background-size:600% 600%;animation:grad1 7s ease infinite;}
        .cat.cat2{background:linear-gradient(45deg,#9b59b6,#8e44ad,#d291bc,#af7ac5,#c39bd3);background-size:600% 600%;animation:grad2 7s ease infinite;}
        .cat.cat3{background:linear-gradient(45deg,#3498db,#6dd5ed,#2193b0,#a1c4fd,#5dade2);background-size:600% 600%;animation:grad3 7s ease infinite;}
        .cat.cat4{background:linear-gradient(45deg,#e91e63,#ff9a9e,#ff6f00,#f8b195,#ff758c);background-size:600% 600%;animation:grad4 7s ease infinite;}
        @keyframes grad1{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}
        @keyframes grad2{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}
        @keyframes grad3{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}
        @keyframes grad4{0%{background-position:0% 50%}50%{background-position:100% 50%}100%{background-position:0% 50%}}

        /* Panel / Table */
        .panel{background:var(--panel);border:1px solid var(--panel-border);border-radius:10px;box-shadow:var(--shadow);padding:16px;}
        .panel h3{color:var(--accent);margin-bottom:8px;}
        .table{width:100%;border-collapse:collapse;margin-top:8px;}
        .table th,.table td{padding:10px;border-bottom:1px solid var(--table-grid);text-align:left;}
        .table th{color:var(--accent);font-weight:800;}
        .status-active{color:#28a745;font-weight:700;}
        .status-inactive{color:#e74c3c;font-weight:700;}
        .btn{padding:8px 12px;border:none;border-radius:8px;cursor:pointer;font-weight:700;}
        .btn-delete{background:#e74c3c;color:#fff;}
        .btn-delete:hover{background:#c0392b;}

        /* Chart with new theme-based glow */
        #calorieChart{
            background:rgba(255,255,255,.06);
            border-radius:10px;
            box-shadow:0 0 20px rgba(255,111,0,.25); /* Orange glow for light mode */
        }
        body.dark #calorieChart {
            box-shadow:0 0 20px rgba(0,255,153,.25); /* Neon green glow for dark mode */
        }

        /* Modal */
        .modal-overlay{position:fixed; inset:0; display:none; align-items:center; justify-content:center; background:rgba(0,0,0,.4); z-index:1000;}
        .modal{width:360px;max-width:90%;background:var(--panel);color:var(--fg);border-radius:14px;padding:18px;box-shadow:0 20px 50px rgba(0,0,0,.28);transform:scale(0.98);opacity:0;transition:all .2s;}
        .modal.show{transform:scale(1);opacity:1;}
        .modal h4{margin-bottom:8px;color:var(--accent);}
        .modal p{color:var(--muted);}
        .modal .actions{display:flex;gap:10px;margin-top:14px;justify-content:flex-end;}
        .modal .btn.confirm{background:#e74c3c;color:#fff;border:none;}

        /* Responsive */
        @media(max-width:900px){.sidebar{position:fixed;height:100vh;z-index:10;}.sidebar.collapsed{transform:translateX(-100%);}}
    </style>
</head>
<body>
    
    <div id="loadingOverlay" style="position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,.7);display:none;align-items:center;justify-content:center;z-index:9999;backdrop-filter:blur(5px);-webkit-backdrop-filter:blur(5px);">
        <div class="loader" style="border:5px solid rgba(255,255,255,.3);border-top:5px solid var(--accent);border-radius:50%;width:50px;height:50px;animation:spin 1s linear infinite;"></div>
    </div>
    <style>@keyframes spin{0%{transform:rotate(0deg)}100%{transform:rotate(360deg)}}</style>

    <div id="statusMessage" style="position:fixed;top:20px;right:20px;padding:12px 20px;border-radius:8px;font-weight:bold;color:#fff;display:none;z-index:10000;box-shadow:0 4px 12px rgba(0,0,0,.15);"></div>

    <canvas id="bg-canvas"></canvas>

    <aside id="sidebar" class="sidebar">
        <div class="logo"><img src="https://via.placeholder.com/80" alt="Logo"><span class="brand text">Tu Kha</span></div>
        <a href="#" class="navlink active"><i class="fas fa-tachometer-alt"></i><span class="text">Dashboard</span></a>
        <a href="Users.aspx" class="navlink"><i class="fas fa-users"></i><span class="text">Users</span></a>
        <a href="Category.aspx" class="navlink"><i class="fas fa-comment"></i><span class="text">Foods</span></a>
        <a href="Feedback.aspx" class="navlink"><i class="fas fa-comment"></i><span class="text">Feedback</span></a>
        <a href="#" class="navlink logout" id="btnLogout"><i class="fas fa-sign-out-alt"></i><span class="text">Logout</span></a>
    </aside>

    <main class="main">
        <div class="topbar">
            <div class="ctrl"><button class="btn-icon" id="btnToggleSidebar"><i class="fas fa-bars"></i></button></div>
            <div class="title">Calorie Tracking System</div>
            <div class="ctrl theme-wrap">
                <span class="theme-label">Theme</span>
                <div class="theme" id="themeToggle"><div class="thumb"><i class="fas fa-sun icon-sun"></i><i class="fas fa-moon icon-moon"></i></div></div>
            </div>
        </div>

        <section class="content">
            <div class="cards">
                <div class="card"><h3><%= TotalUsers %></h3><p>Total Users</p></div>
                <div class="card"><h3><%= ActiveUsersToday %></h3><p>Active Today</p></div>
                <div class="card"><h3><%= TotalFoodItems %></h3><p>Food Items</p></div>
                <div class="card"><h3><%= CaloriesLogged %></h3><p>Calories Logged</p></div>
            </div>

            <div class="cards categories">
                <div class="cat cat1"><h4>Meat &amp; Fish</h4><p><%= MeatCount %> items</p></div>
                <div class="cat cat2"><h4>Beverages &amp; Drinks</h4><p><%= BeverageCount %> items</p></div>
                <div class="cat cat3"><h4>Snacks &amp; Desserts</h4><p><%= SnacksCount %> items</p></div>
                <div class="cat cat4"><h4>Grains &amp; Fruits</h4><p><%= GrainCount %> items</p></div>
            </div>

            <div class="panel"><h3>Calories Logged (Last 7 Days)</h3><canvas id="calorieChart" height="100"></canvas></div>

            <div class="panel">
                <h3>Users</h3>
                <table class="table">
                    <thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                        <% int count = 1; %>
                        <% foreach (var user in UserList) { %>
                        <tr data-id="<%= user.Id %>">
                            <td><%= count++ %></td>
                            <td><%= user.Name %></td>
                            <td><%= user.Email %></td>
                            <td class="<%= user.IsActive ? "status-active" : "status-inactive" %>"><%= user.IsActive ? "Active" : "Inactive" %></td>
                            <td><button class="btn btn-delete" onclick="confirmDelete('<%= user.Id %>', '<%= user.Name %>')">Delete</button></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </main>

    <div class="modal-overlay" id="modalOverlay">
        <div class="modal" id="modalBox">
            <h4 id="modalTitle">Confirm Action</h4>
            <p id="modalMsg">Are you sure?</p>
            <div class="actions">
                <button class="btn" id="btnCancel">Cancel</button>
                <button class="btn confirm" id="btnConfirm">Yes</button>
            </div>
        </div>
    </div>

   <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // --- Particle System Logic ---
    class ParticleSystem {
        constructor(canvasId) {
            this.canvas = document.getElementById(canvasId);
            this.ctx = this.canvas.getContext('2d');
            this.particles = [];
            this.mouseParticles = [];
            this.isDark = document.body.classList.contains('dark');
            this.isAnimating = false;
            this.mouseParticleColors = ['#FF6F00', '#FFD700', '#ADFF2F', '#00FFFF', '#9370DB', '#FF1493', '#00BFFF'];
            this.setupEventListeners();
            this.resizeCanvas();
        }
        setupEventListeners() {
            window.addEventListener('resize', this.resizeCanvas.bind(this));
            document.addEventListener('mousemove', this.handleMouseMove.bind(this));
        }
        resizeCanvas() {
            this.canvas.width = window.innerWidth;
            this.canvas.height = window.innerHeight;
            this.buildParticles();
        }
        handleMouseMove(e) {
            for (let i = 0; i < 5; i++) {
                const randomColor = this.mouseParticleColors[Math.floor(Math.random() * this.mouseParticleColors.length)];
                const angle = Math.random() * Math.PI * 2;
                const speed = Math.random() * 2 + 1;
                this.mouseParticles.push({
                    x: e.clientX, y: e.clientY, r: Math.random() * 3 + 1, alpha: 1, rotation: Math.random() * Math.PI * 2, color: randomColor,
                    dx: Math.cos(angle) * speed, dy: Math.sin(angle) * speed,
                });
            }
        }
        buildParticles() {
            this.isDark = document.body.classList.contains('dark');
            this.particles = [];
            let colors = this.isDark ? ['#00ff99', '#ffffff'] : ['#ff4500', '#ff8c00', '#1e90ff', '#FFD700', 'blue', 'red', 'pink', 'yellow'];
            for (let i = 0; i < 100; i++) {
                this.particles.push({
                    x: Math.random() * this.canvas.width, y: Math.random() * this.canvas.height,
                    r: Math.random() * 1.5 + 0.5, dx: (Math.random() - 0.5) * 0.3, dy: (Math.random() - 0.5) * 0.3,
                    color: colors[Math.floor(Math.random() * colors.length)]
                });
            }
        }
        animate() {
            if (!this.isAnimating) return;
            this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
            this.particles.forEach(p => {
                this.ctx.beginPath();
            this.ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
            this.ctx.fillStyle = p.color; 
            this.ctx.shadowColor = p.color; 
            this.ctx.shadowBlur = 14; 
            this.ctx.fill();
            p.x += p.dx; p.y += p.dy;
            if (p.x < 0 || p.x > this.canvas.width) p.dx *= -1;
            if (p.y < 0 || p.y > this.canvas.height) p.dy *= -1;
        });
        for (let i = this.mouseParticles.length - 1; i >= 0; i--) {
            const mp = this.mouseParticles[i];
            const numSpikes = 5; const outerRadius = mp.r * 2; const innerRadius = outerRadius / 2;
            this.ctx.beginPath(); this.ctx.moveTo(mp.x, mp.y - outerRadius);
            for (let j = 0; j < numSpikes; j++) {
                let angle = (j * 2 * Math.PI / numSpikes) - Math.PI / 2 + mp.rotation;
                this.ctx.lineTo(mp.x + Math.cos(angle) * outerRadius, mp.y + Math.sin(angle) * outerRadius);
                angle += Math.PI / numSpikes;
                this.ctx.lineTo(mp.x + Math.cos(angle) * innerRadius, mp.y + Math.sin(angle) * innerRadius);
            }
            this.ctx.closePath();
            this.ctx.fillStyle = mp.color; this.ctx.shadowColor = mp.color; this.ctx.shadowBlur = 20;
            this.ctx.globalAlpha = mp.alpha; this.ctx.fill();
            this.ctx.globalAlpha = 1; this.ctx.shadowBlur = 0;
            mp.alpha -= 0.03; mp.r *= 0.93; mp.x += mp.dx; mp.y += mp.dy; mp.rotation += 0.1;
            if (mp.alpha <= 0 || mp.r <= 0.1) this.mouseParticles.splice(i, 1);
        }
        requestAnimationFrame(this.animate.bind(this));
    }
    start() { this.isAnimating = true; this.animate(); }
    stop() { this.isAnimating = false; }
    updateTheme() { this.isDark = document.body.classList.contains('dark'); this.buildParticles(); }
    }

    const myParticleSystem = new ParticleSystem('bg-canvas');

    // --- Chart ---
    const ctx = document.getElementById('calorieChart').getContext('2d');
    const myChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: <%= CalorieLabelsJson %>,
            datasets: [{
                label: 'Calories',
                data: <%= CalorieDataJson %>,
                borderColor: '',
                backgroundColor: '',
                borderWidth: 3,
                tension: .4,
                pointBackgroundColor: '',
                pointRadius: 6,
                fill: 'start',
            }]
        },
        options: { responsive: true, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
    });

    function updateChartTheme() {
        const isDark = document.body.classList.contains('dark');
        const dataLight = [1500, 1800, 1700, 2000, 2200, 2100, 2300];
        const dataDark = [1600, 2400, 1900, 2800, 2100, 2600, 2900];
        const colorLight = '#ff6f00', colorDark = '#00ff99';
        const shadeLight = 'rgba(255,111,0,0.2)', shadeDark = 'rgba(0,255,153,0.2)';

        myChart.data.datasets[0].borderColor = isDark ? colorDark : colorLight;
        myChart.data.datasets[0].backgroundColor = isDark ? shadeDark : shadeLight;
        myChart.data.datasets[0].pointBackgroundColor = isDark ? colorDark : colorLight;
        myChart.data.datasets[0].data = isDark ? dataDark : dataLight;
        myChart.update();
    }

    // --- Theme Toggle with Persistence ---
    const themeToggle = document.getElementById('themeToggle');
    function applyTheme(isDark) {
        if (isDark) document.body.classList.add('dark'); 
        else document.body.classList.remove('dark');
        myParticleSystem.updateTheme();
        updateChartTheme();
    }
    // Load saved theme
    const savedTheme = localStorage.getItem('theme');
    applyTheme(savedTheme === 'dark');

    themeToggle.addEventListener('click', () => {
        const isDark = !document.body.classList.contains('dark');
    applyTheme(isDark);
    localStorage.setItem('theme', isDark ? 'dark' : 'light');
    });

    // --- Sidebar Toggle with Persistence ---
    const sidebar = document.getElementById('sidebar');
    const btnToggleSidebar = document.getElementById('btnToggleSidebar');
    function applySidebar(isCollapsed) {
        if (isCollapsed) sidebar.classList.add('collapsed');
        else sidebar.classList.remove('collapsed');
    }
    const savedSidebar = localStorage.getItem('sidebarCollapsed');
    applySidebar(savedSidebar === 'true');
    btnToggleSidebar.addEventListener('click', () => {
        const isCollapsed = !sidebar.classList.contains('collapsed');
    applySidebar(isCollapsed);
    localStorage.setItem('sidebarCollapsed', isCollapsed);
    });

    // --- Navigation links ---
    const navLinks = document.querySelectorAll('.navlink');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            if (this.getAttribute('href') === '#' && this.id !== 'btnLogout') e.preventDefault();
            navLinks.forEach(item => item.classList.remove('active'));
            this.classList.add('active');
        });
    });

    // --- Modal ---
    const modalOverlay = document.getElementById('modalOverlay');
    const modalBox = document.getElementById('modalBox');
    const modalTitle = document.getElementById('modalTitle');
    const modalMsg = document.getElementById('modalMsg');
    const btnCancel = document.getElementById('btnCancel');
    const btnConfirm = document.getElementById('btnConfirm');
    let currentAction = null;

    function showModal(title, msg, callback) {
        modalTitle.textContent = title;
        modalMsg.textContent = msg;
        modalOverlay.style.display = 'flex';
        setTimeout(() => modalBox.classList.add('show'), 10);
        currentAction = callback;
    }
    function closeModal() { modalBox.classList.remove('show'); setTimeout(() => modalOverlay.style.display='none',200); }
    btnCancel.addEventListener('click', closeModal);
    btnConfirm.addEventListener('click', () => { if(currentAction) currentAction(); closeModal(); });

    function confirmDelete(userId, userName) {
        showModal('Delete User', `Are you sure you want to delete user **${userName}**?`, () => {
            document.getElementById('loadingOverlay').style.display='flex';
        window.location.href = `dashboard.aspx?deleteId=${userId}`;
    });
    }

    document.getElementById('btnLogout').addEventListener('click', (e) => {
        e.preventDefault();
    showModal('Logout', 'Are you sure you want to logout?', () => { console.log('User logged out.'); });
    });

    // --- Status messages ---
    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');
    const statusMessage = document.getElementById('statusMessage');
    if (status === 'success') {
        statusMessage.textContent = 'User deleted successfully!';
        statusMessage.style.backgroundColor = '#28a745';
        statusMessage.style.display = 'block';
        setTimeout(() => { statusMessage.style.display = 'none'; }, 3000);
    }

    // --- Start particles after page load ---
    window.addEventListener('load', () => { setTimeout(() => myParticleSystem.start(), 500); });
</script>
