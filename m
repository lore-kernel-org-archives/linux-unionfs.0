From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v7 09/14] ovl: A new xattr OVL_XATTR_METACOPY for file on
 upper
Date: Mon, 20 Nov 2017 09:34:55 -0500
Message-ID: <20171120143455.GA16840@redhat.com>
References: <20171116220335.13448-1-vgoyal@redhat.com>
 <20171116220335.13448-10-vgoyal@redhat.com>
 <CAOQ4uxgb0mC2qEAL0AbC7qY-Hv+PcoHMXhfadqojhA=iPHuh1Q@mail.gmail.com>
 <20171117203443.GE15566@redhat.com>
 <CAOQ4uxiTOU7RcXdBmewcUe8_Yh-N6+heJKNn2CMo0zuw4YLBRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55812 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751155AbdKTOez (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Nov 2017 09:34:55 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiTOU7RcXdBmewcUe8_Yh-N6+heJKNn2CMo0zuw4YLBRg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Sat, Nov 18, 2017 at 09:06:41AM +0200, Amir Goldstein wrote:

[..]
> >> > Note, we now set OVL_UPPERDATA on all kind of dentires and check
> >> > OVL_UPPERDATA only where it makes sense. If a file is created on upper,
> >> > we set OVL_UPPERDATA. This can be accessed lockless in ovl_d_real()
> >> > path again. This time ordering dependency is w.r.t oe->__upperdata. We
> >> > need to make surr OVL_UPPERDATA is visible before oe->__upperdata is
> >> > visible. Otherwise following code path might try to copy up an upper
> >> > only file.
> >>
> >> Why all this explanations?
> >> Just use ovl_set_upperdata() when creating upper and be done with it.
> >
> > Just using ovl_set_upperdata() will not do away with ordering dependency
> > right? I mean, setting OVL_UPPERDATA in file creation path has different
> > ordering requirement (same is the case of >has_upper). And I wanted to
> > highlight that ordering requirement in changelogs.
> >
> > I can get rid of it. But this seems such a subtle requirement, I think
> > its a good idea to talk about it explicitly.
> >
> 
> I am not following. you only need to ovl_set_upperdata() before
> ovl_inode_update(), just like in regular copy up. Am I missing something
> subtle?

Hi Amir,

Right. This is ordering dependency between setting of OVL_UPPERDATA and
oi->__upperdentry.

So as per barrier documentation file, read/write barrier should look
as follows.

	CPU1				CPU2
     set OVL_UPPERDATA			smp_rmb()
     smp_wmb()				Load oi->__upperdentry
     set oi->__upperdentry

So we need to place smp_wmb() after setting OVL_UPPERDATA and place
smp_rmb() just before load of oi->__upperdentry.

Instead of smp_rmb() we are relying on checking for ovl_dentry_lower().
That is even if OVL_UPPERDATA is not visible on CPU2, but
oi->__upperdentry is visible, then we don't try to copy up a file which
does not have a lower.

So ovl_dentry_lower() is preventing the race which *in-theory* can trigger
trying to copy up file which does not have lower. 

Does this make sense?


[..]
> >> > +static inline bool open_for_write(int flags)
> >>
> >> Need ovl_ namespace prefix
> >> and the name sounds like an action (i.e. a request to open for write)
> >
> > ovl_opened_for_write_or_trunc()?
> 
> OK. maybe ovl_open_flags_need_copy_up() ?

Ok, will use ovl_open_flags_need_copy_up().

Vivek
