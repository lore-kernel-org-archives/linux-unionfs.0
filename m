From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 4/9] vfs: intercept reads to overlay files
Date: Sun, 19 Feb 2017 10:24:35 +0100
Message-ID: <CAOssrKcTiPCx-D+yZLaWyMz2-EMMO1Kv_3=EJ+CFiVb6Nc6fzw@mail.gmail.com>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
 <1487347778-18596-5-git-send-email-mszeredi@redhat.com> <20170219090545.GK29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:33775 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdBSJYi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 19 Feb 2017 04:24:38 -0500
Received: by mail-lf0-f45.google.com with SMTP id l12so771645lfe.0
        for <linux-unionfs@vger.kernel.org>; Sun, 19 Feb 2017 01:24:37 -0800 (PST)
In-Reply-To: <20170219090545.GK29622@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sun, Feb 19, 2017 at 10:05 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Feb 17, 2017 at 05:09:33PM +0100, Miklos Szeredi wrote:
>> ...in order to handle the corner case when the file is copyied up after
>> being opened read-only.
>
>> --- /dev/null
>> +++ b/fs/overlay_util.c
>> @@ -0,0 +1,39 @@
>> +/*
>> + * Copyright (C) 2017 Red Hat, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + */
>> +#if IS_ENABLED(CONFIG_OVERLAY_FS)
>
> This is crap - it should be handled in fs/Makefile, not with IS_ENABLED.

This is needed if overlay is built in or a module.  Couldn't figure
out how makefile could handle that.

>
>> +#include <linux/overlay_util.h>
>> +#include <linux/fs.h>
>> +#include <linux/file.h>
>> +#include "internal.h"
>> +
>> +static bool overlay_file_consistent(struct file *file)
>> +{
>> +     return d_real_inode(file->f_path.dentry) == file_inode(file);
>> +}
>> +
>> +ssize_t overlay_read_iter(struct file *file, struct kiocb *kio,
>> +                       struct iov_iter *iter)
>> +{
>> +     ssize_t ret;
>> +
>> +     if (likely(overlay_file_consistent(file)))
>> +             return file->f_op->read_iter(kio, iter);
>> +
>> +     file = filp_clone_open(file);
>> +     if (IS_ERR(file))
>> +             return PTR_ERR(file);
>> +
>> +     ret = vfs_iter_read(file, iter, &kio->ki_pos);
>> +     fput(file);
>
> You do realize that a bunch of such calls will breed arseloads of struct file,
> right?  Freeing is delayed...

No, I hadn't realized that.  Could we force freeing file here?

>
>> +static inline bool is_overlay_file(struct file *file)
>> +{
>> +     return IS_ENABLED(CONFIG_OVERLAY_FS) && file->f_mode & FMODE_OVERLAY;
>> +}
>> +
>>  static inline ssize_t call_read_iter(struct file *file, struct kiocb *kio,
>>                                    struct iov_iter *iter)
>>  {
>> +     if (unlikely(is_overlay_file(file)))
>> +             return overlay_read_iter(file, kio, iter);
>> +
>>       return file->f_op->read_iter(kio, iter);
>>  }
>
> 1) that IS_ENABLED is fairly pointless and it's not obvious that nobody
> else will use that flag

It's mean to be a micro-optimization for the CONFIG_OVERLAYFS=n case.

>
> 2) what that check should include is overlay_file_consistent(), with
> no method call in overlay_read_iter().

This is again a micro-optimization for the case when this is not an
overlay file.  Which is the very very likely case.

What's the problem with putting that test in the non-inline function?

>
> 3) anything that does a plenty of calls of kernel_read() is going to be
> very unpleasantly surprised by the effects of that thing.

Why is that?

Thanks,
Miklos
