From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 11/11] ovl: Put barriers to order oi->__upperdentry and
 OVL_METACOPY update
Date: Thu, 19 Oct 2017 16:33:44 -0400
Message-ID: <20171019203344.GB24029@redhat.com>
References: <1508274358-17456-12-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxg6Y7LU_JffejeteT11PT5rqGhUASNgk-hTdngGOqmAjg@mail.gmail.com>
 <20171019130030.GA2090@redhat.com>
 <CAOQ4uxhFKMaDmh3H1DdXqA-WFq7_MoDEzLU0UjMCZ1sMA-yLuw@mail.gmail.com>
 <20171019145824.GB2090@redhat.com>
 <CAOQ4uxgzcO=jJ5putycLD7xPwPbk4Tr+axfFxvR_wwtAnhHBiQ@mail.gmail.com>
 <20171019152221.GC2090@redhat.com>
 <CAOQ4uxjfkTfwEi7iwca7sHfsQvWK_foinBYjP1OjVTjDeEKq+A@mail.gmail.com>
 <20171019155932.GA24029@redhat.com>
 <CAOQ4uxhLM=DYLRJMhCRvce3u=fhMtL=mE-CCu+QBazFdoKH5Yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752345AbdJSUdp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 19 Oct 2017 16:33:45 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhLM=DYLRJMhCRvce3u=fhMtL=mE-CCu+QBazFdoKH5Yg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 19, 2017 at 07:33:37PM +0300, Amir Goldstein wrote:
