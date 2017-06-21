From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 5/5] ovl: consistent st_ino/d_ino
Date: Wed, 21 Jun 2017 11:03:41 +0300
Message-ID: <CAOQ4uxiYVuhqbzmM0yx+3cUKhhzfrjBubHwKo6ro1FXedJ-Tqg@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
 <1496307779-2766-6-git-send-email-amir73il@gmail.com> <CAJfpeguF6aW6uNdZLaqQnyTo00rz7E=NBbHbYjSpKVcMCVu1dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35470 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752137AbdFUIDm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 04:03:42 -0400
Received: by mail-oi0-f67.google.com with SMTP id v74so14640679oie.2
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 01:03:42 -0700 (PDT)
In-Reply-To: <CAJfpeguF6aW6uNdZLaqQnyTo00rz7E=NBbHbYjSpKVcMCVu1dg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Jun 21, 2017 at 12:25 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jun 1, 2017 at 11:02 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> This patch is based on an earlier POC by Miklos Szeredi.
>>
>> When iterating an "impure" upper directory which may contain copy up
>> entries, lookup the overlay dentries to see if we know their copy up
>> origin and if we do, call vfs_getattr() on the overlay dentry
>> to make sure that d_ino will be consistent with st_ino from stat(2).
>
> Getting back to this, because there are issues:
>
>  - ".." can have different origin even if dir is pure (pure upper
> residing in merged dir, pure lower residing in dir which has another
> lower layer (which is the origin) above it)

If we need to add complexity only for the sake of consistent d_ino for
"..", then IMO we should leave it inconsistent (as is it today).
Directories don't have consistent d_ino today and nobody complains
(right?). As I wrote before, 'find' doesn't look at d_ino for directories,
it always checks st_ino for dir (i.e. with find -ino N).
So as long as won't we are not aware of any application for which
that matters, let's leave directories at "best effort" w.r.t consistent
d_ino. They are already best effort w.r.t persistent st_ino (!samefs).


>
>  - we check impure at open time,

Not only. we also check impure (ovl_dir_is_real) at ovl_dir_reset(),
so at first call to getdents(2).

> but dir can become impure between two
> getdents*(2) calls, we can get wrong inode numbers
>
> Becoming impure needs to be handled differently from what this patch
> does, because we can't switch to cached readdir in the middle of the
> directory listing.
>
> To handle that we need to add our own actor to the is_real case to fix
> up the inode numbers.  This would fix the ".." case as well.
>
> The problem is, we are inside underlying fs code when  actor is
> called, so there's not much we can do without risking deadlocks.  One
> thing we can do (hopefully) is call d_lookup() to check for a cached
> overlay dentry, and get the inode number out.
>
>  We need to store the full inode number in the overlay inode, because
> we can't do vfs_getattr() either, but that's a good optimization
> anyway.
>
> If the overlay dentry  is not in the cache we need to abort the
> iteration, lookup the dentry, and continue iterating.
>
> Thoughts?  I'll have a go at this tomorrow.
>

Thinking out loud: If we store od->version for is_real
dir containing the dentry version when we decided that
od->is_real. Then we can compare version in ovl_iterate() and if
version has changed then call ovl_dir_reset() and if is_real became
false then "abort the iteration, lookup the dentry, and continue iterating."
without having to go through all the pain involved with acting in underlying
fs code context.

I might note, though you are probably aware, that dir becoming impure
due to copy up is not a problem, because then dir is either already merge
before copy up or we are already iterating real lower dir.

The rename origin into pure upper dir case, is synchronized with overlay
dir inode lock against any single getdents(2) call, so dir becoming impure
due to rename can only happen between two getdents(2) calls as you wrote.

Amir.
