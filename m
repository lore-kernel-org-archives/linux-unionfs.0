From: Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [V9fs-developer] [RFC][PATCH] ovl: count subdirs to get the
 correct link count
Date: Mon, 12 Oct 2015 18:15:28 +0200
Message-ID: <20151012161528.GA22376@nautica>
References: <1444636874-16886-1-git-send-email-wenqing.lz@taobao.com>
 <CAJfpegsbLD+hKBRVmPVBRvMyJ-RR8nDqsd+sPrknGDc_t=DfOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from nautica.notk.org ([91.121.71.147]:60893 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbbJLQPo (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 12 Oct 2015 12:15:44 -0400
Content-Disposition: inline
In-Reply-To: <CAJfpegsbLD+hKBRVmPVBRvMyJ-RR8nDqsd+sPrknGDc_t=DfOw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, v9fs-developer@lists.sourceforge.net, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Zheng Liu <wenqing.lz@taobao.com>

Miklos Szeredi wrote on Mon, Oct 12, 2015:
> On Mon, Oct 12, 2015 at 10:01 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > This warning can be reproduced by the following steps.
> >
> > [In host os]
> > 1. build a ROOTFS for booting up a vm using 9pfs
> > 2. mount -t overlay -olowerdir=${lower},upperdir=${upper},workdir={work} none ${ROOTFS}/mnt
> > 3. run a vm using 9pfs
> >    e.g. http://www.linux-kvm.org/page/9p_virtio
> > [In guest os]
> > 4. cd /mnt
> > 5. mkdir 1
> > 6. rm -rf 1; mkdir 1
> 
> In the stack trace above I don'[t see overlayfs calls.  So apparently
> the mkdir goes directly to the 9p filesystem.  So where's overlayfs in
> all this?

It's probably as he described:
host os overlayfs mount exported by qemu as a 9P mount to a guest linux

The warning is on the client (where 9P is mounted), basically
complaining that the server, so qemu, is lying -- and it is because
overlayfs apparently does.


You won't see any new crash/warn with 9p and overlayfs mixed in because
that broke in 4.2 (4bacc9 "overlayfs: Make f_path always point to the
overlay and f_inode to the underlay"), and I never got any reply when
asking how 9P could "pick" its inode/file struct.
Maybe that's not possible and I should look for another way of fixing
this, but I haven't had much time and no-one seems to care...
Anyway, I don't mean to hijack this thread, sorry for disgressing.

-- 
Dominique Martinet
