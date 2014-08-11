From: David Howells <dhowells@redhat.com>
Subject: Race in ovl_copy_up()?
Date: Mon, 11 Aug 2014 15:37:07 +0100
Message-ID: <24270.1407767827@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbaHKOhO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 11 Aug 2014 10:37:14 -0400
Content-ID: <24269.1407767827.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Miklos,

Looking at the following:

	int ovl_copy_up(struct dentry *dentry)
	{
		int err;

		err = 0;
		while (!err) {
			struct dentry *next;
			struct dentry *parent;
			struct path lowerpath;
			struct kstat stat;
			enum ovl_path_type type = ovl_path_type(dentry);

			if (type != OVL_PATH_LOWER)
				break;

			next = dget(dentry);
			/* find the topmost dentry not yet copied up */
			for (;;) {
				parent = dget_parent(next);

				type = ovl_path_type(parent);
				if (type != OVL_PATH_LOWER)
					break;

				dput(next);
				next = parent;
			}

			ovl_path_lower(next, &lowerpath);
			err = vfs_getattr(&lowerpath, &stat);
			if (!err)
				err = ovl_copy_up_one(parent, next, &lowerpath, &stat);

			dput(parent);
			dput(next);
		}

		return err;
	}

In the for-loop in the middle, if you ascend any levels at all, how are you
protected from racing with copy-ups taking place on those more rootwards
dentries?

I can see ovl_copy_up_one() using lock_rename() on the workdir and upperdir,
but there's no relevant lock on the overlayfs fs.  You stepped out of the lock
the VFS caller holds when you ascended.

David
