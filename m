From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 11/11] ovl: Put barriers to order oi->__upperdentry and
 OVL_METACOPY update
Date: Thu, 19 Oct 2017 18:39:57 +0300
Message-ID: <CAOQ4uxjfkTfwEi7iwca7sHfsQvWK_foinBYjP1OjVTjDeEKq+A@mail.gmail.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
 <1508274358-17456-12-git-send-email-vgoyal@redhat.com> <CAOQ4uxg6Y7LU_JffejeteT11PT5rqGhUASNgk-hTdngGOqmAjg@mail.gmail.com>
 <20171019130030.GA2090@redhat.com> <CAOQ4uxhFKMaDmh3H1DdXqA-WFq7_MoDEzLU0UjMCZ1sMA-yLuw@mail.gmail.com>
 <20171019145824.GB2090@redhat.com> <CAOQ4uxgzcO=jJ5putycLD7xPwPbk4Tr+axfFxvR_wwtAnhHBiQ@mail.gmail.com>
 <20171019152221.GC2090@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:50917 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752642AbdJSPj6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 19 Oct 2017 11:39:58 -0400
Received: by mail-yw0-f193.google.com with SMTP id i198so3862621ywe.7
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Oct 2017 08:39:58 -0700 (PDT)
In-Reply-To: <20171019152221.GC2090@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 19, 2017 at 6:22 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Oct 19, 2017 at 06:08:32PM +0300, Amir Goldstein wrote:
>> On Thu, Oct 19, 2017 at 5:58 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Thu, Oct 19, 2017 at 04:21:46PM +0300, Amir Goldstein wrote:
>> ...
>> >>
>> >> Process 2 will get lower dentry on open for read at 8AM
>> >> Process 1 will copy up file at 9AM (on CPU1)
>> >> Process 2 will open same file for read at 9AM (on CPU2)
>> >> Does it matter if process 2 gets lower or upper dentry? No.
>> >> It only matter that IF process 2 gets an upper dentry, that
>> >> this dentry is consistent, so it only matters that IF __upperdentry
>> >> is visible to CPU2 AND OVL_UPPER_DATA flag is visible to
>> >> CPU2 then dentry and its inode are consistent.
>> >
>> > That's a good point. So if OVL_UPPER_DATA update is not visible on CPU2
>> > yet, then CPU1 will use lower dentry. And this is equivalent to as if file
>> > copy up has not taken place yet.
>> >
>> > And if CPU1 needed to do use upper dentry only, then it will do flags=WRITE
>> > and that will take oi->lock and make sure OVL_UPPER_DATA is set.
>> >
>> > So only *additional* smp_rmb()/smp_wmb() we require for the case when
>> > data is copied up later and we need to make sure OVL_UPPER_DATA is
>> > visible only after the full data copy up is done and stable.
>> >
>> >
>>
>> Right. forgot about that wmb.
>>
>> >>
>> >> So IMO you may only need to add smp_rmb() before
>> >> ovl_test_flag(OVL_UPPER_DATA in ovl_d_real() and the smp_wmb()
>> >> in ovl_inode_update() should be sufficient.
>> >> Change the comment in ovl_inode_update() to mention that wmb also
>> >> matches rmb in ovl_d_real() w.r.t OVL_UPPER_DATA flag.
>> >
>> > Hmm..., I agree that we require smp_rmb() here but it will pair with
>> > smp_wmb() in ovl_copy_meta_data_inode() and not the one in
>> > ovl_inode_update(), right? Something like.
>>
>> Right. my bad.
>>
>> >
>> > ovl_d_real() {
>> >         bool has_upper_data;
>> >
>> >         has_upper_data = ovl_test_flag(OVL_UPPER_DATA, d_inode(dentry));
>> >         /* Pairs with smp_wmb() in ovl_copy_up_meta_inode_data() */
>> >         smp_rmb();
>> >         if (!has_upper_data)
>> >                 goto lower;
>>
>> Just put smp_rmb() here. no need for the bool variable.
>> rmb does matter if you goto lower...
>
> I thought smp_rmb() has to be put *only* after LOAD of oi->flags.
> Something like.
>
> LOAD oi->flags
> smp_rmb()
> Look at results of oi->flags and take action.
>
> So that means I need to store results of oi->flags load in variable
> temporarily so that I can analyze it after smp_rmb(). IOW, I am not
> sure how would I get rid of boolean here. I need some kind of temp
> variable.
>

One of us is very confused.

Remember you are not synchronizing the value of OVL_UPPER_DATA between CPUs
You don't care if user gets lower or upper dentry.
You only care about the upper case so you can put smb_rmb() after goto
lower line
which will make sure CPU cannot read inconsistent upper inode state
from before smp_wmb()
in ovl_copy_up_meta_inode_data() after CPU read positive
OVL_UPPER_DATA before smp_rmb().
That's the way I understand it.

Amir.
