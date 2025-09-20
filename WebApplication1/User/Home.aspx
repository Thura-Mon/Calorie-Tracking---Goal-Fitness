<%@ Page Title="Home" Language="C#" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="WebApplication1.User.Home" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tu Kha - Home</title>

    <!-- Font Awesome and Tailwind -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>

    <script>
        tailwind.config = {
            theme: { extend: { fontFamily: { inter: ['Inter', 'sans-serif'] } } }
        }
    </script>

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f5f5f5; color: #333; transition: background-color 0.3s, color 0.3s; }
        body.dark { background-color: #0f0f12; color: #f5f7fb; }

        /* ===== Top Menu Bar ===== */
        .topbar {
            position: sticky; top: 0; z-index: 50; background: #fff;
            border-bottom: 1px solid #ddd;
            display: flex; align-items: center; justify-content: space-between;
            padding: 12px 16px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.06);
            transition: background 0.25s, color 0.25s, border-color 0.25s;
        }
        body.dark .topbar { background: #121318; border-color: #2b2d34; }
        .nav-menu { display: flex; align-items: center; gap: 12px; }
        .nav-menu a {
            padding: 8px 12px; border-radius: 8px; text-decoration: none;
            color: inherit; font-weight: 600; transition: all 0.3s ease; position: relative;
        }
        .nav-menu a:hover { background: rgba(255,111,0,0.12); color: #ff6f00; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(255,111,0,0.2); }
        body.dark .nav-menu a:hover { background: rgba(0,255,153,0.12); color: #00ff99; box-shadow: 0 4px 12px rgba(0,255,153,0.2); }
        .nav-menu a.active { color: #ff6f00; border-bottom: 2px solid #ff6f00; }
        .title { font-size: 20px; font-weight: 800; color: #ff6f00; }
        body.dark .title { color: #fff; position: relative; text-shadow: 0 0 6px rgba(255,255,255,0.25), 0 0 12px rgba(255,255,255,0.15); }
        body.dark .title::after { content: "✦ ✧ ✦ ✧"; position: absolute; top: -14px; left: 50%; transform: translateX(-50%); font-size: 10px; letter-spacing: 6px; color: #fff; opacity: .7; animation: twinkle 2.3s infinite alternate; }
        @keyframes twinkle { 0% { opacity: .25; filter: blur(.2px); transform: translateX(-50%) translateY(0); } 100% { opacity: .8; filter: blur(0); transform: translateX(-50%) translateY(-1px); } }

        /* ===== Particle Canvas ===== */
        #bg-canvas { position: fixed; inset: 0; width: 100%; height: 100%; z-index: -1; pointer-events: none; }

        /* ===== Theme Toggle ===== */
        .theme-wrap { display: flex; align-items: center; gap: 10px; user-select: none; }
        .theme-label { font-weight: 700; opacity: .9; }
        .theme { position: relative; width: 58px; height: 28px; border-radius: 20px; background: #e4e7ee; border: 1px solid #ccc; cursor: pointer; transition: background .25s; }
        body.dark .theme { background: #23262d; }
        .thumb { position: absolute; top: 2px; left: 2px; width: 24px; height: 24px; border-radius: 50%; background: #fff; display: grid; place-items: center; font-size: 13px; box-shadow: 0 4px 14px rgba(0,0,0,0.25); transition: transform .25s ease, background .25s; }
        body.dark .thumb { transform: translateX(30px); background: #ffb84a; }
        .icon-sun { color: #f5a623; } .icon-moon { display: none; }
        body.dark .icon-sun { display: none; } body.dark .icon-moon { display: block; color: #1d1f26; }

        /* Hero Section */
        .hero { max-width:900px; margin-left: 20%; margin-top: 100px; text-align:center; padding:4rem 1rem; opacity:0; transform:translateY(20px); animation:fadeInHero 1s forwards 0.6s; }
        .hero h1 { font-size:2.5rem; font-weight:800; margin-bottom:1rem; opacity:0; transform:translateY(20px); animation:fadeInText 1s forwards 0.8s; }
        .hero p { font-size:1.25rem; margin-bottom:2rem; opacity:0; transform:translateY(20px); animation:fadeInText 1s forwards 1s; }
        .btn-start { background:#ff6f00; color:white; font-weight:600; padding:0.75rem 2rem; border-radius:9999px; box-shadow:0 4px 12px rgba(0,0,0,0.2); transition:all 0.3s; opacity:0; transform:translateY(20px); animation:fadeInText 1s forwards 1.2s; }
        .btn-start:hover { background:#ff8c00; transform:scale(1.05); }
        body.dark .btn-start { background:#00ff99; color:#000; }
        body.dark .btn-start:hover { background:#00cc7a; }

        /* Animations */
        @keyframes fadeInMenu { to { opacity:1; transform:translateY(0); } }
        @keyframes fadeInHero { to { opacity:1; transform:translateY(0); } }
        @keyframes fadeInText { to { opacity:1; transform:translateY(0); } }
    </style>
</head>
<body>

    <!-- ===== Particle Canvas ===== -->
    <canvas id="bg-canvas"></canvas>

    <!-- ===== Top Menu Bar ===== -->
    <nav class="topbar">
        <div class="flex items-center">
            <img class="h-10 w-10 rounded-full object-cover" src="https://placehold.co/40x40/28a745/FFFFFF?text=CT" alt="Logo" />
            <span class="ml-3 text-2xl font-semibold" style="color: inherit;">Tu Kha</span>
        </div>
        <div class="title hidden md:block">Calorie Tracking System</div>
        <div class="nav-menu">
            <a href="Home.aspx" class="active">Home</a>
            <a href="Category.aspx">Category</a>
            <a href="Results.aspx">Results</a>
            <a href="Bmi.aspx">BMI</a>
            <a href="Feedback.aspx">Feedback</a>
            <a href="Userprofile.aspx">Profile</a>
            <a href="/Account/Logout.aspx" class="bg-red-500 text-white font-semibold py-2 px-6 rounded-full shadow-lg hover:bg-red-900 transition-all duration-300 transform hover:scale-105">Logout</a>
        </div>
    </nav>

    <!-- ===== Theme Toggle Button ===== -->
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

    <!-- Hero Section -->
    <section class="hero">
        <h1>Achieve Your Health Goals with Intelligent Calorie Tracking</h1>
        <p>Effortlessly log your meals, track your progress, and get actionable insights to lead a healthier life.</p>
        <button class="btn-start" onclick="location.href='Category.aspx'">Start Tracking Calories</button>
    </section>

    <script>
        // --- Particle System ---
        class ParticleSystem {
            constructor(canvasId) {
                this.canvas = document.getElementById(canvasId);
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

        // --- Theme Toggle ---
        const themeToggle = document.getElementById('themeToggle');
        function applyTheme(isDark){
            if(isDark) document.body.classList.add('dark'); else document.body.classList.remove('dark');
            myParticleSystem.updateTheme();
        }
        const savedTheme = localStorage.getItem('theme');
        applyTheme(savedTheme==='dark');
        themeToggle.addEventListener('click', ()=>{
            const isDark = !document.body.classList.contains('dark');
        applyTheme(isDark);
        localStorage.setItem('theme', isDark?'dark':'light');
        });
        window.addEventListener('load', ()=>{ setTimeout(()=>myParticleSystem.start(),500); });
    </script>
</body>
</html>
