From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
Date: Thu, 2 Nov 2017 20:06:14 +0200
Message-ID: <CAOQ4uxjfhTfDF76TYDAHYg6A2tDJR+s7SKPnEc0JtK_fLBU67w@mail.gmail.com>
References: <1509567773-25590-1-git-send-email-amir73il@gmail.com> <CAJfpegsoj7HhL-_O0Y3EcrCNxDfmzwPa56hr1Uoza_NivLzU5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:44861 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933025AbdKBSGQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 14:06:16 -0400
Received: by mail-yw0-f193.google.com with SMTP id k11so356087ywh.1
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Nov 2017 11:06:15 -0700 (PDT)
In-Reply-To: <CAJfpegsoj7HhL-_O0Y3EcrCNxDfmzwPa56hr1Uoza_NivLzU5A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Nov 2, 2017 at 6:33 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Nov 1, 2017 at 9:22 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Miklos,
>>
>> My trigger for fixing up the non-samefs patches is that I found out
>> while testing NFS export that reconnecting a dir dentry doesn't work
>> for non-samefs case.
>> I tracked the problem down to the default implementation of get_name()
>> in expfs.c that looks up a child inode in parent dir by d_ino.
>
> That may be a good fix, but..

Not that good, it creates dir cache for pure lower without handling
NULL upper properly.

Pushed tested fix to ovl-nonsamefs-v7
with some re-arrange of the patches and more blurb in commit messages.


> we shouldn't have to rely on correct
> d_ino to get the name.
>
> In fact we can just recursively call exportfs_get_name() on underlying
> fs, since we have the parent and the child handle in both the dir and
> non-dir cases.
>

Yes, I have that implementation in the early pure upper decode patches,
but threw it out later on.

> Am I missing something?
>

No, in fact implementation of get_name() is even simpler than that.

The trick with copy up of dir on encode is that we are guarantied
to have a connected upper real  dir dentry before we decode the
overlay dentry (see simple implementation of get_parent() for example),
so we can lookup the name in dcache.

I just thought, hey, I'll apply Chandan's patch to fix get_name(),
but it turned out to be a lot more.
V7 should be fine now, although I still need to improve the xfstest
to make sure I covered all cases properly.

I did already torture V7 (+ovl-nfs-export-wip +ovl_snapshot_wip)
with snapshot tests, so I am more confident about it than V6.

Will post V7 patched to list after I have the test, but feel free to review.

Thanks,
Amir.
