From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlayfs update for 4.10
Date: Sun, 11 Dec 2016 02:12:23 +0000
Message-ID: <20161211021218.GK1555@ZenIV.linux.org.uk>
References: <20161210204926.GL2622@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:49950 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbcLKCMf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Dec 2016 21:12:35 -0500
Content-Disposition: inline
In-Reply-To: <20161210204926.GL2622@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Sat, Dec 10, 2016 at 09:49:26PM +0100, Miklos Szeredi wrote:
> Hi Al,
> 
> I usually send overlayfs pulls directly to Linus, but it it suits you, please
> feel free to pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus
> 
> This update contains:
> 
>  - try to clone on copy-up;
>  - allow renaming a directory;
>  - fix data inconsistency of read-only fds after copy up;
>  - misc cleanups and fixes.

	Miklos, I'm very tempted to just let Linus do the... explaining
why "ovl: add infrastructure for intercepting file ops" is not nicely done.
It relies upon so damn many subtle things that result is a minefield for
any later work.  If nothing else, you've just created a magical place that
will have to be modified every time somebody adds a method.  Moreover, ->open()
instances have every right to expect that nothing will change ->f_op after
they return, period.  That includes things like later comparisons of ->f_op
with known pointers, etc.

Worse, there's nothing to prohibit embedding file_operations into an object
with lifetime shorter than that of a module.  Your approach will blow up on
those.  Sure, at the moment all of them live on weird filesystems that will be
(hopefully) rejected before you get to that point.  With no promise whatsoever
that this situation will persist.

overlayfs is already one hell of a special snowflake, but this is just plain
ridiculous - that sticks its fingers into so many places that making sure they
don't get squashed will be very hard.  IMO that kind of stuff is on the
"this should be handled by VFS or not at all" side of things, and I'm not
at all sure that doing that anywhere is a good idea.

PS: macros like
+#define OVL_CALL_REAL_FOP(file, call) \
+       ({ struct ovl_fops *__ofop =                                     \
+                       container_of(file->f_op, struct ovl_fops, fops); \
+          WARN_ON(__ofop->magic != OVL_FOPS_MAGIC) ? -EIO :             \
+                  __ofop->orig_fops->call;                              \
+       })

with uses along the lines of
+               return OVL_CALL_REAL_FOP(file,
+                                        fsync(file, start, end, datasync));
make some things (like, you know, "find all places where a method could
be called") harder for no good reason.

While we are at it,
+               module_put(ofop->owner);
+               fops_put(ofop->orig_fops);
is wrong - if that was the last reference to a module, your fops_put()
might very well try and access a vfree'd area...
