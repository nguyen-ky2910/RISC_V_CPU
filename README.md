# Pipelined RISC-V CPU Design

## Giới thiệu
Dự án thiết kế bộ vi xử lý RISC-V cấu trúc Pipeline tầng (ví dụ: 5 tầng) sử dụng ngôn ngữ Verilog. Đây là một phần trong quá trình nghiên cứu về kiến trúc máy tính và thiết kế vi mạch của tôi.

## Đặc điểm kỹ thuật
* **Kiến trúc:** RISC-V (RV32I).
* **Cấu trúc:** Pipeline (Fetch, Decode, Execute, Memory, Writeback).
* **Ngôn ngữ:** Verilog.
* **Công cụ:** Xilinx Vivado 2018.3.

## Các tập lệnh hỗ trợ
* **R-type:** ADD, SUB, AND, OR, SLT...
* **I-type:** ADDI, LW, ORI...
* **S-type:** SW.
* **B-type:** BEQ.

## Sơ đồ khối (Block Diagram)
![Block Diagram](đường_link_ảnh_nếu_có)

## Cách chạy dự án
1. Mở phần mềm **Vivado**.
2. Chọn **Open Project** và trỏ đến file `RISC-V_CPU.xpr`.
3. Chạy **Simulation** để kiểm tra dạng sóng (Waveform).
