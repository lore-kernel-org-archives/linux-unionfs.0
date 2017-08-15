From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: two questiones about overlayfs
Date: Tue, 15 Aug 2017 16:52:37 +0200
Message-ID: <CAOQ4uxj6qkN-gi4a9ztKJj0FoBMrJC3DPta-m+3dVeHCxZOBNw@mail.gmail.com>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
 <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com> <20170815133554.GB29201@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36623 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751847AbdHOOwi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2017 10:52:38 -0400
Received: by mail-oi0-f41.google.com with SMTP id g131so9230745oic.3
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2017 07:52:38 -0700 (PDT)
In-Reply-To: <20170815133554.GB29201@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com, Vivek Goyal <vgoyal@redhat.com>

On Tue, Aug 15, 2017 at 3:35 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Aug 08, 2017 at 07:01:30AM +0200, Amir Goldstein wrote:
>> On Mon, Aug 7, 2017 at 9:57 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>
> [snip]
>
>> > 2. Chattr will modify lower file's attributes directly.
>> > Reproduce:
>> > # mkdir lower upper worker merger
>> > # touch lower/aa
>> > # lsattr -p lower/aa
>> >     0 --------------e---- lower/aa
>> > # mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
>> > # chattr -p 123 merger/aa             #set project id
>> > # lsattr -p lower/aa
>> >   123 --------------e---- lower/aa
>> >
>> > If we try to set "immutable" or any other attributes, the result are consistent.
>> > Because chattr open file in RDONLY mode, so it will not trigger copyup, and then,
>> > FS_IOC_SETFLAGS ioctl will get the lower inode and modify it.
>>
>> Ouch! I guess it's a "known to some" issue.
>> Fixing this would be a pain (intercept ioctl and whitelisting readonly
>> fs specific ioctls).
>
> Fixing ioctl properly would be a pain.  But we can hack around the issue, and
> just deny it for now.
>
> See patch below

I like this, but it will require good test coverage of fs specific ioctls.
The list of filesystems that call  mnt_want_write_file() for ioctl is not short.

>
> (Side note: probably better just add another argument to ->d_real() instead of
> trying to cram everyting into the open_flags arg).
>

I was going to say that the -1 flags hack is not pretty and suggest O_REAL_INODE
open flag. With the addition of -2 I think another interenal_flags
argument is in order,
which will also replace the implicit modes of d_real() with explicit modes:
D_REAL_COPYUP, D_REAL_MATCH_INODE, D_REAL_RDONLY and now also
D_REAL_STAT and D_REAL_UPPER.

This patch makes me wonder about O_PATH.
It looks strange that f->f_inode and f->f_mapping are being set at all
for files open
with O_PATH. Indeed file_inode(f) could sometimes be used for files
open with O_PATH
(e.g. fchdir() -> inode_permission() ), but it may make more sense to
use a helper
file_path_inode(f.file) (same as locks_inode()) for those cases
instead of relying on
f->f_inode being set. No?

Amir.
