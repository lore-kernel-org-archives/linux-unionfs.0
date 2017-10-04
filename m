From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 5/7] ovl: Set OVL_METACOPY flag during ovl_lookup()
Date: Wed, 4 Oct 2017 10:48:36 +0300
Message-ID: <CAOQ4uxi76Ob_k6bfTUOA2N5QqkF879+0yFbPh2ZR2=hEAVEF4A@mail.gmail.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
 <1506951605-31440-6-git-send-email-vgoyal@redhat.com> <CAOQ4uxgDZST72GWN5WO7Qk_=CA0SA+jPCyWEuej3Ppug4Wnkxw@mail.gmail.com>
 <20171003152742.GF14308@redhat.com> <CAOQ4uxhwWhm2K0uOZ_9azddK6G3Ry0oQoTLryaUj+FQwD3os0A@mail.gmail.com>
 <20171003182026.GG14308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:52813 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbdJDHsj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 4 Oct 2017 03:48:39 -0400
Received: by mail-qt0-f169.google.com with SMTP id o52so17568833qtc.9
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Oct 2017 00:48:39 -0700 (PDT)
In-Reply-To: <20171003182026.GG14308@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Oct 3, 2017 at 9:20 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Oct 03, 2017 at 06:42:48PM +0300, Amir Goldstein wrote:
>> On Tue, Oct 3, 2017 at 6:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Mon, Oct 02, 2017 at 10:31:42PM +0300, Amir Goldstein wrote:
>> >> On Mon, Oct 2, 2017 at 4:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> > During lookup, check for presence of OVL_XATTR_METACOPY and if present,
>> >> > set OVL_METACOPY bit in flags.
>> >> >
>> >> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> >> > ---
>> >> >  fs/overlayfs/namei.c | 34 ++++++++++++++++++++++++++++++++++
>> >> >  1 file changed, 34 insertions(+)
>> >> >
>> >> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> >> > index c3addd1114f1..9b6f9afa4f75 100644
>> >> > --- a/fs/overlayfs/namei.c
>> >> > +++ b/fs/overlayfs/namei.c
>> >> > @@ -26,6 +26,24 @@ struct ovl_lookup_data {
>> >> >         char *redirect;
>> >> >  };
>> >> >
>> >> > +/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
>> >> > +static int ovl_check_metacopy(struct dentry *dentry)
>> >> > +{
>> >> > +       int res;
>> >> > +
>> >> > +       res = vfs_getxattr(dentry, OVL_XATTR_METACOPY, NULL, 0);
>> >> > +       if (res < 0) {
>> >> > +               if (res == -ENODATA || res == -EOPNOTSUPP)
>> >> > +                       return 0;
>> >> > +               goto out;
>> >> > +       }
>> >> > +
>> >> > +       return 1;
>> >> > +out:
>> >> > +       pr_warn_ratelimited("overlayfs: failed to get metacopy (%i)\n", res);
>> >> > +       return res;
>> >> > +}
>> >> > +
>> >> >  static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
>> >> >                               size_t prelen, const char *post)
>> >> >  {
>> >> > @@ -591,6 +609,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>> >> >         struct dentry *this;
>> >> >         unsigned int i;
>> >> >         int err;
>> >> > +       bool metacopy = false;
>> >> >         struct ovl_lookup_data d = {
>> >> >                 .name = dentry->d_name,
>> >> >                 .is_dir = false,
>> >> > @@ -631,6 +650,12 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>> >> >                                                roe->numlower, &stack, &ctr);
>> >> >                         if (err)
>> >> >                                 goto out;
>> >> > +
>> >> > +                       err = ovl_check_metacopy(upperdentry);
>> >> > +                       if (err < 0)
>> >> > +                               goto out;
>> >> > +                       if (err == 1)
>> >> > +                               metacopy = true;
>> >> >                 }
>> >> >
>> >> >                 if (d.redirect) {
>> >> > @@ -716,6 +741,15 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>> >> >                 OVL_I(inode)->redirect = upperredirect;
>> >> >                 if (index)
>> >> >                         ovl_set_flag(OVL_INDEX, inode);
>> >> > +
>> >> > +               if (metacopy) {
>> >> > +                       /*
>> >> > +                        * TODO: What happens we if find metacopy xattr but
>> >> > +                        * could not find/resolve origin.
>> >> > +                        */
>> >>
>> >> Hint: if metacopy could also exist only on an index entry, with no
>> >> upper aliases,
>> >> this index entry would be detected as stale on mount (cannot resolve origin) and
>> >> cleaned, so you won't get to this problem.
>> >
>> > Hi Amir,
>> >
>> > Sorry, I am getting lost here. Can you please explain a bit more.
>> >
>> > My understanding is that index entry is created during copy up only for
>> > files with nlink > 1. If a regular file is copied up there will not be
>> > any index entry.
>> >
>> > And during mount time, you are going through all index entries and
>> > verifying there are no stale entries and cleaning up stale entries.
>> > (ovl_indexdir_cleanup()).
>> >
>> > So is the idea that with metacopyup we create index entries even for
>> > regular files with nlink=1
>>
>> Yes. please cherry-pick 982a78ebd5cd ovl: create ovl_need_index() helper
>> from https://github.com/amir73il/linux/commits/ovl-index-all
>> and then in the patch that introduces metacopy up, return true from
>> ovl_need_index() helper for regular files if ofs->config.metacopy is set
>
> Hi Amir,
>
> Ok. Before I dive into details of that patch, I have a concern about
> creating index of all regular files and verifying them on mount time. Will
> this lead to excessive mount time overhead for a large index. I mean
> in container land, people do mount/unmount of container roots very
> frequently. And paying this verification cost on every mount, can soon
> start showing up and become a concern.

Vivek,

That is a valid concern.
Counter proposal:

Have metacopy depend on index=on but not index every regular file.

This way you still get the assurance that you cannot set inconsistent
origins to 2 broken hardlinks of the same origin, which would break
future mount with index=on.

So counter to what I wrote earlier, has_upper_alias AND !index will
be a valid state.
If you find in lookup an upper with METACOPY and no/stale origin
you return ESTALE.
Note there are several cases where ovl_lookup_index() will return
EIO from lookup for inconsistent index.

>
> With chown(), this will be common case for container use case. All the
> files in the image will be metadata copy up.
>
> Also, is it fine to just cleanup upper files automatically during mount
> time, without any input from users?
>

upper files - probably not without explicit opt-in config, index files - yes.
With index=on, a stale index (i.e. original lower is gone), index may
still have upper aliases and they will not be cleaned up.
The only case where cleaning an index MAY result in data loss for
user is:
- foo and bar are lower hardlinks
- user modifies foo (index is created with new data and linked to upper foo)
- user unlinks foo (upper foo unlinked but index remains)
- reading bar still reads the new data from upper index

Now the index has nlink == 1 and if that index is cleaned on mount, the data
of bar is lost.
However, the only way to get from lower bar to index is by encoding bar
file handle, but if index is stale, it means that bar cannot be found
by file handle.
So unless NFS export ops of lower fs are broken, the stale index is useless
and may be safely cleaned on mount.

Hope this example explains more that it confuses ;)

Amir.
