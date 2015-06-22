From: Jan Olszak <j.olszak@samsung.com>
Subject: Re: Optional switching off cow in overlayfs
Date: Mon, 22 Jun 2015 17:32:53 +0200
Message-ID: <55882AA5.10908@samsung.com>
References: <5582C6C1.8080602@samsung.com>
 <13405.1434634748@warthog.procyon.org.uk> <5582D8F7.1060700@samsung.com>
 <CAJfpegsP-_MAKybYZ=uS3UCxsxL9Hv-cJ-GYrVL4h3B+tWZF9A@mail.gmail.com>
 <5588116E.20509@samsung.com>
 <CAJfpegsVqzVhq8BjCwqA+6dEZey0aNb4amnnOT_JVDfzki9v1g@mail.gmail.com>
 <55881B2A.7090106@samsung.com>
 <CAJfpegtcUt6jR7t_2Ca1osu6+-BKGtnTVVTVXEcWrqBtY0fCzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45529 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbbFVPc6 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 22 Jun 2015 11:32:58 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQC00GZDR6VBHA0@mailout2.w1.samsung.com> for
 linux-unionfs@vger.kernel.org; Mon, 22 Jun 2015 16:32:55 +0100 (BST)
In-reply-to: <CAJfpegtcUt6jR7t_2Ca1osu6+-BKGtnTVVTVXEcWrqBtY0fCzA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On 06/22/2015 04:37 PM, Miklos Szeredi wrote:
> On Mon, Jun 22, 2015 at 4:26 PM, Jan Olszak <j.olszak@samsung.com> wrote:
>>> You can bind mount individual files from the lower layer to the
>>> overlay.  That fixes the "allow modification" part.
>> Well bind mounting every file that should have COW is unmaintainable - if
>> new files appear admin has to mount each one.
> No.  I was proposing bind mounts for non-COW ones.
>
> mount -t overlay -olowerdir=/lower,upperdir=/upper,workdir=/work  overlay /ovl
> mount --bind /lower/this-file-is-non-cow /ovl/this-file-is-non-cow
> ...
Yes, you are right. This should work, but introduces an overhead of many 
mounts for each Linux container.

The proposed alternative is: Use setfattr only once for each file and 
then forget about it.

>>>    But what should happen on rename or unlink?
>> Both would operate on the original inode.
> And that would make this hugely complex.
Are you sure? I haven't looked into rename and unlink routines but this 
patch covers opening the file and is pretty simple (though it probably 
breaks fchmod/fchown...).

I can try to prepare a real solution if you like the idea.




 From 20e590c0e37f087955b25edfbc2ab4c9c034b5b1 Mon Sep 17 00:00:00 2001
From: Jan Olszak <j.olszak@samsung.com>
Date: Mon, 22 Jun 2015 17:07:31 +0200
Subject: [PATCH] Optional copy on write in overlayfs

---
  fs/overlayfs/inode.c     | 17 +++++++++++++++++
  fs/overlayfs/overlayfs.h |  1 +
  fs/overlayfs/super.c     |  5 -----
  3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 04f1248..4f9f399 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -321,6 +321,20 @@ out:
      return err;
  }

+static bool ovl_dentry_need_copy_up(struct dentry *realdentry)
+{
+    int res;
+    char val;
+    struct inode *inode = realdentry->d_inode;
+
+    res = inode->i_op->getxattr(realdentry, OVL_XATTR_COW, &val, 1);
+    if (res == 1 && val == 'n'){
+        return false;
+    }
+
+    return true;
+}
+
  static bool ovl_open_need_copy_up(int flags, enum ovl_path_type type,
                    struct dentry *realdentry)
  {
@@ -330,6 +344,9 @@ static bool ovl_open_need_copy_up(int flags, enum 
ovl_path_type type,
      if (special_file(realdentry->d_inode->i_mode))
          return false;

+    if (!ovl_dentry_need_copy_up(realdentry))
+        return false;
+
      if (!(OPEN_FMODE(flags) & FMODE_WRITE) && !(flags & O_TRUNC))
          return false;

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 17ac5af..b364888 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -26,6 +26,7 @@ enum ovl_path_type {
  #define OVL_XATTR_PRE_NAME "trusted.overlay."
  #define OVL_XATTR_PRE_LEN  16
  #define OVL_XATTR_OPAQUE   OVL_XATTR_PRE_NAME"opaque"
+#define OVL_XATTR_COW      OVL_XATTR_PRE_NAME"cow"

  static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
  {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index bf8537c..916a4b5 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -944,11 +944,6 @@ static int ovl_fill_super(struct super_block *sb, 
void *data, int silent)
              pr_err("overlayfs: failed to clone lowerpath\n");
              goto out_put_lower_mnt;
          }
-        /*
-         * Make lower_mnt R/O.  That way fchmod/fchown on lower file
-         * will fail instead of modifying lower fs.
-         */
-        mnt->mnt_flags |= MNT_READONLY;

          ufs->lower_mnt[ufs->numlower] = mnt;
          ufs->numlower++;
-- 
1.9.1





Thanks,
Jan
