From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 0/7] overlayfs: Delayed copy up of data
Date: Tue, 3 Oct 2017 09:26:59 -0400
Message-ID: <20171003132659.GA14308@redhat.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxgmvukQPbAWxA9Mfs_9-qBJkOV+oEwjsJBr0bARzyki9g@mail.gmail.com>
 <20171002194852.GB18630@redhat.com>
 <CAOQ4uxjQtgARYCkG=OKZCc9+PRZy_NJX6zqUoOTRecgUNOkM2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35630 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751116AbdJCN1A (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Oct 2017 09:27:00 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjQtgARYCkG=OKZCc9+PRZy_NJX6zqUoOTRecgUNOkM2g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Oct 03, 2017 at 08:36:07AM +0300, Amir Goldstein wrote:
> On Mon, Oct 2, 2017 at 10:48 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Mon, Oct 02, 2017 at 10:03:13PM +0300, Amir Goldstein wrote:
> >> On Mon, Oct 2, 2017 at 4:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > Hi,
> >> >
> >> > In one of the recent converstions, people mentioned that chown/chmod
> >> > lead to copy up files as well as data. We could optimize it so that
> >> > only metadata is copied up during chown/chmod and data is copied up when
> >> > file is opened for WRITE.
> >> >
> >> > This optimization potentially could be useful with containers and user
> >> > namespaces. In popular scenario, people end up doing chown() on whole
> >> > image directory tree based on container mappings. And this chown copies
> >> > up everything, breaking sharing of page cache between containers.
> >> >
> >> > With these patches, only metadat is copied up during chown() and if file
> >> > is opened for READ, d_real() returns lower dentry/inode. That way,
> >> > different containers can still continue to use page cache. That's the
> >> > use case I have in mind. I have not tested it though.
> >> >
> >> > So here are very crude RFC patch. I have done bare minimal testing on
> >> > these and there are many unaddressed issues I can see.
> >> >
> >> > Before I go any further, I wanted to send these out for some feedback
> >> > and see if I am moving in right direction or this appraoch is completely
> >> > broken.
> >> >
> >>
> >> I like the direction this is going :)
> >> Beyond the important use case you listed, this could be useful also for:
> >> 1. copy up of lower hardlink in ovl_nlink_start(), just to have a place holder
> >>     inode for OVL_XATTR_NLINK
> >> 2. similar case as above needed for NFS export of lower hardlink
> >> 3. possible starting point for consistent ro/rw file descriptor, see POC:
> >>     https://github.com/amir73il/linux/commits/ovl-rocopyup
> >>     your patches actually take off where my patches stop
> >>
> >> > Basically, I am relying on storing OVL_XATTR_ORIGIN in upper inode
> >> > during copy up. I use that information to get to lower inode later and
> >> > do data copy up when necessary.
> >>
> >> Your feature is relying on OVL_XATTR_ORIGIN, and so does index feature.
> >> There are several places in your patches were you wonder what happens
> >> in cases there is no index or there is an index.
> >> Why not make life simpler and make METACOPY depend on index?
> >
> > Hi Amir,
> >
> > I am not sure. Both index and METACOPY rely on OVL_XATTR_ORIGIN.
> > But conceptually metacopy does not seem to depend on index feature. We
> > could very well have index disabled while still having metacopy enabled.
> 
> *conceptually* you may be right, but as I pointed out in on some of the
> METACOPY patches, supporting metacopy=on,index=off gets you into
> an implementation corner that I think would be best to avoid.

Ok, that's fine. Right now, I don't have any requirement which says
that I need metadata copy up but index=off. So I will make it
conditional on index=on. And if somebody has such requirement later,
we can look into, how to decouple two.

> 
> We need to ask ourselves why someone would *want* to have the feature
> combination metacopy=on,index=off. It only makes sense if index=on
> brings extra constrains that metacopy=on doesn't have, but does it?
> index=on requires:
> 1. upper xattr support
> 2. lower file handle support
> 3. upper file handle support
> 4. no reuse of upperdir with new lowerdir
> 5. no reuse of workdir with new upperdir
> 
> METACOPY requires most of the above, except 3 and 5,
> but these extra constrains are so easy to meet, so compared to the
> tradeoff of simplifying the implementation corners of metacopy=on,index=off
> relying on index=on seems like a win to me.

Right. I just now fixed 1 and 2 for meta copyup. It was trivial. I did
not take care of 4 though. So index=on, will get me that as well.

