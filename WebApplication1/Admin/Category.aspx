<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Category.aspx.cs" Inherits="WebApplication1.Admin.Category" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Calorie Tracking System - Food Items</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <style>
        /* ================== Existing UI Styles ================== */
        *{margin:0;padding:0;box-sizing:border-box}
        :root{
            --bg:#ffffff; --fg:#333; --muted:#777;
            --panel:#fff; --panel-border:#ddd; --topbar:#fff;
            --accent:#ff6f00; --accent-2:#ff9800; --shadow:0 2px 6px rgba(0,0,0,.06);
            --card-border:5px solid var(--accent); --table-grid:#eee;
        }
        body{ font-family:Arial,sans-serif; color:var(--fg); background:var(--bg); display:flex; height:100vh; overflow:hidden;}
        body.dark{--bg:#0f0f12;--fg:#f5f7fb;--muted:#b8beca;--panel:#17181c;--panel-border:#2b2d34;--topbar:#121318;--accent:#ff9800;--accent-2:#ffb74d;--shadow:0 10px 24px rgba(0,0,0,.35);--table-grid:#2a2d33;}
        .table tbody tr {position: relative; overflow: hidden;}
        .table tbody tr::after {content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; background: radial-gradient(circle, rgba(255,255,255,0.4) 0%, transparent 80%); opacity: 0; transform: scale(0.5); transition: opacity 0.3s ease, transform 0.3s ease;}
        .table tbody tr:hover::after {opacity: 1; transform: scale(1.5); animation: sparkle 1s infinite alternate;}
        @keyframes sparkle {0% {opacity: 0.6; transform: scale(1.3);} 50% {opacity: 0.3; transform: scale(1.5);} 100% {opacity: 0.6; transform: scale(1.2);}}
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
        .navlink.active {background: rgba(255,111,0,.15); color: var(--accent) !important; transform: translateX(4px); border-left: 3px solid var(--accent);}
        body.dark .navlink.active {background: rgba(0,255,153,.15); color: var(--accent) !important; border-left: 3px solid var(--accent);}
        .main{flex:1; display:flex; flex-direction:column; overflow:auto; z-index:1; background:var(--bg);}
        .topbar{position: sticky; top: 0; z-index: 8; background: var(--topbar); border-bottom: 1px solid var(--panel-border); display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; transition: background .25s, color .25s, border-color .25s;}
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
        .title{font-size:20px;font-weight:800;letter-spacing:.3px;color:var(--accent);position:relative;}
        body.dark .title{color:#fff; text-shadow:0 0 6px rgba(255,255,255,.25),0 0 12px rgba(255,255,255,.15);}
        .content{padding:18px; display:flex; flex-direction:column; gap:18px;}
        .panel{background:var(--panel);border:1px solid var(--panel-border);border-radius:10px;box-shadow:var(--shadow);padding:16px;}
        .panel h3{color:var(--accent);margin-bottom:8px;}
        .table-container{overflow-x:auto;}
        .table{width:100%;border-collapse:collapse;margin-top:8px;}
        .table th,.table td{padding:10px;border-bottom:1px solid var(--table-grid);text-align:left;}
        .table th{color:var(--accent);font-weight:800;white-space:nowrap;}
        .status-active{color:#28a745;font-weight:700;}
        .status-inactive{color:#e74c3c;font-weight:700;}
        .btn{padding:8px 12px;border:none;border-radius:8px;cursor:pointer;font-weight:700;transition:.25s;}
        .btn-delete{background:#e74c3c;color:#fff;}
        .btn-delete:hover{background:#c0392b;}
        /* Neon purple for 'Add New Item' button */
        .btn-add{background:#fff;color:#000;}
        .btn-add:hover{background:#7C00CC;}
        /* Green for 'Edit' button */
        .btn-edit{background:#28a745;color:#fff;}
        .btn-edit:hover{background:#218838;}
        .modal-overlay{position:fixed; inset:0; display:none; align-items:center; justify-content:center; background:rgba(0,0,0,.4); z-index:1000;}
        
        /* FIX: Make modal content scrollable on smaller screens */
        .modal{
            width:400px;
            max-width:90%;
            max-height: 90vh;
            overflow-y: auto;
            background:var(--panel);
            color:var(--fg);
            border-radius:14px;
            padding:24px;
            box-shadow:0 20px 50px rgba(0,0,0,.28);
            transform:scale(0.98);
            opacity:0;
            transition:all .2s;
        }

        .modal.show{transform:scale(1);opacity:1;}
        .modal h4{margin-bottom:12px;color:var(--accent);text-align:center;font-size:24px;}
        .modal p{color:var(--muted);text-align:center;margin-bottom:16px;}
        .modal form .form-group{margin-bottom:12px;}
        .modal form label{display:block;margin-bottom:4px;font-weight:600;}
        .modal form input, .modal form select, .modal form textarea{width:100%;padding:8px;border:1px solid var(--panel-border);border-radius:8px;background:var(--bg);color:var(--fg);transition:border-color .2s;}
        .modal form input:focus, .modal form select:focus, .modal form textarea:focus{outline:none;border-color:var(--accent);}
        .modal .actions{display:flex;gap:10px;margin-top:20px;justify-content:flex-end;}
        .modal .btn.confirm{background:#28a745;color:#fff;border:none;}
        .modal .btn.confirm.delete{background:#e74c3c;}
        #bg-canvas{position:fixed; inset:0; width:100%; height:100%; z-index:999; pointer-events:none;}
        .action-cell{white-space:nowrap;}

        /* Form Styling for modal */
        #itemForm {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .form-group label {
            font-size: 14px;
            color: var(--fg);
        }

        .form-group input,
        .form-group select {
            border: 1px solid var(--panel-border);
            background: var(--bg);
            border-radius: 6px;
            padding: 10px;
            font-size: 16px;
            color: var(--fg);
        }
        
        /* Search Bar Style */
        .search-bar-container {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .search-bar {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid var(--panel-border);
            border-radius: 8px;
            font-size: 16px;
            background: var(--bg);
            color: var(--fg);
        }

        .search-bar-icon {
            color: var(--muted);
        }
        
        /* Image Preview Style */
        .image-preview-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 120px;
            width: 120px;
            margin: 0 auto 15px;
            border: 2px dashed var(--panel-border);
            border-radius: 8px;
            overflow: hidden;
        }
        .image-preview-container img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }
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
        <a href="dashboard.aspx" class="navlink"><i class="fas fa-tachometer-alt"></i><span class="text">Dashboard</span></a>
        <a href="Users.aspx" class="navlink"><i class="fas fa-users"></i><span class="text">Users</span></a>
        <a href="Category.aspx" class="navlink active"><i class="fas fa-utensils"></i><span class="text">Foods</span></a>
        <a href="Feedback.aspx" class="navlink"><i class="fas fa-comment"></i><span class="text">Feedback</span></a>
        <a href="#" class="navlink logout" id="btnLogout"><i class="fas fa-sign-out-alt"></i><span class="text">Logout</span></a>
    </aside>

    <main class="main">
        <div class="topbar">
            <div class="ctrl"><button class="btn-icon" id="btnToggleSidebar"><i class="fas fa-bars"></i></button></div>
            <div class="title">Food Items</div>
            <div class="ctrl theme-wrap">
                <span class="theme-label">Theme</span>
                <div class="theme" id="themeToggle"><div class="thumb"><i class="fas fa-sun icon-sun"></i><i class="fas fa-moon icon-moon"></i></div></div>
            </div>
        </div>

        <section class="content">
            <div class="panel">
                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
                    <h3>Food Items</h3>
                    <button class="btn btn-add" id="btnAddItem"><i class="fas fa-plus-circle"></i> Add New Item</button>
                </div>
                <!-- Search Bar Section -->
                <div class="search-bar-container">
                    <i class="fas fa-search search-bar-icon"></i>
                    <input type="text" id="searchInput" class="search-bar" placeholder="Search for food items..." onkeyup="filterTable()" />
                </div>
                <!-- End Search Bar Section -->
                <div class="table-container">
                    <table class="table" id="itemTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Image</th>
                                <th>Name</th>
                                <th>Size</th>
                                <th>Energy</th>
                                <th>Protein</th>
                                <th>Fat</th>
                                <th>Category</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% int count = 1; %>
                            <% foreach (var item in this.ItemList) { %>
                            <tr data-id="<%= item.Id %>">
                                <td><%= count++ %></td>
                                <td>
                                    <% if (!string.IsNullOrEmpty(item.ImageBase64)) { %>
                                        <img src="data:image/jpeg;base64,<%= item.ImageBase64 %>" style="width: 50px; height: 50px; border-radius: 8px; object-fit: cover;" />
                                    <% } else { %>
                                        <i class="fas fa-utensils" style="font-size: 24px; color: var(--muted);"></i>
                                    <% } %>
                                </td>
                                <td><%= item.Name %></td>
                                <td><%= item.Size %></td>
                                <td><%= item.Energy %></td>
                                <td><%= item.Protein %></td>
                                <td><%= item.Fat %></td>
                                <td><%= item.Type %></td>
                                <td class="action-cell">
                                    <button class="btn btn-edit" onclick="editItem('<%= item.Id %>', '<%= item.Name %>', '<%= item.Size %>', '<%= item.Energy %>', '<%= item.Protein %>', '<%= item.Fat %>', '<%= item.Type %>', '<%= item.ImageBase64 %>')">Edit</button>
                                    <button class="btn btn-delete" onclick="confirmDelete('<%= item.Id %>', '<%= item.Name %>')">Delete</button>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>

    <!-- Modal for Add/Edit -->
    <div class="modal-overlay" id="itemModalOverlay">
        <div class="modal" id="itemModalBox">
            <h4 id="itemModalTitle">Add New Food Item</h4>
            <!-- Form to handle file upload and data submission -->
            <form id="itemForm" runat="server" method="post" enctype="multipart/form-data">
                <input type="hidden" id="modalAction" name="action" value="add" />
                <input type="hidden" id="itemId" name="id" value="" />
                
                <div class="form-group" style="text-align: center;">
                    <label for="itemImageFile">Image</label>
                    <div class="image-preview-container">
                        <img id="imagePreview" src="#" alt="Image Preview" style="display:none;" />
                        <i id="imagePlaceholder" class="fas fa-camera" style="font-size: 40px; color: var(--muted);"></i>
                    </div>
                    <input type="file" id="itemImageFile" name="itemImageFile" accept="image/*" />
                </div>

                <div class="form-group"><label for="itemName">Name</label><input type="text" id="itemName" name="name" required /></div>
                <div class="form-group"><label for="itemSize">Size (g)</label><input type="text" id="itemSize" name="size" required /></div>
                <div class="form-group"><label for="itemEnergy">Energy (cal)</label><input type="text" id="itemEnergy" name="energy" required /></div>
                <div class="form-group"><label for="itemProtein">Protein (g)</label><input type="text" id="itemProtein" name="protein" required /></div>
                <div class="form-group"><label for="itemFat">Fat (g)</label><input type="text" id="itemFat" name="fat" required /></div>
                <div class="form-group">
                    <label for="itemType">Category</label>
                    <select id="itemType" name="type" required>
                        <option value="">Select a category</option>
                        <option value="Meat & Fish">Meat & Fish</option>
                        <option value="Beverages & Drinks">Beverages & Drinks</option>
                        <option value="Snacks & Desserts">Snacks & Desserts</option>
                        <option value="Grains & Fruits">Grains & Fruits</option>
                    </select>
                </div>
                <div class="actions">
                    <button type="button" class="btn" id="btnItemCancel">Cancel</button>
                    <button type="submit" class="btn btn-add" id="btnItemSave">Add</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal for Delete Confirmation -->
    <div class="modal-overlay" id="deleteModalOverlay">
        <div class="modal" id="deleteModalBox">
            <h4 id="deleteModalTitle">Confirm Deletion</h4>
            <p id="deleteModalMsg">Are you sure you want to delete this item?</p>
            <div class="actions">
                <button class="btn" id="btnDeleteCancel">Cancel</button>
                <button class="btn confirm delete" id="btnDeleteConfirm">Delete</button>
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
        window.addEventListener('load', () => { setTimeout(() => myParticleSystem.start(), 500); });

        // --- Theme Toggle with Persistence ---
        const themeToggle = document.getElementById('themeToggle');
        function applyTheme(isDark) {
            if (isDark) document.body.classList.add('dark');
            else document.body.classList.remove('dark');
            myParticleSystem.updateTheme();
        }
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

        // --- Status Messages ---
        function showStatus(message, isSuccess) {
            const statusMessage = document.getElementById('statusMessage');
            statusMessage.textContent = message;
            statusMessage.style.backgroundColor = isSuccess ? '#28a745' : '#e74c3c';
            statusMessage.style.display = 'block';
            setTimeout(() => { statusMessage.style.display = 'none'; }, 3000);
        }
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');
        if (status) {
            showStatus(urlParams.get('msg'), status === 'success');
            // Remove parameters from URL after displaying
            window.history.replaceState({}, document.title, window.location.pathname);
        }

        // --- Item Add/Edit Modal Logic ---
        const itemModalOverlay = document.getElementById('itemModalOverlay');
        const itemModalBox = document.getElementById('itemModalBox');
        const itemModalTitle = document.getElementById('itemModalTitle');
        const btnItemSave = document.getElementById('btnItemSave');
        const btnItemCancel = document.getElementById('btnItemCancel');
        const itemForm = document.getElementById('itemForm');
        const imagePreview = document.getElementById('imagePreview');
        const imagePlaceholder = document.getElementById('imagePlaceholder');
        const itemImageFile = document.getElementById('itemImageFile');

        function openItemModal(id = null, name = '', size = '', energy = '', protein = '', fat = '', type = '', imageBase64 = '') {
            itemForm.reset(); // Reset the form fields
            document.getElementById('itemId').value = id || '';
            document.getElementById('modalAction').value = id ? 'edit' : 'add';
            itemModalTitle.textContent = id ? 'Edit Food Item' : 'Add New Food Item';
            btnItemSave.textContent = id ? 'Save Changes' : 'Add';
            document.getElementById('itemName').value = name;
            document.getElementById('itemSize').value = size;
            document.getElementById('itemEnergy').value = energy;
            document.getElementById('itemProtein').value = protein;
            document.getElementById('itemFat').value = fat;
            document.getElementById('itemType').value = type;
            
            // Handle image preview
            if (imageBase64) {
                imagePreview.src = 'data:image/jpeg;base64,' + imageBase64;
                imagePreview.style.display = 'block';
                imagePlaceholder.style.display = 'none';
            } else {
                imagePreview.style.display = 'none';
                imagePlaceholder.style.display = 'block';
            }

            itemModalOverlay.style.display = 'flex';
            setTimeout(() => itemModalBox.classList.add('show'), 10);
        }

            function closeItemModal() {
                itemModalBox.classList.remove('show');
                setTimeout(() => {
                    itemModalOverlay.style.display = 'none';
                itemForm.reset();
                imagePreview.style.display = 'none';
                imagePlaceholder.style.display = 'block';
            }, 200);
        }

        // Live image preview
        itemImageFile.addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    imagePreview.src = e.target.result;
                    imagePreview.style.display = 'block';
                    imagePlaceholder.style.display = 'none';
                }
                reader.readAsDataURL(file);
            } else {
                imagePreview.style.display = 'none';
                imagePlaceholder.style.display = 'block';
            }
        });

        document.getElementById('btnAddItem').addEventListener('click', () => openItemModal());
        btnItemCancel.addEventListener('click', closeItemModal);

        // Expose edit function to global scope for onclick
        window.editItem = function(id, name, size, energy, protein, fat, type, imageBase64) {
            openItemModal(id, name, size, energy, protein, fat, type, imageBase64);
        };

        // --- Delete Modal Logic ---
        const deleteModalOverlay = document.getElementById('deleteModalOverlay');
        const deleteModalBox = document.getElementById('deleteModalBox');
        const deleteModalMsg = document.getElementById('deleteModalMsg');
        const btnDeleteCancel = document.getElementById('btnDeleteCancel');
        const btnDeleteConfirm = document.getElementById('btnDeleteConfirm');
        let itemIdToDelete = null;

        function confirmDelete(id, name) {
            itemIdToDelete = id;
            deleteModalMsg.textContent = `Are you sure you want to delete "${name}"?`;
            deleteModalOverlay.style.display = 'flex';
            setTimeout(() => deleteModalBox.classList.add('show'), 10);
        }

        btnDeleteCancel.addEventListener('click', () => {
            deleteModalBox.classList.remove('show');
        setTimeout(() => deleteModalOverlay.style.display = 'none', 200);
        });

        btnDeleteConfirm.addEventListener('click', () => {
            document.getElementById('loadingOverlay').style.display='flex';
        window.location.href = `Category.aspx?action=delete&id=${itemIdToDelete}`;
        });

        // --- Search/Filter Logic ---
        function filterTable() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const table = document.getElementById('itemTable');
            const tr = table.getElementsByTagName('tr');

            for (let i = 1; i < tr.length; i++) {
                let found = false;
                const td = tr[i].getElementsByTagName('td');
                // Check all cells except the first one (ID) and the last one (Actions)
                for (let j = 1; j < td.length - 1; j++) {
                    const cellText = td[j].textContent || td[j].innerText;
                    if (cellText.toLowerCase().indexOf(filter) > -1) {
                        found = true;
                        break;
                    }
                }
                tr[i].style.display = found ? '' : 'none';
            }
        }
    </script>
</body>
</html>
