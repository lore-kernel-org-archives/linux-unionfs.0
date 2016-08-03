From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] fix overlayfs deadlock in file_remove_privs()
Date: Wed, 3 Aug 2016 18:32:28 +0100
Message-ID: <20160803173227.GH2356@ZenIV.linux.org.uk>
References: <20160803163029.GD25404@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160803163029.GD25404@veci.piliscsaba.szeredi.hu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Aug 03, 2016 at 06:30:29PM +0200, Miklos Szeredi wrote:
> Hi Al,
> 
> Please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git for-viro
> 
> This fixes the deadlock introduced by making the suid removal actually work on
> overlayfs.
> 
> Responsible commit 07a2daab49c5 ("ovl: Copy up underlying inode's ->i_mode to
> overlay inode") unfortunately slipped through my testing and 4.7 was released
> with this bug.
> 
> Two more patches are cleaning away unneeded exports of related helpers.

Pulled, will push tonight.
