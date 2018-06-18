Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39594 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933189AbeFRM1N (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Jun 2018 08:27:13 -0400
Date: Mon, 18 Jun 2018 07:27:09 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Do we need DCACHE_WHITEOUT_TYPE?
Message-ID: <20180618122709.2dims4vjfa26drb3@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
To: viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

There are some DCACHE_*_TYPE which are not used. I assume they were
added during the development of overlayfs/unionfs and do not seem to
make sense to keep.

Should we revert the following commits?

155e35d4daa8 ("VFS: Introduce inode-getting helpers for layered/unioned fs environments")
e7f7d2253c05 ("VFS: Add a whiteout dentry type")
df1a085af1f6 ("VFS: Add a fallthrough flag for marking virtual dentries")

Are there any more commits related or during this merge which are not
relevant anymore?

Regards,

-- 
Goldwyn
