<%@ Page Title="Food Category" Language="C#" AutoEventWireup="true" CodeFile="Category.aspx.cs" Inherits="WebApplication1.User.Category" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tu Kha - Category</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

    <script>
        tailwind.config = {
            theme: { extend: { fontFamily: { inter: ['Inter', 'sans-serif'] } } }
        }
    </script>
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f5f5f5; color: #333; transition: background-color 0.3s, color 0.3s; }
        body.dark { background-color: #0f0f12; color: #f5f7fb; }
        .modal-open .topbar, .modal-open #form1, .modal-open #bg-canvas, .modal-open .theme-wrap { filter: blur(5px); transition: filter 0.3s ease; }
        .topbar { position: sticky; top: 0; z-index: 50; background: #fff; border-bottom: 1px solid #ddd; display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; box-shadow: 0 2px 6px rgba(0,0,0,0.06); transition: background 0.25s, color 0.25s, border-color 0.25s; }
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
        .food-item-container { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1.5rem; }
        .food-item { display: flex; flex-direction: column; background-color: white; padding: 1rem; border-radius: 1rem; box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: transform 0.2s, box-shadow 0.2s; cursor: pointer; }
        .food-item:hover { transform: translateY(-5px); box-shadow: 0 8px 12px rgba(0,0,0,0.15); }
        body.dark .food-item { background-color: #17181c; color: #f5f7fb; }
        body.dark input[type="text"], body.dark input[type="number"] { background-color: #17181c; color: #f5f7fb; border-color: #4b5563; }
        body.dark h1, body.dark h2, body.dark p { color: #f5f7fb; }
        .theme-wrap { display: flex; align-items: center; gap: 10px; user-select: none; }
        .theme-label { font-weight: 700; opacity: .9; }
        .theme { position: relative; width: 58px; height: 28px; border-radius: 20px; background: #e4e7ee; border: 1px solid #ccc; cursor: pointer; transition: background .25s; }
        body.dark .theme { background: #23262d; }
        .thumb { position: absolute; top: 2px; left: 2px; width: 24px; height: 24px; border-radius: 50%; background: #fff; display: grid; place-items: center; font-size: 13px; box-shadow: 0 4px 14px rgba(0,0,0,0.25); transition: transform .25s ease, background .25s; }
        body.dark .thumb { transform: translateX(30px); background: #ffb84a; }
        .icon-sun { color: #f5a623; } .icon-moon { display: none; }
        body.dark .icon-sun { display: none; } body.dark .icon-moon { display: block; color: #1d1f26; }
        #dailyLogModal { position: fixed; inset: 0; background-color: rgba(0, 0, 0, 0.5); display: flex; align-items: center; justify-content: center; padding: 1rem; z-index: 50; transition: opacity 0.3s ease; opacity: 0; pointer-events: none; }
        #dailyLogModal.show { opacity: 1; pointer-events: auto; }
        #dailyLogModal.show #dailyLog { transform: scale(1); opacity: 1; }
        #dailyLog { position: relative; background-color: white; border-radius: 1rem; box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1); padding: 1.5rem; width: 100%; max-width: 36rem; transform: scale(0.95); opacity: 0; transition: transform 0.3s ease, opacity 0.3s ease; }
        body.dark #dailyLog { background-color: #17181c; color: #f5f7fb; }
        body.dark #dailyLog h2, body.dark #dailyLog h3, body.dark #dailyLog p, body.dark #dailyLog span { color: #f5f7fb; }
        body.dark #dailyLogContent .bg-gray-50 { background-color: #23262d; }
        body.dark #dailyLogContent .text-gray-600 { color: #a0aec0; }

        /* Custom Alert Boxes */
        #customAlert { position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%) scale(0.9); padding: 1.5rem; background-color: #fff; border-radius: 1rem; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2); z-index: 100; transition: transform 0.3s ease, opacity 0.3s ease; opacity: 0; pointer-events: none; }
        #customAlert.show { opacity: 1; transform: translate(-50%, -50%) scale(1); pointer-events: auto; }
        body.dark #customAlert { background-color: #17181c; color: #f5f7fb; }

        /* Dynamic Success Toast */
        #successMessage { position: fixed; top: 1.5rem; left: 50%; transform: translateX(-50%) translateY(-100%); background-color: #10b981; color: white; padding: 0.75rem 1.5rem; border-radius: 0.5rem; z-index: 100; opacity: 0; transition: transform 0.5s ease, opacity 0.5s ease; box-shadow: 0 4px 10px rgba(0,0,0,0.2); }
        #successMessage.show { transform: translateX(-50%) translateY(0); opacity: 1; }

        /* Final Submission Confirmation Box */
        #finalAlert { position: fixed; inset: 0; background-color: rgba(0, 0, 0, 0.5); display: flex; align-items: center; justify-content: center; z-index: 100; transition: opacity 0.3s ease; opacity: 0; pointer-events: none; }
        #finalAlert.show { opacity: 1; pointer-events: auto; }
        #finalAlertContent { background-color: #fff; padding: 2rem; border-radius: 1rem; text-align: center; box-shadow: 0 10px 20px rgba(0,0,0,0.25); width: 100%; max-width: 24rem; transform: scale(0.95); transition: transform 0.3s ease; }
        body.dark #finalAlertContent { background-color: #17181c; }
        #finalAlert.show #finalAlertContent { transform: scale(1); }
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
            <a href="Category.aspx" class="active">Category</a>
            <a href="Results.aspx">Results</a>
            <a href="Bmi.aspx">BMI</a>
            <a href="Feedback.aspx">Feedback</a>
            <a href="Userprofile.aspx">Profile</a>
            <a href="Logout.aspx" class="bg-red-500 text-white font-semibold py-2 px-6 rounded-full shadow-lg hover:bg-red-900 transition-all duration-300 transform hover:scale-105">Logout</a>
        </div>
    </nav>

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

    <form id="form1" runat="server" class="container mx-auto p-4 md:p-8 mt-6">
        <h1 class="text-4xl font-bold text-center text-gray-800 mb-6">Food Categories</h1>
        <div class="flex justify-center items-center mb-8">
            <div class="bg-white rounded-xl shadow-lg p-6 w-full max-w-2xl">
                <div class="flex items-center space-x-4">
                    <input type="text" id="searchInput" placeholder="Search for a food item..." class="flex-grow p-3 border rounded-xl focus:outline-none focus:ring-2 focus:ring-red-500">
                    <button type="button" id="searchUSDA" class="bg-red-500 text-white px-6 py-3 rounded-xl shadow-lg hover:bg-red-600 transition-colors">Search</button>
                    <button id="dailyLogIcon" type="button" class="relative bg-blue-500 text-white p-3 rounded-xl shadow-lg hover:bg-blue-600 transition-colors">
                        <i class="fas fa-shopping-cart text-xl"></i>
                        <span id="logCount" class="absolute top-0 right-0 inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-red-100 transform translate-x-1/2 -translate-y-1/2 bg-red-600 rounded-full hidden">0</span>
                    </button>
                </div>
            </div>
        </div>

        <asp:HiddenField ID="hdnLogItems" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnTotalCalories" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnLogDate" runat="server" ClientIDMode="Static" />

        <div id="searchResultsSection" class="hidden">
            <p id="loadingMessage" class="text-center text-lg text-gray-500 hidden">Searching...</p>
            <p id="noResultsMessage" class="text-center text-lg text-gray-500 hidden">No results found.</p>
            <div id="searchResults" class="food-item-container"></div>
        </div>

        <div class="mt-8">
            <h2 class="text-3xl font-semibold mb-4 text-gray-800">Local Food Items</h2>
            <div class="food-item-container">
                <% foreach (var item in ItemList) { %>
                    <div class="food-item" data-id="<%= item.Id %>" data-name="<%= item.Name %>" data-energy="<%= item.Energy %>" data-protein="<%= item.Protein %>" data-fat="<%= item.Fat %>" data-type="local">
                        <img src="<%= string.IsNullOrEmpty(item.ImageBase64) ? "https://placehold.co/200x200" : "data:image/jpeg;base64," + item.ImageBase64 %>" class="w-full h-40 object-cover rounded-lg mb-2" alt="<%= item.Name %>"/>
                        <h3 class="font-semibold mb-1"><%= item.Name %></h3>
                        <p class="text-sm">Energy: <%= item.Energy %> Cal</p>
                        <p class="text-sm">Protein: <%= item.Protein %> g</p>
                        <p class="text-sm">Fat: <%= item.Fat %> g</p>
                        <div class="mt-2 flex items-center gap-2">
                            <input type="number" min="1" value="1" class="qtyInput border rounded-lg px-2 py-1 w-20 text-center"/>
                            <button type="button" class="addBtn bg-blue-500 text-white px-3 py-1 rounded-lg hover:bg-blue-600">Add to Log</button>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
        
        <div style="display:none;">
            <asp:Button ID="btnSubmitLog" runat="server" Text="Submit Daily Log" OnClick="btnSubmitLog_Click" />
        </div>
    </form>

    <div id="dailyLogModal">
        <div id="dailyLog">
            <button id="closeLog" class="absolute top-4 right-4 text-gray-500 hover:text-gray-800">
                <i class="fas fa-times"></i>
            </button>
            <h2 class="text-2xl font-semibold text-gray-800 mb-4">My Daily Log</h2>
            <div id="dailyLogContent" class="space-y-4 max-h-96 overflow-y-auto"></div>
            <div class="mt-4 pt-4 border-t border-gray-200">
                <h3 class="text-xl font-bold mb-2">Totals</h3>
                <p>Energy: <span id="totalEnergy" class="font-semibold">0</span> Cal</p>
                <p>Protein: <span id="totalProtein" class="font-semibold">0</span> g</p>
                <p>Fat: <span id="totalFat" class="font-semibold">0</span> g</p>
            </div>
            <button type="button" id="submitLog" class="w-full bg-green-500 text-white font-semibold py-3 rounded-lg mt-4 shadow-lg hover:bg-green-600 transition-colors">Submit Daily Log</button>
        </div>
    </div>

    <div id="customAlert" class="hidden">
        <p id="customAlertMessage" class="mb-4 text-center"></p>
        <div class="flex justify-center">
            <button id="customAlertOkBtn" class="bg-blue-500 text-white font-semibold px-4 py-2 rounded-lg hover:bg-blue-600">OK</button>
        </div>
    </div>

    <div id="successMessage" class="hidden"></div>

    <div id="finalAlert" class="hidden">
        <div id="finalAlertContent">
            <i class="fas fa-check-circle text-green-500 text-4xl mb-4"></i>
            <h4 class="text-2xl font-bold text-green-500 mb-2">Success!</h4>
            <p id="finalAlertMessage" class="mb-4">Daily Log submitted successfully!</p>
            <div class="flex justify-center gap-4">
                <button id="viewResultsBtn" class="bg-green-500 text-white font-semibold px-6 py-3 rounded-lg shadow-lg hover:bg-green-600 transition-colors">View Your Result</button>
            </div>
        </div>
    </div>

    <script>
        const USDA_API_KEY = "rdGg0VNKygxLTm1IJeubYSebVhYJkFAlcvS915Pj";
        let dailyLogItems = [];
        const dailyLogIcon = document.getElementById('dailyLogIcon');
        const logCount = document.getElementById('logCount');
        const dailyLogModal = document.getElementById('dailyLogModal');
        const closeLogBtn = document.getElementById('closeLog');
        const hdnLogItems = document.getElementById('hdnLogItems');
        const hdnTotalCalories = document.getElementById('hdnTotalCalories');
        const hdnLogDate = document.getElementById('hdnLogDate');

        const customAlert = document.getElementById('customAlert');
        const customAlertMessage = document.getElementById('customAlertMessage');
        const customAlertOkBtn = document.getElementById('customAlertOkBtn');
        const successMessage = document.getElementById('successMessage');
        const finalAlert = document.getElementById('finalAlert');
        const finalAlertMessage = document.getElementById('finalAlertMessage');
        const viewResultsBtn = document.getElementById('viewResultsBtn');

        function showAlert(message) {
            customAlertMessage.textContent = message;
            customAlert.classList.add('show');
            customAlert.classList.remove('hidden');
        }

        function hideAlert() {
            customAlert.classList.remove('show');
            customAlert.classList.add('hidden');
        }

        function showSuccessToast(message) {
            successMessage.textContent = message;
            successMessage.classList.remove('hidden');
            successMessage.classList.add('show');
            setTimeout(() => {
                successMessage.classList.remove('show');
            setTimeout(() => successMessage.classList.add('hidden'), 500);
        }, 2000);
        }

        customAlertOkBtn.addEventListener('click', hideAlert);
        viewResultsBtn.addEventListener('click', () => {
            const today = new Date();
        const dateString = `${today.getFullYear()}-${(today.getMonth() + 1).toString().padStart(2, '0')}-${today.getDate().toString().padStart(2, '0')}`;
        hdnLogDate.value = dateString;
        // The total calories are already set in the hdnTotalCalories hidden field
        // Trigger the server-side logic and redirection
        document.getElementById('btnSubmitLog').click();
        });

        function toggleLogModal() {
            dailyLogModal.classList.toggle('show');
            document.body.classList.toggle('modal-open');
        }

        dailyLogIcon.addEventListener('click', () => {
            renderDailyLog();
        toggleLogModal();
        });
        closeLogBtn.addEventListener('click', toggleLogModal);

        function renderDailyLog() {
            const contentEl = document.getElementById('dailyLogContent');
            contentEl.innerHTML = '';
            let totalEnergy = 0, totalProtein = 0, totalFat = 0;
            let logData = [];

            if (dailyLogItems.length === 0) {
                contentEl.innerHTML = '<p class="text-center text-gray-500">Your log is empty. Add some food!</p>';
            }

            dailyLogItems.forEach((item, index) => {
                const e = parseFloat(item.energy) * parseFloat(item.quantity);
            const p = parseFloat(item.protein) * parseFloat(item.quantity);
            const f = parseFloat(item.fat) * parseFloat(item.quantity);
            totalEnergy += e;
            totalProtein += p;
            totalFat += f;

            const div = document.createElement('div');
            div.className = 'bg-gray-50 rounded-lg p-4 shadow-sm';
            div.innerHTML = `<p class="font-semibold">${item.name}</p>
                <p class="text-sm text-gray-600">Qty: ${item.quantity}</p>
                <p class="text-sm text-gray-600">Energy: ${e.toFixed(2)} Cal</p>
                <p class="text-sm text-gray-600">Protein: ${p.toFixed(2)} g</p>
                <p class="text-sm text-gray-600">Fat: ${f.toFixed(2)} g</p>
                <div class="mt-2 flex gap-2">
                    <button type="button" data-index="${index}" class="editBtn text-blue-500 hover:underline">Edit Qty</button>
                    <button type="button" data-index="${index}" class="removeBtn text-red-500 hover:underline">Remove</button>
                </div>`;
            contentEl.appendChild(div);
            logData.push({ id: item.id, quantity: item.quantity, type: item.type, energy: item.energy });
        });

        document.getElementById('totalEnergy').textContent = totalEnergy.toFixed(2);
        document.getElementById('totalProtein').textContent = totalProtein.toFixed(2);
        document.getElementById('totalFat').textContent = totalFat.toFixed(2);

        logCount.textContent = dailyLogItems.length;
        if (dailyLogItems.length === 0) logCount.classList.add('hidden');
        else logCount.classList.remove('hidden');

        hdnLogItems.value = JSON.stringify(logData);
        hdnTotalCalories.value = totalEnergy.toFixed(2);

        document.querySelectorAll('.editBtn').forEach(btn => {
            btn.addEventListener('click', e => {
                const index = e.target.dataset.index;
        const newQty = prompt("Enter new quantity:", dailyLogItems[index].quantity);
        if (newQty !== null && !isNaN(newQty) && parseFloat(newQty) > 0) {
            dailyLogItems[index].quantity = parseFloat(newQty);
            renderDailyLog();
        }
        });
        });
        document.querySelectorAll('.removeBtn').forEach(btn => {
            btn.addEventListener('click', e => {
                const index = e.target.dataset.index;
        if (confirm("Are you sure you want to remove this item?")) {
            dailyLogItems.splice(index, 1);
            renderDailyLog();
        }
        });
        });
        }

        document.addEventListener('click', e => {
            if (e.target.classList.contains('addBtn')) {
                const div = e.target.closest('.food-item');
        const q = parseFloat(div.querySelector('.qtyInput').value);
        if (isNaN(q) || q <= 0) {
            showAlert('Please enter a valid quantity.');
            return;
        }

        dailyLogItems.push({
            id: div.dataset.id,
            name: div.dataset.name,
            quantity: q,
            energy: parseFloat(div.dataset.energy),
            protein: parseFloat(div.dataset.protein),
            fat: parseFloat(div.dataset.fat),
            type: div.dataset.type
        });

        renderDailyLog();
        showSuccessToast(`Added ${div.dataset.name} x ${q} to log.`);
        }
        });

        $("#submitLog").click(function () {
            if (dailyLogItems.length === 0) {
                showAlert('Your log is empty.');
                return;
            }
            $("#btnSubmitLog").click();
        });

        $("#searchUSDA").click(function () {
            const query = $("#searchInput").val().trim();
            if (!query) {
                showAlert('Please enter a food name.');
                return;
            }

            const resultsEl = $("#searchResults");
            const sectionEl = $("#searchResultsSection");
            const loadingEl = $("#loadingMessage");
            const noResultsEl = $("#noResultsMessage");

            resultsEl.empty();
            sectionEl.removeClass('hidden');
            loadingEl.removeClass('hidden');
            noResultsEl.addClass('hidden');

            $.ajax({
                type: "GET",
                url: `https://api.nal.usda.gov/fdc/v1/foods/search?api_key=${USDA_API_KEY}&query=${encodeURIComponent(query)}`,
            success: function (data) {
                if (data.foods && data.foods.length > 0) {
                    let count = 0;
                    $.each(data.foods, function (i, f) {
                        if (count >= 3) return false;
                        let e = 0, p = 0, fat = 0;
                        $(f.foodNutrients).each(function (j, n) {
                            const nName = n.nutrientName.toLowerCase();
                            if (nName.includes('energy')) e = n.value;
                            if (nName.includes('protein')) p = n.value;
                            if (nName.includes('fat') || nName.includes('lipid')) fat = n.value;
                        });

                        const div = $('<div class="food-item"></div>');
                        div.attr('data-id', f.fdcId);
                        div.attr('data-name', f.description);
                        div.attr('data-energy', e);
                        div.attr('data-protein', p);
                        div.attr('data-fat', fat);
                        div.attr('data-type', 'usda');

                        div.html(`
                            <img src="https://placehold.co/200x200" class="w-full h-40 object-cover rounded-lg mb-2"/>
                            <h3 class="font-semibold mb-1">${f.description}</h3>
                            <p class="text-sm">Energy: ${e.toFixed(2)} Cal</p>
                            <p class="text-sm">Protein: ${p.toFixed(2)} g</p>
                            <p class="text-sm">Fat: ${fat.toFixed(2)} g</p>
                            <div class="mt-2 flex items-center gap-2">
                                <input type="number" min="1" value="1" class="qtyInput border rounded-lg px-2 py-1 w-20 text-center"/>
                                <button type="button" class="addBtn bg-blue-500 text-white px-3 py-1 rounded-lg hover:bg-blue-600">Add to Log</button>
                            </div>
                        `);
                        resultsEl.append(div);
                        count++;
                    });
                } else {
                    noResultsEl.removeClass('hidden');
                }
            },
            error: function (xhr, status, error) {
                console.error("USDA API Error: ", status, error);
                showAlert('Failed to fetch USDA data.');
            },
            complete: function () {
                loadingEl.addClass('hidden');
            }
        });
        });

        // --- Particle System & Theme Toggle from Home.aspx ---
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