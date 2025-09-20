<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="WebApplication1.User.Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tu Kha - Register</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: { extend: { fontFamily: { inter: ['Inter', 'sans-serif'] } } }
        }
    </script>
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f5f5f5; 
            color: #333; 
            transition: background-color 0.3s, color 0.3s; 
            overflow: hidden;
        }
        body.dark { background-color: #0f0f12; color: #f5f7fb; }
        
        .dynamic-text-color { color: #000; }
        body.dark .dynamic-text-color { color: #fff; }

        .form-card-container { 
            background-color: #fff; 
            transition: background-color 0.3s, color 0.3s;
            position: relative;
            z-index: 10;
        }
        body.dark .form-card-container { 
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
            inset: -3px;
            background: linear-gradient(
                90deg, 
                #39FF14, #FF073A, #A020F0, #FF10F0, #4D4DFF, #39FF14
            );
            background-size: 400% 400%;
            animation: gradient-animation 3s linear infinite;
            border-radius: 1rem;
            z-index: -1;
        }

        @keyframes gradient-animation {
            0% { background-position: 0% 50%; }
            100% { background-position: 100% 50%; }
        }

        .input-group { position: relative; }
        .input-group .validation-icon,
        .input-group .toggle-password {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.25rem;
            transition: color 0.3s;
        }
        .input-group .validation-icon {
            right: 0;
            color: #ccc;
            display: none; 
        }
        .input-group.valid .validation-icon {
            color: #39FF14;
            display: block; 
        }
        .input-group .toggle-password { right: 2rem; color: #999; cursor: pointer; }
        body.dark .input-group .toggle-password { color: #bbb; }
        
        /* Floating label */
        .input-group label {
            position: absolute;
            top: 1rem;
            left: 0;
            font-size: 1rem;
            color: #777;
            pointer-events: none;
            transition: all 0.2s ease;
        }
        body.dark .input-group label { color: #bbb; }

        .input-group .register-input {
            width: 100%;
            padding: 1rem 0;
            border: none;
            border-bottom: 2px solid #ccc;
            outline: none;
            background-color: transparent;
            font-size: 1rem;
            transition: all 0.2s ease;
            color: #333;
        }
        body.dark .input-group .register-input { color: #f5f7fb; }
        .input-group .register-input:focus { border-color: #ff6f00; }
        .input-group .register-input:focus + label,
        .input-group .register-input:not(:placeholder-shown) + label {
            top: 0;
            font-size: 0.75rem;
            transform: translateY(-50%);
            color: #ff6f00;
        }
        
        /* Error messages */
        .error-message {
            color: #e53e3e;
            font-size: 0.75rem;
            margin-top: 4px;
            min-height: 1.25rem;
            opacity: 0;
            transition: opacity 0.3s ease-in-out;
        }
        .input-group.error .error-message { opacity: 1; }
        .input-group.error .register-input { border-color: #e53e3e; }
        .input-group.error .register-input:focus + label,
        .input-group.error .register-input:not(:placeholder-shown) + label { color: #e53e3e; }
        
        #bg-canvas { position: fixed; inset: 0; width: 100%; height: 100%; z-index: -1; pointer-events: none; }

        /* Modal */
        #messageBoxModal {
            position: fixed;
            inset: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: rgba(0,0,0,0.6);
            z-index: 1000;
        }
        .modal-content {
            background-color: #fff;
            padding: 2.5rem;
            border-radius: 1rem;
            text-align: center;
            box-shadow: 0 10px 25px rgba(0,0,0,0.25);
            max-width: 90%;
            width: 400px;
            position: relative;
        }
        body.dark .modal-content { background-color: #1a1a2e; }
        .modal-success { border: 2px solid #39FF14; }
        .modal-error { border: 2px solid #FF073A; }
        .modal-icon { font-size: 3rem; margin-bottom: 1rem; }
        .modal-success .modal-icon { color: #39FF14; }
        .modal-error .modal-icon { color: #FF073A; }
        .modal-title { font-size: 1.5rem; font-weight: 700; margin-bottom: 0.5rem; }
        .modal-message { margin-bottom: 1.5rem; color: #666; }
        body.dark .modal-message { color: #bbb; }
        .modal-close {
            background-color: #ff6f00;
            color: #fff;
            padding: 0.75rem 2rem;
            border-radius: 9999px;
            font-weight: 600;
            transition: all 0.2s ease-in-out;
        }
        .modal-close:hover { transform: translateY(-2px); box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
    </style>
</head>
<body class="bg-gray-100 dark:bg-gray-900 flex flex-col items-center justify-center min-h-screen">
    <canvas id="bg-canvas"></canvas>
    
    <form id="form1" runat="server" class="w-full">
        <!-- Theme Toggle -->
        <div class="absolute right-4 md:right-8 top-4 z-50">
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
        
        <!-- Register Form -->
        <div class="animated-card-gradient w-full max-w-4xl mx-auto">
            <div class="form-card-container rounded-2xl p-4 md:p-6 z-20">
                <h1 class="text-2xl font-bold text-center dynamic-text-color mb-3">Create Account</h1>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-y-4 md:gap-x-8">
                    <div>
                        <div class="input-group">
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="register-input" placeholder=" " />
                            <label for="txtEmail" class="register-label dynamic-text-color">Email</label>
                            <i class="fas fa-check-circle validation-icon"></i>
                            <div class="error-message"></div>
                        </div>

                        <div class="input-group mt-4">
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="register-input" TextMode="Password" placeholder=" " />
                            <label for="txtPassword" class="register-label dynamic-text-color">Password</label>
                            <i class="fas fa-check-circle validation-icon"></i>
                            <i id="togglePasswordIcon" class="toggle-password fas fa-eye"></i>
                            <div class="error-message"></div>
                        </div>

                        <div class="input-group mt-4">
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="register-input" TextMode="Password" placeholder=" " />
                            <label for="txtConfirmPassword" class="register-label dynamic-text-color">Confirm Password</label>
                            <i class="fas fa-check-circle validation-icon"></i>
                            <i id="toggleConfirmPasswordIcon" class="toggle-password fas fa-eye"></i>
                            <div class="error-message"></div>
                        </div>

                        <div class="input-group mt-4">
                            <asp:TextBox ID="txtName" runat="server" CssClass="register-input" placeholder=" " />
                            <label for="txtName" class="register-label dynamic-text-color">Full Name</label>
                            <i class="fas fa-check-circle validation-icon"></i>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="input-group mt-4">
                            <asp:TextBox ID="txtAge" runat="server" CssClass="register-input" TextMode="Number" placeholder=" " />
                            <label for="txtAge" class="register-label dynamic-text-color">Age</label>
                            <i class="fas fa-check-circle validation-icon"></i>
                            <div class="error-message"></div>
                        </div>
                    </div>

                    <div>
                        <div class="input-group">
                            <asp:DropDownList ID="ddlGender" runat="server" CssClass="register-input">
                                <asp:ListItem Text="Select Gender" Value="" Selected="True" />
                                <asp:ListItem Text="Male" Value="Male" />
                                <asp:ListItem Text="Female" Value="Female" />
                            </asp:DropDownList>
                            <i class="fas fa-check-circle validation-icon"></i>
                            <div class="error-message"></div>
                        </div>

                        <div class="input-group mt-4">
                            <asp:DropDownList ID="ddlGoal" runat="server" CssClass="register-input">
                                <asp:ListItem Text="Select Goal" Value="" Selected="True" />
                                <asp:ListItem Text="Lose Weight" Value="Lose Weight" />
                                <asp:ListItem Text="Maintain Weight" Value="Maintain Weight" />
                                <asp:ListItem Text="Gain Weight" Value="Gain Weight" />
                            </asp:DropDownList>
                            <i class="fas fa-check-circle validation-icon"></i>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="input-group mt-4">
                            <asp:TextBox ID="txtWeight" runat="server" CssClass="register-input" TextMode="Number" placeholder=" " />
                            <label for="txtWeight" class="register-label dynamic-text-color">Weight (kg)</label>
                            <i class="fas fa-check-circle validation-icon"></i>
                            <div class="error-message"></div>
                        </div>
                        
                        <div class="input-group mt-4">
                            <asp:TextBox ID="txtHeight" runat="server" CssClass="register-input" TextMode="Number" placeholder=" " />
                            <label for="txtHeight" class="register-label dynamic-text-color">Height (cm)</label>
                            <i class="fas fa-check-circle validation-icon"></i>
                            <div class="error-message"></div>
                        </div>
                    </div>
                </div>

                <div class="mt-4 text-center">
                    <asp:Button ID="btnRegister" runat="server" Text="Register" 
                        CssClass="bg-green-500 text-white font-semibold py-1.5 px-4 rounded-full shadow-lg hover:bg-green-600 transition-all duration-300 transform hover:scale-105" 
                        OnClick="btnRegister_Click" />
                </div>
                
                <p class="mt-3 text-center text-gray-500 text-sm">
                    Already have an account? <a href="Login.aspx" class="text-blue-500 hover:underline">Log in</a>
                </p>
            </div>
        </div>
    </form>
    
    <!-- Modal -->

    
    
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
        attachValidationEvents();
        attachPasswordToggleEvents();
        });

        function attachValidationEvents() {
            const inputs = document.querySelectorAll('.register-input');
            inputs.forEach(input => {
                input.addEventListener('keyup', () => validateField(input));
            input.addEventListener('blur', () => validateField(input));
        });
        }
        
        function attachPasswordToggleEvents() {
            const togglePassword = (input, icon) => {
                icon.addEventListener('click', () => {
                    const type = input.getAttribute('type') === 'password' ? 'text' : 'password';
            input.setAttribute('type', type);
            icon.classList.toggle('fa-eye');
            icon.classList.toggle('fa-eye-slash');
        });
        };

        const passwordInput = document.getElementById('<%= txtPassword.ClientID %>');
                const passwordIcon = document.getElementById('togglePasswordIcon');
                if (passwordInput && passwordIcon) {
                    togglePassword(passwordInput, passwordIcon);
                }

                const confirmPasswordInput = document.getElementById('<%= txtConfirmPassword.ClientID %>');
            const confirmPasswordIcon = document.getElementById('toggleConfirmPasswordIcon');
            if (confirmPasswordInput && confirmPasswordIcon) {
                togglePassword(confirmPasswordInput, confirmPasswordIcon);
            }
            }

            function validateField(element) {
                const id = element.id;
                const value = element.value;

                const isValidEmail = (email) => /@gmail\.com$/.test(email);
                const isValidPassword = (password) => /^(?=.*[A-Z])(?=.*[a-z])(?=.*[^a-zA-Z0-9]).*$/.test(password) && password.length >= 8;
                const passwordsMatch = () => document.getElementById('<%= txtPassword.ClientID %>').value === document.getElementById('<%= txtConfirmPassword.ClientID %>').value;
            const isValidName = (name) => /^[a-zA-Z\s]+$/.test(name) && name.length > 2;
            const isValidAge = (age) => /^\d+$/.test(age) && parseInt(age, 10) > 0 && parseInt(age, 10) < 120;
            const isOptionSelected = (select) => select.value !== "";
            const isValidNumber = (number) => /^\d+(\.\d+)?$/.test(number) && parseFloat(number) > 0;

            const errorMessages = {
                email: 'Must be a valid @gmail.com address.',
                password: 'Password must start with a capital letter, contain a lowercase letter, and a special character.',
                confirmPassword: 'Passwords do not match.',
                name: 'Full Name must contain only letters and spaces, and be at least 3 characters long.',
                age: 'Age must be a positive number.',
                gender: 'Please select your gender.',
                goal: 'Please select a goal.',
                weight: 'Weight must be a positive number.',
                height: 'Height must be a positive number.',
            };

            let isValid = false;
            let errorMessage = '';
            
            if (id.includes('txtEmail')) {
                isValid = isValidEmail(value);
                errorMessage = errorMessages.email;
            } else if (id.includes('txtPassword')) {
                isValid = isValidPassword(value);
                errorMessage = errorMessages.password;
            } else if (id.includes('txtConfirmPassword')) {
                isValid = passwordsMatch();
                errorMessage = errorMessages.confirmPassword;
            } else if (id.includes('txtName')) {
                isValid = isValidName(value);
                errorMessage = errorMessages.name;
            } else if (id.includes('txtAge')) {
                isValid = isValidAge(value);
                errorMessage = errorMessages.age;
            } else if (id.includes('ddlGender')) {
                isValid = isOptionSelected(element);
                errorMessage = errorMessages.gender;
            } else if (id.includes('ddlGoal')) {
                isValid = isOptionSelected(element);
                errorMessage = errorMessages.goal;
            } else if (id.includes('txtWeight')) {
                isValid = isValidNumber(value);
                errorMessage = errorMessages.weight;
            } else if (id.includes('txtHeight')) {
                isValid = isValidNumber(value);
                errorMessage = errorMessages.height;
            }
            setValidationStatus(element, isValid, errorMessage);
        }
        
        function setValidationStatus(element, isValid, errorMessage) {
            const parentGroup = element.closest('.input-group');
            if (!parentGroup) return;
            const errorElement = parentGroup.querySelector('.error-message');
            
            if (isValid) {
                parentGroup.classList.add('valid');
                parentGroup.classList.remove('error');
                if (errorElement) errorElement.textContent = '';
            } else {
                parentGroup.classList.remove('valid');
                parentGroup.classList.add('error');
                if (errorElement) errorElement.textContent = errorMessage;
            }
        }
        
        function showMessageBox(message, isSuccess) {
            const modal = document.getElementById('messageBoxModal');
            const icon = document.getElementById('modalIcon');
            const title = document.getElementById('modalTitle');
            const msg = document.getElementById('modalMessage');

            const modalContent = modal.querySelector('.modal-content');
            modalContent.classList.remove('modal-success', 'modal-error');
            icon.className = 'modal-icon fas';

            if (isSuccess) {
                modalContent.classList.add('modal-success');
                icon.classList.add('fa-check-circle');
                title.textContent = 'Success!';
            } else {
                modalContent.classList.add('modal-error');
                icon.classList.add('fa-times-circle');
                title.textContent = 'Error!';
            }

            msg.textContent = message;
            modal.classList.remove('hidden');

            document.getElementById('modalClose').onclick = () => {
                modal.classList.add('hidden');
        };
        }
    </script>
</body>
</html>