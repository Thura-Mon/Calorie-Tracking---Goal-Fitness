<%@ Page Title="Results" Language="C#" AutoEventWireup="true" CodeFile="Results.aspx.cs" Inherits="WebApplication1.User.Results" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tu Kha - Results</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        tailwind.config = {
            theme: { extend: { fontFamily: { inter: ['Inter', 'sans-serif'] } } }
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f5f5f5; color: #333; transition: background-color 0.3s, color 0.3s; }
        body.dark { background-color: #0f0f12; color: #f5f7fb; }
        
        /* Fixed Header */
        .topbar { position: fixed; top: 0; left: 0; right: 0; z-index: 50; background: #fff; border-bottom: 1px solid #ddd; display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; box-shadow: 0 2px 6px rgba(0,0,0,0.06); transition: background 0.25s, color 0.25s, border-color 0.25s; }
        body.dark .topbar { background: #121318; border-color: #2b2d34; }

        .nav-menu { display: flex; align-items: center; gap: 12px; }
        .nav-menu a { padding: 8px 12px; border-radius: 8px; text-decoration: none; color: inherit; font-weight: 600; transition: all 0.3s ease; position: relative; }
        .nav-menu a:hover { background: rgba(255,111,0,0.12); color: #ff6f00; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(255,111,0,0.2); }
        body.dark .nav-menu a:hover { background: rgba(0,255,153,0.12); color: #00ff99; box-shadow: 0 4px 12px rgba(0,255,153,0.2); }
        .nav-menu a.active { color: #ff6f00; border-bottom: 2px solid #ff6f00; }
        .title { font-size: 20px; font-weight: 800; color: #ff6f00; }
        body.dark .title { color: #fff; position: relative; text-shadow: 0 0 6px rgba(255,255,255,0.25), 0 0 12px rgba(255,255,255,0.15); }
        body.dark .title::after { content: "✦ ✧ ✦ ✧"; position: absolute; top: -14px; left: 50%; transform: translateX(-50%); font-size: 10px; letter-spacing: 6px; color: #fff; opacity: .7; animation: twinkle 2.3s infinite alternate; }
        @keyframes twinkle { 0% { opacity: .25; filter: blur(.2px); transform: translateX(-50%) translateY(0); } 100% { opacity: .8; filter: blur(0); transform: translateX(-50%) translateY(-1px); } }
        #bg-canvas { position: fixed; inset: 0; width: 100%; height: 100%; z-index: -1; pointer-events: none; }
        .theme-wrap { display: flex; align-items: center; gap: 10px; user-select: none; }
        .theme { position: relative; width: 58px; height: 28px; border-radius: 20px; background: #e4e7ee; border: 1px solid #ccc; cursor: pointer; transition: background .25s; }
        body.dark .theme { background: #23262d; }
        .thumb { position: absolute; top: 2px; left: 2px; width: 24px; height: 24px; border-radius: 50%; background: #fff; display: grid; place-items: center; font-size: 13px; box-shadow: 0 4px 14px rgba(0,0,0,0.25); transition: transform .25s ease, background .25s; }
        body.dark .thumb { transform: translateX(30px); background: #ffb84a; }
        .icon-sun { color: #f5a623; } .icon-moon { display: none; }
        body.dark .icon-sun { display: none; } body.dark .icon-moon { display: block; color: #1d1f26; }

        .results-card-container { background-color: #fff; transition: background-color 0.3s, color 0.3s; }
        body.dark .results-card-container { background-color: #1a1a2e; color: #e0e0e0; }
        .dynamic-text-color { color: #000; }
        body.dark .dynamic-text-color { color: #fff; }

        @keyframes gradient-animation {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .gradient-card { border-radius: 0.75rem; box-shadow: 0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23); transform: translateZ(0); transition: all 0.3s ease-in-out; position: relative; overflow: hidden; background-size: 400% 400%; animation: gradient-animation 8s ease infinite; }
        .gradient-card:hover { transform: translateY(-5px) scale(1.02) translateZ(0); box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22); }
        .gradient-card > * { position: relative; z-index: 1; }
        .card-consumed { background-image: linear-gradient(135deg, #a8ed9c, #dcf8a1, #b2f1f2, #a8ed9c, #b2f1f2); color: #216f3d; }
        .card-consumed p { color: #216f3d; }
        body.dark .card-consumed { background-image: linear-gradient(135deg, #1c7a40, #54b435, #7fe9a1, #1c7a40, #7fe9a1); color: #ebffe6; }
        body.dark .card-consumed p { color: #ebffe6; }
        .card-recommended { background-image: linear-gradient(135deg, #f7d2d7, #f7a9bb, #f5c8e3, #f7d2d7, #f5c8e3); color: #8c244c; }
        .card-recommended p { color: #8c244c; }
        body.dark .card-recommended { background-image: linear-gradient(135deg, #8b1d3d, #c93b6e, #f06a8f, #8b1d3d, #f06a8f); color: #ffe6eb; }
        body.dark .card-recommended p { color: #ffe6eb; }
        .card-net { background-image: linear-gradient(135deg, #a1eafb, #b2f1f2, #c7ecee, #a1eafb, #c7ecee); color: #2e7a8a; }
        .card-net p { color: #2e7a8a; }
        body.dark .card-net { background-image: linear-gradient(135deg, #1f6e8c, #3f90af, #7fcde3, #1f6e8c, #7fcde3); color: #e6f6ff; }
        body.dark .card-net p { color: #e6f6ff; }
        .comment-box-base { border-radius: 0.75rem; box-shadow: 0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23); transform: translateZ(0); transition: all 0.3s ease-in-out; position: relative; overflow: hidden; }
        .comment-box-base:hover { transform: translateY(-3px) scale(1.01) translateZ(0); box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22); }
        .comment-box-base p { position: relative; z-index: 1; }
        .comment-green { background: linear-gradient(135deg, #a8ed9c, #dcf8a1, #b2f1f2); color: #216f3d; }
        body.dark .comment-green { background: linear-gradient(135deg, #1c7a40, #54b435, #7fe9a1); color: #ebffe6; }
        .comment-blue { background: linear-gradient(135deg, #a1d9ff, #c3e2ff, #a1c1ff); color: #2e5a8a; }
        body.dark .comment-blue { background: linear-gradient(135deg, #1f6e8c, #3f90af, #7fcde3); color: #e6f6ff; }
        .comment-red { background: linear-gradient(135deg, #ff9a9e, #fad0c4, #fddb92); color: #a12f2f; }
        body.dark .comment-red { background: linear-gradient(135deg, #a02020, #d03030, #ff6060); color: #ffebeb; }
        .comment-yellow { background: linear-gradient(135deg, #fff7ad, #ffe79c, #ffe4c7); color: #9c7821; }
        body.dark .comment-yellow { background: linear-gradient(135deg, #b08d00, #e0b000, #ffda5a); color: #333; }
        .comment-gray { background: linear-gradient(135deg, #e0e0e0, #f0f0f0, #e8e8e8); color: #555; }
        body.dark .comment-gray { background: linear-gradient(135deg, #333333, #444444, #3a3a3a); color: #ccc; }
        .chart-container { background-color: #fff; transition: background-color 0.3s, color 0.3s; }
        body.dark .chart-container { background-color: #1a1a2e; color: #e0e0e0; }
    </style>
</head>
<body>
    <canvas id="bg-canvas"></canvas>
    
    <nav class="topbar">
        <div class="flex items-center">
            <img class="h-10 w-10 rounded-full object-cover" src="https://placehold.co/40x40/28a745/FFFFFF?text=CT" alt="Logo" />
            <span class="ml-3 text-2xl font-semibold" style="color: inherit;">Tu Kha</span>
        </div>
        <div class="title hidden md:block">Calorie Tracking System</div>
        <div class="nav-menu">
            <a href="Home.aspx">Home</a>
            <a href="Category.aspx">Category</a>
            <a href="Results.aspx" class="active">Results</a>
            <a href="Bmi.aspx">BMI</a>
            <a href="Feedback.aspx">Feedback</a>
            <a href="Userprofile.aspx">Profile</a>
            <a href="Logout.aspx" class="bg-red-500 text-white font-semibold py-2 px-6 rounded-full shadow-lg hover:bg-red-900 transition-all duration-300 transform hover:scale-105">Logout</a>
        </div>
    </nav>
    
    <form id="form1" runat="server" class="container mx-auto p-4 md:p-8 mt-20 md:mt-24">
        <div class="absolute right-4 md:right-8 top-16 z-50">
            <div class="ctrl theme-wrap">
                <span class="theme-label">Theme</span>
                <div class="theme" id="themeToggle">
                    <div class="thumb">
                        <i class="fas fa-sun icon-sun"></i>
                        <i class="fas fa-moon icon-moon"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <div id="resultsCard" class="results-card-container rounded-2xl shadow-lg p-8 w-full max-w-3xl mx-auto">
            <h1 class="text-3xl font-bold text-center dynamic-text-color mb-4">Your Daily Results</h1>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6 text-center md:text-left">
                <div>
                    <h2 class="text-xl font-semibold dynamic-text-color">Hello, <asp:Label ID="lblName" runat="server" CssClass="text-orange-500 font-bold"></asp:Label>!</h2>
                    <p class="text-sm dynamic-text-color">Here's your log for <asp:Label ID="lblDate" runat="server" CssClass="text-cyan-500 font-semibold"></asp:Label>.</p>
                </div>
                <div class="text-right">
                    <h2 class="text-xl font-semibold dynamic-text-color">Your Goal: <asp:Label ID="lblGoal" runat="server" CssClass="text-green-500 font-bold"></asp:Label></h2>
                </div>
            </div>
            
            <hr class="my-4 border-gray-200" />
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-center">
                <div class="p-4 gradient-card card-consumed">
                    <p class="text-3xl font-extrabold"><asp:Label ID="lblConsumedCalories" runat="server"></asp:Label> kcal</p>
                    <p class="mt-1 font-semibold text-sm">Consumed Today</p>
                </div>
                <div class="p-4 gradient-card card-recommended">
                    <p class="text-3xl font-extrabold"><asp:Label ID="lblRecommendedCalories" runat="server"></asp:Label> kcal</p>
                    <p class="mt-1 font-semibold text-sm">Recommended Target</p>
                </div>
                <div class="p-4 gradient-card card-net">
                    <p class="text-3xl font-extrabold"><asp:Label ID="lblNetCalories" runat="server"></asp:Label> kcal</p>
                    <p class="mt-1 font-semibold text-sm">Net Calories</p>
                </div>
            </div>
            
            <div class="mt-6 text-center">
                <div id="commentBox" runat="server" class="p-4 comment-box-base">
                    <p class="text-2xl font-bold mb-1">Comment</p>
                    <p class="text-lg leading-relaxed"><asp:Label ID="lblFeedback" runat="server"></asp:Label></p>
                </div>
            </div>
        </div>
        
        <div class="text-center mt-6 space-x-4 flex justify-center items-center">
            <a href="Category.aspx" class="inline-block bg-gray-500 text-white font-semibold py-2 px-6 rounded-full shadow-lg hover:bg-gray-600 transition-all duration-300 transform hover:scale-105">
                <i class="fas fa-arrow-left mr-2"></i> Go Back
            </a>
            <asp:Button ID="ViewHistoryBtn" runat="server" Text="View History" CssClass="bg-blue-500 text-white font-semibold py-2 px-6 rounded-full shadow-lg hover:bg-blue-600 transition-all duration-300 transform hover:scale-105" OnClick="ViewHistoryBtn_Click" />
            <button type="button" id="saveImageBtn" class="bg-orange-500 text-white font-semibold py-2 px-6 rounded-full shadow-lg hover:bg-orange-600 transition-all duration-300 transform hover:scale-105">
                <i class="fas fa-camera mr-2"></i> Save as Image
            </button>
        </div>

        <div id="historyModal" class="fixed inset-0 bg-gray-900 bg-opacity-50 flex items-center justify-center hidden z-[100]">
            <div class="bg-white dark:bg-gray-800 rounded-lg p-8 w-11/12 md:w-3/4 max-w-4xl max-h-screen overflow-y-auto">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-2xl font-bold text-black dark:text-white">Your Calorie History (Last 7 days)</h3>
                    <button id="closeModalBtn" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 text-2xl">&times;</button>
                </div>
                <div id="historyContent" class="text-black dark:text-white">
                    <div class="mb-6">
                        <canvas id="historyChart"></canvas>
                    </div>

                    <asp:Repeater ID="historyRepeater" runat="server">
                        <HeaderTemplate>
                            <div class="overflow-x-auto">
                                <table class="min-w-full text-left table-auto rounded-lg overflow-hidden shadow-lg">
                                    <thead>
                                        <tr class="bg-gray-200 dark:bg-gray-700 text-gray-600 dark:text-gray-200">
                                            <th class="px-4 py-2">Date</th>
                                            <th class="px-4 py-2">Consumed (kcal)</th>
                                            <th class="px-4 py-2">Net Calories (kcal)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr class="border-b dark:border-gray-600 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors duration-200">
                                <td class="px-4 py-2 whitespace-nowrap"><%# Eval("Date") %></td>
                                <td class="px-4 py-2"><%# ((decimal)Eval("Consumed")).ToString("N0") %></td>
                                <td class="px-4 py-2">
                                    <span class="<%# GetNetCaloriesCssClass((decimal)Eval("Net")) %>"><%# ((decimal)Eval("Net")).ToString("N0") %></span>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody>
                                </table>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>
                    <asp:Label ID="lblNoHistory" runat="server" Text="No history available." CssClass="text-center text-gray-500 dark:text-gray-400" Visible="false"></asp:Label>
                </div>
            </div>
        </div>
    </form>
    <script>
        // Theme toggle and other scripts
        class ParticleSystem {
            constructor(canvasId) {
                this.canvas = document.getElementById(canvasId);
                if (!this.canvas) return;
                this.ctx = this.canvas.getContext('2d');
                this.particles = [];
                this.mouseParticles = [];
                this.isDark = document.body.classList.contains('dark');
                this.isAnimating = false;
                this.mouseParticleColors = ['#ff6f00','#ffd700','#adff2f','#00ffff','#9370db','#ff1493','#00bfff'];
                window.addEventListener('resize', this.resizeCanvas.bind(this));
                document.addEventListener('mousemove', this.handleMouseMove.bind(this));
                this.resizeCanvas();
            }
            resizeCanvas() {
                this.canvas.width = window.innerWidth;
                this.canvas.height = window.innerHeight;
                this.buildParticles();
            }
            handleMouseMove(e){
                for(let i=0;i<5;i++){
                    const color=this.mouseParticleColors[Math.floor(Math.random()*this.mouseParticleColors.length)];
                    const angle=Math.random()*Math.PI*2;
                    const speed=Math.random()*2+1;
                    this.mouseParticles.push({
                        x:e.clientX, y:e.clientY, r:Math.random()*3+1, alpha:1, rotation:Math.random()*Math.PI*2, color:color,
                        dx:Math.cos(angle)*speed, dy:Math.sin(angle)*speed
                    });
                }
            }
            buildParticles(){
                this.isDark=document.body.classList.contains('dark');
                this.particles=[];
                const colors=this.isDark?['#00ff99','#ffffff']:['#ff4500','#ff8c00','#1e90ff','#ffd700','blue','red','pink','yellow'];
                const numParticles=this.isDark?100:50;
                for(let i=0;i<numParticles;i++){
                    this.particles.push({
                        x:Math.random()*this.canvas.width, y:Math.random()*this.canvas.height,
                        r:this.isDark?(Math.random()*1.5+0.5):(Math.random()*1+0.5),
                        dx:(Math.random()-0.5)*(this.isDark?0.3:0.2),
                        dy:(Math.random()-0.5)*(this.isDark?0.3:0.2),
                        color:colors[Math.floor(Math.random()*colors.length)]
                    });
                }
            }
            animate(){
                if(!this.isAnimating) return;
                this.ctx.clearRect(0,0,this.canvas.width,this.canvas.height);
                this.particles.forEach(p=>{
                    this.ctx.beginPath();
                this.ctx.arc(p.x,p.y,p.r,0,Math.PI*2);
                this.ctx.fillStyle=p.color;
                this.ctx.shadowColor=p.color;
                this.ctx.shadowBlur=14;
                this.ctx.fill();
                p.x+=p.dx; p.y+=p.dy;
                if(p.x<0||p.x>this.canvas.width)p.dx*=-1;
                if(p.y<0||p.y>this.canvas.height)p.dy*=-1;
            });
            for(let i=this.mouseParticles.length-1;i>=0;i--){
                const mp=this.mouseParticles[i];
                const numSpikes=5; const outerRadius=mp.r*2; const innerRadius=outerRadius/2;
                this.ctx.beginPath(); this.ctx.moveTo(mp.x, mp.y-outerRadius);
                for(let j=0;j<numSpikes;j++){
                    let angle=(j*2*Math.PI/numSpikes)-Math.PI/2+mp.rotation;
                    this.ctx.lineTo(mp.x+Math.cos(angle)*outerRadius, mp.y+Math.sin(angle)*outerRadius);
                    angle+=Math.PI/numSpikes;
                    this.ctx.lineTo(mp.x+Math.cos(angle)*innerRadius, mp.y+Math.sin(angle)*innerRadius);
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
        start(){this.isAnimating=true;this.animate();}
        stop(){this.isAnimating=false;}
        updateTheme(){this.isDark=document.body.classList.contains('dark');this.buildParticles();}
        }
        const myParticleSystem = new ParticleSystem('bg-canvas');
        
        const themeToggle = document.getElementById('themeToggle');
        function applyTheme(isDark){
            if(isDark) {
                document.body.classList.add('dark');
            } else {
                document.body.classList.remove('dark');
            }
            myParticleSystem.updateTheme();
        }
        const savedTheme = localStorage.getItem('theme');
        applyTheme(savedTheme==='dark');
        
        themeToggle.addEventListener('click', ()=>{
            const isDark = !document.body.classList.contains('dark');
        applyTheme(isDark);
        localStorage.setItem('theme', isDark?'dark':'light');
        });
        
        window.addEventListener('load', ()=>{ 
            myParticleSystem.start(); 
        });

        document.getElementById('saveImageBtn').addEventListener('click', function() {
            const resultsCard = document.getElementById('resultsCard');
            html2canvas(resultsCard, {
                scale: 2,
                useCORS: true
            }).then(canvas => {
                const imageData = canvas.toDataURL('image/png');
            const link = document.createElement('a');
            link.href = imageData;
            link.download = 'TuKha_Daily_Log_Result.png';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        });
        });

        // Script to close the modal
        document.getElementById('closeModalBtn').addEventListener('click', function() {
            const modal = document.getElementById('historyModal');
            modal.classList.add('hidden');
        });

        // Event listener for the server-side button click
        document.addEventListener('DOMContentLoaded', () => {
            const modal = document.getElementById('historyModal');
        if (modal && modal.classList.contains('show-modal')) {
            modal.classList.remove('hidden');
        }
        });
    </script>
</body>
</html>