> 
> I can't imagine that feature wise someone would *want* to break hardlinks
> with metacopy=on is an argument.
> 
> In theory, METACOPY could be made safe to migrate to new filesystem
> and then won't require prereq 2 and 4 above if OVL_XATTR_REDIRECT
> would be set on regular files as well and then it would make sense to decouple
> it from index=on, but I am not sure if this is a direction worth pursuing.
> 
> My plan for the future is to have a userland migration tool for layer+index that
> sets   OVL_XATTR_REDIRECT from OVL_XATTR_ORIGIN before export to
> tarball and restores uptodate  OVL_XATTR_ORIGIN from
> OVL_XATTR_REDIRECT after import layers+index from tarball.

Sounds very interesting.

> 
> >
> >> METACOPY is not backward compat, not even readonly backward compat.
> >
> > Do you mean forward compatible? IIUC, I can take existing overlay
> > directories and mount them with newer kernel with metadata copy up
> > enabled. Just that metadata copy up will apply to only copy ups which
> > happen with new kernels. Files which have already been copied up
> > with old kernels will remain unaffected. So this way it is backward
> > compatible.
> >
> > But once a metadata copy up has taken up, I can't go back to old kernel
> > and expect it to work. It will show an upper file of zero size. So this
> > looks like a forward compatibility issue. Metadata created by newer
> > version of software is not expected to be handled by older version of
> > software.
> >
> > Am I misunderstanding the issue?
> >
> 
> Not misunderstanding just mixing up the terms as they are used in file systems:
> Backward compat = new on-disk format understood by old kernels
> Forward compat = old on-disk format understood by new kernel

Ok, got it. 

> 
> >
> >> It may be easy for you to base on my index=all patches:
> >> https://github.com/amir73il/linux/commits/ovl-index-all
> >> and make the life cycle of copy up go through the following stages:
> >> - create metadata copy index
> >
> > So this is same index which you are creating for hardlink with index=on?
> > With my pathces, now when copy up happens, only metadata will be copied
> > up.
> >
> 
> Correct.
> 
> >> - copy data to index
> >
> > As of now, this will happen when file is opened for WRITE.
> >
> >> - link index to upper
> >
> > So this step happens after first one. We create index with metadata copy
> > up and then index is hard linked to upper (alias).
> >
> >>
> >> AFAICT there is never any reason to actually have an upper alias as
> >> a result of metadata copy up.
> >
> > I am not able to understand this point. So if a file foo.txt is hard
> > linked and I do a "chown vivek foo.txt", then I would like to have.
> >
> > - Index created with metadata copy up only.
> > - Create upper alias.
> >
> > Isn't it?
> >
> > IOW why not create upper alias with metadata copy up.
> >
> 
> Because chown/chmod is a property of the inode, not the directory entry,
> so if you have
> ln foo.txt bar.txt
> chown vivek foo.txt
> 
> The optimal result is that both foo.txt and bar.txt are now owned by vivek
> 
> Specifically, with index=on and hardlinks not broken on copy up
> ovl_dentry_upper(dentry) of bar.txt will return the index denrty
> with !ovl_has_upper_alias(dentry) and overlay inode as well as
> ovl_inode_real() will have the new ownership for all union aliases
> (bar.txt and foo.txt) whether they have upper alias or not.

I understand this part, that with index=on, both bar.txt and foo.txt
will show "vivek" as new owner.

What I was trying to say is that with index=off, hardlinks are broken
over copyup and metadata copyup does not make it any worse.

Anyway, now with index=on, being pre-condition, hopefully, this is
take care of.

> 
> >>
> >> >
> >> > I also store OVL_XATTR_METACOPY in upper inode to mark that only
> >> > metadata has been copied up and data copy up still might be required.
> >> >
> >>
> >> And that is not backward compat so need a new opt-in config option.
> >> I don't like it so much that we keep adding config options and complicate
> >> the compatibility matrix, that is why I prefer if we bundle several new
> >> functionalities into a single new opt-in config option if possible, but
> >> Miklos seems to feel differently about this.
> >
> > Making user opt-in for this feature is fine. It especially makes sense
> > because user can't downgrade its kernel now to older version. So those
> > who are used to downgrading (because upgraded kernel had issues), will
> > complain, saying we did not ask for this optimzation and don't break
> > our downgrade.
> >
> > So a mount option "-o metacopy=on/off" sounds reasonable?
> >
> 
> Sounds reasonable to me, but I campaign for have mount reject
> metacopy=on or fallback to metacopy=off if neither index=on or
> CONFIG_OVERLAY_FS_INDEX=y are set.

Ok, in V2, I will make metacopy conditional on index=on.

Thanks
Vivek
