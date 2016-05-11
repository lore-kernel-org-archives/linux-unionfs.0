From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlayfs fixes for 4.6-rc7
Date: Wed, 11 May 2016 05:07:51 +0100
Message-ID: <20160511040751.GO2694@ZenIV.linux.org.uk>
References: <20160503200403.GB10623@veci.piliscsaba.szeredi.hu>
 <20160510152704.GK2694@ZenIV.linux.org.uk>
 <20160510202458.GD10623@veci.piliscsaba.szeredi.hu>
 <20160510232342.GE10623@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:59588 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbcEKEHx (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 11 May 2016 00:07:53 -0400
Content-Disposition: inline
In-Reply-To: <20160510232342.GE10623@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Wed, May 11, 2016 at 01:23:42AM +0200, Miklos Szeredi wrote:
> Hi Al,
> 
> Hopefully this addresses your concerns.  I couldn't find a better name for
> lookup_hash(), after all it's just that.
> 
> Please pull:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus
> 
> ---
> Miklos Szeredi (4):
>       vfs: add vfs_select_inode() helper

B0rken - for one thing, you've lost file->f_path = *path in vfs_open(), for
another this thing belongs in dcache.h as static inline.  Fixed, pushed
as vfs.git#ovl-fixes, merged into #for-linus.

If you have any objections against the current state of that branch, please
yell.
