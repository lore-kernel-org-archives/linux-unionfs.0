From: Miklos Szeredi <miklos@szeredi.hu>
Subject: How to cope with two incompatible overlayfs formats out in the wild
Date: Tue, 18 Nov 2014 15:28:03 +0100
Message-ID: <CAJfpegtG68g=dDi7j-WfhkuJidZRBg46vyuWg8CTrW3TrW_nYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Neil Brown <neilb@suse.de>, linux-unionfs@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

[CC-ing mailing lists, Al and Linus for wider exposure]

This issue is this: Ubuntu and SUSE carry an "old" format of overlayfs
while mainline has a "new" format.  The differences are:

 - whiteouts are represented differently (symlink + xattr in the old
format, chardev in the new)

 - new one needs a "workdir" mount option, which points to a directory
on the same filesystem as upperdir.  If upperdir was the root of the
filesystem then it needs to be moved into a subdir to make space for
the work directory.

Migrating from old to new is not a big issue, but Ubuntu people have
expressed concerns about systems with mixed kernel versions and want
to support the old format alongside the new.

This can all be done with out-of-tree code.

So from mainline we need two things:

  - when mounting distinguish between old and new format.

  - userspace can detect which formats are supported by the kernel.

If we'd have a different filesystem type for the old and new formats,
then that would solve both (checking /proc/filesystems would indicate
which one is supported).

Unfortunately that would mean having to change "overlayfs" type to
something else in 3.18.  Question is, is there some sane name which
would fit?  "overlayfs2" is perhaps the best, but I'm not overly
enthusiastic about it.

Any other ideas?

Thanks,
Miklos
