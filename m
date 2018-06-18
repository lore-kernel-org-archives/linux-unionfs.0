Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754714AbeFRP3v (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Jun 2018 11:29:51 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20180618122709.2dims4vjfa26drb3@merlin>
References: <20180618122709.2dims4vjfa26drb3@merlin>
Subject: Re: Do we need DCACHE_WHITEOUT_TYPE?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19225.1529335789.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Jun 2018 16:29:49 +0100
Message-ID: <19226.1529335789@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

> There are some DCACHE_*_TYPE which are not used. I assume they were
> added during the development of overlayfs/unionfs and do not seem to
> make sense to keep.

Yes, Al started passing the patches for unionmounts upstream, then Linus went
and plonked overlayfs in there which broke unionmounts in a number of ways, so
these can be cleaned up.

(Though I suggest that overlayfs should probably set the DCACHE_WHITEOUT_TYPE
on whiteouts).

> Should we revert the following commits?
> 
> 155e35d4daa8 ("VFS: Introduce inode-getting helpers for layered/unioned fs environments")
> e7f7d2253c05 ("VFS: Add a whiteout dentry type")
> df1a085af1f6 ("VFS: Add a fallthrough flag for marking virtual dentries")

The last one can definitely be reverted.  The second one possibly, though
overlayfs should possibly be using it.  The first one, I'm not sure - parts of
that overlayfs might be using.

> Are there any more commits related or during this merge which are not
> relevant anymore?

Possibly; I'll try and find some time to go through them.

David
