Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180307202708.GK5350@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-9-vgoyal@redhat.com>
 <CAOQ4uxgzJpqcKUr-FkYPEo3pZTG8L6LkNdYJcmm2kdGr2J9Dqg@mail.gmail.com> <20180307202708.GK5350@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 8 Mar 2018 10:43:09 +0200
Message-ID: <CAOQ4uxhLXv-iw-JzWury11X2tVn-mX0JEmig2dJZurHMM+CcCQ@mail.gmail.com>
Subject: Re: [PATCH v12 08/17] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 7, 2018 at 10:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Mar 07, 2018 at 04:42:54PM +0200, Amir Goldstein wrote:
[...]

>> >  static bool ovl_is_opaquedir(struct dentry *dentry)
>> >  {
>> >         return ovl_check_dir_xattr(dentry, OVL_XATTR_OPAQUE);
>> > @@ -242,9 +265,16 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>> >                 goto put_and_out;
>> >         }
>> >         if (!d_can_lookup(this)) {
>> > -               d->stop = true;
>> >                 if (d->is_dir)
>>
>> You need to set d->stop here because this is a non-dir below upper dir.
>
> With metacopy dentry on regular files, we want to do d->stop=true only
> if this is not a metacopy. Otherwise we want to continue to do path
> based lookup in lower layers. That's the whole point of this patch
> series.
>

Yes we do, but the point that yo missed about (d->is_dir) check is that it means
that upper layer was a directory (e.g. upperdir/foo) and underneath it we find
a non-dir (e.g. lowerdir/foo). This is a case were lookup needs to stop and
result in a non-merge pure upper dir.

>>
>> >                         goto put_and_out;
>> > +               err = ovl_check_metacopy_xattr(this);
>> > +               if (err < 0)
>> > +                       goto out_err;
>> > +               if (!err) {
>> > +                       d->stop = true;
>> > +                       d->metacopy = false;
>> > +               } else
>> > +                       d->metacopy = true;
>>
>> Need to have {} in both if and else, but better not use if at all:
>> d->stop = !err;
>> d->metacopy = !!err;
>
> I think I will put {}. Its much easier to read the code that way.

Well, execution branch is less efficient and I don't know if compiler
will optimize it away, but in any case I think d->metacopy = err is
nicer because  ovl_check_metacopy_xattr() returns an error or
an answer to is_metacopy.

[...]

>> > +               /*
>> > +                * For non-dir dentry, make sure dentry found by lookup
>> > +                * matches the origin stored in upper
>> > +                */
>> > +               if (!d.is_dir && upperdentry && !ctr && origin_path) {
>> > +                       err = ovl_verify_origin(upperdentry, this, false);
>> > +                       if (err) {
>> > +                               dput(this);
>> > +                               goto out_put;
>> > +                       }
>> > +               }
>> > +
>>
>> Why is this code duplicated from d.is_dir case?
>
> Primarily because for the case of dir, you are verifying origin only
> if nfs_export is enabled. While I doing this verification even when
> nfs_export is not enabled.

(d.is_dir && ovl_verify_lower(dentry->d_sb)) || (!d.is_dir && origin_path)

The case of verifying dir found by path and file found by found is exactly
the same case. You should just include the new case in the comment above
current code. The idea is to make metacopy lookup as similar as possible
to merge dir lookup, not to have a different code path for it.

>
> So far by default we always installed origin in lowerstack[0] for non-dir.
> Now we are doing lookup for non-dir files and looked up file might
> be different from origin. So we need to make sure file found by lookup
> is same as pointed by origin, otherwise something is not right?
>

[...]

>> > +       } else if (!d.is_dir && upperdentry && !ctr && origin_path) {
>> > +               if (WARN_ON(stack != NULL)) {
>> > +                       err = -EIO;
>> > +                       goto out_put;
>> > +               }
>> > +               stack = origin_path;
>> > +               ctr = 1;
>> > +               origin_path = NULL;
>>
>> I am having a hard time understanding why origin_path is needed at all
>> and why not lookup only by path and then ovl_verify_origin().
>
> Right now we look for non-dir file in lower only if upper is metacopy. So
> if upper is not metacopy, then origin has to be installed in
> lowerstack[0]. That's why I save origin in origin_path, and install it
> in lowerstack[0] when there is no lower.

OK. you don't need to allocate origin_path, because it is limited to stack
size of 1. See how ovl_verify_index() initializes stock and origin vars.

>
> Now other way could be that we lookup for dentry in lower even for
> non-metacopy non-dir files and do ovl_verify_origin(). I think that's
> what you are referring to. But that seems like unnecessary lookup in
> lower. We don't have to do it.
>

Nah, that will require also doing redirect on non-dir without metacopy.

Thanks,
Amir.
