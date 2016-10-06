From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v6 00/16] Xattr inode operation removal
Date: Thu, 6 Oct 2016 22:34:45 +0100
Message-ID: <20161006213444.GL19539@ZenIV.linux.org.uk>
References: <1475164125-28635-1-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ecryptfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1475164125-28635-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Sep 29, 2016 at 05:48:29PM +0200, Andreas Gruenbacher wrote:
> This is version 6 of the xattr inode operation removal patch queue, rebased on
> top of the fuse/xattr branch, which is ahead of v4.8-rc8.  This queue merges
> cleanly with the current vfs for-next branch (6731cb0f).
> 
> The patches are available in git form at:
> 
>   https://git.kernel.org/cgit/linux/kernel/git/agruen/linux.git/log/?h=work.xattr
> 
> Changes since the previous posting:
> 
>  * Drop patch "fuse: Switch to generic xattr handlers" from this queue in favor
>    of "fuse: Use generic xattr ops" from fuse/xattr.

Will apply, modulo the ->set() question in #15/16.  Another odd thing is
ecryptfs - why not simply make IOP_XATTR on ecryptfs inode to match that
on the underlying one?  Could remove those
	if (!(lower_inode->i_opflags & IOP_XATTR)) {
		rc = -EOPNOTSUPP;
		goto out;
	}
things that way...  In any case, that's a followup.
