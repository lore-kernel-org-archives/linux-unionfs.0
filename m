From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 11/11] ovl: Put barriers to order oi->__upperdentry and
 OVL_METACOPY update
Date: Thu, 19 Oct 2017 10:58:24 -0400
Message-ID: <20171019145824.GB2090@redhat.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
 <1508274358-17456-12-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxg6Y7LU_JffejeteT11PT5rqGhUASNgk-hTdngGOqmAjg@mail.gmail.com>
 <20171019130030.GA2090@redhat.com>
 <CAOQ4uxhFKMaDmh3H1DdXqA-WFq7_MoDEzLU0UjMCZ1sMA-yLuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36236 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752044AbdJSO6Z (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 19 Oct 2017 10:58:25 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhFKMaDmh3H1DdXqA-WFq7_MoDEzLU0UjMCZ1sMA-yLuw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 19, 2017 at 04:21:46PM +0300, Amir Goldstein wrote:
> On Thu, Oct 19, 2017 at 4:00 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Oct 18, 2017 at 08:40:59AM +0300, Amir Goldstein wrote:
> >> On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > OVL_METACOPY in oi->flags can be accessed in lockless manner. So if a file
> >> > is being copied up metadata only, we need to make sure that upperdentry is
> >> > visible only after OVL_METACOPY flag has been set. IOW, if oi->__upperdentry
> >> > is visble to a cpu, then we also need to make sure any updates to OVL_METACOPY
> >> > flags are visible too.
> >> >
> >>
> >> You know, I have a feeling that this ordering requirement could be simplified or
> >> completely avoided if you flip the meaning of the flag, i.e.:
> >>
> >> bool ovl_dentry_has_upper_data(struct dentry *dentry)
> >> {
> >>         return ovl_test_flag(OVL_UPPER_DATA, d_inode(dentry));
> >> }
> >>
> >> Then flag visibility requirements are the same as visibility requirements
> >> for oe->has_upper.
> >> You probably don't need to add any new barriers for setting setting the flag
> >> on normal copy up.
> >> For setting the flag in copy_up_meta_inode_data, and testing the flag
> >> in ovl_d_real() the requirements stay the same as you implemented in patch 10.
> >
> > Hi Amir,
> >
> > I thought about it and IIUC, flipping the bit does not do away with the
> > ordering requirement w.r.t ovl_inode_update(). For example.
> >
> > Say on CPU1 a file is being copied up (both data and metadata copy up).
> >
> > ovl_copy_up_inode()
> > install inode;
> > ovl_set_flag(OVL_UPPER_DATA);
> > ovl_inode_update();
> >
> > Assume, Say another CPU2 is doing d_real() with flags=0.
> >
> > ovl_d_real()
> >   real = ovl_dentry_upper(dentry);
> >   if (real) {
> >         if (!ovl_test_flag(OVL_UPPER_DATA, d_inode(dentry)))
> >                 goto lower;
> >   }
> >
> > Now assume that CPU2 has not seen the update of OVL_UPPER_DATA yet. So it
> > will end up returning a "lower" dentry, while it should have returned
> > an upper dentry. So ordering requirement is very much still there.
> >
> > What do you think?
> 
> Process 2 will get lower dentry on open for read at 8AM
> Process 1 will copy up file at 9AM (on CPU1)
> Process 2 will open same file for read at 9AM (on CPU2)
> Does it matter if process 2 gets lower or upper dentry? No.
> It only matter that IF process 2 gets an upper dentry, that
> this dentry is consistent, so it only matters that IF __upperdentry
> is visible to CPU2 AND OVL_UPPER_DATA flag is visible to
> CPU2 then dentry and its inode are consistent.

That's a good point. So if OVL_UPPER_DATA update is not visible on CPU2
yet, then CPU1 will use lower dentry. And this is equivalent to as if file
copy up has not taken place yet.

And if CPU1 needed to do use upper dentry only, then it will do flags=WRITE
and that will take oi->lock and make sure OVL_UPPER_DATA is set.

So only *additional* smp_rmb()/smp_wmb() we require for the case when 
data is copied up later and we need to make sure OVL_UPPER_DATA is
visible only after the full data copy up is done and stable.

Sounds good.

> 
> So IMO you may only need to add smp_rmb() before
> ovl_test_flag(OVL_UPPER_DATA in ovl_d_real() and the smp_wmb()
> in ovl_inode_update() should be sufficient.
> Change the comment in ovl_inode_update() to mention that wmb also
> matches rmb in ovl_d_real() w.r.t OVL_UPPER_DATA flag.

Hmm..., I agree that we require smp_rmb() here but it will pair with
smp_wmb() in ovl_copy_meta_data_inode() and not the one in
ovl_inode_update(), right? Something like.

ovl_d_real() {
	bool has_upper_data;

	has_upper_data = ovl_test_flag(OVL_UPPER_DATA, d_inode(dentry));
	/* Pairs with smp_wmb() in ovl_copy_up_meta_inode_data() */
	smp_rmb();
	if (!has_upper_data)
		goto lower;

	...
	...
	return real;
}

Note that now smp_rmb() will be placed after loading OVL_UPPER_DATA and
not before it. Because we are ensuring ordering w.r.t smp_wmb() in
ovl_copy_up_meta_inode_data().

In fact I think my current patches are buggy because they should have had
this smp_rmb() to begin with.

> 
> 
> >
> > To simplify ordering requirements w.r.t ovl_inode_updat(), can we replace
> > data dependency barrier in ovl_upperdentry_dereference() with a read
> > barrier instead (smp_rmb()). That way we will not have to introduce
> > this additional smp_rmb() everything and code will be simpler.
> >
> > Thoughts?
> >
> 
> I am am right with my claims above, this can be avoided.

Agreed. By flipping the bit, instead of two ordering requirements we 
should have only one ordering requirement and place barrier only for
that requirement (That's patch 10).

Vivek
