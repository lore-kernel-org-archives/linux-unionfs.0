Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Question about CAP_SYS_RESOURCES in overlayfs
Message-ID: <c976a238-a45c-c385-61db-e94844e3c01a@huawei.com>
Date: Mon, 28 May 2018 16:13:21 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
To: overlayfs <linux-unionfs@vger.kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>, zengweilin@huawei.com, Miao Xie <miaoxie@huawei.com>, yi.zhang@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi All,

Now, we have a problem when we use "docker + overlayfs + ext4 project quota".
The project quota limit were set for each container's overlay dirs on one
basic ext4 filesystem, but part of them are privilege containers which have
CAP_SYS_RESOURCE and may want to exceed it's quota limit to use the reserved
space. But we can't because overlayfs drops CAP_SYS_RESOURCES from saved
credentials and don't allow to use the reserved space in basic ext4 filesystem
even it is a privileged process.

I notice that this point have been already discussed in (51f8f3c4e "ovl: drop
CAP_SYS_RESOURCE from saved mounter's credentials") [1] and it works well
at that time. But I still want to ask again is it better to inherit caller's
CAP_SYS_RESOURCES let privileged to use reserved space (keep basic filesystem's
ability) now ? If so, I can post a patch to cover this; If not, we should avoid
setting quota limit for privilege containers.

[1] https://patchwork.kernel.org/patch/9508297/

Thanks,
Yi.
