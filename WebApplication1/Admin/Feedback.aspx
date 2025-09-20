<%@ Page Title="Dashboard" Language="C#" AutoEventWireup="true" CodeFile="Feedback.aspx.cs" Inherits="WebApplication1.Admin.Feedback" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <title>Calorie Tracking System - Home</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- Font Awesome and Tailwind -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        inter: ['Inter', 'sans-serif'],
                    },
                    animation: {
                        'float-form': 'floatForm 3s ease-in-out infinite alternate',
                    },
                    keyframes: {
                        floatForm: {
                            'from': { transform: 'translateY(0)' },
                            'to': { transform: 'translateY(-12px)' },
                        },
                    },
                }
            }
        }
    </script>

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f5f5f5;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        #particles {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
        }
    </style>
</head>
<body class="bg-gray-100 flex flex-col font-inter">

    <!-- Navbar -->
    <nav class="bg-white/80 backdrop-blur-md sticky top-0 z-50 shadow-md">
        <div class="container mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
                <!-- Left Logo -->
                <div class="flex-shrink-0 flex items-center">
                    <img class="h-10 w-10 rounded-full object-cover" src="https://placehold.co/40x40/28a745/FFFFFF?text=CT" alt="Logo" />
                    <span class="ml-3 text-2xl font-semibold text-gray-900">Tu Kha</span>
                </div>

                <!-- Right Links -->
                <div class="flex items-center space-x-2 md:space-x-6">
                    <a href="dashboard.aspx" class="text-gray-600 hover:text-green-500 font-medium transition-colors duration-200">Dashboard</a>
                    <a href="Category.aspx" class="text-gray-600 hover:text-green-500 font-medium transition-colors duration-200">Category</a>
                    <a href="Feedback.aspx" class="text-green-600 hover:text-green-500 font-medium transition-colors duration-200">Feedback</a>
                    <a href="/Account/Logout.aspx" class="bg-red-500 text-white font-semibold py-2 px-6 rounded-full shadow-lg hover:bg-red-900 transition-all duration-300 transform hover:scale-105">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Particles background -->
    <canvas id="particles"></canvas>

    <!-- Main content -->
    <form id="form1" runat="server" class="flex-grow flex items-center justify-center p-6">
        <div class="flex flex-col items-center p-6 md:p-10 bg-white/85 backdrop-blur-3xl border border-gray-200 rounded-3xl shadow-2xl relative max-w-3xl w-full z-10 animate-float-form overflow-y-auto">

            <!-- Buttons -->
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-2 lg:grid-cols-4 gap-4 w-full mb-6">
                <asp:Button ID="btnmeanu" runat="server" CssClass="w-full bg-green-500 text-white font-semibold py-4 rounded-xl shadow-lg hover:bg-green-600 transition-all duration-300 transform hover:scale-105" Text="Meanu" PostBackUrl="~/TrackCalories.aspx" />
                <asp:Button ID="btnTrackCalories" runat="server" CssClass="w-full bg-green-500 text-white font-semibold py-4 rounded-xl shadow-lg hover:bg-green-600 transition-all duration-300 transform hover:scale-105" Text="Track Calories" PostBackUrl="~/TrackCalories.aspx" />
                <asp:Button ID="btnViewReports" runat="server" CssClass="w-full bg-green-500 text-white font-semibold py-4 rounded-xl shadow-lg hover:bg-green-600 transition-all duration-300 transform hover:scale-105" Text="View Reports" PostBackUrl="~/Reports.aspx" />
                <asp:Button ID="btnLogout" runat="server" CssClass="w-full bg-red-500 text-white font-semibold py-4 rounded-xl shadow-lg hover:bg-red-600 transition-all duration-300 transform hover:scale-105" Text="Logout" PostBackUrl="~/Logout.aspx" />
            </div>

            <!-- Section -->
            <div class="text-center">
                <h2 class="text-2xl font-bold text-green-600 mb-2">Your Health, Your Calories!</h2>
                <p class="text-gray-700 max-w-xl mx-auto">
                    Track your daily calorie intake and maintain a healthy lifestyle with our easy-to-use system.
                    Get detailed reports, insights, and recommendations to achieve your fitness goals.
                </p>
            </div>
        </div>
    </form>

    <!-- Particles JS (copied from Login.aspx) -->
    <script>
        const canvas = document.getElementById("particles");
        const ctx = canvas.getContext("2d");
        let particlesArray, w, h, mouse;
        let mouseParticlesArray = [];

        function initParticles() {
            w = canvas.width = window.innerWidth;
            h = canvas.height = window.innerHeight;
            particlesArray = [];
            const numStars = Math.floor((w * h) / 8000);
            for (let i = 0; i < numStars; i++) {
                const radius = Math.random() * 1.5 + 0.3;
                particlesArray.push({
                    x: Math.random() * w,
                    y: Math.random() * h,
                    vx: (Math.random() - 0.5) * 0.05,
                    vy: (Math.random() - 0.5) * 0.05,
                    radius: radius,
                    baseRadius: radius,
                    color: `hsl(200, ${Math.random() * 30 + 70}%, ${Math.random() * 30 + 70}%)`,
            opacity: Math.random(),
            fadeSpeed: (Math.random() * 0.02 + 0.01) * (Math.random() > 0.5 ? 1 : -1),
            });
        }
        }

        class MouseParticle {
            constructor(x, y) {
                this.x = x;
                this.y = y;
                this.vx = (Math.random() - 0.5) * 5;
                this.vy = (Math.random() - 0.5) * 5;
                this.radius = Math.random() * 2 + 1;
                this.opacity = 1;
                this.decayRate = Math.random() * 0.02 + 0.01;
                this.hue = Math.floor(Math.random() * 360);
            }
            draw() {
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
                const gradient = ctx.createRadialGradient(this.x, this.y, 0, this.x, this.y, this.radius);
                gradient.addColorStop(0, `hsla(${this.hue}, 100%, 70%, ${this.opacity})`);
            gradient.addColorStop(1, `hsla(${this.hue}, 100%, 50%, 0)`);
        ctx.fillStyle = gradient;
        ctx.fill();
        }
        update() {
            this.x += this.vx;
            this.y += this.vy;
            this.opacity -= this.decayRate;
        }
        }

        function animateParticles() {
            ctx.fillStyle = "rgba(245, 245, 245, 0.2)";
            ctx.fillRect(0, 0, w, h);

            for (let i = 0; i < mouseParticlesArray.length; i++) {
                mouseParticlesArray[i].update();
                mouseParticlesArray[i].draw();
                if (mouseParticlesArray[i].opacity <= 0) {
                    mouseParticlesArray.splice(i, 1);
                    i--;
                }
            }

            for (let p of particlesArray) {
                p.opacity += p.fadeSpeed;
                if (p.opacity > 1 || p.opacity < 0.1) {
                    p.fadeSpeed *= -1;
            }

        if (mouse) {
            const dx = mouse.x - p.x;
            const dy = mouse.y - p.y;
            const dist = Math.sqrt(dx * dx + dy * dy);
            const maxDist = 200;

            if (dist < maxDist) {
                const pull = 0.005;
                p.vx += dx * pull;
                p.vy += dy * pull;
                p.vx *= 0.95;
                p.vy *= 0.95;
            }
        }

        p.x += p.vx;
        p.y += p.vy;

        if (p.x < 0 || p.x > w) p.vx *= -1;
        if (p.y < 0 || p.y > h) p.vy *= -1;

        ctx.beginPath();
        ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
        ctx.fillStyle = `hsl(200, 100%, 80%, ${p.opacity})`;
        ctx.fill();
        }
        requestAnimationFrame(animateParticles);
        }

        mouse = null;
        window.addEventListener("mousemove", (event) => {
            mouse = { x: event.clientX, y: event.clientY };
        for (let i = 0; i < 8; i++) {
            mouseParticlesArray.push(new MouseParticle(event.clientX, event.clientY));
        }
        if (mouseParticlesArray.length > 200) {
            mouseParticlesArray = mouseParticlesArray.slice(-200);
        }
        });

        window.addEventListener("resize", initParticles);
        initParticles();
        animateParticles();
    </script>
</body>
</html>

