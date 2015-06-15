From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [OpenWrt-Devel] Device tree issues with TL-WDR4900 (mpc85xx) and
 kernel 4.0.1
Date: Mon, 15 Jun 2015 14:52:38 +0200
Message-ID: <20150615125238.GA1969@tucsk.suse.de>
References: <CAJfpegvbBWmxouP=vt7e7_W38TGWcbOcHnUOifuzFhOsjhYKag@mail.gmail.com>
 <557E8BBC.8090901@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36449 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbbFOMwm (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 15 Jun 2015 08:52:42 -0400
Received: by wigg3 with SMTP id g3so76525746wig.1
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jun 2015 05:52:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <557E8BBC.8090901@openwrt.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Felix Fietkau <nbd@openwrt.org>
Cc: Roman Yeryomin <leroi.lists@gmail.com>, Wojciech Dubowik <Wojciech.Dubowik@neratec.com>, Heiner Kallweit <hkallweit1@gmail.com>, OpenWrt Development List <openwrt-devel@lists.openwrt.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jun 15, 2015 at 10:24:28AM +0200, Felix Fietkau wrote:
> On 2015-06-15 10:20, Miklos Szeredi wrote:
> > On Thu, Jun 11, 2015 at 2:01 PM, Miklos Szeredi <mszeredi@suse.cz> wrote:
> >> On 7 May 2015 at 15:49, Felix Fietkau <nbd@openwrt.org> wrote:
> >>> On 2015-05-07 08:01, Wojciech Dubowik wrote:
> >>>> Try to boot with kernel locking enabled. I have seen jffs2 deadlocks on
> >>>> readdir. As far as I remember
> >>>> with this patch it went through but I don't know anymore whether I have
> >>>> changed sth in config.
> >>>>
> >>>> Have a look at (search engine...) [PATCH] fs: jffs2: Add setup code for
> >>>> spi nor flash.
> >>>>
> >>>> Even with this patch I got some possible dead lock warnings so it might
> >>>> be just a partial cure. BTW it's
> >>>> a bit scary for future use. Looks like jffs2 doesn't get enough care...
> >>> I believe the locking issues are an overlayfs regression, maybe even
> >>> the same one as this one (which I fixed years ago):
> >>> http://linux-fsdevel.vger.kernel.narkive.com/XRtXLDlf/patch-1-2-overlayfs-fix-a-deadlock-in-ovl-dir-read-merged
> >>>
> >>> I believe this is the cause of the regression:
> >>>
> >>> commit 49c21e1cacd74a8c83407c70ad860c994e606e25
> >>> Author: Miklos Szeredi <mszeredi@suse.cz>
> >>> Date:   Sat Dec 13 00:59:42 2014 +0100
> >>>
> >>
> >> I'm working on 4.0 support for ar71xx and found that
> >> /etc/rc.d/S00sysfixtime is not able to finish it's job after second
> >> boot after flashing (t.i. after overlayfs is switched to jffs). I've
> >> run strace and found that find hangs on the very last getdents64 call
> >> (before calling it succesfully many times on previous
> >> files/directories).
> >> I've reverted every change up to
> >> 49c21e1cacd74a8c83407c70ad860c994e606e25 to overlayfs and it started
> >> working. Applying 49c21e1cacd74a8c83407c70ad860c994e606e25 back breaks
> >> it. So this commit is indeed the cause of regression.
> >>
> >> Miklos, any ideas how to fix it in current tree? I'm using 4.0.5 now
> >> but AFAIK there were no more changes to overlayfs.
> > 
> > What's the full mount setup?  (cat /proc/mounts)
> /dev/root /rom squashfs ro,relatime 0 0
> proc /proc proc rw,noatime 0 0
> sysfs /sys sysfs rw,noatime 0 0
> tmpfs /tmp tmpfs rw,nosuid,nodev,noatime 0 0
> /dev/mtdblock8 /overlay jffs2 rw,noatime 0 0
> overlayfs:/overlay / overlay rw,noatime,lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work 0 0
> tmpfs /dev tmpfs rw,relatime,size=512k,mode=755 0 0
> devpts /dev/pts devpts rw,relatime,mode=600 0 0
> debugfs /sys/kernel/debug debugfs rw,noatime 0 0
> 
> - Felix


Following patch should fix the locking issue.

Please test.

Thanks,
Miklos

---
 fs/overlayfs/readdir.c |   77 +++++++++++++++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 28 deletions(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -23,6 +23,7 @@ struct ovl_cache_entry {
 	u64 ino;
 	struct list_head l_node;
 	struct rb_node node;
+	struct ovl_cache_entry *next_maybe_whiteout;
 	bool is_whiteout;
 	char name[];
 };
@@ -39,7 +40,7 @@ struct ovl_readdir_data {
 	struct rb_root root;
 	struct list_head *list;
 	struct list_head middle;
-	struct dentry *dir;
+	struct ovl_cache_entry *first_maybe_whiteout;
 	int count;
 	int err;
 };
@@ -79,7 +80,7 @@ static struct ovl_cache_entry *ovl_cache
 	return NULL;
 }
 
-static struct ovl_cache_entry *ovl_cache_entry_new(struct dentry *dir,
+static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
 						   const char *name, int len,
 						   u64 ino, unsigned int d_type)
 {
@@ -98,29 +99,8 @@ static struct ovl_cache_entry *ovl_cache
 	p->is_whiteout = false;
 
 	if (d_type == DT_CHR) {
-		struct dentry *dentry;
-		const struct cred *old_cred;
-		struct cred *override_cred;
-
-		override_cred = prepare_creds();
-		if (!override_cred) {
-			kfree(p);
-			return NULL;
-		}
-
-		/*
-		 * CAP_DAC_OVERRIDE for lookup
-		 */
-		cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
-		old_cred = override_creds(override_cred);
-
-		dentry = lookup_one_len(name, dir, len);
-		if (!IS_ERR(dentry)) {
-			p->is_whiteout = ovl_is_whiteout(dentry);
-			dput(dentry);
-		}
-		revert_creds(old_cred);
-		put_cred(override_cred);
+		p->next_maybe_whiteout = rdd->first_maybe_whiteout;
+		rdd->first_maybe_whiteout = p;
 	}
 	return p;
 }
@@ -148,7 +128,7 @@ static int ovl_cache_entry_add_rb(struct
 			return 0;
 	}
 
-	p = ovl_cache_entry_new(rdd->dir, name, len, ino, d_type);
+	p = ovl_cache_entry_new(rdd, name, len, ino, d_type);
 	if (p == NULL)
 		return -ENOMEM;
 
@@ -169,7 +149,7 @@ static int ovl_fill_lower(struct ovl_rea
 	if (p) {
 		list_move_tail(&p->l_node, &rdd->middle);
 	} else {
-		p = ovl_cache_entry_new(rdd->dir, name, namelen, ino, d_type);
+		p = ovl_cache_entry_new(rdd, name, namelen, ino, d_type);
 		if (p == NULL)
 			rdd->err = -ENOMEM;
 		else
@@ -219,6 +199,43 @@ static int ovl_fill_merge(struct dir_con
 		return ovl_fill_lower(rdd, name, namelen, offset, ino, d_type);
 }
 
+static int ovl_check_whiteouts(struct dentry *dir, struct ovl_readdir_data *rdd)
+{
+	int err = 0;
+
+	mutex_lock(&dir->d_inode->i_mutex);
+	while (rdd->first_maybe_whiteout) {
+		struct dentry *dentry;
+		const struct cred *old_cred;
+		struct cred *override_cred;
+		struct ovl_cache_entry *p = rdd->first_maybe_whiteout;
+
+		rdd->first_maybe_whiteout = p->next_maybe_whiteout;
+
+		override_cred = prepare_creds();
+		if (!override_cred) {
+			err = -ENOMEM;
+			break;
+		}
+		/*
+		 * CAP_DAC_OVERRIDE for lookup
+		 */
+		cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
+		old_cred = override_creds(override_cred);
+
+		dentry = lookup_one_len(p->name, dir, p->len);
+		if (!IS_ERR(dentry)) {
+			p->is_whiteout = ovl_is_whiteout(dentry);
+			dput(dentry);
+		}
+		revert_creds(old_cred);
+		put_cred(override_cred);
+	}
+	mutex_unlock(&dir->d_inode->i_mutex);
+
+	return err;
+}
+
 static inline int ovl_dir_read(struct path *realpath,
 			       struct ovl_readdir_data *rdd)
 {
@@ -229,7 +246,7 @@ static inline int ovl_dir_read(struct pa
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 
-	rdd->dir = realpath->dentry;
+	rdd->first_maybe_whiteout = NULL;
 	rdd->ctx.pos = 0;
 	do {
 		rdd->count = 0;
@@ -238,6 +255,10 @@ static inline int ovl_dir_read(struct pa
 		if (err >= 0)
 			err = rdd->err;
 	} while (!err && rdd->count);
+
+	if (!err && rdd->first_maybe_whiteout)
+		err = ovl_check_whiteouts(realpath->dentry, rdd);
+
 	fput(realfile);
 
 	return err;
