Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 17 Aug 2018 14:16:51 +0300
Message-ID: <CAOQ4uxhPbS5v5m3XAZ2MTbYcAmjBALXDoyhNf0wVW-SjA4Hjbg@mail.gmail.com>
Subject: RE: ovl: set I_CREATING on inode being created
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

I have 2 questions/comments w.r.t. commit 9475938ce8cf
("ovl: set I_CREATING on inode being created") in overlayfs-next.

1. insert_inode_locked4() sets I_CREATING not inside
spinlock and your patch sets it inside spinlock.
technically, I guess the spinlock taken inside inode_insert5()
to set I_NEW and insert to hash probably provides the needed
barriers. Do you think we should choose one of the practices
and stick with it??

2. I find it nicer if ovl_new_inode() would return an I_CREATING
inode, to conform with the users of inode_insert_locked4() (e.g.
btrfs_new_inode()) this will conform with the pattern:
inode = XXXfs_new_inode(...);
d_instantiate_new(dentry, inode);
The call site d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
could either use a variant of ovl_new_inode() or we could
let ovl_inode_init() clear I_CREATING.

Both those issues could be addressed after rc1.

Thanks,
Amir.
