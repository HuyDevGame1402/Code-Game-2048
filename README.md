# 🧩 2048 Godot Edition

Dự án game giải đố **2048** được làm bằng **Godot Engine 4.3**. Đây là phiên bản cơ bản, tập trung vào logic cốt lõi và trải nghiệm chơi game mượt mà trên nền tảng Godot.

## ✨ Tính năng (Features)

* **Classic Gameplay:** Lối chơi 2048 truyền thống (Vuốt/Phím mũi tên để ghép các ô số).
* **Grid Logic:** Xử lý ma trận 4x4, sinh số ngẫu nhiên (2 và 4).
* **Godot 4.3 Powered:** Sử dụng các tính năng mới nhất của Godot 4.3 để tối ưu hiệu suất.
* **Simple UI:** Giao diện tối giản, tập trung vào trải nghiệm người chơi.

## 🛠️ Công nghệ sử dụng (Tech Stack)

* **Game Engine:** [Godot Engine 4.3](https://godotengine.org/)
* **Scripting:** GDScript (hoặc C# tùy theo code của bạn).
* **Version Control:** Git.

## 📁 Cấu trúc dự án (Project Structure)

```text
├── Assets/2048      # Chứa hình ảnh, âm thanh và tài nguyên liên quan đến game
├── BuildGame/       # Thư mục chứa các bản xuất bản (Export) sau khi đóng gói
├── Scenes/          # Các cảnh trong game (Main Scene, Tile Scene, UI Scene)
├── Scripts/         # Logic xử lý di chuyển, tính điểm và quản lý bàn cờ
├── icon.svg         # Icon mặc định của dự án
└── project.godot    # File cấu hình chính của dự án Godot
