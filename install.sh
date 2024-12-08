!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Cài đặt Flutter và Android SDK trên Ubuntu ==="

# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Cài đặt các công cụ cần thiết
echo "=== Cài đặt các công cụ cần thiết ==="
sudo apt install -y unzip curl openjdk-11-jdk git xz-utils zip libglu1-mesa clang cmake ninja-build pkg-config libgtk-3-dev
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
# Xóa thư mục Flutter cũ nếu có
echo "=== Xóa Flutter cũ nếu tồn tại ==="
rm -rf ~/flutter

# Tải Flutter phiên bản 3.16.2
echo "=== Tải và cài đặt Flutter ==="
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.2-stable.tar.xz -P ~
tar -xf ~/flutter_linux_3.16.2-stable.tar.xz -C ~
rm ~/flutter_linux_3.16.2-stable.tar.xz

# Thêm Flutter vào PATH
echo "export PATH=\"\$PATH:\$HOME/flutter/bin\"" >> ~/.bashrc
source ~/.bashrc

# Tải và cài đặt Android SDK Command-line Tools
echo "=== Tải và cài đặt Android SDK ==="
mkdir -p ~/Android/cmdline-tools
curl -o commandlinetools-linux.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux.zip -d ~/Android/cmdline-tools
mv ~/Android/cmdline-tools/cmdline-tools ~/Android/cmdline-tools/latest
rm commandlinetools-linux.zip

# Cấu hình biến môi trường cho Android SDK
echo "export ANDROID_HOME=\$HOME/Android" >> ~/.bashrc
echo "export PATH=\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools:\$PATH" >> ~/.bashrc
source ~/.bashrc

# Cài đặt các thành phần Android SDK
sdkmanager --licenses <<EOF
y
y
y
EOF
sdkmanager "platform-tools" "build-tools;33.0.0" "platforms;android-33"

# Kiểm tra Flutter Doctor
echo "=== Kiểm tra Flutter Doctor ==="
flutter doctor

flutter clean
flutter pub get



