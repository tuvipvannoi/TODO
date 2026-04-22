# TODO App (Swift - MVVM)

## Giới thiệu

Ứng dụng quản lý công việc (TODO) viết bằng Swift + UIKit theo mô hình
MVVM.\
Cho phép người dùng thêm, sửa, xóa và quản lý thời gian công việc.

<img width="363" height="818" alt="Ảnh màn hình 2026-04-23 lúc 04 14 05" src="https://github.com/user-attachments/assets/aba2e067-4e1a-457d-8b8c-26dbf9a43762" />

## Tính năng

-   Thêm / sửa / xóa task\
-   Đánh dấu hoàn thành\
-   Lọc task: All / Active / Completed\
-   Chọn ngày và giờ cho task\
-   Kiểm tra:
    -   Không cho chọn ngày quá khứ\
    -   Giờ kết thúc phải \> giờ bắt đầu\
    -   Không được trùng thời gian

## Kiến trúc

-   Model: Task\
-   ViewModel: ListVM\
-   View/Controller: ListVC, EditorVC, TaskCell\
-   Service: TaskStorage (UserDefaults)

## Công nghệ

-   Swift 5\
-   UIKit (code UI, không storyboard)\
-   MVVM\
-   UserDefaults + Codable
