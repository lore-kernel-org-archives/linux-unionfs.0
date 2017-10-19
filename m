From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 11/11] ovl: Put barriers to order oi->__upperdentry and
 OVL_METACOPY update
Date: Thu, 19 Oct 2017 19:33:37 +0300
Message-ID: <CAOQ4uxhLM=DYLRJMhCRvce3u=fhMtL=mE-CCu+QBazFdoKH5Yg@mail.gmail.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
 <1508274358-17456-12-git-send-email-vgoyal@redhat.com> <CAOQ4uxg6Y7LU_JffejeteT11PT5rqGhUASNgk-hTdngGOqmAjg@mail.gmail.com>
 <20171019130030.GA2090@redhat.com> <CAOQ4uxhFKMaDmh3H1DdXqA-WFq7_MoDEzLU0UjMCZ1sMA-yLuw@mail.gmail.com>
 <20171019145824.GB2090@redhat.com> <CAOQ4uxgzcO=jJ5putycLD7xPwPbk4Tr+axfFxvR_wwtAnhHBiQ@mail.gmail.com>
 <20171019152221.GC2090@redhat.com> <CAOQ4uxjfkTfwEi7iwca7sHfsQvWK_foinBYjP1OjVTjDeEKq+A@mail.gmail.com>
 <20171019155932.GA24029@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:52015 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753391AbdJSQdj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 19 Oct 2017 12:33:39 -0400
Received: by mail-yw0-f193.google.com with SMTP id k3so4009898ywk.8
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Oct 2017 09:33:38 -0700 (PDT)
In-Reply-To: <20171019155932.GA24029@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 19, 2017 at 6:59 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Oct 19, 2017 at 06:39:57PM +0300, Amir Goldstein wrote:
>> On Thu, Oct 19, 2017 at 6:22 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Thu, Oct 19, 2017 at 06:08:32PM +0300, Amir Goldstein wrote:
>> >> On Thu, Oct 19, 2017 at 5:58 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> > On Thu, Oct 19, 2017 at 04:21:46PM +0300, Amir Goldstein wrote:
>> >> ...
>> >> >>
>> >> >> Process 2 will get lower dentry on open for read at 8AM
>> >> >> Process 1 will copy up file at 9AM (on CPU1)
>> >> >> Process 2 will open same file for read at 9AM (on CPU2)
>> >> >> Does it matter if process 2 gets lower or upper dentry? No.
>> >> >> It only matter that IF process 2 gets an upper dentry, that
>> >> >> this dentry is consistent, so it only matters that IF __upperdentry
>> >> >> is visible to CPU2 AND OVL_UPPER_DATA flag is visible to
>> >> >> CPU2 then dentry and its inode are consistent.
>> >> >
>> >> > That's a good point. So if OVL_UPPER_DATA update is not visible on CPU2
>> >> > yet, then CPU1 will use lower dentry. And this is equivalent to as if file
>> >> > copy up has not taken place yet.
>> >> >
>> >> > And if CPU1 needed to do use upper dentry only, then it will do flags=WRITE
>> >> > and that will take oi->lock and make sure OVL_UPPER_DATA is set.
>> >> >
>> >> > So only *additional* smp_rmb()/smp_wmb() we require for the case when
>> >> > data is copied up later and we need to make sure OVL_UPPER_DATA is
>> >> > visible only after the full data copy up is done and stable.
>> >> >
>> >> >
>> >>
>> >> Right. forgot about that wmb.
>> >>
>> >> >>
>> >> >> So IMO you may only need to add smp_rmb() before
>> >> >> ovl_test_flag(OVL_UPPER_DATA in ovl_d_real() and the smp_wmb()
>> >> >> in ovl_inode_update() should be sufficient.
>> >> >> Change the comment in ovl_inode_update() to mention that wmb also
>> >> >> matches rmb in ovl_d_real() w.r.t OVL_UPPER_DATA flag.
>> >> >
>> >> > Hmm..., I agree that we require smp_rmb() here but it will pair with
>> >> > smp_wmb() in ovl_copy_meta_data_inode() and not the one in
>> >> > ovl_inode_update(), right? Something like.
>> >>
>> >> Right. my bad.
>> >>
>> >> >
>> >> > ovl_d_real() {
>> >> >         bool has_upper_data;
>> >> >
>> >> >         has_upper_data = ovl_test_flag(OVL_UPPER_DATA, d_inode(dentry));
>> >> >         /* Pairs with smp_wmb() in ovl_copy_up_meta_inode_data() */
>> >> >         smp_rmb();
>> >> >         if (!has_upper_data)
>> >> >                 goto lower;
>> >>
>> >> Just put smp_rmb() here. no need for the bool variable.
>> >> rmb does matter if you goto lower...
>> >
>> > I thought smp_rmb() has to be put *only* after LOAD of oi->flags.
>> > Something like.
>> >
>> > LOAD oi->flags
>> > smp_rmb()
>> > Look at results of oi->flags and take action.
>> >
>> > So that means I need to store results of oi->flags load in variable
>> > temporarily so that I can analyze it after smp_rmb(). IOW, I am not
>> > sure how would I get rid of boolean here. I need some kind of temp
>> > variable.
>> >
>>
>> One of us is very confused.
>>
>> Remember you are not synchronizing the value of OVL_UPPER_DATA between CPUs
>> You don't care if user gets lower or upper dentry.
>> You only care about the upper case so you can put smb_rmb() after goto
>> lower line
>> which will make sure CPU cannot read inconsistent upper inode state
>> from before smp_wmb()
>> in ovl_copy_up_meta_inode_data() after CPU read positive
>> OVL_UPPER_DATA before smp_rmb().
>> That's the way I understand it.
>
> ok, I think I get it now. You are suggesting following structure.
>
>         if (!ovl_test_flag(OVL_UPPER_DATA, d_inode(dentry)))
>                 goto lower;
>         smp_rmb();
>         return real;
>
> So if we are returning lower, we don't have to do smp_rmb(). But if we
> saw OVL_UPPER_DATA, set, then we need to do smp_rmb() to make sure upper
> is consistent (just in case it was data copied up just now).
>
> In fact, I should probably put is outside if condition block. That is.

If that was true then you should have tested OVL_UPPER_DATA outside
the if condition. The reason it is not needed if inode is not NULL and equals
to the upper inode then we have already made it visible to someone, then
we can make it visible to evevryone.

This is very not clear from this code, so worth some fat comments.
Also at top of ovl_d_real(),  D_REAL_UPPER just returns upper dentry
without testing flag :-/ and this is not good for may_write_real()
not sure about update_ovl_inode_times()...

You should run another pass on all ovl_dentry_upper()
ovl_dentry_real(), ovl_path_real() and ovl_path_upper()
ovl_inode_upper() ovl_i_dentry_upper()
I have a feeling there other issues lurking...


>
>         real = ovl_dentry_upper(dentry);
>         if (real && (!inode || inode == d_inode(real))) {
>                 if (!inode) {
>                         err = ovl_check_append_only(d_inode(real), open_flags);
>                         if (err)
>                                 return ERR_PTR(err);
>
>                         if (!ovl_test_flag(OVL_UPPER_DATA, d_inode(dentry)))
>                                 goto lower;
>                 }
>                 smp_rmb();
>                 return real;
>         }
>
> Vivek
