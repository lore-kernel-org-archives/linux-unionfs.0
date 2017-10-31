From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 00/13][V5] overlayfs: Delayed copy up of data
Date: Tue, 31 Oct 2017 09:39:55 -0400
Message-ID: <20171031133955.GA30720@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxhDkDHAFxhs6mu6HQ+Z1+y8ykvcw5vbXO3H79kGJ6zAaA@mail.gmail.com>
 <20171027164032.GB5442@redhat.com>
 <CAOQ4uxhOLm+Jx3LoEeeXKMEK+i3yiok1+Ad93W2fRfThgJ=nDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752216AbdJaNj4 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Oct 2017 09:39:56 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhOLm+Jx3LoEeeXKMEK+i3yiok1+Ad93W2fRfThgJ=nDA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Sat, Oct 28, 2017 at 05:50:19PM +0300, Amir Goldstein wrote:
> On Fri, Oct 27, 2017 at 7:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Oct 26, 2017 at 10:18:19AM +0300, Amir Goldstein wrote:
> >> On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > Hi,
> >> >
> >> > Here is the V5 of patches. Following are changes from V4.
> >>
> >> Please use git format-patch -v6 next time you post.
> >> It tags all the patch subjects so it is easier to find the former
> >> revision of specific patch.
> >
> > Will do.
> >
> >>
> >> >
> >> > - Flipped the meaning of bit. Now OVL_METACOPY is called OVL_UPPERDATA and
> >> >   dropped a barrier patch which implemented ordering requirements between
> >> >   oi->flags and oi->__upperdentry.
> >> >
> >> > - Now ovl_d_real() does return upper dentry if upper dentry is metacopy only
> >> >   dentry.
> >>
> >> doesn't return upper dentry
> >>
> >> But I am still not convinced that metacopy upper inode is not accessed in places
> >> it shouldn't be accessed by vfs, via other APIs.
> >>
> >> For example, ovl_permission(), ovl_getattr(), ovl_setattr(), ovl_listxattr(),
> >> ovl_get_acl() will all access metacopy inode and that outcome will be desired.
> >> But you did not provide a complete list of vfs APIs and verify for each
> >> that accessing the metacopy upper via various variants of ovl_dentry_real()
> >> is either not possible (because access requires a rw fd) or is the
> >> desired outcome.
> >
> > Thanks for asking this. I have been looking at code and trying to figure
> > out if there is anything which is broken. But this also requires the
> > eyeballs from all the experienced filesystem folks. I have tried
> > going through all overlayfs interfaces and listing my thoughts below.
> > AFAICS, nothing seems to be broken.
> 
> That's a very good start.
> Now I wonder if the metacopy feature can break userspace apps that relied on
> metadata operations doing copy up to avoid the RDONLY/RDWR fd inconsistency,
> even if they escaped the inconsistency by accident so far.

There is a small possibility that somebody was relying on this. But we
are keeping metacopy=off by default. So this should not be a backward
compatibility issue. Those who chose to enable it, they can't rely on
file being copied up on changing file attr. 

> I guess there is only one one to know...

Not sure what does this mean.

> 
> >
> > - I am assuming that ovl_dir_operations{} are not impacted by this at
> >   all. Metadata copy up affects only regular files and does not touch any
> >   of directory operations.
> >
> > Operations internal to overlayfs
> > ================================
> > 1. ovl_setattr()
> >
> >    Will do metadata copy up and work on upper inode.
> >
> > 2. inode_permission()
> >
> >    Will do permission checks on upper metacopy inode. Which seems to be
> >    right thing.
> >
> > 3. ovl_getattr()
> >
> >    Will do getattr on metacopy inode and will query lower for number of
> >    blocks. Seems ok.
> 
> Hmm it seems ok for stat(2), not sure about statx().
> If upper metacopy is not encrypted (it has no data) and lower
> is encrypted, not sure what should be the result of querying
> the STATX_ATTR_ENCRYPTED attribute.

That's a good point. I think we have similar issue for directories as
well. In case of merged dir, statx() will return STATX_ATTR_ENCRYPTED
attribute from top of dir stack. So if lower dir is encrypted while
upper is not, STATX_ATTR_ENCRYPTED will not be reported.

Having said that, I feel it makes sense to report STATX_ATTR_ENCRYPTED
for metadata only files (if these files are encrypted on lower). So
while file metadata is not encrypted in this case, but file data is
encrypted. We are anyway querying lower for number of blocks. We could
just query STATX_ATTR_ENCRYPTED as well and report it to user.

> But that is just an example showing how fragile this can, when
> 'metadata' is not a well defined term.
> 
> Not saying that this is a show stopper, but something to consider.
> 
> >
> > 4. vfs_listxattr()
> >
> >    Will retrieve xattr list from upper metacopy inode. Seems right.
> >
> > 5. ovl_get_acl()
> >
> >    Will retrieve acl from upper metacopy inode. Seems right.
> >
> 
> You missed ovl_posix_acl_xattr_set/get().
> They are hiding well ;-)
> But they seem right anyway.

Right. I missed these. Thanks for pointing out. Yes, these should be fine
too.

Thanks
Vivek
