<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="WebApplication1.Admin.UserPage" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Calorie Tracking System - Users</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* ================== Existing UI Styles ================== */
        *{margin:0;padding:0;box-sizing:border-box;}
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
        body.dark .title{color:#fff; text-shadow:0 0 6px rgba(255,255,255,.25),0 0 12px rgba(255,255,255,.15),0 0 18px rgba(0,255,153,.25),0 0 24px rgba(0,255,153,.2); animation:neonPulse 2.3s infinite alternate;}
        .content{padding:18px; display:flex; flex-direction:column; gap:18px;}
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
        .modal-overlay{position:fixed; inset:0; display:none; align-items:center; justify-content:center; background:rgba(0,0,0,.4); z-index:10000;}
        .modal{width:360px;max-width:90%;background:var(--panel);color:var(--fg);border-radius:14px;padding:18px;box-shadow:0 20px 50px rgba(0,0,0,.28);transform:scale(0.98);opacity:0;transition:all .2s;}
        .modal.show{transform:scale(1);opacity:1;}
        .modal h4{margin-bottom:8px;color:var(--accent);}
        .modal p{color:var(--muted);}
        .modal .actions{display:flex;gap:10px;margin-top:14px;justify-content:flex-end;}
        .modal .btn.confirm{background:#e74c3c;color:#fff;border:none;}
        #bg-canvas{position:fixed; inset:0; width:100%; height:100%; z-index:9999; pointer-events:none;}

        /* ================== Pie Chart Resize ================== */
        #userPieChart { max-width: 400px; width: 100%; height: auto; display: block; margin: 0 auto; }
    </style>
</head>
<body>
    <canvas id="bg-canvas"></canvas>

    <!-- Sidebar -->
    <aside id="sidebar" class="sidebar">
        <div class="logo"><img src="https://via.placeholder.com/80" alt="Logo"><span class="brand text">Tu Kha</span></div>
        <a href="dashboard.aspx" class="navlink"><i class="fas fa-tachometer-alt"></i><span class="text">Dashboard</span></a>
        <a href="#" class="navlink active"><i class="fas fa-users"></i><span class="text">Users</span></a>
        <a href="Category.aspx" class="navlink"><i class="fas fa-utensils"></i><span class="text">Foods</span></a>
        <a href="#" class="navlink"><i class="fas fa-comment"></i><span class="text">Feedback</span></a>
        <a href="#" class="navlink logout" id="btnLogout"><i class="fas fa-sign-out-alt"></i><span class="text">Logout</span></a>
    </aside>

    <!-- Main -->
    <main class="main">
        <div class="topbar">
            <div class="ctrl"><button class="btn-icon" id="btnToggleSidebar"><i class="fas fa-bars"></i></button></div>
            <div class="title">Calorie Tracking System - Users</div>
            <div class="ctrl theme-wrap">
                <span class="theme-label">Theme</span>
                <div class="theme" id="themeToggle"><div class="thumb"><i class="fas fa-sun icon-sun"></i><i class="fas fa-moon icon-moon"></i></div></div>
            </div>
        </div>

        <section class="content">
            <!-- Users Table -->
            <div class="panel">
                <h3>Users</h3>
                <table class="table">
                    <thead>
                        <tr><th>ID</th><th>Name</th><th>Email</th><th>Weight</th><th>Goal</th><th>Status</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <% int count = 1; %>
                        <% foreach (var user in UserList) { %>
                        <tr data-id="<%= user.Id %>">
                            <td><%= count++ %></td>
                            <td><%= user.Name %></td>
                            <td><%= user.Email %></td>
                            <td><%= user.Weight %></td>
                            <td><%= user.Goal %></td>
                            <td class="<%= user.IsActive ? "status-active" : "status-inactive" %>"><%= user.IsActive ? "Active" : "Inactive" %></td>
                            <td><button class="btn btn-delete" onclick="confirmDelete('<%= user.Email %>', '<%= user.Name %>')">Delete</button></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Pie Chart Panel -->
            <div class="panel">
                <h3>Daily Interactions Today</h3>
                <canvas id="userPieChart"></canvas>
            </div>
        </section>
    </main>

    <!-- Modal -->
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

    <script>
        // ================== Particle System ==================
        class ParticleSystem {
            constructor(canvasId){
                this.canvas=document.getElementById(canvasId);
                this.ctx=this.canvas.getContext('2d');
                this.particles=[]; this.mouseParticles=[];
                this.isAnimating=false;
                this.isDark=document.body.classList.contains('dark');
                this.mouseParticleColors=['#FF6F00','#FFD700','#ADFF2F','#00FFFF','#9370DB','#FF1493','#00BFFF'];
                this.setupEventListeners(); this.resizeCanvas();
            }
            setupEventListeners(){
                window.addEventListener('resize',this.resizeCanvas.bind(this));
                document.addEventListener('mousemove',this.handleMouseMove.bind(this));
            }
            resizeCanvas(){this.canvas.width=window.innerWidth; this.canvas.height=window.innerHeight; this.buildParticles();}
            handleMouseMove(e){
                for(let i=0;i<5;i++){
                    const color=this.mouseParticleColors[Math.floor(Math.random()*this.mouseParticleColors.length)];
                    const angle=Math.random()*Math.PI*2;
                    const speed=Math.random()*2+1;
                    this.mouseParticles.push({x:e.clientX,y:e.clientY,r:Math.random()*3+1,alpha:1,rotation:Math.random()*Math.PI*2,color:color,dx:Math.cos(angle)*speed,dy:Math.sin(angle)*speed});
                }
            }
            buildParticles(){
                this.isDark=document.body.classList.contains('dark');
                this.particles=[];
                let colors=this.isDark?['#00ff99','#ffffff']:['#ff4500','#ff8c00','#1e90ff','#FFD700','blue','red','pink','yellow'];
                for(let i=0;i<100;i++){this.particles.push({x:Math.random()*this.canvas.width,y:Math.random()*this.canvas.height,r:Math.random()*1.5+.5,dx:(Math.random()-.5)*.3,dy:(Math.random()-.5)*.3,color:colors[Math.floor(Math.random()*colors.length)]});}
            }
            animate(){
                if(!this.isAnimating) return;
                this.ctx.clearRect(0,0,this.canvas.width,this.canvas.height);
                this.particles.forEach(p=>{
                    this.ctx.beginPath(); this.ctx.arc(p.x,p.y,p.r,0,Math.PI*2);
                this.ctx.fillStyle=p.color; this.ctx.shadowColor=p.color; this.ctx.shadowBlur=14; this.ctx.fill();
                p.x+=p.dx; p.y+=p.dy;
                if(p.x<0||p.x>this.canvas.width)p.dx*=-1;
                if(p.y<0||p.y>this.canvas.height)p.dy*=-1;
            });
            for(let i=this.mouseParticles.length-1;i>=0;i--){
                const mp=this.mouseParticles[i];
                const numSpikes=5; const outerRadius=mp.r*2; const innerRadius=outerRadius/2;
                this.ctx.beginPath(); this.ctx.moveTo(mp.x,mp.y-outerRadius);
                for(let j=0;j<numSpikes;j++){
                    let angle=(j*2*Math.PI/numSpikes)-Math.PI/2+mp.rotation;
                    this.ctx.lineTo(mp.x+Math.cos(angle)*outerRadius,mp.y+Math.sin(angle)*outerRadius);
                    angle+=Math.PI/numSpikes;
                    this.ctx.lineTo(mp.x+Math.cos(angle)*innerRadius,mp.y+Math.sin(angle)*innerRadius);
                }
                this.ctx.closePath();
                this.ctx.fillStyle=mp.color; this.ctx.shadowColor=mp.color; this.ctx.shadowBlur=20;
                this.ctx.globalAlpha=mp.alpha; this.ctx.fill();
                this.ctx.globalAlpha=1; this.ctx.shadowBlur=0;
                mp.alpha-=0.03; mp.r*=0.93; mp.x+=mp.dx; mp.y+=mp.dy; mp.rotation+=0.1;
                if(mp.alpha<=0||mp.r<=0.1) this.mouseParticles.splice(i,1);
            }
            requestAnimationFrame(this.animate.bind(this));
        }
        start(){this.isAnimating=true; this.animate();}
        stop(){this.isAnimating=false;}
        updateTheme(){this.isDark=document.body.classList.contains('dark'); this.buildParticles();}
        }
        const myParticleSystem=new ParticleSystem('bg-canvas');
        myParticleSystem.start();

        // ================== Sidebar & Theme ==================
        const sidebar=document.getElementById('sidebar');
        document.getElementById('btnToggleSidebar').addEventListener('click',()=>{sidebar.classList.toggle('collapsed'); localStorage.setItem('sidebarCollapsed',sidebar.classList.contains('collapsed'));});
        const themeToggle=document.getElementById('themeToggle');
        if(localStorage.getItem('theme')==='dark') document.body.classList.add('dark');
        themeToggle.addEventListener('click',()=>{
            document.body.classList.toggle('dark');
        localStorage.setItem('theme',document.body.classList.contains('dark')?'dark':'light');
        myParticleSystem.updateTheme();
        });

        // ================== Modal ==================
        let selectedEmail = null;
        function confirmDelete(email, name){
            selectedEmail = email;
            const modalOverlay = document.getElementById('modalOverlay');
            const modalBox = document.getElementById('modalBox');
            document.getElementById('modalTitle').textContent='Confirm Delete';
            document.getElementById('modalMsg').textContent=`Delete user "${name}"?`;
            modalOverlay.style.display='flex';
            setTimeout(()=>modalBox.classList.add('show'),10);
        }
        document.getElementById('btnCancel').addEventListener('click',()=>{
            const modalOverlay = document.getElementById('modalOverlay');
        const modalBox = document.getElementById('modalBox');
        modalBox.classList.remove('show');
        setTimeout(()=>modalOverlay.style.display='none',200);
        });
        document.getElementById('btnConfirm').addEventListener('click', () => {
            if (selectedEmail) {
         // Make sure the path is correct relative to your site root
         window.location.href = '/Admin/Users.aspx?deleteEmail=' + encodeURIComponent(selectedEmail);
        }
        });

        // ================== Pie Chart ==================
        const ctx = document.getElementById('userPieChart').getContext('2d');
        const labels = [<% for(int i=0;i<UserList.Count;i++){ %><%="'" + UserList[i].Name + "'" + (i<UserList.Count-1?",":"") %><% } %>];
        const data = [<% for(int i=0;i<UserList.Count;i++){ %><%= UserList[i].DailyLogCount %><% if(i<UserList.Count-1){ %>,<% } %><% } %>];
        function generateColors(count){const colors=[]; for(let i=0;i<count;i++){colors.push(`hsl(${(360/count)*i},70%,50%)`);} return colors;}
        const backgroundColors = generateColors(labels.length);
        const userPieChart = new Chart(ctx,{
            type:'pie',
            data:{labels:labels,datasets:[{label:'Interactions Today',data:data,backgroundColor:backgroundColors,borderWidth:1}]},
            options:{responsive:true, maintainAspectRatio:true, plugins:{legend:{position:'right'}}, animation:{animateRotate:true,animateScale:true}}
        });
    </script>
</body>
</html>
