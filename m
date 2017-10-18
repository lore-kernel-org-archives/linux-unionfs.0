From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 04/11] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Wed, 18 Oct 2017 10:26:09 -0400
Message-ID: <20171018142609.GH3445@redhat.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
 <1508274358-17456-5-git-send-email-vgoyal@redhat.com>
 <CAOQ4uximnQT43BK3Ut82Vs0FMDi03cxAkyDK4LthkMiXHii-HQ@mail.gmail.com>
 <20171018130343.GC3445@redhat.com>
 <CAOQ4uxiLk-psMLGdBFNBBQf3cnHm0Z7yHL3ZoaN+oCVZn_wqWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39558 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752252AbdJRO0K (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 10:26:10 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiLk-psMLGdBFNBBQf3cnHm0Z7yHL3ZoaN+oCVZn_wqWg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 05:09:08PM +0300, Amir Goldstein wrote:
> On Wed, Oct 18, 2017 at 4:03 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Oct 18, 2017 at 07:31:51AM +0300, Amir Goldstein wrote:
> >> On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > By default metadata only copy up is disabled. Provide a mount option so
> >> > that users can choose one way or other.
> >> >
> >> > Also provide a kernel config and module option to enable/disable
> >> > metacopy feature.
> >> >
> >> > Like index feature, when overlay is mounted, on root upper directory we
> >> > set ORIGIN which points to lower. And at later mount time it is verified
> >> > again. This hopes to get the configuration right. But this does only so
> >> > much as we don't verify all the lowers. So it is possible that a lower is
> >> > missing and later data copy up fails.
> >>
> >> Like index feature, please error mount if ovl_inuse_trylock fails.
> >> As you know, this error is only conditional because of backward
> >> compatibility, so any new opt-in feature should enforce it.
> >
> > Hi Amir,
> >
> > I am not so sure about it. Avoiding leaking any mount point is really
> > really hard. And I don't think current container runtime have been
> > modified to make it fool proof.
> >
> > IMHO, if we really want to enforce something like this, then we need
> > to have some sort of capability to find existing superblock and reuse it.
> > (Something like what happens with block devices).
> >
> 
> That sounds like a good idea. Any chance you can make it happen?
> Keep in mind that would be a change of behavior, so users will have to
> opt-in for it as well.

I will look into it. I have no idea if it is doable and what is needed
at this point of time.

> 
> > I am afraid that if I start enforcing this, then this feature will not
> > be used at all because software has not been hardended enough to avoid
> > mount point leaks completely.
> >
> 
> I find that approach a bit dodgy.

It is. But at the same time I am having hard time understanding what's
wrong with having mount point in two separate mount namespaces. And
why overlay is putting this additional restriction. 

How can one realiably avoid mount point leaks. For example, say a dameon
foo is running in init mount namespace and mounts an overlay mount. Now
systemd starts another service bar and say that service starts with
MountFlags=private. Now overlay mount point will leak. Now daemon foo 
stop (it will unmount overlay), and restarts, it will fail to restart
because it can't mount that overlay anymore (upper/work are busy in 
mount namespace of bar).

I mean what's wrong with above programming model and how would programmers
avoid mount point leaks in other mount namespaces. 

Vivek


> If not for enjoying new overlayfs feature, why would container runtime
> developers ever bother to fix mount leaks.
> 
> Anyway, that is up to Miklos to decide.
> 
> Amir.
