Return-Path: <miklos@szeredi.hu>
Date: Wed, 13 Nov 2019 12:26:08 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix timestamp limits
Message-ID: <20191113112608.GA5569@miu.piliscsaba.redhat.com>
References: <20191111073000.2957-1-amir73il@gmail.com>
 <CAJfpegvASSszZoYOdX9dcffo0EUNGVe_b8RU3JTtn-tXr9O7eg@mail.gmail.com>
 <CAOQ4uxhMqYWYnXfXrzU7Qtv8xpR6k_tR9CFSo01NLZSvqBOxsw@mail.gmail.com>
 <CAJfpeguvm=1Dw7V4XTr4gyo3uK+-EFNYKeDCFvUmuMPJxA=TcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguvm=1Dw7V4XTr4gyo3uK+-EFNYKeDCFvUmuMPJxA=TcA@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Nov 13, 2019 at 11:26:13AM +0100, Miklos Szeredi wrote:
> On Tue, Nov 12, 2019 at 5:06 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Nov 12, 2019 at 5:48 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Mon, Nov 11, 2019 at 8:30 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > Overlayfs timestamp overflow limits should be inherrited from upper
> > > > filesystem.
> > > >
> > > > The current behavior, when overlayfs is over an underlying filesystem
> > > > that does not support post 2038 timestamps (e.g. xfs), is that overlayfs
> > > > overflows post 2038 timestamps instead of clamping them.
> > >
> > > How?  Isn't the clamping supposed to happen in the underlying filesystem anyway?
> > >
> >
> > Not sure if it is supposed to be it doesn't.
> > It happens in do_utimes() -> utimes_common()
> 
> Ah.   How about moving the timestamp_truncate() inside notify_change()?

Untested patch below.

BTW overlayfs isn't the only one calling notify_change().  There's knfsd and
ecryptfs, neither of which seems to clamp timestamps according on the underlying
filesystem.

Thanks,
Miklos

diff --git a/fs/attr.c b/fs/attr.c
index df28035aa23e..e8de5e636e66 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -268,8 +268,13 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 	attr->ia_ctime = now;
 	if (!(ia_valid & ATTR_ATIME_SET))
 		attr->ia_atime = now;
+	else
+		attr->ia_atime = timestamp_truncate(attr->ia_atime, inode);
 	if (!(ia_valid & ATTR_MTIME_SET))
 		attr->ia_mtime = now;
+	else
+		attr->ia_mtime = timestamp_truncate(attr->ia_mtime, inode);
+
 	if (ia_valid & ATTR_KILL_PRIV) {
 		error = security_inode_need_killpriv(dentry);
 		if (error < 0)
diff --git a/fs/utimes.c b/fs/utimes.c
index 1ba3f7883870..df483207da4e 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -35,17 +35,13 @@ static int utimes_common(const struct path *path, struct timespec64 *times)
 	if (times) {
 		if (times[0].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_ATIME;
-		else if (times[0].tv_nsec != UTIME_NOW) {
-			newattrs.ia_atime = timestamp_truncate(times[0], inode);
+		else if (times[0].tv_nsec != UTIME_NOW)
 			newattrs.ia_valid |= ATTR_ATIME_SET;
-		}
 
 		if (times[1].tv_nsec == UTIME_OMIT)
 			newattrs.ia_valid &= ~ATTR_MTIME;
-		else if (times[1].tv_nsec != UTIME_NOW) {
-			newattrs.ia_mtime = timestamp_truncate(times[1], inode);
+		else if (times[1].tv_nsec != UTIME_NOW)
 			newattrs.ia_valid |= ATTR_MTIME_SET;
-		}
 		/*
 		 * Tell setattr_prepare(), that this is an explicit time
 		 * update, even if neither ATTR_ATIME_SET nor ATTR_MTIME_SET
