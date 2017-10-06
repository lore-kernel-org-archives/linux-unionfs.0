From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 8/8] ovl: Fix ovl_getattr() to get number of blocks from lower
Date: Fri, 6 Oct 2017 22:09:38 +0300
Message-ID: <CAOQ4uxh4fcDc4FovOW_9vNGVJ3mDKrT=YVyXBNOFQAL_a2Gh_w@mail.gmail.com>
References: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
 <1507312037-30909-9-git-send-email-vgoyal@redhat.com> <CAOQ4uxgYC=UKpXw+P36PnB2hxDzV+L=QP_j8whJeL2GCrSxLnw@mail.gmail.com>
 <20171006190104.GA1449@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:37540 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbdJFTJj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 15:09:39 -0400
Received: by mail-qt0-f195.google.com with SMTP id 32so8751690qtp.4
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Oct 2017 12:09:39 -0700 (PDT)
In-Reply-To: <20171006190104.GA1449@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Oct 6, 2017 at 10:01 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Oct 06, 2017 at 09:58:58PM +0300, Amir Goldstein wrote:
>> On Fri, Oct 6, 2017 at 8:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > If an inode has been copied up metadata only, then we need to query the
>> > number of blocks from lower and fill up the stat->st_blocks.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > ---
>> >  fs/overlayfs/inode.c | 18 ++++++++++++++++--
>> >  1 file changed, 16 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
>> > index e5825b8948e0..18007634ea9a 100644
>> > --- a/fs/overlayfs/inode.c
>> > +++ b/fs/overlayfs/inode.c
>> > @@ -67,6 +67,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>> >         const struct cred *old_cred;
>> >         bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
>> >         int err;
>> > +       bool lowerstat_done = false;
>> > +       struct kstat lowerstat;
>> >
>> >         type = ovl_path_real(dentry, &realpath);
>> >         old_cred = ovl_override_creds(dentry->d_sb);
>> > @@ -86,8 +88,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>> >          */
>> >         if (ovl_same_sb(dentry->d_sb)) {
>> >                 if (OVL_TYPE_ORIGIN(type)) {
>> > -                       struct kstat lowerstat;
>> > -                       u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
>> > +                       u32 lowermask = STATX_INO | STATX_BLOCKS |
>> > +                                       (!is_dir ? STATX_NLINK : 0);
>> >
>> >                         ovl_path_lower(dentry, &realpath);
>> >                         err = vfs_getattr(&realpath, &lowerstat,
>> > @@ -95,6 +97,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>> >                         if (err)
>> >                                 goto out;
>> >
>> > +                       lowerstat_done = true;
>> >                         WARN_ON_ONCE(stat->dev != lowerstat.dev);
>> >                         /*
>> >                          * Lower hardlinks may be broken on copy up to different
>> > @@ -140,6 +143,17 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>> >         if (!is_dir && ovl_test_flag(OVL_INDEX, d_inode(dentry)))
>> >                 stat->nlink = dentry->d_inode->i_nlink;
>> >
>> > +       if (ovl_test_flag(OVL_METACOPY, d_inode(dentry))) {
>> > +               u32 lowermask = STATX_BLOCKS;
>> > +
>> > +               if (!lowerstat_done) {
>>
>> I guess lowerstat_done is as result from my comment,
>> but I did not mean I think vfs_getattr() is expensive,
>> I just didn't like the duplication of that code block, but maybe
>> just a matter of personal taste.
>> Can be sorted out later.
>
> Yes, I added this because I thought you wanted to avoid that extra
> vfs_getattr() call. I am open to change it whatever way you like.
> Personally I did not like this extra boolean and I liked unconditional
> vfs_getattr() better. It was not most optimized but was easier to
> understand.
>

Yeh, I liked it without the boolean better as well.
What I meant is once this patch lands:
https://github.com/chandanr/linux/commit/e9024b0a08a1c725daed548f68ff703305c40124
vfs_getattr() will be called for all non-dir with ORIGIN anyway, so
METACOPY will be able to piggy back STATX_BLOCKS flag on the same call.

Amir.
