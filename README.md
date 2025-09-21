# Tu Kha (သုခ) – Calorie Tracking & Goal Monitoring System (ASP.NET)

**Repository Description:**  
Tu Kha (သုခ) is a **C# ASP.NET (.NET 4.0) web application** for tracking daily calorie intake, monitoring fitness goals, and managing user health data. Integrated with **SQL Server**, USDA API (Food API), Google Image API, and SMTP for authentication, this project demonstrates full-stack web development and health-focused data visualization.  

> **Note:** This is an **academic project**, developed as a **full-stack application in 12 days by me**.

---

## ✨ Features

### User Features
- 🔐 **Authentication** – Login with session management and "Remember Me" cookies. Password recovery via **SMTP OTP email**.
- 🍽 **Food Search & Tracking**  
  - Search food uploaded by admin.  
  - If not found, fetch data from **USDA API** and **Google Image API** (calories, protein, fat).  
  - Displays whether the intake meets **daily calorie requirements** and **goal** (Lose Weight / Maintain Weight / Gain Weight).  
- ⚖ **BMI Calculation** – Based on weight & height entered at registration.  
- 🖼 **Save Result as Image** – Users can export the calorie/goal results as an image.  
- 📝 **Profile Management** – Update profile (name, weight, height, age, goals, gender), except email.  
- ✉ **Feedback System** – Send feedback to admin.  
- 🌗 **Light & Dark Mode** – Dark mode preferred for personal use.

### Admin Features
- 🍴 **Food Management** – Add or update food categories and items.  
- 👤 **User Management** – View users, their daily calorie logs, and delete users.  
- 📊 **Charts** – Visualize daily calorie logs for each user.  
- 📨 **Feedback Management** – View and respond to user feedback.

---

## 💻 Tech Stack
- **Backend:** C# ASP.NET (.NET 4.0)  
- **Frontend:** HTML, CSS, JavaScript, jQuery  
- **Database:** SQL Server  
- **APIs:** USDA Food API, Google Image API  
- **Mail:** SMTP for OTP-based password recovery  
- **Other:** Session & cookies for authentication, Light/Dark mode toggle  

---

## 🛠 Requirements
- **.NET Framework 4.0**  
- **Visual Studio** (2019/2022 compatible with .NET 4.0)  
- **SQL Server** (local or remote)  
- SMTP-enabled email account for password recovery  
- Internet access for **USDA API** and **Google Image API**  
- Browser with JavaScript enabled  
> **Note:** Replace the Database Connection String with yours
---

## 🚀 Getting Started

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Thura-Mon/Calorie-Tracking---Goal-Fitness
