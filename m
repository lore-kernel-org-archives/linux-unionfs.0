From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [RFC PATCH 0/4] vfs: map unique ino/dev pairs for user space
Date: Thu, 02 Aug 2018 09:24:27 +0900
Message-ID: <30133.1533169467@jrobl>
References: <20180731211045.5671-1-mfasheh@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20180731211045.5671-1-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, linux-nfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Mark Fasheh:
> The following patches fix these inconsistencies by introducing a VFS helper
> function which calls the underlying filesystem ->getattr to get our real
> inode number / device pair.  The returned values can then be used at those
> places in the kernel where we are incorrectly reporting our ino/dev pair. 
> We then update fs/proc/ and fs/locks.c to use this helper when writing to
> /proc/PID/maps and /proc/locks respectively.

I definitly agree that ino/dev pair should be a unique identity on the
system.  But I don't know why you are tryng to solve the problem in
generic VFS layer instead of the problematic FS.  Isn't it an
unnecessary overhead for many FS?
How about creating a new f_op member ->get_ino_dev(), ->show_identity()
or something, and implement the new f_op in the problematic FS only?
I hope it will be a lighter way to get the pair than generic getattr
way.


J. R. Okajima
