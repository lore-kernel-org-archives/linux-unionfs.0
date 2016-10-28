From: Raphael Hertzog <hertzog@debian.org>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Fri, 28 Oct 2016 14:56:20 +0200
Message-ID: <20161028125620.uusbhlcwncmicvab@home.ouaza.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com>
 <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.vm.ouaza.com ([212.83.178.2]:33946 "EHLO mail.vm.ouaza.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754617AbcJ1M4Y (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Oct 2016 08:56:24 -0400
Content-Disposition: inline
In-Reply-To: <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

On Wed, 26 Oct 2016, Miklos Szeredi wrote:
> On Tue, Oct 25, 2016 at 1:57 PM, Raphael Hertzog <hertzog@debian.org> wrote:

[ redirect feature enabled by default ]

> I think it would be safe to make it the default if upperdir is empty.
> Nonempty implies that it was created with old kernel (or it was
> crafted by hand).   But there should be a way to explicitly turn it
> off;  either because of the need for backward compatibility or because
> the old format is simply easier to work with for humans.
> 
> How about:
> 
> - If upper is nonempty, then leave redirect feature alone except when
> mount option "-oredirect=on" is used to force enabling it.
> - If upper is empty, then enable redirect feature except when mount
> option "-oredirect=off" is used to force disabling it.

Looks good, but is there some stickyness of the setting? My use case is
schroot and it always starts with an empty upperdir when I create a
temporary/throw-away chroot but if I reboot the machine, then it's possible
that schroot will remount the overlayfs with a non-empty upperdir
(the temporary chroot is preserved until I explicitly end the chroot).

Cheers,
-- 
Raphaël Hertzog ◈ Debian Developer

Support Debian LTS: http://www.freexian.com/services/debian-lts.html
Learn to master Debian: http://debian-handbook.info/get/
