#!/bin/bash

# 定义一个函数，将环境配置写入到 ~/.bashrc 文件
setup_environment() {
    # 检查是否已经写入过，以避免重复添加
    if grep -q "# Custom Environment Setup" ~/.bashrc; then
        echo "配置已存在于 ~/.bashrc 中，不再重复添加。"
        return
    fi

    # 将配置写入到 ~/.bashrc
    cat << 'EOF' >> ~/.bashrc

# Custom Environment Setup
LS_OPTIONS='--color=auto'
alias ls="ls \$LS_OPTIONS"
alias ll="ls \$LS_OPTIONS -l"
alias l="ls \$LS_OPTIONS -lA"

# 启用颜色支持
if command -v dircolors >/dev/null 2>&1; then
    eval "\$(dircolors)"
fi

# 历史记录配置
HISTSIZE=100000
HISTFILESIZE=100000
HISTTIMEFORMAT="%F %T \$(who -u am i 2>/dev/null | awk '{print \$NF}' | sed -e 's/[()]//g') \$(whoami)"

# 自动检测并设置退格键
if [ "\$(stty -a | grep -o 'erase = .')" = "erase = ^?" ]; then
    stty erase ^?
elif [ "\$(stty -a | grep -o 'erase = .')" = "erase = ^H" ]; then
    stty erase ^H
else
    echo -n "按下退格键以自动设置: "
    read -r -s -n 1 key
    stty erase "\$key"
    echo "退格键已设置为 \$(stty -a | grep 'erase =')"
fi

# 扩展 PATH 环境变量
export PATH=\$PATH:/sbin/

EOF

    echo "环境配置已成功添加到 ~/.bashrc 文件。"
    echo "请运行 'source ~/.bashrc' 或重新打开终端以使配置生效。"
}

# 调用函数以将配置写入 ~/.bashrc
setup_environment
