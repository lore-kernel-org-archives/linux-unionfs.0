From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 5/7] ovl: Set OVL_METACOPY flag during ovl_lookup()
Date: Tue, 3 Oct 2017 18:42:48 +0300
Message-ID: <CAOQ4uxhwWhm2K0uOZ_9azddK6G3Ry0oQoTLryaUj+FQwD3os0A@mail.gmail.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
 <1506951605-31440-6-git-send-email-vgoyal@redhat.com> <CAOQ4uxgDZST72GWN5WO7Qk_=CA0SA+jPCyWEuej3Ppug4Wnkxw@mail.gmail.com>
 <20171003152742.GF14308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:56965 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdJCPmt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Oct 2017 11:42:49 -0400
Received: by mail-qt0-f177.google.com with SMTP id e19so9841439qta.13
        for <linux-unionfs@vger.kernel.org>; Tue, 03 Oct 2017 08:42:49 -0700 (PDT)
In-Reply-To: <20171003152742.GF14308@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Oct 3, 2017 at 6:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Oct 02, 2017 at 10:31:42PM +0300, Amir Goldstein wrote:
>> On Mon, Oct 2, 2017 at 4:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > During lookup, check for presence of OVL_XATTR_METACOPY and if present,
>> > set OVL_METACOPY bit in flags.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > ---
>> >  fs/overlayfs/namei.c | 34 ++++++++++++++++++++++++++++++++++
>> >  1 file changed, 34 insertions(+)
>> >
>> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> > index c3addd1114f1..9b6f9afa4f75 100644
>> > --- a/fs/overlayfs/namei.c
>> > +++ b/fs/overlayfs/namei.c
>> > @@ -26,6 +26,24 @@ struct ovl_lookup_data {
>> >         char *redirect;
>> >  };
>> >
>> > +/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
>> > +static int ovl_check_metacopy(struct dentry *dentry)
>> > +{
>> > +       int res;
>> > +
>> > +       res = vfs_getxattr(dentry, OVL_XATTR_METACOPY, NULL, 0);
>> > +       if (res < 0) {
>> > +               if (res == -ENODATA || res == -EOPNOTSUPP)
>> > +                       return 0;
>> > +               goto out;
>> > +       }
>> > +
>> > +       return 1;
>> > +out:
>> > +       pr_warn_ratelimited("overlayfs: failed to get metacopy (%i)\n", res);
>> > +       return res;
>> > +}
>> > +
>> >  static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
>> >                               size_t prelen, const char *post)
>> >  {
>> > @@ -591,6 +609,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>> >         struct dentry *this;
>> >         unsigned int i;
>> >         int err;
>> > +       bool metacopy = false;
>> >         struct ovl_lookup_data d = {
>> >                 .name = dentry->d_name,
>> >                 .is_dir = false,
>> > @@ -631,6 +650,12 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>> >                                                roe->numlower, &stack, &ctr);
>> >                         if (err)
>> >                                 goto out;
>> > +
>> > +                       err = ovl_check_metacopy(upperdentry);
>> > +                       if (err < 0)
>> > +                               goto out;
>> > +                       if (err == 1)
>> > +                               metacopy = true;
>> >                 }
>> >
>> >                 if (d.redirect) {
>> > @@ -716,6 +741,15 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>> >                 OVL_I(inode)->redirect = upperredirect;
>> >                 if (index)
>> >                         ovl_set_flag(OVL_INDEX, inode);
>> > +
>> > +               if (metacopy) {
>> > +                       /*
>> > +                        * TODO: What happens we if find metacopy xattr but
>> > +                        * could not find/resolve origin.
>> > +                        */
>>
>> Hint: if metacopy could also exist only on an index entry, with no
>> upper aliases,
>> this index entry would be detected as stale on mount (cannot resolve origin) and
>> cleaned, so you won't get to this problem.
>
> Hi Amir,
>
> Sorry, I am getting lost here. Can you please explain a bit more.
>
> My understanding is that index entry is created during copy up only for
> files with nlink > 1. If a regular file is copied up there will not be
> any index entry.
>
> And during mount time, you are going through all index entries and
> verifying there are no stale entries and cleaning up stale entries.
> (ovl_indexdir_cleanup()).
>
> So is the idea that with metacopyup we create index entries even for
> regular files with nlink=1

Yes. please cherry-pick 982a78ebd5cd ovl: create ovl_need_index() helper
from https://github.com/amir73il/linux/commits/ovl-index-all
and then in the patch that introduces metacopy up, return true from
ovl_need_index() helper for regular files if ofs->config.metacopy is set

> and do similar cleanup? Sorry, I am little
> lost here.
>

Your patches need not do anything more.
The cleanup will happen with current ovl_indexdir_cleanup() code.
You ask in the comment "What happens we if find metacopy xattr but
could not find/resolve origin?"
If you follow my suggestions, then metacopy xattr can exist only on
index entry *before* it was linked to upper dir.
So if such an index entry exists that its origin is not available or
cannot be resolved, this index will be cleaned on mount time
and you shall not find it on lookup.

Amir.
