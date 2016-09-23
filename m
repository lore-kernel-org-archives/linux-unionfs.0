From: Zhang AiHua <zhangaihua1@huawei.com>
Subject: Hi, Is this a problem?
Date: Fri, 23 Sep 2016 15:05:39 +0800
Message-ID: <57E4D443.2040502@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:21256 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753989AbcIWHJV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 23 Sep 2016 03:09:21 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

mount£º
overlay on /tmp type overlay (rw,relatime,lowerdir=/home/zah/lower,upperdir=/home/zah/upper,workdir=/home/zah/workdir)
/dev/mapper/fedora-home on /home type ext4 (rw,relatime,data=ordered)

problem as below:
[root@localhost tmp]# mkdir zzz
[root@localhost tmp]# chown -R zah zzz
[root@localhost tmp]# su zah
mktemp: failed to create file via template â€?tmp/.colorlsXXXâ€? Permission denied
bash: $TMP: ambiguous redirect
[zah@localhost tmp]$
[zah@localhost tmp]$
[zah@localhost tmp]$
[zah@localhost tmp]$ ls -alt |grep zzz
drwxr-xr-x   2 zah  root   4096 Sep 24 02:03 zzz
[zah@localhost tmp]$ rm -fr zzz
rm: cannot remove â€˜zzzâ€? Permission denied
[zah@localhost tmp]$

Is this a problem?
