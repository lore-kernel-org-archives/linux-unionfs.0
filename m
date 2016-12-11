From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] readlink cleanup
Date: Sun, 11 Dec 2016 02:36:27 +0000
Message-ID: <20161211023620.GL1555@ZenIV.linux.org.uk>
References: <20161210204145.GK2622@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:50262 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753033AbcLKCgm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Dec 2016 21:36:42 -0500
Content-Disposition: inline
In-Reply-To: <20161210204145.GK2622@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Sat, Dec 10, 2016 at 09:41:45PM +0100, Miklos Szeredi wrote:
> Hi Al,
> 
> Please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git readlink
> 
> This is a rework of the readlink cleanup patchset.  Now readlink(2) does the
> following:
> 
>  - if i_op->readlink() is non-NULL (only proc and afs mountpoints for now) then
>    it calls that;
>  - otherwise call i_op->get_link();
>  - signature of ->readlink() now matches that of ->get_link();
> 
> This is against the #misc branch (the stats look better that way ;)

I'm still not sure what does "vfs: convert ->readlink to same signature as
->get_link" buy us.  If anything, the result appears to be more complex -
you make freeing that buffer delayed (and introduce a dynamically allocated
buffer in one case that didn't use it)...
