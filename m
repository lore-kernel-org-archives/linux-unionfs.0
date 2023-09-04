Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D03DC71153
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 07:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbjIDHrn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 03:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244268AbjIDHrn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 03:47:43 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936A0DF
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 00:47:39 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VrG.30t_1693813656;
Received: from 30.221.146.157(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0VrG.30t_1693813656)
          by smtp.aliyun-inc.com;
          Mon, 04 Sep 2023 15:47:37 +0800
Message-ID: <a05e13c7-2fc2-77d8-05b5-759a73d7f5e2@linux.alibaba.com>
Date:   Mon, 4 Sep 2023 15:47:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Content-Language: en-US
From:   Jingbo Xu <jefflexu@linux.alibaba.com>
Subject: [potential issue, question] whiteout shows up in merged directory
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Cc:     Xiang Gao <xiang@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi, all,

I found an issue may be related to overlayfs on the latest master branch
[1] when I'm developing tarfs mode for erofs-utils [2], which converts
and merges tar layers into one merged erofs image with overlayfs-like model.

The issue is that, the whiteout from lowerdir may still shows up in the
merged directory.  Though this issue is initially found with erofs, it
can also be reproduced with ext4.  Following is a simple reproducer with
ext4.

```
mkdir -p /mnt/lower1/dir /mnt/lower2
mknod /mnt/lower1/file1 c 0 0
mknod /mnt/lower1/dir/file2 c 0 0
mount -t overlay none -olowerdir=/mnt/lower1:/mnt/lower2 /mnt2

# ls  -l /mnt2/
total 4
drwxr-xr-x 2 root root 4096 Sep  4 14:40 dir

# ls  -l /mnt2/dir
ls: cannot access /mnt2/dir/file2: No such file or directory
total 0
c????????? ? ? ? ?            ? file2
```

It seems that this issue is relevant to whether the parent directory of
the whiteout is a merged directory or not.  In the above example, file1
is hidden from the merged directory as expected (with its parent
directory '/' a merged directory), while file2 shows up unexpectedly
(with its parent directory '/dir' from lowerdir).


I also noticed that this issue doesn't exist if the whiteout is created
by overlayfs itself rather than handcrafted with mknod like:

```
mkdir -p /mnt/lower/dir /mnt/upper /mnt/work
touch /mnt/lower/file1
touch /mnt/lower/dir/file2
mount -t overlay none
-olowerdir=/mnt/lower,upperdir=/mnt/upper,workdir=/mnt/work /mnt1
rm /mnt1/file1
rm /mnt1/dir/file2
umount /mnt1
mount -t overlay -olowerdir=/mnt/upper:/mnt/lower none /mnt2

# ls -l /mnt2/
total 8
drwxr-xr-x 1 root root 4096 Sep  4 15:45 dir

# ls -l /mnt2/dir/
total 0
```

I'm not sure if it's a known issue or not, or due to my mishandling.
Appreciate if you could shed a light on this.


[1] git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
[2]
https://lore.kernel.org/all/20230901094706.27539-1-jefflexu@linux.alibaba.com/

-- 
Thanks,
Jingbo
