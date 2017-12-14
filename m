From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 16/18] fsck.overlay: remove test cases
Date: Thu, 14 Dec 2017 11:11:08 +0200
Message-ID: <CAOQ4uxgt8d_xTnap9LkdpPBrdCH+r1Db3eJ2Bp+NjXiwcx78mA@mail.gmail.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com> <20171214064747.20999-17-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f177.google.com ([209.85.213.177]:41517 "EHLO
        mail-yb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdLNJLJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 04:11:09 -0500
In-Reply-To: <20171214064747.20999-17-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>

On Thu, Dec 14, 2017 at 8:47 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Remove test cases for fsck.overlay, these cases will move to xfstests.

Again, better keep you initial incubator version clean of this remove and
not add the tests in the original commit.

>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  test/README.md            |  12 ----
>  test/auto_test.sh         |  46 -------------
>  test/clean.sh             |   6 --
>  test/local.config         |  16 -----
>  test/src/opaque_test.sh   | 144 ----------------------------------------
>  test/src/prepare.sh       |  15 -----
>  test/src/redirect_test.sh | 163 ----------------------------------------------
>  test/src/whiteout_test.sh |  63 ------------------
>  8 files changed, 465 deletions(-)
>  delete mode 100644 test/README.md
>  delete mode 100755 test/auto_test.sh
>  delete mode 100755 test/clean.sh
>  delete mode 100644 test/local.config
>  delete mode 100755 test/src/opaque_test.sh
>  delete mode 100755 test/src/prepare.sh
>  delete mode 100755 test/src/redirect_test.sh
>  delete mode 100755 test/src/whiteout_test.sh
>
> diff --git a/test/README.md b/test/README.md
> deleted file mode 100644
> index 71dbad8..0000000
> --- a/test/README.md
> +++ /dev/null
> @@ -1,12 +0,0 @@
> -fsck.overlay test
> -=================
> -
> -This test cases simulate different inconsistency of overlay filesystem
> -underlying directories, test fsck.overlay can repair them correctly or not.
> -
> -USAGE
> -=====
> -
> -1. Check "local.config", modify config value to appropriate one.
> -2. ./auto_test.sh
> -3. After testing, the result file and log file created in the result directory.
> diff --git a/test/auto_test.sh b/test/auto_test.sh
> deleted file mode 100755
> index 8248e24..0000000
> --- a/test/auto_test.sh
> +++ /dev/null
> @@ -1,46 +0,0 @@
> -#!/bin/bash
> -
> -. ./src/prepare.sh
> -
> -echo "***************"
> -
> -# 1. Test whiteout
> -echo -e "1.Test Whiteout\n"
> -$SOURCE_DIR/whiteout_test.sh >> $LOG_FILE 2>&1
> -if [ $? -ne 0 ]; then
> -       echo -e "Result:\033[31m Fail\033[0m\n"
> -       RESULT="Fail"
> -else
> -       echo -e "Result:\033[32m Pass\033[0m\n"
> -       RESULT="Pass"
> -fi
> -
> -echo -e "Test whiteout: $RESULT" >> $RESOULT_FILE
> -
> -# 2. Test opaque dir
> -echo -e "2.Test opaque directory\n"
> -$SOURCE_DIR/opaque_test.sh >> $LOG_FILE 2>&1
> -if [ $? -ne 0 ]; then
> -       echo -e "Result:\033[31m Fail\033[0m\n"
> -       RESULT="Fail"
> -else
> -       echo -e "Result:\033[32m Pass\033[0m\n"
> -       RESULT="Pass"
> -fi
> -
> -echo -e "Test opaque directory: $RESULT" >> $RESOULT_FILE
> -
> -# 3. Test redirect dir
> -echo -e "3.Test redirect direcotry\n"
> -$SOURCE_DIR/redirect_test.sh >> $LOG_FILE 2>&1
> -if [ $? -ne 0 ]; then
> -       echo -e "Result:\033[31m Fail\033[0m\n"
> -       RESULT="Fail"
> -else
> -       echo -e "Result:\033[32m Pass\033[0m\n"
> -       RESULT="Pass"
> -fi
> -
> -echo -e "Test redirect direcotry: $RESULT" >> $RESOULT_FILE
> -
> -echo "***************"
> diff --git a/test/clean.sh b/test/clean.sh
> deleted file mode 100755
> index 80f360b..0000000
> --- a/test/clean.sh
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#!/bin/bash
> -
> -. ./src/prepare.sh
> -
> -rm -rf $RESULT_DIR
> -rm -rf $TEST_DIR
> diff --git a/test/local.config b/test/local.config
> deleted file mode 100644
> index 21b25c2..0000000
> --- a/test/local.config
> +++ /dev/null
> @@ -1,16 +0,0 @@
> -# Config
> -export OVL_FSCK=fsck.overlay
> -export TEST_DIR=/mnt/test
> -
> -# Base environment
> -export PWD=`pwd`
> -export RESULT_DIR=$PWD/result
> -export SOURCE_DIR=$PWD/src
> -
> -# Overlayfs config
> -export LOWER_DIR="lower"
> -export UPPER_DIR="upper"
> -export WORK_DIR="work"
> -export MERGE_DIR="merge"
> -export LOWER_DIR1="lower1"
> -export WORK_DIR1="work1"
> diff --git a/test/src/opaque_test.sh b/test/src/opaque_test.sh
> deleted file mode 100755
> index 7cb5030..0000000
> --- a/test/src/opaque_test.sh
> +++ /dev/null
> @@ -1,144 +0,0 @@
> -#!/bin/bash
> -
> -. ./local.config
> -
> -__clean()
> -{
> -       rm -rf $TEST_DIR/*
> -       cd $PWD
> -}
> -
> -OVL_OPAQUE_XATTR="trusted.overlay.opaque"
> -OVL_OPAQUE_XATTR_VAL="y"
> -RET=0
> -
> -cd $TEST_DIR
> -rm -rf *
> -mkdir $LOWER_DIR $LOWER_DIR1 $UPPER_DIR $WORK_DIR
> -
> -# 1.Test lower invalid opaque directory
> -echo "***** 1.Test lower invalid opaque directory *****"
> -mkdir $LOWER_DIR/testdir
> -setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $LOWER_DIR/testdir
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_OPAQUE_XATTR $LOWER_DIR/testdir
> -if [[ $? -eq 0 ]];then
> -       echo "ERROR: lower's invalid opaque xattr not remove"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $LOWER_DIR/*
> -
> -# 2.Test upper invalid opaque directory
> -echo "***** 2.Test upper invalid opaque directory *****"
> -mkdir -p $UPPER_DIR/testdir0/testdir1
> -setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $UPPER_DIR/testdir0/testdir1
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_OPAQUE_XATTR $UPPER_DIR/testdir0/testdir1
> -if [[ $? -eq 0 ]];then
> -       echo "ERROR: upper's invalid opaque xattr not remove"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $UPPER_DIR/*
> -
> -# 3.Test upper opaque direcotry in merged directory
> -echo "***** 3.Test upper opaque direcotry in merged directory *****"
> -mkdir $UPPER_DIR/testdir
> -setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $UPPER_DIR/testdir
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_OPAQUE_XATTR $UPPER_DIR/testdir
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: upper's opaque xattr incorrect removed"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $UPPER_DIR/*
> -
> -# 4.Test upper opaque direcotry cover lower file
> -echo "***** 4.Test upper opaque direcotry cover lower file *****"
> -mkdir $UPPER_DIR/testdir
> -mkdir $LOWER_DIR/testdir
> -setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $UPPER_DIR/testdir
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_OPAQUE_XATTR $UPPER_DIR/testdir
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: upper's opaque xattr incorrect removed"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $UPPER_DIR/*
> -rm -rf $LOWER_DIR/*
> -
> -# 5.Test upper opaque direcotry cover lower directory
> -echo "***** 5.Test upper opaque direcotry cover lower directory *****"
> -mkdir $UPPER_DIR/testdir
> -touch $LOWER_DIR/testdir
> -setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $UPPER_DIR/testdir
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_OPAQUE_XATTR $UPPER_DIR/testdir
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: upper's opaque xattr incorrect removed"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $UPPER_DIR/*
> -rm -rf $LOWER_DIR/*
> -
> -# 6.Test lower invalid opaque directory in middle layer
> -echo "***** 6.Test lower invalid opaque directory in middle layer *****"
> -mkdir $LOWER_DIR/testdir0/testdir1
> -setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $LOWER_DIR/testdir0/testdir1
> -$OVL_FSCK -a -l $LOWER_DIR:$LOWER_DIR1 -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_OPAQUE_XATTR $LOWER_DIR/testdir0/testdir1
> -if [[ $? -eq 0 ]];then
> -       echo "ERROR: middle's opaque xattr not removed"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $LOWER_DIR/*
> -
> -# 7.Test lower invalid opaque directory in bottom layer
> -echo "***** 7.Test lower invalid opaque directory in bottom layer *****"
> -mkdir $LOWER_DIR1/testdir0/testdir1
> -setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $LOWER_DIR1/testdir0/
> -$OVL_FSCK -a -l $LOWER_DIR:$LOWER_DIR1 -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_OPAQUE_XATTR $LOWER_DIR1/testdir0/testdir1
> -if [[ $? -eq 0 ]];then
> -       echo "ERROR: middle's opaque xattr not removed"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $LOWER_DIR1/*
> -
> -# 8.Test middle opaque direcotry cover bottom directory
> -echo "***** 8.Test middle opaque direcotry cover bottom directory *****"
> -mkdir $LOWER_DIR1/testdir
> -mkdir $LOWER_DIR/testdir
> -setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $LOWER_DIR/testdir
> -$OVL_FSCK -a -l $LOWER_DIR:$LOWER_DIR1 -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_OPAQUE_XATTR $LOWER_DIR/testdir
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: middle's opaque xattr incorrect removed"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $LOWER_DIR1/*
> -rm -rf $LOWER_DIR/*
> -
> -# 9.Test double opaque direcotry in middle and upper layer
> -echo "***** 9.Test double opaque direcotry in middle and upper layer *****"
> -mkdir $LOWER_DIR1/testdir
> -mkdir $LOWER_DIR/testdir
> -mkdir $UPPER_DIR/testdir
> -setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $LOWER_DIR/testdir
> -setfattr -n $OVL_OPAQUE_XATTR -v $OVL_OPAQUE_XATTR_VAL $UPPER_DIR/testdir
> -$OVL_FSCK -a -l $LOWER_DIR:$LOWER_DIR1 -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_OPAQUE_XATTR $LOWER_DIR/testdir
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: middle's opaque xattr incorrect removed"
> -       RET=$(($RET+1))
> -fi
> -getfattr -n $OVL_OPAQUE_XATTR $UPPER_DIR/testdir
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: upper's opaque xattr incorrect removed"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $LOWER_DIR1/*
> -rm -rf $LOWER_DIR/*
> -rm -rf $UPPER_DIR/*
> -
> -__clean
> -exit $RET
> diff --git a/test/src/prepare.sh b/test/src/prepare.sh
> deleted file mode 100755
> index 138539a..0000000
> --- a/test/src/prepare.sh
> +++ /dev/null
> @@ -1,15 +0,0 @@
> -#!/bin/bash
> -
> -. ./local.config
> -
> -NOW=`date +"%Y-%m-%d-%H-%M-%S"`
> -LOG_FILE=$RESULT_DIR/LOG_${NOW}.log
> -RESOULT_FILE=$RESULT_DIR/RESULT_${NOW}.out
> -
> -# creat test base dir
> -if [ ! -d "$TEST_DIR" ]; then
> -       mkdir -p $TEST_DIR
> -fi
> -
> -# creat result dir
> -mkdir -p $RESULT_DIR
> diff --git a/test/src/redirect_test.sh b/test/src/redirect_test.sh
> deleted file mode 100755
> index be2ce80..0000000
> --- a/test/src/redirect_test.sh
> +++ /dev/null
> @@ -1,163 +0,0 @@
> -#!/bin/bash
> -
> -. ./local.config
> -
> -__clean()
> -{
> -       rm -rf $TEST_DIR/*
> -       cd $PWD
> -}
> -
> -OVL_REDIRECT_XATTR="trusted.overlay.redirect"
> -OVL_OPAQUE_XATTR="trusted.overlay.opaque"
> -RET=0
> -
> -cd $TEST_DIR
> -rm -rf *
> -mkdir $LOWER_DIR $LOWER_DIR1 $UPPER_DIR $WORK_DIR
> -
> -# 1.Test no exist redirect origin
> -echo "***** 1.Test no exist redirect origin *****"
> -mkdir $UPPER_DIR/testdir
> -setfattr -n $OVL_REDIRECT_XATTR -v "xxx" $UPPER_DIR/testdir
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir
> -if [[ $? -eq 0 ]];then
> -       echo "ERROR: upper's redirect xattr not remove"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $UPPER_DIR/*
> -
> -# 2.Test redirect origin is file
> -echo "***** 2.Test redirect origin is file *****"
> -mkdir $UPPER_DIR/testdir
> -touch $LOWER_DIR/origin
> -setfattr -n $OVL_REDIRECT_XATTR -v "origin" $UPPER_DIR/testdir
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir
> -if [[ $? -eq 0 ]];then
> -       echo "ERROR: upper's redirect xattr not remove"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $UPPER_DIR/*
> -rm -rf $LOWER_DIR/*
> -
> -# 3.Test valid redirect xattr
> -echo "***** 3.Test valid redirect xattr *****"
> -mkdir $UPPER_DIR/testdir
> -mknod $UPPER_DIR/origin c 0 0
> -mkdir $LOWER_DIR/origin
> -setfattr -n $OVL_REDIRECT_XATTR -v "origin" $UPPER_DIR/testdir
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: upper's redirect xattr incorrect removed"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $UPPER_DIR/*
> -rm -rf $LOWER_DIR/*
> -
> -# 4.Test valid redirect xattr start from root
> -echo "***** 4.Test valid redirect xattr start from root *****"
> -mkdir -p $UPPER_DIR/testdir0/testdir1
> -mknod $UPPER_DIR/origin c 0 0
> -mkdir $LOWER_DIR/origin
> -setfattr -n $OVL_REDIRECT_XATTR -v "/origin" $UPPER_DIR/testdir0/testdir1
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir0/testdir1
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: upper's redirect xattr incorrect removed"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $UPPER_DIR/*
> -rm -rf $LOWER_DIR/*
> -
> -# 5.Test missing whiteout in redirect parent directory
> -echo "***** 5.Test missing whiteout in redirect parent directory *****"
> -mkdir $UPPER_DIR/testdir
> -mkdir $LOWER_DIR/origin
> -setfattr -n $OVL_REDIRECT_XATTR -v "origin" $UPPER_DIR/testdir
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: upper's redirect xattr incorrect removed"
> -       RET=$(($RET+1))
> -fi
> -if [ ! -e "$UPPER_DIR/origin" ];then
> -       echo "ERROR: upper's missing whiteout not create"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $UPPER_DIR/*
> -rm -rf $UPPER_DIR/*
> -
> -# 6.Test missing opaque in redirect parent directory
> -echo "***** 6.Test missing opaque in redirect parent directory *****"
> -mkdir -p $UPPER_DIR/testdir0/testdir1
> -mkdir $UPPER_DIR/origin
> -mkdir $LOWER_DIR/origin
> -setfattr -n $OVL_REDIRECT_XATTR -v "/origin" $UPPER_DIR/testdir0/testdir1
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir0/testdir1
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: upper's redirect xattr incorrect removed"
> -       RET=$(($RET+1))
> -fi
> -getfattr -n $OVL_OPAQUE_XATTR $UPPER_DIR/origin
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: upper's missing opaque not set"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $UPPER_DIR/*
> -rm -rf $LOWER_DIR/*
> -
> -# 7.Test duplicate redirect directory in one layer
> -echo "***** 7.Test duplicate redirect directory in one layer *****"
> -mkdir $UPPER_DIR/testdir0
> -mkdir $UPPER_DIR/testdir1
> -mknod $UPPER_DIR/origin c 0 0
> -mkdir $LOWER_DIR/origin
> -setfattr -n $OVL_REDIRECT_XATTR -v "origin" $UPPER_DIR/testdir0
> -setfattr -n $OVL_REDIRECT_XATTR -v "origin" $UPPER_DIR/testdir1
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -if [[ $? -eq 0 ]];then
> -       echo "ERROR: fsck check incorrect pass"
> -       RET=$(($RET+1))
> -fi
> -rm -rf $UPPER_DIR/*
> -rm -rf $LOWER_DIR/*
> -
> -# 8.Test duplicate redirect directory in different layer
> -echo "***** 8.Test duplicate redirect directory in different layer *****"
> -mkdir $UPPER_DIR/testdir0
> -mkdir $LOWER_DIR/testdir1
> -mkdir $LOWER_DIR1/origin
> -setfattr -n $OVL_REDIRECT_XATTR -v "origin" $UPPER_DIR/testdir0
> -setfattr -n $OVL_REDIRECT_XATTR -v "origin" $LOWER_DIR/testdir1
> -$OVL_FSCK -a -l $LOWER_DIR:$LOWER_DIR1 -u $UPPER_DIR -w $WORK_DIR
> -getfattr -n $OVL_REDIRECT_XATTR $UPPER_DIR/testdir0
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: upper's redirect xattr incorrect removed"
> -       RET=$(($RET+1))
> -fi
> -getfattr -n $OVL_REDIRECT_XATTR $LOWER_DIR/testdir1
> -if [[ $? -ne 0 ]];then
> -       echo "ERROR: lower's redirect xattr incorrect removed"
> -       RET=$(($RET+1))
> -fi
> -
> -if [ ! -e "$LOWER_DIR/origin" ];then
> -       echo "ERROR: upper's missing whiteout not create"
> -       RET=$(($RET+1))
> -fi
> -if [ ! -e "$LOWER_DIR/origin" ];then
> -       echo "ERROR: lower's missing whiteout not create"
> -       RET=$(($RET+1))
> -fi
> -
> -rm -rf $UPPER_DIR/*
> -rm -rf $LOWER_DIR/*
> -rm -rf $LOWER_DIR1/*
> -
> -__clean
> -
> -exit $RET
> diff --git a/test/src/whiteout_test.sh b/test/src/whiteout_test.sh
> deleted file mode 100755
> index c0e1555..0000000
> --- a/test/src/whiteout_test.sh
> +++ /dev/null
> @@ -1,63 +0,0 @@
> -#!/bin/bash
> -
> -. ./local.config
> -
> -__clean()
> -{
> -       rm -rf $TEST_DIR/*
> -       cd $PWD
> -}
> -
> -RET=0
> -
> -cd $TEST_DIR
> -rm -rf *
> -mkdir $LOWER_DIR $LOWER_DIR1 $UPPER_DIR $WORK_DIR
> -
> -# 1.Test lower orphan whiteout
> -echo "***** 1.Test lower orphan whiteout *****"
> -mknod $LOWER_DIR/foo c 0 0
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -if [ -e "$LOWER_DIR/foo" ];then
> -       echo "lower's whiteout not remove"
> -       RET=$(($RET+1))
> -fi
> -rm -f $LOWER_DIR/*
> -
> -# 2.Test upper orphan whiteout
> -echo "***** 2.Test upper orphan whiteout *****"
> -mknod $UPPER_DIR/foo c 0 0
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -if [ -e "$UPPER_DIR/foo" ];then
> -       echo "upper's whiteout not remove"
> -       RET=$(($RET+1))
> -fi
> -rm -f $UPPER_DIR/*
> -
> -# 3.Test upper inuse whiteout
> -echo "***** 3.Test upper inuse whiteout *****"
> -touch $LOWER_DIR/foo
> -mknod $UPPER_DIR/foo c 0 0
> -$OVL_FSCK -a -l $LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -if [ ! -e "$UPPER_DIR/foo" ];then
> -       echo "upper's whiteout incorrect remove"
> -       RET=$(($RET+1))
> -fi
> -rm -f $UPPER_DIR/*
> -rm -f $LOWER_DIR/*
> -
> -# 4.Test lower inuse whiteout
> -echo "***** 4.Test lower inuse whiteout *****"
> -touch $LOWER_DIR/foo
> -mknod $LOWER_DIR1/foo c 0 0
> -$OVL_FSCK -a -l $LOWER_DIR1:$LOWER_DIR -u $UPPER_DIR -w $WORK_DIR
> -if [ ! -e "$LOWER_DIR1/foo" ];then
> -       echo "lower's whiteout incorrect remove"
> -       RET=$(($RET+1))
> -fi
> -rm -f $LOWER_DIR1/*
> -rm -f $LOWER_DIR/*
> -
> -__clean
> -
> -exit $RET
> --
> 2.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
