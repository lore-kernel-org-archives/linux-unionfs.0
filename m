From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/2] Fix hardlinks in overlay
Date: Mon, 7 Mar 2016 11:49:31 +0100
Message-ID: <CAJfpegun7NuWdiWP3=W1OL9+qqX8Fj1b58KbMg6cJJVgRb554Q@mail.gmail.com>
References: <1444419297-16232-1-git-send-email-lk4d4@docker.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34209 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbcCGKtc (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 7 Mar 2016 05:49:32 -0500
Received: by mail-oi0-f68.google.com with SMTP id m82so6520666oif.1
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Mar 2016 02:49:32 -0800 (PST)
In-Reply-To: <1444419297-16232-1-git-send-email-lk4d4@docker.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alexander Morozov <alexandr.morozov@docker.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexander Morozov <lk4d4@docker.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Oct 9, 2015 at 9:34 PM, Alexander Morozov
<alexandr.morozov@docker.com> wrote:
> There were reports that overlay doesn't work very well with unix-sockets.
> In particular you can't access unix-socket through hardlink on overlay fs.
> Problem is that overlay creates different inodes for hardlinks and code in
> net/unix/af_unix.c relies on inodes for unix-socket lookup. I think this
> affects any code which relies on inodes from kern_path. There is helper
> d_backing_inode, which I think supposed to get inodes from underlying fs
> (for example ext4), but in current implementation it does nothing.  These
> patches made on top of v4.3-rc4 of main linux tree (master is broken for my
> ubuntu VM), but I tested that they applying on master and there was no
> changes to overlay since v4.3-rc4.
>
> Alexander Morozov (2):
>   fs/overlay: move update and instantiate dentry code to function
>   fs/overlay: use same inodes for hardlinks

Problem is with lookup: how do we go from backing dentry to overlayfs
dentry so the inode can be shared?

Thanks,
Miklos
