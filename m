Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxht5LMRpgTDg5AXyTOU4APnQavU-Q2WYpJOnBJNRi3Q4g@mail.gmail.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-21-vgoyal@redhat.com>
 <CAOQ4uxiJpXWXjWMWPa9DGzP06etO7-Y82MKdgroiD08Fhx9H6A@mail.gmail.com>
 <20180410140057.GA2776@redhat.com> <CAOQ4uxht5LMRpgTDg5AXyTOU4APnQavU-Q2WYpJOnBJNRi3Q4g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Apr 2018 22:29:00 +0300
Message-ID: <CAOQ4uxhpiNiOhsNjCJQ9w6vkvK+LCkTAB=db3Ho1SdP_-O_-0g@mail.gmail.com>
Subject: Re: [PATCH v13 20/28] ovl: Do not set dentry type ORIGIN for broken hardlinks
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Apr 10, 2018 at 10:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Apr 10, 2018 at 5:00 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
[...]
>>
>> In fact I see OVL_INDEX being used in ovl_getattr(). If a parallel copy
>> up took place it is possible that ovl_getattr() saw upperdentry but not
>> the OVL_INDEX. And then nlink count will be off. IOW, what barrier/lock
>> guarantees that this does not happen.
>>
>
> Yes. and that is not the only problem I see with ovl_getattr().
>
> stat->dev could be set to ovl_get_pseudo_dev(dentry), even
> if stat->ino is not set to lowerstat.ino; that is not good.
>
> If I am not mistaken, all the special conditions in ovl_getattr()
> to use lower st_ino are already encoded in ovl_hash_bylower(),
> so you may completely remove those extra tests if
> OVL_TYPE_ORIGIN(type) already checks the OVL_BYLOWER
> flag.
>
> It may be hard to see my claim above is true, because, for
> example, sb->s_export_op in ovl_hash_bylower() is equivalent
> to ovl_verify_lower(dentry->d_sb) in ovl_getattr().
>
> Please double check my claims, and if you agree, you can submit a
> patch that Fixes: ("a0c5ad307ac0 ovl: relax same fs constraint for
> constant st_ino"), which already does the right thing for metacopy.
>

On second thought, it would be better to submit the simple fix patch
first, so it could be applied to stable kernels that don't have
ovl_hash_bylower() and only then submit the patch that adds
OVL_BYLOWER and removes the extra tests in ovl_getattr().
Something like this (untested) should do.
Let me know if you would like me to submit the fix patch.

Thanks,
Amir.

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3b1bd469accd..34fe86dedd3b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -118,13 +118,10 @@ int ovl_getattr(const struct path *path, struct
kstat *stat,
                         */
                        if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) ||
                            (!ovl_verify_lower(dentry->d_sb) &&
-                            (is_dir || lowerstat.nlink == 1)))
+                            (is_dir || lowerstat.nlink == 1))) {
                                stat->ino = lowerstat.ino;
-
-                       if (samefs)
-                               WARN_ON_ONCE(stat->dev != lowerstat.dev);
-                       else
                                stat->dev = ovl_get_pseudo_dev(dentry);
+                       }
                }
                if (samefs) {
                        /*
