<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Feedback.aspx.cs" Inherits="WebApplication1.User.Feedback" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tu Kha - User Feedback</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
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
        #bg-canvas { position: fixed; inset: 0; width: 100%; height: 100%; z-index: 9999; pointer-events: none; }
        .theme-wrap { display: flex; align-items: center; gap: 10px; user-select: none; }
        .theme { position: relative; width: 58px; height: 28px; border-radius: 20px; background: #e4e7ee; border: 1px solid #ccc; cursor: pointer; transition: background .25s; }
        body.dark .theme { background: #23262d; }
        .thumb { position: absolute; top: 2px; left: 2px; width: 24px; height: 24px; border-radius: 50%; background: #fff; display: grid; place-items: center; font-size: 13px; box-shadow: 0 4px 14px rgba(0,0,0,0.25); transition: transform .25s ease, background .25s; }
        body.dark .thumb { transform: translateX(30px); background: #ffb84a; }
        .icon-sun { color: #f5a623; } .icon-moon { display: none; }
        body.dark .icon-sun { display: none; } body.dark .icon-moon { display: block; color: #1d1f26; }
        
        .dynamic-text-color { color: #000; }
        body.dark .dynamic-text-color { color: #fff; }

        .user-card-container { 
            background-color: #fff; 
            transition: background-color 0.3s, color 0.3s;
            position: relative;
            z-index: 10;
        }
        body.dark .user-card-container { 
            background-color: #1a1a2e !important; 
            color: #e0e0e0 !important; 
        }

        .animated-card-gradient {
            position: relative;
            padding: 3px;
            border-radius: 1rem;
            box-shadow: 0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23);
            overflow: hidden;
        }
        .animated-card-gradient::before {
            content: '';
            position: absolute;
            inset: -3px; /* Extends the pseudo-element to cover the border */
            background: linear-gradient(
                90deg, 
                #39FF14, #FF073A, #A020F0, #FF10F0, #4D4DFF, #39FF14
            );
            background-size: 400% 400%; /* Stretched background for a longer "line" */
            animation: gradient-animation 3s linear infinite; /* Faster animation speed */
            border-radius: 1rem;
            z-index: -1;
        }

        @keyframes gradient-animation {
            0% { background-position: 0% 50%; }
            100% { background-position: 100% 50%; }
        }

        .feedback-label { font-weight: 600; color: #555; }
        body.dark .feedback-label { color: #ccc; }

        .feedback-input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            background-color: #f9f9f9;
            transition: all 0.2s ease-in-out;
            color: #333;
        }
        body.dark .feedback-input {
            background-color: #2b2d34;
            border-color: #4a4d53;
            color: #f5f7fb;
        }

        .feedback-input:focus {
            outline: none;
            border-color: #ff6f00;
            box-shadow: 0 0 0 2px rgba(255, 111, 0, 0.25);
        }

        .message-container {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 600;
            opacity: 0;
            transform: translateY(-20px);
            animation: fadeInOut 5s forwards;
        }

        .message-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @keyframes fadeInOut {
            0% { opacity: 0; transform: translateY(-20px); }
            10% { opacity: 1; transform: translateY(0); }
            90% { opacity: 1; transform: translateY(0); }
            100% { opacity: 0; transform: translateY(-20px); }
        }
    </style>
</head>
<body>
    <canvas id="bg-canvas"></canvas>
    
    <!-- Top menu bar outside the form for correct positioning -->
    <nav class="topbar">
        <div class="flex items-center">
            <img class="h-10 w-10 rounded-full object-cover" src="https://placehold.co/40x40/28a745/FFFFFF?text=CT" alt="Logo" />
            <span class="ml-3 text-2xl font-semibold" style="color: inherit;">Tu Kha</span>
        </div>
        <div class="title hidden md:block">Calorie Tracking System</div>
        <div class="nav-menu">
            <a href="Home.aspx">Home</a>
            <a href="Category.aspx">Category</a>
            <a href="Results.aspx">Results</a>
            <a href="Bmi.aspx">BMI</a>
            <a href="Feedback.aspx" class="active">Feedback</a>
            <a href="Userprofile.aspx">Profile</a>
            <a href="Logout.aspx" class="bg-red-500 text-white font-semibold py-2 px-6 rounded-full shadow-lg hover:bg-red-900 transition-all duration-300 transform hover:scale-105">Logout</a>
        </div>
    </nav>
    
    <form id="form1" runat="server" class="container mx-auto p-4 md:p-8 mt-20 md:mt-24">
        <div class="absolute right-4 md:right-8 top-16 z-50">
            <div class="ctrl theme-wrap">
                <span class="theme-label">Theme</span>
                <div class="theme" id="themeToggle" runat="server">
                    <div class="thumb">
                        <i class="fas fa-sun icon-sun"></i>
                        <i class="fas fa-moon icon-moon"></i>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="animated-card-gradient w-full max-w-2xl mx-auto">
            <div class="user-card-container rounded-2xl p-8 z-20">
                <h1 class="text-3xl font-bold text-center dynamic-text-color mb-6">User Feedback</h1>
                
                <div id="messageContainer" runat="server"></div>

                <div class="grid grid-cols-1 gap-y-6">
                    <div>
                        <label for="txtFeedback" class="feedback-label dynamic-text-color">Your Feedback</label>
                        <asp:TextBox ID="txtFeedback" runat="server" CssClass="feedback-input" TextMode="MultiLine" Rows="10" />
                    </div>
                </div>

                <div class="mt-8 text-center">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Feedback" 
                        CssClass="bg-green-500 text-white font-semibold py-3 px-8 rounded-full shadow-lg hover:bg-green-600 transition-all duration-300 transform hover:scale-105" 
                        OnClick="btnSubmit_Click" />
                </div>
            </div>
        </div>
    </form>
    
    <script>
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

                window.addEventListener('mousemove', this.handleMouseMove.bind(this));
                window.addEventListener('resize', this.resizeCanvas.bind(this));
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
            const body = document.body;
            if(isDark) {
                body.classList.add('dark');
            } else {
                body.classList.remove('dark');
            }
            myParticleSystem.updateTheme();
        }
        
        const savedTheme = localStorage.getItem('theme');
        applyTheme(savedTheme === 'dark');
        
        themeToggle.addEventListener('click', ()=>{
            const isDark = !document.body.classList.contains('dark');
        applyTheme(isDark);
        localStorage.setItem('theme', isDark ? 'dark' : 'light');
        });
        
        window.addEventListener('load', ()=>{ 
            myParticleSystem.start(); 
        });
    </script>
</body>
</html>
