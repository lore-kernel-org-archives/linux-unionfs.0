Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180402194514.GG23306@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-11-vgoyal@redhat.com>
 <CAOQ4uxiO8fRn6TB54SANB4cp4uURDJ6wQVNT8mF29nH67F7M+A@mail.gmail.com>
 <CAOQ4uxhouT+uR0sZEd+gn7cGkcRUxc46us2-m5gwzQbAGfFnaA@mail.gmail.com> <20180402194514.GG23306@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 2 Apr 2018 23:07:52 +0300
Message-ID: <CAOQ4uxhQ5HYS5GaK7VzdbxvYSFvOwDRm_Y6oxWWq-vm_-XvDnw@mail.gmail.com>
Subject: Re: [PATCH v13 10/28] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Apr 2, 2018 at 10:45 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 30, 2018 at 12:12:18PM +0300, Amir Goldstein wrote:
>> On Fri, Mar 30, 2018 at 8:49 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> > On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> This patch modifies ovl_lookup() and friends to lookup metacopy dentries.
>> >> It also allows for presence of metacopy dentries in lower layer.
>> >>
>> >> During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
>> >> set OVL_UPPERDATA bit in flags.
>> >>
>> >> We don't support metacopy feature with nfs_export. So in nfs_export code,
>> >> we set OVL_UPPERDATA flag set unconditionally if upper inode exists.
>> >>
>> >> Do not follow metacopy origin if we find a metacopy only inode and metacopy
>> >> feature is not enabled for that mount. Like redirect, this can have security
>> >> implications where an attacker could hand craft upper and try to gain
>> >> access to file on lower which it should not have to begin with.
>> >>
>> >> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> >> ---
>> [...]
>>
>> >> @@ -917,16 +929,35 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>> >>                  * When "verify_lower" feature is enabled, do not merge with a
>> >>                  * lower dir that does not match a stored origin xattr. In any
>> >>                  * case, only verified origin is used for index lookup.
>> >> +                *
>> >> +                * For non-dir dentry, make sure dentry found by lookup
>> >> +                * matches the origin stored in upper. Otherwise its an
>> >> +                * error.
>> >>                  */
>> >> -               if (upperdentry && !ctr && ovl_verify_lower(dentry->d_sb)) {
>> >> +               if (upperdentry && !ctr &&
>> >> +                   ((d.is_dir && ovl_verify_lower(dentry->d_sb)) ||
>> >> +                    (!d.is_dir && origin_path))) {
>> >>                         err = ovl_verify_origin(upperdentry, this, false);
>> >>                         if (err) {
>> >>                                 dput(this);
>> >> -                               break;
>> >> +                               if (d.is_dir)
>> >> +                                       break;
>> >> +                               goto out_put;
>> >>                         }
>> >> -
>> >>                         /* Bless lower dir as verified origin */
>> >> -                       origin = this;
>> >> +                       if (d.is_dir)
>> >> +                               origin = this;
>> >
>> > It's ok to bless verified non-dir as well.
>> > It is going to be blesses anyway, just above index lookup if ctr > 0.
>>
>> >
>> >> +               }
>> >> +
>> >> +               if (d.metacopy)
>> >> +                       metacopy = true;
>> >> +               /*
>> >> +                * Do not store intermediate metacopy dentries in chain,
>> >> +                * except top most lower metacopy dentry
>> >> +                */
>> >> +               if (d.metacopy && ctr) {
>> >> +                       dput(this);
>> >> +                       continue;
>> >>                 }
>> >>
>> >>                 stack[ctr].dentry = this;
>> >> @@ -960,6 +991,34 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>> >>                 }
>> >>         }
>> >>
>> >> +       if (metacopy) {
>> >> +               BUG_ON(d.is_dir);
>> >
>> > Yeh, I think that is really a bug, because you need to detect
>> > the case of dir in lower layer under metacopy in upper layer
>> > and do something about it.
>> >
>> >> +               /*
>> >> +                * Found a metacopy dentry but did not find corresponding
>> >> +                * data dentry
>> >> +                */
>> >> +               if (d.metacopy) {
>> >> +                       err = -ESTALE;
>> >> +                       goto out_put;
>> >> +               }
>> >> +
>> >> +               err = -EPERM;
>> >> +               if (!ofs->config.metacopy) {
>> >> +                       pr_warn_ratelimited("overlay: refusing to follow"
>> >> +                                           " metacopy origin for (%pd2)\n",
>> >> +                                           dentry);
>> >> +                       goto out_put;
>> >> +               }
>>
>> in (!origin_path) lower was followed by name/redirect and not
>> verified by origin, we should not lookup index of non-dir below.
>> Right now non-dir index entries assume that origin xattr exists
>> and matches the entry name. We may be able to relax that in
>> the future using non-dir redirect, but we are not there yet.
>
> Ok.
>
>>
>>
>> >> +       } else if (!d.is_dir && upperdentry && !ctr && origin_path) {
>> >> +               if (WARN_ON(stack != NULL)) {
>> >> +                       err = -EIO;
>> >> +                       goto out_put;
>> >> +               }
>> >> +               stack = origin_path;
>> >> +               ctr = 1;
>> >> +               origin_path = NULL;
>> >> +       }
>> >> +
>> >>         /*
>> >>          * Lookup index by lower inode and verify it matches upper inode.
>> >>          * We only trust dir index if we verified that lower dir matches
>>          * origin, otherwise dir index entries may be inconsistent and we
>>          * ignore them. Always lookup index of non-dir and non-upper.
>>          */
>>         if (ctr && (!upperdentry || !d.is_dir))
>>                 origin = stack[0].dentry;
>>
>> So this condition needs to be fixed.
>
> Ok, So I could make it like the case of directory. That is for
> metacopy files bless origin only if it was verified and modify
> above condiiton as follows.
>
>          if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
>                  origin = stack[0].dentry;
>
> That way for a metcopy dentry we will search for index only if
> origin was verified.
>

Correct.

Thanks,
Amir.
