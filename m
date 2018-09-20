Return-Path: <linux@rasmusvillemoes.dk>
Return-Path: <linux@rasmusvillemoes.dk>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: revealing file from lower fs ('reverting changes')
Message-ID: <7da0ae14-8eda-1d53-ec45-38c457c35117@rasmusvillemoes.dk>
Date: Thu, 20 Sep 2018 11:17:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

I'm wondering if there is a way to remove a file from the upper
directory without leaving a whiteout behind, but instead let the file
(if any, of course) in the lower file system become visible? Obviously
this can be done by unmounting the overlay, removing the file (or
whiteout) from the upper dir, then mounting again, but I'd like to be
able to do this to a live system. Essentially, having a way to revert
changes done to an existing file.

I briefly looked into dir.c, and it seems that ovl_remove_upper would
actually do the right thing, but there doesn't seem to be any way to get
there via normal VFS operations. RENAME_WHITEOUT is the exact opposite,
and even if there was a RENAME_NOWHITEOUT, that would have a lot of
problems (probably wouldn't work if the file is a whiteout (src dentry
lookup would fail), requires coming up with a tmp name to rename to and
then unlink that as a second step, semantics if the file only exists in
the lower layer). Maybe an AT_REMOVEUPPER flag for unlinkat could be
implemented (which would fail with ENOENT unless the file is in the
upper part of an overlay file system)? Or, as an overlayfs specific
ioctl on the containing directory?

Thanks,
Rasmus
