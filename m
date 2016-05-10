From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs fixes for 4.6-rc7
Date: Tue, 10 May 2016 22:24:58 +0200
Message-ID: <20160510202458.GD10623@veci.piliscsaba.szeredi.hu>
References: <20160503200403.GB10623@veci.piliscsaba.szeredi.hu>
 <20160510152704.GK2694@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34810 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbcEJUZD (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 10 May 2016 16:25:03 -0400
Received: by mail-wm0-f67.google.com with SMTP id n129so5030007wmn.1
        for <linux-unionfs@vger.kernel.org>; Tue, 10 May 2016 13:25:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160510152704.GK2694@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Tue, May 10, 2016 at 04:27:05PM +0100, Al Viro wrote:
> 	NAK on lookup_hash().  If nothing else, you need either
> lookup_one_len_unlocked() or its "we already know hash" variant (assuming it's
> worth bothering with).  That locking the parent is potentially a lot costlier
> than recalculating the (default) hash function.  Especially in -next, where
> lookup_one_len_unlocked() will take the lock shared if it has to take it at
> all, but the mainline one also has a good chance to avoid taking the lock.

Can't use lookup_one_len_unlocked() because point of the fix is to lose the
permission check.

So how about this?

| struct dentry *lookup_hash(const struct qstr *name, struct dentry *base)
| {
| 	struct dentry *ret;
| 
| 	ret = lookup_dcache(name, base, 0);
| 	if (!ret)
| 		ret = lookup_slow(name, base, 0);
| 
| 	return ret;
| }

Updated pull request:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

---
Miklos Szeredi (3):
      vfs: rename: check backing inode being equal
      vfs: export lookup_hash() to modules
      ovl: ignore permissions on underlying lookup

---
 fs/namei.c            | 40 +++++++++++++++++++++++++++++++++++++++-
 fs/overlayfs/super.c  |  4 +---
 include/linux/namei.h |  2 ++
 3 files changed, 42 insertions(+), 4 deletions(-)
