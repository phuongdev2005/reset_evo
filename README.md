# 🔄 Evoto Multi-Account Tool Suite

Bộ công cụ cho phép **dùng nhiều account Evoto** trên cùng 1 máy mà không cần cài đi cài lại.

---

## 🚀 Cách sử dụng

### Lần đầu tiên (setup 1 lần):

```bash
# Bước 1: Cài Evoto
install_evoto.bat

# Bước 2: Mở Evoto lên → KHÔNG đăng nhập → Đóng Evoto

# Bước 3: Chụp trạng thái sạch
prepare_snapshot.bat
```

### Sử dụng hàng ngày:

```bash
# Mở Evoto → Đăng nhập Account A → Dùng xong → Đổi account:
reset_evoto.bat

# Đăng nhập Account B → Dùng xong → Đổi account:
reset_evoto.bat
```

> ⚡ Mỗi lần reset sẽ **đổi MachineGuid** → Evoto nghĩ đây là máy mới!

### Xóa sạch Evoto (khi không cần nữa):

```bash
# Xóa Evoto + khôi phục MachineGuid gốc
clean_evoto.bat
restore_guid.bat
```

---

## 📁 Danh sách lệnh

| Lệnh | Chức năng | Quyền |
|---|---|---|
| `install_evoto.bat` | Cài đặt Evoto tự động | User |
| `prepare_snapshot.bat` | Chụp trạng thái chưa đăng nhập | User |
| `reset_evoto.bat` | Reset + đổi MachineGuid (~1s) | Admin (tự nâng) |
| `clean_evoto.bat` | Xóa sạch Evoto khỏi máy | Admin (tự nâng) |
| `restore_guid.bat` | Khôi phục MachineGuid gốc | Admin (tự nâng) |

---

## 🔄 Cập nhật phiên bản Evoto mới

```bash
# 1. Đặt file installer mới (EvotoInstaller_xxx.exe) vào thư mục, xóa file cũ
# 2. Cài lại + chụp snapshot mới:
install_evoto.bat
# Mở Evoto → KHÔNG đăng nhập → Đóng
prepare_snapshot.bat
```
