From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v5 2/4] ovl: allocate anonymous devs for lowerdirs
Date: Wed, 1 Nov 2017 15:34:38 +0200
Message-ID: <CAOQ4uxj=dLaikbukL0pEwoTQ9oFS0Y0d1ZQ+3Mt0fsxCdw1SPg@mail.gmail.com>
References: <1509395247-15180-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgCxei2GsTbVoZUGmPTs7F5LE21zHQvHXQh9Xf03V8XzA@mail.gmail.com>
 <CAOQ4uxiN0Du-25CN=Hn=5G6qm5-SPJ47EK3yQ8itQ8x5CpCzjw@mail.gmail.com> <1609807.jvdsPgIkQ8@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:56581 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdKANek (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 09:34:40 -0400
Received: by mail-yw0-f194.google.com with SMTP id l32so1816295ywh.13
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Nov 2017 06:34:39 -0700 (PDT)
In-Reply-To: <1609807.jvdsPgIkQ8@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Nov 1, 2017 at 3:17 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Wednesday, November 1, 2017 4:31:00 AM IST Amir Goldstein wrote:
...
>>
>> Pushed the requested changes to branch:
>> https://github.com/amir73il/linux/commits/ovl-nonsamefs-v6
>>
>> Currently same tip as overlayfs-devel.
>>
>
> Amir, The changes look fine to me. Thanks for addressing the review comments.
>

No problem, but just found another problem in testing -
When we iterate pure lower or upper dir type entries
we do not adjust their d_ino to overlay ino, which is differnt
than real ino for non-samefs dirs.
example ((mnt/b is pure upper):
=====================================
# ls -li /mnt/
total 0
16237 drwxr-xr-x  2 root root   40 Nov  1 13:12 b

# find /mnt -inum 16237
/mnt/b

# ../xfstests/src/t_dir_type /mnt/b 16237
. d

# ../xfstests/src/t_dir_type /mnt/b 16237

<nothing>
=====================================

This problem does not affect 'find -inum' because 'find' always
does stat(2) for directories to check st_ino and more.

But the problem does affect decoding of NFS file handles
because the default get_name() implementation relies on
d_ino lookup to match child name with disconnected child dentry.

I will fix it up.

Chandan,

When you have time, please send a fix to xfstests 038 and 041 to test
this missed use case and please send a nonsamefs test variant of 017.

Thanks,
Amir.
