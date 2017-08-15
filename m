From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: two questiones about overlayfs
Date: Tue, 15 Aug 2017 17:28:46 +0200
Message-ID: <CAOQ4uxha+B6bpKVxg824-WG-eYxfoL5OxW-PgmcWGcXGe55LXw@mail.gmail.com>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
 <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
 <20170815133554.GB29201@veci.piliscsaba.szeredi.hu> <CAOQ4uxj6qkN-gi4a9ztKJj0FoBMrJC3DPta-m+3dVeHCxZOBNw@mail.gmail.com>
 <CAJfpegsOjqJ-BXFBA3SsuDVornt37GOomP4E8UTaNBxACtGFFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:36585 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752316AbdHOP2r (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2017 11:28:47 -0400
Received: by mail-oi0-f47.google.com with SMTP id g131so10252441oic.3
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2017 08:28:47 -0700 (PDT)
In-Reply-To: <CAJfpegsOjqJ-BXFBA3SsuDVornt37GOomP4E8UTaNBxACtGFFw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com, Vivek Goyal <vgoyal@redhat.com>

On Tue, Aug 15, 2017 at 5:06 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Aug 15, 2017 at 4:52 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Tue, Aug 15, 2017 at 3:35 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Tue, Aug 08, 2017 at 07:01:30AM +0200, Amir Goldstein wrote:
>>>> On Mon, Aug 7, 2017 at 9:57 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>
>>> [snip]
>>>
>>>> > 2. Chattr will modify lower file's attributes directly.
>>>> > Reproduce:
>>>> > # mkdir lower upper worker merger
>>>> > # touch lower/aa
>>>> > # lsattr -p lower/aa
>>>> >     0 --------------e---- lower/aa
>>>> > # mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
>>>> > # chattr -p 123 merger/aa             #set project id
>>>> > # lsattr -p lower/aa
>>>> >   123 --------------e---- lower/aa
>>>> >
>>>> > If we try to set "immutable" or any other attributes, the result are consistent.
>>>> > Because chattr open file in RDONLY mode, so it will not trigger copyup, and then,
>>>> > FS_IOC_SETFLAGS ioctl will get the lower inode and modify it.
>>>>
>>>> Ouch! I guess it's a "known to some" issue.
>>>> Fixing this would be a pain (intercept ioctl and whitelisting readonly
>>>> fs specific ioctls).
>>>
>>> Fixing ioctl properly would be a pain.  But we can hack around the issue, and
>>> just deny it for now.
>>>
>>> See patch below
>>
>> I like this, but it will require good test coverage of fs specific ioctls.
>> The list of filesystems that call  mnt_want_write_file() for ioctl is not short.
>
> If it's called from within the filesystem, then the new behavior is
> certainly the correct one.

It certainly is. It doesn't mean that fixing incorrect behavior won't
lead to unacceptable regressions, which may require explicit
d_real() call from filesystem to be fixed.

Side note: IMO may_write_real() should return -EPERM instead
of -EINVAL, same behavior as IS_IMMUTABLE, i.e. there is nothing
invalid about the parameters of the SETFLAGS ioctl as far as the user
is concerned. You could also go with -EROFS, which makes more sence,
but that may be a bit more surprising to user.

Amir.
