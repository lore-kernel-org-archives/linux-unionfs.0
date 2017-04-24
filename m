From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 01/11] ovl: store path type in dentry
Date: Mon, 24 Apr 2017 16:41:39 +0300
Message-ID: <CAOQ4uxiR1FsubAJs=0dZpnfp8dXJtRqWpFHKOA_PBfpaR_j=hw@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-2-git-send-email-amir73il@gmail.com> <20170424125921.GA18180@redhat.com>
 <CAOQ4uxjBnoCfCr4os16Vehv8-LVQm9acKBGq7ud-YQ=ptZ9B3g@mail.gmail.com> <20170424133617.GA17437@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36805 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1171050AbdDXNll (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Apr 2017 09:41:41 -0400
In-Reply-To: <20170424133617.GA17437@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Apr 24, 2017 at 4:36 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Apr 24, 2017 at 04:10:30PM +0300, Amir Goldstein wrote:
>> On Mon, Apr 24, 2017 at 3:59 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >
>> > On Mon, Apr 24, 2017 at 12:14:06PM +0300, Amir Goldstein wrote:
>> >
>> > [..]
>> > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> > > index c072a0c..671bac0 100644
>> > > --- a/fs/overlayfs/super.c
>> > > +++ b/fs/overlayfs/super.c
>> > > @@ -961,6 +961,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>> > >       kfree(stack);
>> > >
>> > >       root_dentry->d_fsdata = oe;
>> > > +     ovl_update_type(root_dentry, true);
>> > >
>> > >       realinode = d_inode(ovl_dentry_real(root_dentry));
>> > >       ovl_inode_init(d_inode(root_dentry), realinode, !!upperpath.dentry);
>> > > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
>> > > index 1953986..6a857fb 100644
>> > > --- a/fs/overlayfs/util.c
>> > > +++ b/fs/overlayfs/util.c
>> > > @@ -70,21 +70,38 @@ bool ovl_dentry_weird(struct dentry *dentry)
>> > >  enum ovl_path_type ovl_path_type(struct dentry *dentry)
>> > >  {
>> > >       struct ovl_entry *oe = dentry->d_fsdata;
>> > > -     enum ovl_path_type type = 0;
>> > > +     enum ovl_path_type type = oe->__type;
>> > >
>> > > -     if (oe->__upperdentry) {
>> > > -             type = __OVL_PATH_UPPER;
>> > > +     /* Matches smp_wmb() in ovl_update_type() */
>> > > +     smp_rmb();
>> > > +     return type;
>> >
>> > Hi Amir,
>> >
>> > I never manage to understand barriers so I will ask. Why this barrier is
>> > required and what can go wrong if we don't use this barrier.
>> >
>>
>> Hi Vivek,
>>
>> Miklos was kind enough to answer that question for me when he made
>> the comment about missing memmory barrier on v1 of the patch:
>> http://www.spinics.net/lists/linux-unionfs/msg01687.html
>>
>> Whether or not I got it right, we shall see shortly ;-)
>
> Hi Amir,
>
> Thanks. Ok, so we are making sure if other cpu sees updated ->type, then
> it is guaranteed that it isses updated ->upperdentry as well.
>
> I feel it is worth to put a shortened version of explanation from miklos
> in the comments. It will help to recall why did we put it. But it is just
> me. May be it is obvious to others.
>

I recon memory barriers are obvious to few.
However, I think the documentation I left is quite standard practice:
- smp_rmb() has a comment to point to the matching smp_wmb()
- smp_wmb() has a comment to explain what the barrier protects:
 * Make sure type is consistent with __upperdentry before making it
 * visible to ovl_path_type()
(i.e. to lockless readers of oe->__type)

Amir.
