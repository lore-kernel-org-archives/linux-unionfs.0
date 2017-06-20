From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 5/5] ovl: consistent st_ino/d_ino
Date: Tue, 20 Jun 2017 23:25:23 +0200
Message-ID: <CAJfpeguF6aW6uNdZLaqQnyTo00rz7E=NBbHbYjSpKVcMCVu1dg@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com> <1496307779-2766-6-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:36100 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbdFTVZZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2017 17:25:25 -0400
Received: by mail-ot0-f194.google.com with SMTP id r67so16830712ota.3
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2017 14:25:25 -0700 (PDT)
In-Reply-To: <1496307779-2766-6-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Jun 1, 2017 at 11:02 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> This patch is based on an earlier POC by Miklos Szeredi.
>
> When iterating an "impure" upper directory which may contain copy up
> entries, lookup the overlay dentries to see if we know their copy up
> origin and if we do, call vfs_getattr() on the overlay dentry
> to make sure that d_ino will be consistent with st_ino from stat(2).

Getting back to this, because there are issues:

 - ".." can have different origin even if dir is pure (pure upper
residing in merged dir, pure lower residing in dir which has another
lower layer (which is the origin) above it)

 - we check impure at open time, but dir can become impure between two
getdents*(2) calls, we can get wrong inode numbers

Becoming impure needs to be handled differently from what this patch
does, because we can't switch to cached readdir in the middle of the
directory listing.

To handle that we need to add our own actor to the is_real case to fix
up the inode numbers.  This would fix the ".." case as well.

The problem is, we are inside underlying fs code when  actor is
called, so there's not much we can do without risking deadlocks.  One
thing we can do (hopefully) is call d_lookup() to check for a cached
overlay dentry, and get the inode number out.

 We need to store the full inode number in the overlay inode, because
we can't do vfs_getattr() either, but that's a good optimization
anyway.

If the overlay dentry  is not in the cache we need to abort the
iteration, lookup the dentry, and continue iterating.

Thoughts?  I'll have a go at this tomorrow.

Thanks,
Miklos
