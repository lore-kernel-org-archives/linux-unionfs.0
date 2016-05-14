From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC 5/8] xattr: Add per-inode xattr handlers as a new inode
 operation
Date: Sat, 14 May 2016 19:21:31 +0100
Message-ID: <20160514182131.GB14480@ZenIV.linux.org.uk>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
 <1462229118-13123-6-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:33048 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbcENSVl (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 14 May 2016 14:21:41 -0400
Content-Disposition: inline
In-Reply-To: <1462229118-13123-6-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>

On Tue, May 03, 2016 at 12:45:15AM +0200, Andreas Gruenbacher wrote:
> Per-inode xattr handlers allow to mark inodes as bad and dirs as "empty"
> in the usual way even when using generic_getxattr, generic_setxattr, and
> generic_removexattr.  This brings us one step closer to getting rid of
> the getxattr, setxattr, and removexattr inode operations.

This is an amazingly convoluted way of doing things.  First of all, "empty"
case is not interesting - they might as well have used generic_...xattr for
the filesystem using them.  And bad_inode... I'd rather have that checked
in generic_getxattr() et.al.  I mean, explicit
	if (unlikely(is_bad_inode(inode)))
		return -EIO;
	... go using ->i_sb->s_xattr
in there won't cost more than your variant and it avoids having a flag
misguised as a pointer to secondary method table in every inode_operations.
