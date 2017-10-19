From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 11/11] ovl: Put barriers to order oi->__upperdentry and
 OVL_METACOPY update
Date: Thu, 19 Oct 2017 16:21:46 +0300
Message-ID: <CAOQ4uxhFKMaDmh3H1DdXqA-WFq7_MoDEzLU0UjMCZ1sMA-yLuw@mail.gmail.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
 <1508274358-17456-12-git-send-email-vgoyal@redhat.com> <CAOQ4uxg6Y7LU_JffejeteT11PT5rqGhUASNgk-hTdngGOqmAjg@mail.gmail.com>
 <20171019130030.GA2090@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:54079 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdJSNVr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 19 Oct 2017 09:21:47 -0400
Received: by mail-yw0-f196.google.com with SMTP id q126so519908ywq.10
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Oct 2017 06:21:47 -0700 (PDT)
In-Reply-To: <20171019130030.GA2090@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 19, 2017 at 4:00 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Oct 18, 2017 at 08:40:59AM +0300, Amir Goldstein wrote:
>> On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > OVL_METACOPY in oi->flags can be accessed in lockless manner. So if a file
>> > is being copied up metadata only, we need to make sure that upperdentry is
>> > visible only after OVL_METACOPY flag has been set. IOW, if oi->__upperdentry
>> > is visble to a cpu, then we also need to make sure any updates to OVL_METACOPY
>> > flags are visible too.
>> >
>>
>> You know, I have a feeling that this ordering requirement could be simplified or
>> completely avoided if you flip the meaning of the flag, i.e.:
>>
>> bool ovl_dentry_has_upper_data(struct dentry *dentry)
>> {
>>         return ovl_test_flag(OVL_UPPER_DATA, d_inode(dentry));
>> }
>>
>> Then flag visibility requirements are the same as visibility requirements
>> for oe->has_upper.
>> You probably don't need to add any new barriers for setting setting the flag
>> on normal copy up.
>> For setting the flag in copy_up_meta_inode_data, and testing the flag
>> in ovl_d_real() the requirements stay the same as you implemented in patch 10.
>
> Hi Amir,
>
> I thought about it and IIUC, flipping the bit does not do away with the
> ordering requirement w.r.t ovl_inode_update(). For example.
>
> Say on CPU1 a file is being copied up (both data and metadata copy up).
>
> ovl_copy_up_inode()
> install inode;
> ovl_set_flag(OVL_UPPER_DATA);
> ovl_inode_update();
>
> Assume, Say another CPU2 is doing d_real() with flags=0.
>
> ovl_d_real()
>   real = ovl_dentry_upper(dentry);
>   if (real) {
>         if (!ovl_test_flag(OVL_UPPER_DATA, d_inode(dentry)))
>                 goto lower;
>   }
>
> Now assume that CPU2 has not seen the update of OVL_UPPER_DATA yet. So it
> will end up returning a "lower" dentry, while it should have returned
> an upper dentry. So ordering requirement is very much still there.
>
> What do you think?

Process 2 will get lower dentry on open for read at 8AM
Process 1 will copy up file at 9AM (on CPU1)
Process 2 will open same file for read at 9AM (on CPU2)
Does it matter if process 2 gets lower or upper dentry? No.
It only matter that IF process 2 gets an upper dentry, that
this dentry is consistent, so it only matters that IF __upperdentry
is visible to CPU2 AND OVL_UPPER_DATA flag is visible to
CPU2 then dentry and its inode are consistent.

So IMO you may only need to add smp_rmb() before
ovl_test_flag(OVL_UPPER_DATA in ovl_d_real() and the smp_wmb()
in ovl_inode_update() should be sufficient.
Change the comment in ovl_inode_update() to mention that wmb also
matches rmb in ovl_d_real() w.r.t OVL_UPPER_DATA flag.


>
> To simplify ordering requirements w.r.t ovl_inode_updat(), can we replace
> data dependency barrier in ovl_upperdentry_dereference() with a read
> barrier instead (smp_rmb()). That way we will not have to introduce
> this additional smp_rmb() everything and code will be simpler.
>
> Thoughts?
>

I am am right with my claims above, this can be avoided.

Amir.
