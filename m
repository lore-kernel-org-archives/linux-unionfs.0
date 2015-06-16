From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Tue, 16 Jun 2015 17:49:48 +0100
Message-ID: <7332.1434473388@warthog.procyon.org.uk>
References: <557ECBC5.7000705@tycho.nsa.gov> <16216.1417109138@warthog.procyon.org.uk> <545A51CB.6070107@tycho.nsa.gov> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk> <8813.1434123054@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655AbbFPQty (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 16 Jun 2015 12:49:54 -0400
In-Reply-To: <557ECBC5.7000705@tycho.nsa.gov>
Content-ID: <7331.1434473388.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, drquigl <drquigl@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>

Stephen Smalley <sds@tycho.nsa.gov> wrote:

> It looks like commit 415103f9932d45f7927f4b17e3a9a13834cdb9a1 changed
> selinux_inode_init_security()'s handling of SECURITY_FS_USE_MNTPOINT,
> and this change was never propagated to selinux_dentry_init_security().
>  However, that commit also did not update
> security/selinux/hooks.c:may_create()'s logic for computing the new file
> label when checking CREATE permission, and therefore introduced a
> potential inconsistency between the label used for the permission check
> and the label assigned to the inode.
> 
> That's why I suggested that we need a common helper for all three to
> ensure consistency there.

I think a common helper is harder than it seems.  We need the parent dir in
one of the cases the helper has to consider, but finding it is done in three
different ways, depending on the caller:

 (1) dentry_init can just use ->d_parent as there's a lock held that prevents
     it changing (I think).  This could use (2) instead, however.

 (2) file_open has to use dget_parent().

 (3) inode_init doesn't have any dentries, but rather has the object and
     parent inodes.

If we don't mind file_open() always calling dget_parent(), then the common
helper can take the dir inode.

Also, thinking ahead to the possibility of bringing unionmount into the kernel
at some point: union non-dir dentries that are not yet copied up have no inode
attached, but rather fall through to the underlying lower inode in the VFS.
This, however, gives us nowhere to hang the inode label.  How expensive is the
security_transition_sid() call?

David
