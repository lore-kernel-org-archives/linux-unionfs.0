From: Anisse Astier <anisse@astier.eu>
Subject: Re: ca4c8a3a800039 ovl: treat special files like a regular fs
Date: Sat, 28 Oct 2017 14:33:24 +0200
Message-ID: <20171028123324.GA8737@bifrost>
References: <20171027152048.GA1246@bifrost>
 <20171027165316.GA21090@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:49812 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdJ1Md2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 28 Oct 2017 08:33:28 -0400
Received: by mail-wm0-f54.google.com with SMTP id b189so7582945wmd.4
        for <linux-unionfs@vger.kernel.org>; Sat, 28 Oct 2017 05:33:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171027165316.GA21090@kroah.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, Sasha Levin <alexander.levin@verizon.com>, Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org

On Fri, Oct 27, 2017 at 06:53:16PM +0200, Greg KH wrote:
> On Fri, Oct 27, 2017 at 05:20:48PM +0200, Anisse Astier wrote:
> > Hi,
> > 
> > Would it be possible to backport upstream commit
> > ca4c8a3a800039c2681d609c5b7491c1bd17c0a7 into 4.9 ?
> > 
> > 	From: Miklos Szeredi <mszeredi@redhat.com>
> > 	ovl: treat special files like a regular fs
> > 
> > 	No sense in opening special files on the underlying layers, they work just
> > 	as well if opened on the overlay.
> > 
> > 	Side effect is that it's no longer possible to connect one side of a pipe
> > 	opened on overlayfs with the other side opened on the underlying layer.
> > 
> > 
> > Before this it's impossible to do in-kernel resolution of a device file,
> > for example to mount or use dmsetup.
> 
> So, this adds a new feature, and does not fix a bug, right?  :)

That's correct. I thought earlier version behaved this way, after some
testing it seems they did not.

> 
> > Miklos, you say this might cause a behaviour change in a very
> > particular case; but did it cause an issue upstream since it was merged
> > in 4.10 ?
> > 
> > I also wish this was fixed in 4.1, so I did a tentative backport below.
> > What do you think Sasha, Miklos ?
> 
> What is preventing you from using a newer kernel like 4.13 if you rely
> on this new feature?

Nothing fancy here, that's what you get when using lots of non-upstream
code from a vendor.

Regards,

Anisse
