From: Raphael Hertzog <hertzog@debian.org>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Mon, 7 Nov 2016 12:03:19 +0100
Message-ID: <20161107110319.7goz3ym3e6fu5lag@home.ouaza.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com>
 <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.vm.ouaza.com ([212.83.178.2]:58208 "EHLO mail.vm.ouaza.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751297AbcKGLDV (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Nov 2016 06:03:21 -0500
Content-Disposition: inline
In-Reply-To: <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hello,

On Sun, 06 Nov 2016, Konstantin Khlebnikov wrote:
> > - If upper is nonempty, then leave redirect feature alone except when
> > mount option "-oredirect=on" is used to force enabling it.
> > - If upper is empty, then enable redirect feature except when mount
> > option "-oredirect=off" is used to force disabling it.
> 
> I don't like this empty-nonempty upper logic.

Why? (I don't have the feeling that your subsequent paragraphs answer this
question... unless "overlayfs mounting is hard, let's complicate it even
more" is your answer)

> I think this feature should be off by default and be enabled
> explicitly in mount option.
> Available features could be listed in sysfs /sys/fs/overlay/..., like ext4 does.

TTBOMK in ext4, they are set at mkfs time and the default feature set
comes from /etc/mke2fs.conf. There's nothing like that for overlayfs.

> Overlayfs mounting anyway is complicated operation.
> User must know a lot about it and provide persistent state for each mount:
> list layers in correct order, work and uppder directory on the same disk, etc.
> Enabled features is a part of this state.

A large part of the users are not direct overlayfs users, they use
application (like schroot and live-build in my case) that rely on
overlayfs to offer some user-modifiable throw-away chroots or some
persistency on top of a read-only image. In both cases, the upper
directory start empty.

I find it highly disturbing to have to modify all those applications just
to get the correct semantics to rename a directory.

> Probably this could be solved in userspace tool "mount.overlay" - it could load
> features and layers from config file or xattr and set required mount
> options automatically.

I'm all for having a better API to mount overlayfs, but I don't think
blocking on the "redirect=on" by default is a good way to get this.

Cheers,
-- 
Raphaël Hertzog ◈ Debian Developer

Support Debian LTS: http://www.freexian.com/services/debian-lts.html
Learn to master Debian: http://debian-handbook.info/get/
