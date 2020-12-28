#
# 编译RocksDB阶段（关闭sse4_2以支持老CPU）
#
FROM alpinelinux/package-builder AS rocksdb
WORKDIR /home/buildozer

RUN set -eux && \
  #设置源
  echo "http://mirrors.ustc.edu.cn/alpine/edge/main/" > /etc/apk/repositories && \
  echo "http://mirrors.ustc.edu.cn/alpine/edge/community/" >> /etc/apk/repositories && \
  echo "http://mirrors.ustc.edu.cn/alpine/edge/testing/" >> /etc/apk/repositories

#构建脚本来自https://git.alpinelinux.org/aports/tree/testing/rocksdb?h=master
COPY rocksdb/* ./
RUN set -eux && \
  abuild-keygen -a -n && \
  abuild deps && \
  abuild -r

RUN set -eux && \
  APK_DIR="packages/home/$(uname -m)" && \
  ls -l ${APK_DIR} && \
  cp "${APK_DIR}/rocksdb-dev-6.14.6-r0.apk" ./rocksdb-dev.apk && \
  cp "${APK_DIR}/rocksdb-6.14.6-r0.apk" ./rocksdb.apk

################

#
# 封装镜像
#
FROM alpine:3

#从编译RocksDB阶段中复制apk并安装
#(不考虑支持老CPU时直接安装rocksdb包即可)
COPY --from=rocksdb /home/buildozer/rocksdb-dev.apk /
COPY --from=rocksdb /home/buildozer/rocksdb.apk /
