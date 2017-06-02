From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 2/5] ovl: relax same fs constrain for constant st_ino
Date: Fri, 2 Jun 2017 09:32:40 +0300
Message-ID: <CAOQ4uxjvBUEB89T0+qO4yksVeU+8KXEphOYxShMtQYiyNdxzLA@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
 <1496307779-2766-3-git-send-email-amir73il@gmail.com> <CAJfpegtacnEncCkWQg4sE=ck6W2Utd6tJe3JsvAaeLoWEkRksw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33978 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbdFBGcv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 02:32:51 -0400
Received: by mail-oi0-f50.google.com with SMTP id o65so55805302oif.1
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Jun 2017 23:32:51 -0700 (PDT)
In-Reply-To: <CAJfpegtacnEncCkWQg4sE=ck6W2Utd6tJe3JsvAaeLoWEkRksw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Jun 1, 2017 at 10:55 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jun 1, 2017 at 11:02 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> For the case of all layers not on the same fs, use the copy up
>> origin st_ino/st_dev for non-dir, if we know it.
>>
>> This guarantied constant and persistent st_ino/st_dev for non-dir,
>> but not system-wide uniqueness, like in the same fs case.
>
> I'd rather leave this until the st_dev uniqueness is sorted out.   Non
> unique st_ino/st_dev is just asking for trouble.
>

I don't mind leaving this out, but you do realize that this commit
doesn't change st_dev/st_ino uniqueness one way or the other, right?

- Directory st_dev/st_ino *remains* constant, unique and non-persistent
- Non-dir st_dev/st_ino *remains* non-unique, but becomes constant and
persistent

So I can't really see the harm in this patch.

Nevertheless, let me know if you want me to re-post consistent d_ino without
the non-samefs relax patches. Actually, consistent d_ino patch is
correct with or
without the non-samefs relax patches, but it misses an optimization for skipping
vfs_getattr() for (impure && !samefs) case.

Amir.
