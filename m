From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 5/9] ovl: Set xattr OVL_XATTR_METACOPY on upper file
Date: Wed, 11 Oct 2017 23:44:26 +0300
Message-ID: <CAOQ4uxi-3y2ENXhv_=nQcLk8rKN20bz7cRuRQXuDuP+jhZBpsg@mail.gmail.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
 <1507649544-4539-6-git-send-email-vgoyal@redhat.com> <CAOQ4uxgNg3SO=xyvh_oAH-ExQGQCWXMGKygdAhmGeDdanyo=vA@mail.gmail.com>
 <20171011201630.GE8086@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36321 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdJKUo1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2017 16:44:27 -0400
Received: by mail-qt0-f194.google.com with SMTP id 24so3987535qts.3
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2017 13:44:27 -0700 (PDT)
In-Reply-To: <20171011201630.GE8086@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>

On Wed, Oct 11, 2017 at 11:16 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Oct 10, 2017 at 08:03:05PM +0300, Amir Goldstein wrote:
>
> [..]
>> > @@ -511,6 +564,10 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
>> >                 goto out_cleanup;
>> >
>> >         ovl_inode_update(d_inode(c->dentry), newdentry);
>> > +       if (c->metadata_only) {
>> > +               smp_wmb();
>>
>> This wmb does not address the only problem imo.
>> The problem is you must not allow inode to appear to have
>> An upper dentry before you made sure metacopy flag is visible.
>> So first you need to set metacopy flag before updating upper.
>> Then you also need to test them is correct order with rmb.
>
> Ok, so conceptually it makse sense to me that OVL_METACOPY flag should
> be set before upper dentry is made visible.
>
> So ovl_set_flag(OVL_METACOPY) should move before ovl_inode_update().
> ovl_inode_update() already has a smp_wmb(). So write side is probably
> fine.
>
> But read side, ovl_upperdentry_dereference() only has data dependency
> barrier and not smp_rmb(). (lockless_dereference(oi->__upperdentry)). I
> am not sure if that's sufficient for ovl_inode->flags read or not. May
> be we need to replace data dependency barrier with smp_rmb() in in
> ovl_upperdentry_dereference()?

I think we do need smp_rmb() between ovl_upperdentry_dereference()
and testing OVL_METACOPY, but not inside ovl_upperdentry_dereference()
somewhere in d_real() path maybe in ovl_open_need_copy_up()

>
> Even if we do this, I think we need barriers around setting/resetting
> of OVL_METACOPY for the reset case. I will explain this in other patch.
>

I think the spinlock in atomic bit ops of set_bit/clear_bit is got you covered
w.r.t. memory barriers. Only need to worry about lockless test_bit() IMO.

Amir.
