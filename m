From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Fri, 4 Nov 2016 11:29:58 +0200
Message-ID: <CAOQ4uxgK9+Nwxtj9GCHp-fFg7Gsu0HMA2-MeguBJ=BWxQATWmw@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161028161534.GM19539@ZenIV.linux.org.uk>
 <CAJfpegs9zoTXiqaYV0=sQqXqD9_owqFiOkrwBkOrZ2yYpFEk2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35173 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752329AbcKDJaA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 4 Nov 2016 05:30:00 -0400
In-Reply-To: <CAJfpegs9zoTXiqaYV0=sQqXqD9_owqFiOkrwBkOrZ2yYpFEk2g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, Nov 3, 2016 at 5:50 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Oct 28, 2016 at 6:15 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Tue, Oct 25, 2016 at 09:34:47AM +0200, Miklos Szeredi wrote:
...
>>
>> I'm not sure if vfs_path_lookup() is the right tool here.  It might be
>> usable for making such a tool, but as it is you are setting one hell of
>> a trap for yourself...
>
> Agreed, it's not the right tool.   A custom loop of lookup_one_len's
> should work much better and doesn't add all that much complexity.
> Updated patch pushed to:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git #redirect
>
> This version also passes the recycling tests by Amir and enables the
> redirect feature by default on an empty upperdir.
>

Miklos,

You did not address my comment about the 'stack' allocation overflow
in ovl_lookup
I believe the (possible) overflow is demonstrated by the following debug patch:

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c7cacbb..7171bfb 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -231,5 +231,7 @@ struct dentry *ovl_lookup(struct inode *dir,
struct dentry *dentry,
                                goto out_put;

                        if (redirect && poe != dentry->d_sb->s_root->d_fsdata) {
+                               int stackroom = poe->numlower - ctr;
+
                                poe = dentry->d_sb->s_root->d_fsdata;

@@ -238,6 +240,8 @@ struct dentry *ovl_lookup(struct inode *dir,
struct dentry *dentry,
                                                break;
                                if (WARN_ON(i == poe->numlower))
                                        break;
+                               if (WARN_ON(poe->numlower - i - 1 > stackroom))
+                                       break;
                        }
                }
        }
-- 
2.7.4

In cases where a directory is moved into another directory with merge history
shorter then total number of layers,
lookup will need to grow the 'stack' while redirecting.
Bug will be hit only after remount or dcache drop, which was the
reason I wrote the
recycle test in the first place...

I instrumented unionmount-tests with test name prints to kmsg (a la xfstests)
Pushed to https://github.com/amir73il/unionmount-testsuite.git #ovl_rename_dir

And as you can see, 5 subtests hit the overflow warning.

[ 1759.692281] TEST rename-new-dir.py:161: Rename empty dir over
removed empty lower dir
[ 1759.747217] WARNING: CPU: 0 PID: 9065 at
/home/amir/src/linux/fs/overlayfs/namei.c:271 ovl_lookup+0x81d/0x870
[overlay]

[ 1759.748887] TEST rename-new-dir.py:172: Rename empty dir over
removed populated lower dir
[ 1759.836195] WARNING: CPU: 2 PID: 9065 at
/home/amir/src/linux/fs/overlayfs/namei.c:271 ovl_lookup+0x81d/0x870
[overlay]

[ 1763.519285] TEST rename-new-pop-dir.py:170: Rename new dir over
removed unioned empty dir
[ 1763.592055] WARNING: CPU: 3 PID: 9065 at
/home/amir/src/linux/fs/overlayfs/namei.c:271 ovl_lookup+0x81d/0x870
[overlay]

[ 1763.592989] TEST rename-new-pop-dir.py:183: Rename new dir over
removed unioned dir, different files
[ 1763.658290] WARNING: CPU: 3 PID: 9065 at
/home/amir/src/linux/fs/overlayfs/namei.c:271 ovl_lookup+0x81d/0x870
[overlay]

[ 1763.660379] TEST rename-new-pop-dir.py:197: Rename new dir over
removed unioned dir, same files
[ 1763.731482] WARNING: CPU: 0 PID: 9065 at
/home/amir/src/linux/fs/overlayfs/namei.c:271 ovl_lookup+0x81d/0x870
[overlay]

I hope I am not missing anything.

Cheers,
Amir.
