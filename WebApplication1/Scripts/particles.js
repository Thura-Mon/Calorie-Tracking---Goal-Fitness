// Particles.js - reusable particle background

const canvas = document.getElementById("particles");
if (canvas) {
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
}
