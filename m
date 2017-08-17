From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: two questiones about overlayfs
Date: Thu, 17 Aug 2017 09:49:19 +0200
Message-ID: <CAOQ4uxg9zaqaT9rWFOL7A4Ed2wCHYvpM+bWbe8qR6OkTS_EzQg@mail.gmail.com>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
 <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
 <20170815133554.GB29201@veci.piliscsaba.szeredi.hu> <CAOQ4uxj6qkN-gi4a9ztKJj0FoBMrJC3DPta-m+3dVeHCxZOBNw@mail.gmail.com>
 <CAJfpegsOjqJ-BXFBA3SsuDVornt37GOomP4E8UTaNBxACtGFFw@mail.gmail.com>
 <CAOQ4uxha+B6bpKVxg824-WG-eYxfoL5OxW-PgmcWGcXGe55LXw@mail.gmail.com>
 <CAJfpegv-u+=edQ+bpD-HqAMUYf+Yy-hg-CkVGRiG6VDPT=S7aw@mail.gmail.com>
 <20170815155617.GC3551@redhat.com> <CAOQ4uxh4y1AAcQvv_A71E38TAUE9+Zk2vSQisOE1E=QEs7N-Jw@mail.gmail.com>
 <CAJfpegvwXL01-6FPXcbKcPiOKj+LBp69-eHnhiJtuevQdKd4tQ@mail.gmail.com>
 <CAOQ4uxgOM4Va3DnL5q+Oyz-OBtCe8-G0bq_Xf9Kuc8KToKyB5A@mail.gmail.com> <b1cd78c9-17cf-df0d-f141-e72f9dde1b98@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:38779 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751266AbdHQHtV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2017 03:49:21 -0400
Received: by mail-oi0-f65.google.com with SMTP id s21so5757761oie.5
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2017 00:49:20 -0700 (PDT)
In-Reply-To: <b1cd78c9-17cf-df0d-f141-e72f9dde1b98@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com, Theodore Tso <tytso@mit.edu>

On Thu, Aug 17, 2017 at 4:55 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> On 2017/8/16 19:10, Amir Goldstein Wrote:
...
>>>> I guess that would make sense.
>>>> I only wonder what was the reason for chattr to open RDONLY in
>>>> the first place (cc Ted)??
>>>
>>> What about copy up of flags?  Should we?
>>
>> IMO we should start with copying KSTAT_ATTR_FS_IOC_FLAGS,
>> which can already be available in kstat.
>> Other "standard" FS_IOC_FLAGS can be copied up when statx
>> gets support for those flags.
>>
>> FYI, chattr [+/-]<flags> does:
>> - fgetflags(&flags): {open OPEN_FLAGS; ioctl EXT2_IOC_GETFLAGS}
>> - change flags
>> - fsetflags(&flags): {open OPEN_FLAGS; ioctl EXT2_IOC_SETFLAGS}
>>
>> OPEN_FLAGS is defined independently in lib/e2p/f{get,set}flags.c as
>> (O_RDONLY|O_NONBLOCK|O_LARGEFILE), so technically all it
>> takes is to change the defined in  lib/e2p/fsetflags.c to O_RDWR
>> and then chattr [+/-]<flags> can be used for preemptive "copy up flags"
>> by userspace (*) to work around issues which require flags copy up.
>>
>
> Hi Amir:
> I notice that RDONLY is required if file is immutable or append-only,
> chattr will fail with EPERM return value if we use O_RDWR open flag to open
> a immutable or append-only file. So I think we cannot simply change
> to O_RDWR in lib/e2p/fsetflags.c, we should take care about this special,
> please see check in may_open() and __inode_permission().
>

Zhangyi,

You are right about the fact that we cannot "just change" OPEN_FLAGS
to O_RDWR, because it would return EPERM for non-overlayfs case and
also in some cases for overlayfs upper file.
However, the workaround for userspace to open O_RDWR to trigger
copy up before chattr should still work because may_open() has no
knowledge of the real inode flags (open may fail but still copy up). See
commit b0990fbbbd14 ("ovl: check IS_APPEND() on real upper inode")
Note that this commit does NOT prevent opening a lower file
O_RDWR even if that file is IS_APPEND or IS_IMMUTABLE
as mentioned in the commit message and that the reason this
commit only speaks about IS_APPEND() is that IS_MMUTABLE
is also checked later with inode_permission(MAY_WRITE).

(*) Like my answer before, this is all in theory, so I may be missing
something... again.

Amir.
