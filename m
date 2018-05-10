Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180510131428.GA2728@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com> <20180507174102.24086-11-vgoyal@redhat.com>
 <CAJfpegvzDAMx66TMhHTacYEUpowRcEYKkFuhD+TQoV83MfXPmQ@mail.gmail.com> <20180510131428.GA2728@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 10 May 2018 17:43:10 +0300
Message-ID: <CAOQ4uxiEWEBSDChH5zq04_7r7WHOgCACvJb0R3oejRsJ=MSR_w@mail.gmail.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 10, 2018 at 4:14 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, May 10, 2018 at 11:19:23AM +0200, Miklos Szeredi wrote:
>> On Mon, May 7, 2018 at 7:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > This patch modifies ovl_lookup() and friends to lookup metacopy dentries.
>> > It also allows for presence of metacopy dentries in lower layer.
>> >
>> > During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
>> > set OVL_UPPERDATA bit in flags.
>> >
>> > We don't support metacopy feature with nfs_export. So in nfs_export code,
>> > we set OVL_UPPERDATA flag set unconditionally if upper inode exists.
>> >
>> > Do not follow metacopy origin if we find a metacopy only inode and metacopy
>> > feature is not enabled for that mount. Like redirect, this can have security
>> > implications where an attacker could hand craft upper and try to gain
>> > access to file on lower which it should not have to begin with.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > ---
[...]

>> > @@ -925,18 +943,36 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>> >                  * When "verify_lower" feature is enabled, do not merge with a
>> >                  * lower dir that does not match a stored origin xattr. In any
>> >                  * case, only verified origin is used for index lookup.
>> > +                *
>> > +                * For non-dir dentry, make sure dentry found by lookup
>> > +                * matches the origin stored in upper. Otherwise its an
>> > +                * error.
>>
>> Umm, why we need to be so strict?  This would  break the case where
>> the layers are copied with xattr intact, but the origin pointer will
>> obviously be "wrong", which shouldn't be a problem, since that's only
>> needed to get a unique st_ino, nothing else.
>
> Hmm...., right this breaks the case of copied up layer. The very reason
> we moved to using path based lookup for metacopy data dentry.
>
> So if we have a origin on upper for metacopy file which does not match
> lower dentry found using path based lookup, we can ignore the origin
> information and don't lookup for index either. That also means that
> inode will be reported of upper. Given we will not use index, that
> probably will mean broken hardlinks and some strange corner cases. I will
> make this change and run the tests on copied layers and see what breaks.
>
>

OK, so maybe just relax below to:

>>
>> >                  */
>> > -               if (upperdentry && !ctr && ovl_verify_lower(dentry->d_sb)) {
>> > +               if (upperdentry && !ctr &&
>> > +                   ((d.is_dir && ovl_verify_lower(dentry->d_sb)) ||
>> > +                    (!d.is_dir && origin_path))) {
>> >                         err = ovl_verify_origin(upperdentry, this, false);
>> >                         if (err) {
>> >                                 dput(this);
>> > -                               break;
>> > +                               if (d.is_dir)
>> > +                                       break;

+                                       else if (ovl_verify_lower(dentry->d_sb))
+                                             goto out_put;

>> >                         }
+                           } else {
>> > -
>> > -                       /* Bless lower dir as verified origin */
>> > +                       /* Bless lower as verified origin */
>> >                         origin = this;

+                           }
>> >                 }

So at least we have the correct logic in place w.r.t
ovl_verify_lower() (i.e. don't follow unverified origin)
even though this feature is only enabled for nfs_export
and metacopy does not yet mix with nfs_export.

Thanks,
Amir.