> On Thu, Oct 19, 2017 at 6:59 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Oct 19, 2017 at 06:39:57PM +0300, Amir Goldstein wrote:
> >> On Thu, Oct 19, 2017 at 6:22 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Thu, Oct 19, 2017 at 06:08:32PM +0300, Amir Goldstein wrote:
> >> >> On Thu, Oct 19, 2017 at 5:58 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> >> > On Thu, Oct 19, 2017 at 04:21:46PM +0300, Amir Goldstein wrote:
> >> >> ...
> >> >> >>
> >> >> >> Process 2 will get lower dentry on open for read at 8AM
> >> >> >> Process 1 will copy up file at 9AM (on CPU1)
> >> >> >> Process 2 will open same file for read at 9AM (on CPU2)
> >> >> >> Does it matter if process 2 gets lower or upper dentry? No.
> >> >> >> It only matter that IF process 2 gets an upper dentry, that
> >> >> >> this dentry is consistent, so it only matters that IF __upperdentry
> >> >> >> is visible to CPU2 AND OVL_UPPER_DATA flag is visible to
> >> >> >> CPU2 then dentry and its inode are consistent.
> >> >> >
> >> >> > That's a good point. So if OVL_UPPER_DATA update is not visible on CPU2
> >> >> > yet, then CPU1 will use lower dentry. And this is equivalent to as if file
> >> >> > copy up has not taken place yet.
> >> >> >
> >> >> > And if CPU1 needed to do use upper dentry only, then it will do flags=WRITE
> >> >> > and that will take oi->lock and make sure OVL_UPPER_DATA is set.
> >> >> >
> >> >> > So only *additional* smp_rmb()/smp_wmb() we require for the case when
> >> >> > data is copied up later and we need to make sure OVL_UPPER_DATA is
> >> >> > visible only after the full data copy up is done and stable.
> >> >> >
> >> >> >
> >> >>
> >> >> Right. forgot about that wmb.
> >> >>
> >> >> >>
> >> >> >> So IMO you may only need to add smp_rmb() before
> >> >> >> ovl_test_flag(OVL_UPPER_DATA in ovl_d_real() and the smp_wmb()
> >> >> >> in ovl_inode_update() should be sufficient.
> >> >> >> Change the comment in ovl_inode_update() to mention that wmb also
> >> >> >> matches rmb in ovl_d_real() w.r.t OVL_UPPER_DATA flag.
> >> >> >
> >> >> > Hmm..., I agree that we require smp_rmb() here but it will pair with
> >> >> > smp_wmb() in ovl_copy_meta_data_inode() and not the one in
> >> >> > ovl_inode_update(), right? Something like.
> >> >>
> >> >> Right. my bad.
> >> >>
> >> >> >
> >> >> > ovl_d_real() {
> >> >> >         bool has_upper_data;
> >> >> >
> >> >> >         has_upper_data = ovl_test_flag(OVL_UPPER_DATA, d_inode(dentry));
> >> >> >         /* Pairs with smp_wmb() in ovl_copy_up_meta_inode_data() */
> >> >> >         smp_rmb();
> >> >> >         if (!has_upper_data)
> >> >> >                 goto lower;
> >> >>
> >> >> Just put smp_rmb() here. no need for the bool variable.
> >> >> rmb does matter if you goto lower...
> >> >
> >> > I thought smp_rmb() has to be put *only* after LOAD of oi->flags.
> >> > Something like.
> >> >
> >> > LOAD oi->flags
> >> > smp_rmb()
> >> > Look at results of oi->flags and take action.
> >> >
> >> > So that means I need to store results of oi->flags load in variable
> >> > temporarily so that I can analyze it after smp_rmb(). IOW, I am not
> >> > sure how would I get rid of boolean here. I need some kind of temp
> >> > variable.
> >> >
> >>
> >> One of us is very confused.
> >>
> >> Remember you are not synchronizing the value of OVL_UPPER_DATA between CPUs
> >> You don't care if user gets lower or upper dentry.
> >> You only care about the upper case so you can put smb_rmb() after goto
> >> lower line
> >> which will make sure CPU cannot read inconsistent upper inode state
> >> from before smp_wmb()
> >> in ovl_copy_up_meta_inode_data() after CPU read positive
> >> OVL_UPPER_DATA before smp_rmb().
> >> That's the way I understand it.
> >
> > ok, I think I get it now. You are suggesting following structure.
> >
> >         if (!ovl_test_flag(OVL_UPPER_DATA, d_inode(dentry)))
> >                 goto lower;
> >         smp_rmb();
> >         return real;
> >
> > So if we are returning lower, we don't have to do smp_rmb(). But if we
> > saw OVL_UPPER_DATA, set, then we need to do smp_rmb() to make sure upper
> > is consistent (just in case it was data copied up just now).
> >
> > In fact, I should probably put is outside if condition block. That is.
> 
> If that was true then you should have tested OVL_UPPER_DATA outside
> the if condition. The reason it is not needed if inode is not NULL and equals
> to the upper inode then we have already made it visible to someone, then
> we can make it visible to evevryone.

That's a good point. I think there is more to it. More below.
> 
> This is very not clear from this code, so worth some fat comments.
> Also at top of ovl_d_real(),  D_REAL_UPPER just returns upper dentry
> without testing flag :-/

When you say "flag" you mean testing for OVL_UPPER_DATA?

> and this is not good for may_write_real()
> not sure about update_ovl_inode_times()...

Hmm..., thinking aloud about the whole issue. I think I have not
thought through the issue of d_real() returning a metadata only
dentry and what does that mean for rest of the system.

I think atleast current code is not broken w.r.t d_real(D_REAL_UPPER).
There are two users of D_REAL_UPPER currently. may_write_real() and
update_ovl_inode_times().

If we have a upper dentry which has only metadata, then may_write_real()
should return -EPERM because "file_inode(file) != d_inode(dentry)". IIUC,
these will be equal only if file had been opened with WRITE and in that
case returned dentry will not be metadata only.

And update_ovl_inode_times() just seems to retrieve metadata information
from upper inode and which should be just fine for metacopy inode. 

But D_REAL_UPPER is only one path. There are other ways one can get
pointer to upper metadata only dentry.

d_real(inode=X), can return upper dentry with metacopy only.

d_real(inode=NULL), will *not* return upper dentry with metacopy only. If
upper is metacopy only, it return lower dentry instead. I think this is
primarily the case of open(O_RDONLY).

So in terms of semantics of d_real() I am thinking of this now.

- d_real(inode=NULL, flags=0), will never return METACOPY dentry. Either
  it will copy up lower (if open_flags & WRITE) or will return lower.

If caller forces d_real() to return a specific dentry (either by
specifying D_REAL_UPPER or by specifying an inode, then one can
get back a METACOPY dentry. And one should not do any of data
operations on that dentry/inode.

So d_real(D_REAL_UPPER) and d_real(inode=X) can return METACOPY only
dentry.

Does that sound reasonable, or it is too fragile and broken?

I will try to audit the callers of d_real() now and see if something
else can be broken due to METACOPY only dentry being returned.

> 
> You should run another pass on all ovl_dentry_upper()
> ovl_dentry_real(), ovl_path_real() and ovl_path_upper()
> ovl_inode_upper() ovl_i_dentry_upper()
> I have a feeling there other issues lurking...

Will do.

I am also wondering what happens to various timestamps when data is
copied up later on a metadata only inode. I am guessing that I will
have to atleast copy mtime from lower and apply on upper. 

Vivek
