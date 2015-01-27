From: Eric Jones <ejones@cray.com>
Subject: Re: overlayfs lazy unmounts?
Date: Tue, 27 Jan 2015 12:41:36 -0800
Message-ID: <20150127204136.GY32617@cray.com>
References: <20150123180309.GN32617@cray.com> <CAJfpegtAL7dGhhRW3x8kEygXAQrW-_mdzEt3NiOo6ETaXkYOCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [68.232.142.33] ([68.232.142.33]:29915 "EHLO
	esa1.cray.iphmx.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbbA0U7F (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 27 Jan 2015 15:59:05 -0500
Content-Disposition: inline
In-Reply-To: <CAJfpegtAL7dGhhRW3x8kEygXAQrW-_mdzEt3NiOo6ETaXkYOCg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

CC'ing linux-unionfs

On Mon, Jan 26, 2015 at 06:00:35PM +0100, Miklos Szeredi wrote:
> On Fri, Jan 23, 2015 at 7:03 PM, Eric Jones <ejones <at> cray.com> wrote:
> > Hi. Thanks for overlayfs.
> >
> > We're using overlayfs, and we're trying to deal with the "undefined" behavior when modifying the lower layer. The approach we are taking is to lazy unmount all overlays, modify the lower layer, and remount with the same upper/lower.
> >
> > Would you expect processes with references to the lazily unmounted overlayfs to behave? Even if the overlay is immediately recreated?
> 
> While referencing the old overlay they will behave in an undefined
> way, regardless of the recreated overlay.
> 
> Now "undefined" does not necessarily mean it will do something bad.
> Depends on what you expect it to do...
> 
> What's the use case?  Why and how are you modifying the lower layer?

Consider managing /opt on a very large diskless cluster. Lower layer is NFS. Upper layer is tmpfs. Upper has portions of /opt we want in memory for performance considerations.

Lower could be one of:
server:/var/images/opt_A
server:/var/images/opt_B
server:/var/images/opt_C
server:/var/images/opt_XXXX

Upper is tmpfs /.opt and they are overlayfs mounted on /opt.

So this would be a typical mount command:
 mount -t overlayfs -olowerdir=/var/images/opt_A,upperdir=/.opt none /opt

1. Will creating new verions of /var/images/opt_XXXX on the NFS server affect existing overlayfs mounts? The docs say modifying the lower filesystem is not allowed, but will anything "bad" happen if we are just adding a sibling directory tree that is not yet overlay mounted? 

2. We switch to a new /var/images/opt_XXXX by doing a lazy unmount of the old and mounting the new. Will processes with outstanding references see broken pwd/cwd? Corruption? 

> 
> Thanks,
> Miklos
> 
> PS. Would you mind including the unionfs mailing list
> <linux-unionfs@vger.kernel.org> in the discussion?
