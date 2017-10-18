From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 10/11] ovl: Introduce read/write barriers around metacopy
 flag update
Date: Wed, 18 Oct 2017 19:05:03 +0300
Message-ID: <CAOQ4uxjkwYQe6Z8-SDMybN+UwUyCScew_J-7NS6SRDMZoG5Yxw@mail.gmail.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
 <1508274358-17456-11-git-send-email-vgoyal@redhat.com> <CAOQ4uxipEM_yjVBYyL48OhUYs2qL6Cw+rA82+mTwRAoTS=Wk5w@mail.gmail.com>
 <20171018153236.GI3445@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:44670 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbdJRQFE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 12:05:04 -0400
Received: by mail-yw0-f195.google.com with SMTP id k11so976301ywh.1
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Oct 2017 09:05:04 -0700 (PDT)
In-Reply-To: <20171018153236.GI3445@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 6:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Oct 18, 2017 at 08:19:50AM +0300, Amir Goldstein wrote:
>> On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > If a file is copied up metadata only and later when same file is opened
>> > for WRITE, then data copy up takes place. We copy up data, remove METACOPY
>> > xattr and then clear the METACOPY flag from ovl_entry->flags. While all
>> > these operations happen with oi->lock held, read side of oi->flags is
>> > lockless. That is another thread on another cpu can check if METACOPY
>> > flag is clear or not.
>> >
>> > So this gives us an ordering requirement w.r.t METACOPY flag. That is, if
>> > another cpu sees METACOPY flag clear, then it should be guaranteed that
>> > effects of data copy up and remove xattr operations are also visible.
>> >
>> > For example.
>> >
>> >         CPU1                            CPU2
>> > ovl_copy_up_flags()                     acquire(oi->lock)
>> >  ovl_dentry_needs_data_copy_up()          ovl_copy_up_data()
>>
>> The relevant lockless execution path of CPU1 is
>> ovl_d_real -> ovl_test_flag(OVL_METACOPY) ->  return real
>> when real is upper, upper needs to be with correct data
>>
>
> That path is relevant for ordering requirements w.r.t oi->__upperdentry
> and next patch does put an smp_rmb() there to cover it.
>
>> The execution path you describe here is going to test the flag
>> under overlay inode lock again in  ovl_copy_up_one() so it is irrelevant
>> to the barriers patch
>
> It will go into ovl_copy_up_one() only if this cpu saw OVL_METACOPY=1. But
> what about the case where OVL_METACOPY is being cleared on CPU2, and
> it became visible on CPU1. That means cpu1 will assume file copy up is
> complete and it will continue and never both to take oi->lock.

Yes, it will continue only to meet the next smp_rmb in d_real before testing
the flag again.
Nevermind that. I think the scheme you are trying to implement over complicates
ordering requirement because you need to toggle the bit twice.
If you start with a cleat bit (OVL_UPPER_DATA) and only set it when data copy
is finalized you have one less memory synchronization to worry about and
life should be simpler.

>
>>
>>
>> >    ovl_test_flag(OVL_METACOPY)            vfs_removexattr()
>> >                                           ovl_clear_metacopy_flag()
>> >                                         release(oi->lock)
>> >
>> > Say CPU2 is copying up data and in the end clears metacopy flag. But if
>> > CPU1 perceives the effects of clearing of metacopy flag but not effects of
>> > preceeding operations, that would be a problem.
>> >
>> > Hence this patch introduces smp_wmb() on metacopy flag clear operation
>> > and smp_rmb() on metacopy flag test operation.
>> >
>> > May be some other lock or barrier is already covering it. But I am not sure
>> > what that is and is it obvious enough that we will not break it in future.
>> >
>> > So hence trying to be safe here and introducing barriers explicitly for
>> > metacopy bit.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > ---
>> >  fs/overlayfs/copy_up.c |  6 ++++++
>> >  fs/overlayfs/util.c    | 12 ++++++++++--
>> >  2 files changed, 16 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>> > index 99b7be4ff4fc..200ee3b7d397 100644
>> > --- a/fs/overlayfs/copy_up.c
>> > +++ b/fs/overlayfs/copy_up.c
>> > @@ -466,6 +466,12 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>> >         if (err)
>> >                 return err;
>> >
>> > +       /*
>> > +        * Pairs with smp_rmb() after test_bit(OVL_METACOPY). Make sure
>>
>> This comment is meant to refer the reader to the code that this pairs with
>> i.e. pairs with smp_rmb() in ovl_d_real() ..
>
> This pairs with smp_rmb() in ovl_dentry_needs_data_copy_up(). Next patch
> has smp_rmb() in ovl_d_real() and I will explain that more.
>
>>
>> > +        * if OVL_METACOPY flag reset is visible, then all the write
>> > +        * operations before it are visible as well
>> > +        */
>> > +       smp_wmb();
>> >         ovl_clear_flag(OVL_METACOPY, d_inode(c->dentry));
>> >         return err;
>> >  }
>> > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
>> > index 91c542d1a39d..6bca9a960c6d 100644
>> > --- a/fs/overlayfs/util.c
>> > +++ b/fs/overlayfs/util.c
>> > @@ -228,6 +228,8 @@ void ovl_dentry_set_upper_alias(struct dentry *dentry)
>> >  }
>> >
>> >  bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
>> > +       bool metacopy;
>> > +
>> >         if (!S_ISREG(d_inode(dentry)->i_mode))
>> >                 return false;
>> >
>> > @@ -237,9 +239,15 @@ bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
>> >         if (!(OPEN_FMODE(flags) & FMODE_WRITE))
>> >                 return false;
>> >
>> > -       if (!ovl_test_flag(OVL_METACOPY, d_inode(dentry)))
>> > +       metacopy = ovl_test_flag(OVL_METACOPY, d_inode(dentry));
>> > +       /*
>> > +        * Pairs with smp_wmb() while clearing OVL_METACOPY. Make sure if
>>
>> This comment is meant to refer the reader to the code that this pairs with
>> i.e. pairs with smp_wmb() in ovl_copy_up_meta_inode_data() ..
>
> Will do. I guess I will retain this which explains what's the intent
> and also add funciton name where OVL_METACOPY is being cleared.
>
>>
>> > +        * clearing of OVL_METACOPY is visible, then effects of writes
>> > +        * before that are visible too.
>> > +        */
>> > +       smp_rmb();
>>
>> Please move this rmb to ovl_d_real() after re-testing flag,
>> which is the only place that matters for inode data access.
>
> But we are testing it atleast at two places.
> (ovl_dentry_needs_data_copy_up()).
>
> First call is in.
>
> ovl_d_real()
>   ovl_open_need_copy_up()
>      ovl_dentry_needs_data_copy_up()
>
> And second call is in ovl_copy_up_flags() further down.
>
> ovl_d_real()
>   ovl_open_need_copy_up()
>      ovl_dentry_needs_data_copy_up()  <---- First Call
>           ovl_copy_up_flags()
>               ovl_dentry_needs_data_copy_up() <--- Second Call
>
> Given we are checking/loading oi->flags at both the places, IIUC, we
> need smp_rmb() at both the places. And if that's the case, its better
> to keep it inside ovl_dentry_needs_data_copy_up() instead of open
> coding it in ovl_open_need_copy_up() and ovl_copy_up_flags().
>

This seems over complicated.
Let's try the single bit flip scheme and see where that gets us.

Amir.
