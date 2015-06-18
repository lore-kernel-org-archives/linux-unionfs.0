From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Thu, 18 Jun 2015 11:15:39 +0100
Message-ID: <8182.1434622539@warthog.procyon.org.uk>
References: <558187EA.60805@tycho.nsa.gov> <55805AEA.3050407@tycho.nsa.gov> <557ECBC5.7000705@tycho.nsa.gov> <16216.1417109138@warthog.procyon.org.uk> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk> <8813.1434123054@warthog.procyon.org.uk> <7332.1434473388@warthog.procyon.org.uk> <16652.1434490473@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbbFRKPp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 18 Jun 2015 06:15:45 -0400
In-Reply-To: <558187EA.60805@tycho.nsa.gov>
Content-ID: <8181.1434622539.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>, eparis@redhat.com
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, drquigl <drquigl@tycho.nsa.gov>, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> >> Until a process writes to the file, we just want to use the lower inode
> >> label, right?
> > 
> > No.
> > 
> > There are two issues:
> > 
> >  (1) Non-fd accesses to an overlayfs file use the security label on the
> >      overlay inode, not the lower inode, even before copy up because they
> >      go through the inode ops of the overlayfs file first.
> > 
> >  (2) I'm told that we want the ability to have a different label on the
> >      upper file to that on the lower file.  This is trivial in overlayfs
> >      since you always have an overlay inode off which to hang the security
> >      label, but tricky with unionmount since you may only have a dentry.
> 
> I recall that being controversial.  I agree that if a process attempts
> to write to the file and a copy-up is triggered, then we want to be able
> to label the copy of the file differently.  But until that happens, why
> wouldn't we simply treat the file as having the lower file label for
> access control purposes on read operations?

Actually, for overlayfs, I've made it such that the label off of the overlay
inode is used for the open file.  This label gets determined when the overlay
inode is set up and so is cached for the lifetime of the inode struct.  Like
this in the patch I posted:

+	if (inode) {
+		isec = inode->i_security;
+		fsec->union_isid = isec->sid;
+	} ...

where 'inode' is the overlay inode.  The subsequent bits:

+	} else if ((sbsec->flags & SE_SBINITIALIZED) &&
+		   (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)) {
+		fsec->union_isid = sbsec->mntpoint_sid;
+	} else {
+		dir = dget_parent(union_path->dentry);
+		dsec = dir->d_inode->i_security;
+
+		rc = security_transition_sid(
+			tsec->sid, dsec->sid,
+			inode_mode_to_security_class(file_inode(file)->i_mode),
+			&union_path->dentry->d_name,
+			&fsec->union_isid);
+		dput(dir);
+		if (rc) {
+			printk(KERN_WARNING "%s:  "
+			       "security_transition_sid failed, rc=%d (name=%pD)\n",
+			       __func__, -rc, file);
+			return rc;
+		}
+	}

are for future unionmount support where there isn't an inode in the union
layer but only an inode in a lower layer.

In patch 7/7, if fsec->union_isid is non-zero in file_has_perm() then that is
used directly with avc_has_perm() in preference to calling inode_has_perm() on
the overlay or lower inodes.

Btw, is it correct that file operations must follow the label currently on the
inode rather than caching it in file_security_struct?

> >  (2) I'm told that we want the ability to have a different label on the
> >      upper file to that on the lower file.  This is trivial in overlayfs
> >      since you always have an overlay inode off which to hang the security
> >      label, but tricky with unionmount since you may only have a dentry.
> 
> I recall that being controversial.  I agree that if a process attempts
> to write to the file and a copy-up is triggered, then we want to be able
> to label the copy of the file differently.  But until that happens, why
> wouldn't we simply treat the file as having the lower file label for
> access control purposes on read operations?

I'm hoping Eric Paris might address this.  As I understand it, we don't want
to give the container access to the lower layer labels, but would rather
consistently use the overlay labels.

David
