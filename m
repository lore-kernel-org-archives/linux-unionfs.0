From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 11/11] ovl: Put barriers to order oi->__upperdentry and
 OVL_METACOPY update
Date: Fri, 20 Oct 2017 11:41:54 -0400
Message-ID: <20171020154154.GA10092@redhat.com>
References: <20171019130030.GA2090@redhat.com>
 <CAOQ4uxhFKMaDmh3H1DdXqA-WFq7_MoDEzLU0UjMCZ1sMA-yLuw@mail.gmail.com>
 <20171019145824.GB2090@redhat.com>
 <CAOQ4uxgzcO=jJ5putycLD7xPwPbk4Tr+axfFxvR_wwtAnhHBiQ@mail.gmail.com>
 <20171019152221.GC2090@redhat.com>
 <CAOQ4uxjfkTfwEi7iwca7sHfsQvWK_foinBYjP1OjVTjDeEKq+A@mail.gmail.com>
 <20171019155932.GA24029@redhat.com>
 <CAOQ4uxhLM=DYLRJMhCRvce3u=fhMtL=mE-CCu+QBazFdoKH5Yg@mail.gmail.com>
 <20171019203344.GB24029@redhat.com>
 <CAOQ4uxj1kTREkCpkO6FjaJPTG9u_m30DDGcSFzzL++bL5zwALA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751018AbdJTPlz (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 20 Oct 2017 11:41:55 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj1kTREkCpkO6FjaJPTG9u_m30DDGcSFzzL++bL5zwALA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Oct 20, 2017 at 07:09:52AM +0300, Amir Goldstein wrote:

[..]
> Hmm maybe we need to take yet a different approach.
> Store __metaupperdentry when upper is metacopy
> and store __upperdentry only after upper is blessed with data.
> 
> So only code that is aware of metacopy like setattr/getattr/permission
> will even know there is a metacopy to read/write information from
> rest of vfs cannot be exposed.
> And it's even simpler than metacopy flag w.r.t memory barriers.

Hmmm..., so basically metacopy dentry/inode will not be visible outside
overlayfs and only overlayfs knows about it. This defnitely sounds a
safer option.

So d_real(D_REAL_UPPER) will return nil for metacopy only dentry.

What about d_real(inode=X) for metacopy inode? That probably is a bug. If
we have never exposed metacopy only dentry/inode, then we should never be
called to return us dentry belonging to metacopy only inode.

One downside of this approach is that if there is any metadata operation
which happens outside overlayfs, it can't be done. For example, ideally
chattr. 

update_ovl_inode_times() may be a problem too. It will return NULL dentry
for metadata inode and atime *should* be broken. May be I can update ovl
inode ctime when metadata inode is copied up. That should make sure
that for regular files, update_ovl_inode_times() is probably not required.

But in general, not having to expose metacopy inode/dentry to vfs
directly makes me feel little better.

I will give this a try and see how does it look.

> 
> I've actually already implemented this scheme, but since then
> abandoned this method. You may be able to use some code from:
> https://github.com/amir73il/linux/commits/ovl-rocopyup-v1
> 
> Mainly ovl_dentry_ro_upper() and the code changes in util.c
> and ovl_entry.h.

Thanks. I will have a look at it.

Thanks
Vivek

> 
> >
> > I am also wondering what happens to various timestamps when data is
> > copied up later on a metadata only inode. I am guessing that I will
> > have to atleast copy mtime from lower and apply on upper.
> >
> 
> Hmm this could be tricky. I think you need to "merge" mtime with ctime/atime
> of metacopy inode. There are some relations to maintain among them,
> which may not be trivial.
> The simplest rule I think is mtime := ctime on data copy up,
> ignoring the case of lower being modified after metadata was copied.
> In most cases, mtime is about to be updated by write shortly after anyway.
> 
> Amir.
