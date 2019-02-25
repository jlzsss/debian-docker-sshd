FROM i386/debian:stretch

RUN ( apt update ;\
      apt upgrade -y )

RUN ( apt install -y openssh-server vim screen unzip curl )

RUN ( mkdir /var/run/sshd ;\
      sed -i "/PermitRootLogin/s/#Permit/Permit/" /etc/ssh/sshd_config ;\
      sed -i "/PermitRootLogin/s/prohibit-password/yes/" /etc/ssh/sshd_config ;\
      sed -i "s/UsePAM yes/#UsePAM yes/g" /etc/ssh/sshd_config ;\
      sed -i "s/#Port 22/Port 2022/" /etc/ssh/sshd_config )

RUN ( echo 'root:debian' | chpasswd )

# 安装配置系统语言环境
RUN ( apt install locales -y ;\
      echo "152 468" >> _tmp_locales_set ;\
      echo "2" >> _tmp_locales_set ;\
      dpkg-reconfigure locales < _tmp_locales_set >/dev/null 2>&1 ;\ 
      rm -rf _tmp_locales_set ;\
      sleep 3 )

# 设定系统语言环境
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

# 配置系统时区
RUN ( apt install tzdata -y ;\
      echo "6" >> _tmp_tzdata_set ;\
      echo "69" >> _tmp_tzdata_set ;\
      dpkg-reconfigure tzdata < _tmp_tzdata_set >/dev/null 2>&1 ;\ 
      rm -rf _tmp_tzdata_set ;\
      sleep 3 )

# 清理环境
RUN ( apt clean && apt autoclean ;\
      rm -rf /tmp/* )

# 对外开放22端口
EXPOSE 80
EXPOSE 2022

# 启动命令行
CMD ["/usr/sbin/sshd", "-D"]
