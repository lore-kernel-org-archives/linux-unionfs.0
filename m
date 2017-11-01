From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v5 2/4] ovl: allocate anonymous devs for lowerdirs
Date: Wed, 1 Nov 2017 17:02:55 +0200
Message-ID: <CAOQ4uxiReuzqQ09b8f0YxxTzT-Lt0pSPxsTsxz9feuFPrmTGWg@mail.gmail.com>
References: <1509395247-15180-1-git-send-email-amir73il@gmail.com>
 <1509395247-15180-3-git-send-email-amir73il@gmail.com> <20171101144249.GA8259@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:49293 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbdKAPC4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 11:02:56 -0400
Received: by mail-yw0-f195.google.com with SMTP id z195so2070697ywz.6
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Nov 2017 08:02:56 -0700 (PDT)
In-Reply-To: <20171101144249.GA8259@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Nov 1, 2017 at 4:42 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Oct 30, 2017 at 10:27:25PM +0200, Amir Goldstein wrote:
>> From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>>
>> For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
>> provides unique values for st_dev. The unique values are obtained by
>> allocating anonymous bdevs for each of the lowerdirs in the overlayfs
>> instance.
>
> Hi Amir, Chandan,
>
> In the commit message, can we also mention what's the current behavior
> and why this new behavior beneficial/desirable.
>

This is the blurb from the uptodate patch on my branch:

     For non-samefs setup, to make sure that st_dev/st_ino pair
    is unique across the system, we return a unique anonymous
    st_dev for stat(2) of lower layer inode.

A bit fatter, but not fat enough...

Actually, it is not accurate, because st_dev/st_ino pair of pure
upper is still same values as underlying inode for non-samefs so the
values are not unique among all inodes in the system.

I can't remember if there was a reason for not allocating anonymous bdev
for upper or if it just because we did not need it to guaranty uniqueness
of st_dev/st_ino *among* overlay inodes while guarantying constant
st_dev/st_ino across copy up.

I will update commit message.

Thanks,
Amir.
