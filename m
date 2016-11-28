From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [POC/RFC PATCH] overlayfs: constant inode numbers
Date: Mon, 28 Nov 2016 13:56:51 +0200
Message-ID: <CAOQ4uxgSHah2OpbgW2nrDXjwXob=_ypjz9dbmHUO-1QrfwooXg@mail.gmail.com>
References: <20161125212934.GB2622@veci.piliscsaba.szeredi.hu>
 <CAOQ4uxgSvo_v37aLJb8FK3c5sDqCkN2XWOd783UXaomdVAvsEQ@mail.gmail.com>
 <CAOQ4uxi2Ko-G2nA_bSWT8juuss9aS9ZfiBWS95RrdfBy30Tozg@mail.gmail.com>
 <CAOQ4uxjAODFk2L7d9P+br8wOY9NW5qKH3aaRC=umBfCGPeyxkg@mail.gmail.com> <CAJfpegvrRF7ZS+Shx6Q8L2BsbYpX3x3UEXkPn=3oEWs2zMP+eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36626 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754097AbcK1L4y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 28 Nov 2016 06:56:54 -0500
In-Reply-To: <CAJfpegvrRF7ZS+Shx6Q8L2BsbYpX3x3UEXkPn=3oEWs2zMP+eA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Nov 28, 2016 at 12:35 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Nov 28, 2016 at 10:10 AM, Amir Goldstein <amir73il@gmail.com> wro=
te:
>>>> @@ -258,12 +268,12 @@ static int ovl_copy_up_locked(struct den
>>>>         if (err)
>>>>                 goto out_cleanup;
>>>>
>>>> -       inode_lock(newdentry->d_inode);
>>>>         err =3D ovl_set_attr(newdentry, stat);
>>>> -       inode_unlock(newdentry->d_inode);
>>>>         if (err)
>>>>                 goto out_cleanup;
>>>>
>>>> +       ovl_dentry_set_ino(dentry, stat->ino);
>>>> +
>>>
>>>
>>
>> Shouldn't we propagate stored ino all the way
>> from lowest layer to preserve ino across layer recycling?
>
> Since OVL_XATTR_INO is set every time we copy-up, layer recycling
> should work fine.
>

Right. I knew it should be there somewhere, but miss-read the copy up code.

> Exception is overlay root, where there's no copy-up, so no
> preservation of ino.  Not sure what the right solution there is.
>
>>
>> Specifically, shouldn't ino of merged dir expose the lower most ino?
>
> It should.
>
>
>>>> @@ -353,11 +354,45 @@ static struct ovl_dir_cache *ovl_cache_g
>>>>         return cache;
>>>>  }
>>>>
>>>> +static int ovl_cache_entry_update_ino(struct dentry *dir,
>>>> +                                     struct ovl_cache_entry *p)
>>>> +
>>>> +{
>>>> +       struct dentry *this;
>>>> +       struct dentry *base =3D ovl_dentry_at_idx(dir, p->idx);
>>>> +
>>>> +       if (p->name[0] =3D=3D '.') {
>>>> +               if (p->len =3D=3D 1) {
>>>> +                       this =3D dget(base);
>>>> +                       goto get;
>>>> +               }
>>>> +               if (p->len =3D=3D 2 && p->name[1] =3D=3D '.') {
>>>> +                       /* =E2=99=AB we shall not be moved */
>>>> +                       this =3D dget(ovl_dentry_real(dir->d_parent));
>>>> +                       goto get;
>>>> +               }
>>>> +       }
>>>> +       this =3D lookup_one_len_unlocked(p->name, base, p->len);
>>>> +       if (IS_ERR(this)) {
>>>> +               pr_err("overlay: failed to look up (%s) for ino (%i)\n=
",
>>>> +                      p->name, (int) PTR_ERR(this));
>>>> +               return -EIO;
>>>> +       }
>>>>
>>>> +       get:
>>>> +       p->ino =3D p->orig_ino;
>>>> +       ovl_get_ino(this, &p->ino);
>>
>> I may be way off here, but why do you need to lookup entry and get ino
>> from xattr at all? Wouldn't it be easier to not add the entry to the lis=
t if
>> it was copied up and rely on the fact that it will be added to list in i=
ter
>> of lower layer with original ino with no extra effort?
>
> What about renamed entries?

Right. I completely missed out on the rename case..

> What about opaque ones?

That's exactly the point of OVL_XATTR_INO IFF !OVL_XATTR_OPAQUE
If you have OVL_XATTR_INO means entry cannot be opaque, so it should
be safe to skip it

>
> I do hope we can optimize directory reading, because doing lookup and
> getxattr for all entries is going to hurt...
>

Possibly silly question:
Do you know if programs really rely of d_ino from getdents to be sane/non-z=
ero?
And what are the implications of overlayfs readdir not exporting the real d=
_ino?

For example, findutils seems to be ok with zero d_ino and just uses non-zer=
o
d_ino for optimization:

commit 2bf001636e66789560ef1d2509c117f78b6cd06f
Author: James Youngman <jay@gnu.org>
Date:   Sat Mar 7 20:16:49 2009 +0000

    Optimise away calls to stat if all we need is the inode number (bug #24=
342).


>> For that matter, I like the fact that every copied up entry will be expl=
icitly
>> marked with OVL_XATTR_INO. In a way, it is the opposite of
>> OVL_XATTR_OPAQUE and if the former becomes a standard, the latter
>> will become redundant. Arguably, it is preferred to mark the copy ups
>> as special case rather then the pure upper files, which can then stay 'p=
ure'.
>
> Maybe.
>
>
>>>> @@ -502,7 +549,8 @@ static int ovl_dir_open(struct inode *in
>>>>                 return PTR_ERR(realfile);
>>>>         }
>>>>         od->realfile =3D realfile;
>>>> -       od->is_real =3D !OVL_TYPE_MERGE(type);
>>>> +//     od->is_real =3D !OVL_TYPE_MERGE(type);
>>>> +       od->is_real =3D false;
>>
>>
>> A major change of framing would be to treat regular file entries as merg=
ed
>> if they have been ever copied up and opaque only if they are pure upper.
>> Same as dirs.
>>
>> This would also allow keeping ino stable across rename/redirect of regul=
ar
>> files. Not sure if any programs rely on that??
>
> We do keep ino stable across rename.  We don't keep ino stable across
> copy-up.  That's what this patch is trying to address.
>
> You are saying that we should have redirects for non-dir and drop
> OVL_XATTR_INO?  That's another option, but it doesn't look like it
> would simplify things...
>

Well, not sure if you noticed my redirect_fh (rediect by file handle) work.
If differs from redirect by path in 2 major ways:
1. Like OVL_XATTR_INO, redirect is set on copy up (but only for dirs)
2. Lookup is much simpler (and most likely faster) then full path lookup

It would be trivial to set oe->ino of merged dir from lower most entry in
ovl_lookup().

So while I cannot justify non-dir redirect in favor of OVL_XATTR_INO,
I do see a big value for redirect by file handle for directories, which can
provide the non-readdir part of stable directory inode as by-product.

> Thanks for the revirew.
>
> Pushed patch to #overlayfs-constino (needs work but it's worth testing).
>

Thanks. I'll get to testing this later this week and will do my best to dra=
ft a
quick xfstest for this as well.

Amir.
