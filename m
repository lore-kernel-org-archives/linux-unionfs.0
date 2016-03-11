From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4_file_open: Inconsistent encryption contexts (commit
 ff978b09f973) breaking Docker
Date: Thu, 10 Mar 2016 21:15:06 -0500
Message-ID: <20160311021506.GA32214@thunk.org>
References: <87io0t3ks9.fsf@gamma.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58728 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933259AbcCKCPL (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 10 Mar 2016 21:15:11 -0500
Content-Disposition: inline
In-Reply-To: <87io0t3ks9.fsf@gamma.ozlabs.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Daniel Axtens <dja@axtens.net>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk, miklos@szeredi.hu, linux-unionfs@vger.kernel.org

On Fri, Mar 11, 2016 at 11:44:54AM +1100, Daniel Axtens wrote:
> Hi,
> 
> Trying to run a Docker container on a mainline kernel is failing
> intermittently, in interesting and exciting ways, such as:
> 
> $ docker run -it --rm --env PACKAGE=sinatra npmtest
> operation not permitted
> docker: Error response from daemon: Cannot start container 4fc0120a6389f25241f84527a0d31854806f6fe4fd98d019f790cea0ae7e230b: [10] System error: operation not permitted.
> 
> EXT4-fs warning (device sda2): ext4_file_open:402: Inconsistent encryption contexts: 27842/3691208

This could only happen if the EXT4_ENCRYPT_FL flag is set.  (I assume
you weren't actually trying to use ext4 encryption.)  The flag can't
be set using the FS_IOC_SETFLAGS ioctl.  It can only be set using
EXT4_IOC_SET_ENCRYPTION_POLICY.

The only thing I can think of is that overlayfs is somehow setting or
otherwise corrupting the i_flags.

So if you could try changing the relevant code in ext4_file_open() to
look like this:

	if (ext4_encrypted_inode(dir) &&
	    !ext4_is_child_context_consistent_with_parent(dir, inode)) {
		char tmpbuf[128];

		ext4_warning(inode->i_sb,
			     "Inconsistent encryption contexts: %lu/%lu\n",
			     (unsigned long) dir->i_ino,
			     (unsigned long) inode->i_ino);
		cp = d_path(&filp->f_path, tmpbuf, sizeof(tmpbuf));
		if (!IS_ERR(cp))
			pr_err("pathname: %s\n", cp);
		pr_err("inode flags: %lu\n", EXT4_I(inode)->i_flags);
		WARN_ON(1);
		return -EPERM;
	}

This should give you the stack trace as well as the pathname and inode
flag information.  This will hopefully give us a bit more context
about how this is happening.

						- Ted
