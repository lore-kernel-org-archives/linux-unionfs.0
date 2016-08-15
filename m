From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] overlayfs: Make dir inode always point to the underlay
Date: Mon, 15 Aug 2016 11:08:15 +0200
Message-ID: <20160815090815.GH25404@veci.piliscsaba.szeredi.hu>
References: <4b4580e4-8bec-bfba-cd94-1d531a2f06cc@yunify.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35947 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbcHOJIU (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 15 Aug 2016 05:08:20 -0400
Received: by mail-wm0-f68.google.com with SMTP id i138so9985801wmf.3
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Aug 2016 02:08:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4b4580e4-8bec-bfba-cd94-1d531a2f06cc@yunify.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: oc <oc@yunify.com>
Cc: linux-unionfs@vger.kernel.org, dhowells@redhat.com, trivial@kernel.org, vito.caputo@coreos.com

[This is *far* from being a trivial patch,  please don't treat it as such]

On Fri, Aug 12, 2016 at 03:34:51PM +0800, oc wrote:
> Since file inode points to the underlay from ovl_path_real method, the dir
> inode should also point to the one from underlay. This issue introduced
> problem when live migrates a container instance using criu, which need to
> convert inotify inode entry to file path, because inotify point to the real
> inode in underlay.

Not quite sure what the problem is here.  It is true that inotify is currently
broken.  There's a fix pending for that here:

  https://git.kernel.org/cgit/linux/kernel/git/mszeredi/vfs.git/commit/?h=overlayfs-next&id=09557932babf3462125749212bc1cde574404fbb

There's also an issue with inode numbers being unstable for directories:

  http://marc.info/?t=146914417200002&r=1&w=2

As explained in that thread the problem with always using the underlying
inode/dev is that it makes the inode number change when the directory is copied
up.

So there are multiple, somewhat conflicting requirements here and it would be
good to have a solution that everyone is happy with and is unlikely to break
existing setups.

Does the last patch in the above thread work for you?

And what about if you additionally do

-stat->dev = lowerstat.dev;
+stat->dev = dentry->d_sb->s_dev;

?

Vito, could you also please supply feedback on those patches?

Thanks,
Miklos
