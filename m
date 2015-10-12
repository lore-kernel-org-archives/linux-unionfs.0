From: Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [V9fs-developer] 9p/overlayfs: what inodes/dentries are safe to
 use?
Date: Mon, 12 Oct 2015 19:47:59 +0200
Message-ID: <20151012174759.GA31768@nautica>
References: <CAJfpegurhotqht8apANWM1iWOw7YWb1oAcY6Nq7nKOp80jvTaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from nautica.notk.org ([91.121.71.147]:41085 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbbJLRsQ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 12 Oct 2015 13:48:16 -0400
Content-Disposition: inline
In-Reply-To: <CAJfpegurhotqht8apANWM1iWOw7YWb1oAcY6Nq7nKOp80jvTaQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vincent Bernat <bernat@luffy.cx>, Dominique Martinet <dominique.martinet@cea.fr>, Latchesar Ionkov <lucho@ionkov.net>, Eric Van Hensbergen <ericvh@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, v9fs-developer@lists.sourceforge.net, Ron Minnich <rminnich@sandia.gov>, Al Viro <viro@zeniv.linux.org.uk>

Miklos Szeredi wrote on Mon, Oct 12, 2015:
> The solution depends on how 9p handles hard links.  If any dentry will
> do then d_find_any_alias() will get you a dentry (any dentry) from the
> inode.
> 
> Otherwise I know of no mechanism to get the backing dentry from the file.

I've got two problems at the moment:
 - first, 9P stores informations in the superblock (accessed
through either dentry->d_sb->s_fs_info or inode->i_sb->...), and
operations such as read will get passed an inode and a file (which has a
dentry), but 9P doesn't know which to trust (if I go this right - if 9P
is underlay then the inode is 9p's, if 9P is overlay then the dentry
is ?)
So we probably need a wrapper to get this right, somehow, and use it
everywhere there's a chance we get an alien inode/dentry.

 - The second problem is more inherent to the 9p protocol, that is every
access is made through a "fid" and the client navigates through the
filesystem tree one operation at a time ("walk") - walk will either
"clone" a fid or get one from its parent directory (it can do more
complex lookups but the kernel client never does)

At some point we need to open a new fid to a currently open file.
The current algorithm uses dentry->d_fsdata as a list of fids, so if we
already have a fid pointing to the dentry we can just usethat one, or if
there's nothing we'll either use the parent or start from scratch, but
the point is that once again I don't know if I can "trust"
dentry->d_fsdata to be a valid pointer or not.

Safest bet would be to remove this mechanism altogether, but that's
going to have a noticiable performance hit as we do this kind of clone
fairly often (9p needs more 'fids' than we have 'dentries' because some
operations will mutate or close them, so we clone pretty often)
Otherwise if there's some kind of flag we can check to tell if THAT
dentry is ours then we could only do this kind of lookup when that is
set, but I don't think there is?


Thanks,
-- 
Dominique Martinet
