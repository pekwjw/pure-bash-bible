#!/bin/bash

source ~/.bash_profile
# 用户可定义的常量, 3个并发
THREAD=5

# 不需要改变的常量
TMPFILE=$$.fifo

# 公共代码开始
mkfifo ${TMPFILE}
# 创建文件描述符
exec 7<>${TMPFILE}
rm -f ${TMPFILE}

# 创建令牌
for (( i = 0; i < ${THREAD}; i++ ))
do
    echo >&7
done

# 业务代码开始
function fun(){
    # 完成业务代码，需要进行并发得逻辑
    echo $i
}

for(( i = 0; i < 10; i++ ))
do
    read -u7
    {
        fun $i
        echo >&7
    }&
done

wait

# 关闭通道
exec 7>&-
exec 7<&-
echo "finished"
