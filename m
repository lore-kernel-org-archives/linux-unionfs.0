Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbeJZXGJ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 26 Oct 2018 19:06:09 -0400
Date: Fri, 26 Oct 2018 10:28:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] overlayfs: Return error if metadata only copy-up can't
 be enabled
Message-ID: <20181026142846.GD17321@redhat.com>
References: <20181026134333.GB17321@redhat.com>
 <CAJfpegu+0iX3BcEXAPQVRpcAWOgyROOT9+Ng92rTp_=1gCBgtg@mail.gmail.com>
 <20181026141640.GC17321@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026141640.GC17321@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Daniel J Walsh <dwalsh@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Oct 26, 2018 at 10:16:40AM -0400, Vivek Goyal wrote:
> On Fri, Oct 26, 2018 at 04:10:27PM +0200, Miklos Szeredi wrote:
> > On Fri, Oct 26, 2018 at 3:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > Assume a user wanted to enable metadata only copy-up and passes metacopy=on.
> > > If this feature can't be enabled, we disable metacopy=off and just leave
> > > a warning in logs. metacopy=on requires redirect_dir=on (for upper dir)
> > > or redirect_dir=follow (for non-upper mount).
> > 
> > What's the reason we can't enable these for metacopy=on automatically?
> > 
> > I mean, the simplest and least surprising behavior would be if
> > metacopy would simply imply redirect_dir, no?
> 
> redirect_dir=on is a significant change. And it might be better if
> users passes it in (instead of enabling it automatically).
> 
> For example, when redirect_dir is enabled, container runtime software
> (docker, podman), their logic to generate image does not work and
> they have to fall back to *slower* method of diff.
> 
> https://github.com/moby/moby/pull/34342

Having said that, metacopy=on will have same issue and user need to
fall back to slower naivediff interface for image generation.

So enabling redirect_dir automatically probably is good. We could
just drop a message in logs that it has been enabled automatically.

IOW, I can go either way depending on how others feel about it.

Thanks
Vivek
