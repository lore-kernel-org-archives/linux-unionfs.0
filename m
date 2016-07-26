From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Stable inode numbers
Date: Tue, 26 Jul 2016 13:09:40 +0200
Message-ID: <20160726110940.GA25404@veci.piliscsaba.szeredi.hu>
References: <CAKp8XJ41QeG03E_AW4cxsuyp4-uxrPWAkhKc60OMp3vK2YAADA@mail.gmail.com>
 <20160722121503.GC20504@veci.piliscsaba.szeredi.hu>
 <CAKp8XJ4Lfx06of5D4aVkg2up77xESZ9cy0z2PGn1g6-AoHvE8g@mail.gmail.com>
 <20160725113400.GF20504@veci.piliscsaba.szeredi.hu>
 <CAKp8XJ7p38vuP_AY7Ky27ui7w=4G5TiwGTB6ZDpfr96dX_hVeQ@mail.gmail.com>
 <CAJfpegvsP62Bk3_5+QzDP1n4d_Jze_eXff1bwXUof1+abk5Ecg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33368 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbcGZLJu (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 26 Jul 2016 07:09:50 -0400
Received: by mail-wm0-f66.google.com with SMTP id o80so1126100wme.0
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Jul 2016 04:09:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAJfpegvsP62Bk3_5+QzDP1n4d_Jze_eXff1bwXUof1+abk5Ecg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vito Caputo <vito.caputo@coreos.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Jul 26, 2016 at 12:02:13PM +0200, Miklos Szeredi wrote:
> On Mon, Jul 25, 2016 at 11:25 PM, Vito Caputo <vito.caputo@coreos.com> wrote:
> > I think this strategy is an improvement, but I'm a bit apprehensive
> > about how specific it is to this particular style of untar-like
> > directory metadata preservation failure in only providing stability to
> > directory inode numbers.
> >
> > Additionally it introduces a userspace-visible mount option, for
> > something which /feels/ like a stop-gap kludge to make some things
> > work better in the short-term.  Maybe it's acceptable, since a more
> > general solution could be implemented later which ignores the added
> > mount option without conflict.

Here's another patch that achieves stability without compromising
performance/disk usage.

Again not perfect, but perhaps good enough?

Thanks,
Miklos

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 12bcd07b9e32..5b7de7d489e0 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -143,13 +143,24 @@ static int ovl_dir_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	type = ovl_path_real(dentry, &realpath);
 	old_cred = ovl_override_creds(dentry->d_sb);
 	err = vfs_getattr(&realpath, stat);
+	/*
+	 * Use lower ino/dev for merged dir, so they are stable across copy up.
+	 */
+	if (!err && OVL_TYPE_MERGE(type) && OVL_TYPE_UPPER(type)) {
+		struct path lowerpath;
+		struct kstat lowerstat;
+
+		ovl_path_lower(dentry, &lowerpath);
+		err = vfs_getattr(&lowerpath, &lowerstat);
+		if (!err) {
+			stat->dev = lowerstat.dev;
+			stat->ino = lowerstat.ino;
+		}
+	}
 	revert_creds(old_cred);
 	if (err)
 		return err;
 
-	stat->dev = dentry->d_sb->s_dev;
-	stat->ino = dentry->d_inode->i_ino;
-
 	/*
 	 * It's probably not worth it to count subdirs to get the
 	 * correct link count.  nlink=1 seems to pacify 'find' and
