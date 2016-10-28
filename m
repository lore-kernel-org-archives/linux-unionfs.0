From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2] ovl: update S_ISGID when setting posix ACLs
Date: Fri, 28 Oct 2016 14:54:57 +0200
Message-ID: <20161028125457.GA8412@veci.piliscsaba.szeredi.hu>
References: <1477501840-25066-1-git-send-email-amir73il@gmail.com>
 <1477506616-14061-1-git-send-email-amir73il@gmail.com>
 <20161027223742.GC4819@redhat.com>
 <CAOQ4uxiSf+9u0P1s5--uj19ubrJYrUWH_WM2FPbpvH9yApoZyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiSf+9u0P1s5--uj19ubrJYrUWH_WM2FPbpvH9yApoZyQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 28, 2016 at 07:47:12AM +0300, Amir Goldstein wrote:
> On Fri, Oct 28, 2016 at 1:37 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Oct 26, 2016 at 09:30:16PM +0300, Amir Goldstein wrote:
> >> Since operations on upper are performed using mounter's credentials,
> >> we need to call posix_acl_update_mode() with current credentials on
> >> overlay inode to possibly copy-up and clear setgid bit, before setting
> >> posix ACLs on upper inode.
> >>
> >> Also wrap posix acl handlers with #ifdef CONFIG_FS_POSIX_ACL to
> >> avoid compiler warning for implicit declaration of function
> >> 'posix_acl_update_mode' on build without that config option.
> >>
> >> This change fixes xfstest generic/375, which failed to clear the
> >> setgid bit in the following test case over overlayfs:
> >>
> >>   touch $testfile
> >>   chown 100:100 $testfile
> >>   chmod 2755 $testfile
> >>   _runas -u 100 -g 101 -- setfacl -m u::rwx,g::rwx,o::rwx $testfile

Instead of calculating and setting the equivalent mode in overlayfs code (as
well as in the upper layer later), how about just clearing the sgid bit when
necessary?

Untested patch follows.

Thanks,
Miklos

---
 fs/overlayfs/super.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -562,6 +562,21 @@ ovl_posix_acl_xattr_set(const struct xat
 
 	posix_acl_release(acl);
 
+	/*
+	 * Check if sgid bit needs to be cleared (actual setacl operation will
+	 * be done with mounter's capabilities and so that won't do it for us).
+	 */
+	if (unlikely(inode->i_mode & S_ISGID) &&
+	    handler->flags == ACL_TYPE_ACCESS &&
+	    !in_group_p(inode->i_gid) &&
+	    !capable_wrt_inode_uidgid(inode, CAP_FSETID)) {
+		struct iattr iattr = { .ia_valid = ATTR_KILL_SGID };
+
+		err = ovl_setattr(dentry, &iattr);
+		if (err)
+			return err;
+	}
+
 	err = ovl_xattr_set(dentry, handler->name, value, size, flags);
 	if (!err)
 		ovl_copyattr(ovl_inode_real(inode, NULL), inode);
