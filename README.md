🖥️ E-Commerce PC Builder — Custom PC Configuration Platform

A full-stack web application that allows users to build a compatible custom PC by selecting components such as CPU, GPU, RAM, Storage, Motherboard, PSU, Cabinet, etc.
The system automatically checks hardware compatibility, prevents invalid builds, and calculates total PC price in real time.

This project solves the biggest problem in buying PC parts online — most customers don’t know what parts actually work together.

👤 User

Register, login, logout

OTP-based authentication

Browse products by category

Add compatible components to build

Real-time price calculation

Save final PC configuration

Add to cart / checkout


⚙️ Compatibility Engine

The backend validates:

CPU ↔ Motherboard socket match

RAM type & max frequency support

PSU minimum wattage based on component power draw

GPU maximum size support (fits inside cabinet)

Storage interface type (SATA / NVMe)


| Layer       | Technology                       |
| ----------- | -------------------------------- |
| Frontend    | React + Vite + Tailwind CSS      |
| Backend     | Spring Boot (Java)               |
| Database    | MySQL + JSON data files          |
| API Style   | REST                             |
| Security    | OTP-based authentication (email) |
| Build Tools | Maven                            |
