From: Greg KH <greg@kroah.com>
Subject: Re: ca4c8a3a800039 ovl: treat special files like a regular fs
Date: Fri, 27 Oct 2017 18:53:16 +0200
Message-ID: <20171027165316.GA21090@kroah.com>
References: <20171027152048.GA1246@bifrost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33965 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752138AbdJ0QxM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Oct 2017 12:53:12 -0400
Content-Disposition: inline
In-Reply-To: <20171027152048.GA1246@bifrost>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Anisse Astier <anisse@astier.eu>
Cc: stable@vger.kernel.org, Sasha Levin <alexander.levin@verizon.com>, Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org

On Fri, Oct 27, 2017 at 05:20:48PM +0200, Anisse Astier wrote:
> Hi,
> 
> Would it be possible to backport upstream commit
> ca4c8a3a800039c2681d609c5b7491c1bd17c0a7 into 4.9 ?
> 
> 	From: Miklos Szeredi <mszeredi@redhat.com>
> 	ovl: treat special files like a regular fs
> 
> 	No sense in opening special files on the underlying layers, they work just
> 	as well if opened on the overlay.
> 
> 	Side effect is that it's no longer possible to connect one side of a pipe
> 	opened on overlayfs with the other side opened on the underlying layer.
> 
> 
> Before this it's impossible to do in-kernel resolution of a device file,
> for example to mount or use dmsetup.

So, this adds a new feature, and does not fix a bug, right?  :)

> Miklos, you say this might cause a behaviour change in a very
> particular case; but did it cause an issue upstream since it was merged
> in 4.10 ?
> 
> I also wish this was fixed in 4.1, so I did a tentative backport below.
> What do you think Sasha, Miklos ?

What is preventing you from using a newer kernel like 4.13 if you rely
on this new feature?

thanks,

greg k-h
