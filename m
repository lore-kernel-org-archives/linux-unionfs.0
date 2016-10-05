From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlayfs update for 4.9
Date: Thu, 6 Oct 2016 00:49:28 +0100
Message-ID: <20161005234928.GJ19539@ZenIV.linux.org.uk>
References: <20161005195210.GC31239@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:45256 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932190AbcJEXtb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Oct 2016 19:49:31 -0400
Content-Disposition: inline
In-Reply-To: <20161005195210.GC31239@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Wed, Oct 05, 2016 at 09:52:10PM +0200, Miklos Szeredi wrote:
> Hi Al,
> 
> Please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-viro
> 
> This has an assortment of fixes and cleanups for overlayfs.
> 
> It also touches the VFS:
> 
>  - add the vfs_get_link() helper for calling i_op->get_link();
>  - fix mnt_want_write_file() to freeze protect the underlying sb instead of
>    overlay sb;
>  - allow vfs_clone_file_range() to be called by overlayfs.

Could you explain why e.g. fsetxattr() needs a different treatment in
"vfs: mnt_want_write_file() should freeze protect underlying sb"?
