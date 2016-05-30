From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 1/1] ovl: setxattr: don't deadlock when called from
 ima_fix_xattr.
Date: Mon, 30 May 2016 16:10:15 +0200
Message-ID: <20160530141015.GC5758@veci.piliscsaba.szeredi.hu>
References: <1463611500.2465.22.camel@linux.vnet.ibm.com>
 <1463725718-2461-1-git-send-email-kli@iki.fi>
 <1463754087.2763.17.camel@linux.vnet.ibm.com>
 <20160520162937.GU14480@ZenIV.linux.org.uk>
 <1463763633.2763.34.camel@linux.vnet.ibm.com>
 <CAH4bDXjHjPSYAoQB8VODcDG2MRz30ZQqtrm+x7BWG-2X8qhGAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32857 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbcE3OKW (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 30 May 2016 10:10:22 -0400
Received: by mail-wm0-f66.google.com with SMTP id a136so23166179wme.0
        for <linux-unionfs@vger.kernel.org>; Mon, 30 May 2016 07:10:21 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAH4bDXjHjPSYAoQB8VODcDG2MRz30ZQqtrm+x7BWG-2X8qhGAg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Krisztian Litkey <kli@iki.fi>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, Krisztian Litkey <krisztian.litkey@intel.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel@vger.kernel.org

On Fri, May 20, 2016 at 11:53:18PM +0300, Krisztian Litkey wrote:
> On Fri, May 20, 2016 at 8:00 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > We deferred __fput() back in 2012 in order for IMA to safely take the
> > i_mutex and write security.ima.   Writing the security.ima xattr now
> > triggers overlayfs to write the xattr, but overlayfs doesn't
> > differentiate between callers - as a result of userspace or as described
> > here in __fput().   All calls to ovl_setxattr() should call vfs_sexattr,
> > except the one triggered by __fput().   Refer to the original lockdep
> > report -
> > http://thread.gmane.org/gmane.linux.file-systems.union/640

Looks like more fallout from 4bacc9c9234c ("overlayfs: Make f_path always point
to the overlay and f_inode to the underlay").

Not sure what we want here.  Doing everything on the underlying dentry/inode
would be trivial (see attached patch).

Question is, can we get setxattr() on file opened for O_RDONLY?  If so, then
that could fail on overlayfs (lower layer is read-only).

Thanks,
Miklos

---
From: Miklos Szeredi <mszeredi@redhat.com>
Subject: ima: use file_path()

Ima tries to call ->setxattr() on overlayfs dentry after having locked
underlying inode, which results in a deadlock.

Reported-by: Krisztian Litkey <kli@iki.fi>
Fixes: 4bacc9c9234c ("overlayfs: Make f_path always point to the overlay and f_inode to the underlay")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: <stable@vger.kernel.org> # v4.2
---
 security/integrity/ima/ima_appraise.c |    4 ++--
 security/integrity/ima/ima_main.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -222,7 +222,7 @@ static int process_measurement(struct fi
 	if ((action & IMA_APPRAISE_SUBMASK) ||
 		    strcmp(template_desc->name, IMA_TEMPLATE_IMA_NAME) != 0)
 		/* read 'security.ima' */
-		xattr_len = ima_read_xattr(file->f_path.dentry, &xattr_value);
+		xattr_len = ima_read_xattr(file_dentry(file), &xattr_value);
 
 	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
 
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -190,7 +190,7 @@ int ima_appraise_measurement(enum ima_ho
 {
 	static const char op[] = "appraise_data";
 	char *cause = "unknown";
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	struct inode *inode = d_backing_inode(dentry);
 	enum integrity_status status = INTEGRITY_UNKNOWN;
 	int rc = xattr_len, hash_start = 0;
@@ -295,7 +295,7 @@ int ima_appraise_measurement(enum ima_ho
  */
 void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file)
 {
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	int rc = 0;
 
 	/* do not collect and update hash for digital signatures */
