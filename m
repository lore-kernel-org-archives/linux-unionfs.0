From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Thu, 06 Nov 2014 12:03:33 +0000
Message-ID: <11463.1415275413@warthog.procyon.org.uk>
References: <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <545A51CB.6070107@tycho.nsa.gov>
Content-ID: <11462.1415275413.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> How do we know that this union_isid will bear any relation to the actual
> SID assigned to the union inode when it is created?

Note that overlayfs *will* have a union inode at this point, but will just not
use it for non-directories - so in this case we just use the first branch of
the if-statement:

	+	if (inode) {
	+		isec = inode->i_security;
	+		fsec->union_isid = isec->sid;
	+	} ...

in which case, I think that we can be fairly sure that we will have the right
label.

The other two cases are in case there isn't an inode - unionmount, for
example.  The second case is used (if I understand the flag correctly) if the
superblock imposes a single label over all its inodes - so no problem there:

	+	} else if ((sbsec->flags & SE_SBINITIALIZED) &&
	+		   (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)) {
	+		fsec->union_isid = sbsec->mntpoint_sid;
	+	} ...

The third case is the tricky one because we have to try and derive a label.
I've copied the code from the inode creation - so unless the policy changes or
the parent directory inode changes, I would've thought we'd be okay.

> If the union inode does not already exist, when/where does it get created?

For overlayfs, union inodes *have* to exist because it's a filesystem and are
created at the normal times and in the normal way.  They need to exist because
otherwise the dentry at that point in the overlay fs would be negative and the
VFS wouldn't call into the filesystem.

> Also, would be good to create a common helper for use here, by
> selinux_dentry_init_security(), selinux_inode_init_security(), and
> may_create().  Already some seeming potential for inconsistencies there.

Okay, I'll have a look at that.

> > +	return inode_has_perm(cred, file_inode(file), fsec->union_isid, &ad);
> 
> Something is seriously wrong here; you are passing fsec->union_isid
> where we expect a permissions bitmap / access vector.

Good point.  I need to call avc_has_perm() directly.  I don't necessarily have
an sclass, though, hmmm...

David
