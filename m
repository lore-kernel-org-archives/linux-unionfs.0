From: Andy Whitcroft <apw@canonical.com>
Subject: Re: How to cope with two incompatible overlayfs formats out in the
 wild
Date: Tue, 18 Nov 2014 17:07:18 +0000
Message-ID: <20141118170718.GH8154@bark>
References: <CAJfpegtG68g=dDi7j-WfhkuJidZRBg46vyuWg8CTrW3TrW_nYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42779 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaKRRGz (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 18 Nov 2014 12:06:55 -0500
Received: by mail-wg0-f46.google.com with SMTP id x12so403282wgg.5
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Nov 2014 09:06:54 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAJfpegtG68g=dDi7j-WfhkuJidZRBg46vyuWg8CTrW3TrW_nYw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Neil Brown <neilb@suse.de>, linux-unionfs@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>

On Tue, Nov 18, 2014 at 03:28:03PM +0100, Miklos Szeredi wrote:
> [CC-ing mailing lists, Al and Linus for wider exposure]
> 
> This issue is this: Ubuntu and SUSE carry an "old" format of overlayfs
> while mainline has a "new" format.  The differences are:
> 
>  - whiteouts are represented differently (symlink + xattr in the old
> format, chardev in the new)
> 
>  - new one needs a "workdir" mount option, which points to a directory
> on the same filesystem as upperdir.  If upperdir was the root of the
> filesystem then it needs to be moved into a subdir to make space for
> the work directory.
> 
> Migrating from old to new is not a big issue, but Ubuntu people have
> expressed concerns about systems with mixed kernel versions and want
> to support the old format alongside the new.
> 
> This can all be done with out-of-tree code.
> 
> So from mainline we need two things:
> 
>   - when mounting distinguish between old and new format.
> 
>   - userspace can detect which formats are supported by the kernel.
> 
> If we'd have a different filesystem type for the old and new formats,
> then that would solve both (checking /proc/filesystems would indicate
> which one is supported).
> 
> Unfortunately that would mean having to change "overlayfs" type to
> something else in 3.18.  Question is, is there some sane name which
> would fit?  "overlayfs2" is perhaps the best, but I'm not overly
> enthusiastic about it.
> 
> Any other ideas?

ext4 makes use of feature flags in /sys/fs/ext4/features.  Perhaps we could
make use of this, say /sys/fs/overlayfs/features/{workdir,whiteout-chrdev},
or a even some kind of version in /sys/fs/overlayfs/version.

The presence of /sys/fs/overlayfs itself might be enought to assume the
presence of support for the new format.

-apw
