# 使用官方 Python 3.12 镜像（基于 Debian）
FROM python:3.12

# 设置工作目录
WORKDIR /app


# 安装依赖（Java + curl）
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-17-jre-headless curl && \
    rm -rf /var/lib/apt/lists/*

# 安装 Allure
RUN curl -o allure-2.24.0.tgz -Ls https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.24.0/allure-commandline-2.24.0.tgz && \
    tar -zxvf allure-2.24.0.tgz -C /opt/ && \
    ln -s /opt/allure-2.24.0/bin/allure /usr/bin/allure && \
    rm -rf allure-2.24.0.tgz

# 验证安装
RUN allure --version


# 配置 PyPI 清华镜像并安装依赖
COPY . ./example
RUN pip install ./example
RUN rm -rf ./example

# 可选：验证 Python 和 pip 版本
RUN pip list

# 设置默认启动命令（可根据需求修改）
CMD ["bash"]