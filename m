From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 5/7] ovl: Set OVL_METACOPY flag during ovl_lookup()
Date: Fri, 6 Oct 2017 11:15:22 -0400
Message-ID: <20171006151522.GB10750@redhat.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
 <1506951605-31440-6-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxgDZST72GWN5WO7Qk_=CA0SA+jPCyWEuej3Ppug4Wnkxw@mail.gmail.com>
 <20171003152742.GF14308@redhat.com>
 <CAOQ4uxhwWhm2K0uOZ_9azddK6G3Ry0oQoTLryaUj+FQwD3os0A@mail.gmail.com>
 <20171003182026.GG14308@redhat.com>
 <CAOQ4uxi76Ob_k6bfTUOA2N5QqkF879+0yFbPh2ZR2=hEAVEF4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbdJFPPX (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 11:15:23 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi76Ob_k6bfTUOA2N5QqkF879+0yFbPh2ZR2=hEAVEF4A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 04, 2017 at 10:48:36AM +0300, Amir Goldstein wrote:

[..]
> > Ok. Before I dive into details of that patch, I have a concern about
> > creating index of all regular files and verifying them on mount time. Will
> > this lead to excessive mount time overhead for a large index. I mean
> > in container land, people do mount/unmount of container roots very
> > frequently. And paying this verification cost on every mount, can soon
> > start showing up and become a concern.
> 
> Vivek,
> 
> That is a valid concern.
> Counter proposal:
> 
> Have metacopy depend on index=on but not index every regular file.
> 
> This way you still get the assurance that you cannot set inconsistent
> origins to 2 broken hardlinks of the same origin, which would break
> future mount with index=on.
> 
> So counter to what I wrote earlier, has_upper_alias AND !index will
> be a valid state.
> If you find in lookup an upper with METACOPY and no/stale origin
> you return ESTALE.

Ok, I will post V2 patches and return -ESTALE if metacopy xattr is present
but origin could not be found/resolved during lookup.

Vivek
