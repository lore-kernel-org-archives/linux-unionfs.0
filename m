From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 5/5] ovl: consistent st_ino/d_ino
Date: Wed, 21 Jun 2017 10:53:02 +0200
Message-ID: <CAJfpegsCF8ZssutAe0yKEL4Bn1LZrMvqK5MXk8oQ7jj5fm0RtQ@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
 <1496307779-2766-6-git-send-email-amir73il@gmail.com> <CAJfpeguF6aW6uNdZLaqQnyTo00rz7E=NBbHbYjSpKVcMCVu1dg@mail.gmail.com>
 <CAOQ4uxiYVuhqbzmM0yx+3cUKhhzfrjBubHwKo6ro1FXedJ-Tqg@mail.gmail.com>
 <CAJfpegumm16iy4v7vVkOOM0upvc=_jmuMxTiXn+cgEfi5c8FFw@mail.gmail.com>
 <CAJfpeguKQbG-EZTziROiKy+2t6iQU3FEwfZmc9ezPX_voEyTmA@mail.gmail.com>
 <CAJfpeguVYLdh5sc7-TCKVrdPdVGhxh3oSeP=EfN=nArh6wi_fA@mail.gmail.com> <CAOQ4uxhXQi-7sNTYxpMnDJGHC95r2QFAaoeeY5GQYWCe30EZOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:34552 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752704AbdFUIxE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 04:53:04 -0400
Received: by mail-ot0-f196.google.com with SMTP id p48so18458247otc.1
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 01:53:03 -0700 (PDT)
In-Reply-To: <CAOQ4uxhXQi-7sNTYxpMnDJGHC95r2QFAaoeeY5GQYWCe30EZOA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Jun 21, 2017 at 10:49 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jun 21, 2017 at 11:45 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Jun 21, 2017 at 10:38 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Wed, Jun 21, 2017 at 10:20 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>
>>>> Right.  The problem is when dir becomes impure due to rename between
>>>> two getdents(2) calls.  We can't call ovl_dir_reset() because the
>>>> offset is not zero.  We could do a "cache with head cut off" starting
>>>> from the current offset in the dir and finish with that.  Yeah, it's
>>>> probably less complexity than trying to intercept the actor...
>>>
>>> On the other hand, we'll need to accommodate the native directory
>>> indexing (i.e. seekdir(3) hell) in the cache, which is going to add to
>>> complexity.  Ugh.
>>
>> Another idea:  we are allowed to omit directory entries added after
>> the opendir/rewinddir.  So if there was a simple way to filter out
>> newly added entries which have origin then we are fine.
>>
>
> Then how about this: implement an actor that ONLY looks in
> overlay dcache for the entries.
> If entry is in dcache then can take inode number from overlay
> inode.
> If entry is not in dcache AND the file was just moved into dir
> (quite unlinkely) then write off d_ino as a transient inconsistency.

Note: in theory the "just moved into dir" can be two weeks before.  In
practice it's unlikely that two calls of getdents(2) will be so far
apart in time.

Still, this feels a bit too hacky.

Thanks,
Miklos
