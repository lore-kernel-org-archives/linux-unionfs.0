Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180308170343.GB2732@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-9-vgoyal@redhat.com>
 <CAOQ4uxgzJpqcKUr-FkYPEo3pZTG8L6LkNdYJcmm2kdGr2J9Dqg@mail.gmail.com>
 <20180307202708.GK5350@redhat.com> <CAOQ4uxhLXv-iw-JzWury11X2tVn-mX0JEmig2dJZurHMM+CcCQ@mail.gmail.com>
 <20180308170343.GB2732@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 8 Mar 2018 19:54:26 +0200
Message-ID: <CAOQ4uxj8ZzuVw9SmEc+Vu_FVeESvve-MffrPgs2tf1sD=2rRew@mail.gmail.com>
Subject: Re: [PATCH v12 08/17] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 8, 2018 at 7:03 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Mar 08, 2018 at 10:43:09AM +0200, Amir Goldstein wrote:
>> On Wed, Mar 7, 2018 at 10:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > On Wed, Mar 07, 2018 at 04:42:54PM +0200, Amir Goldstein wrote:
>> [...]
>>
>> >> >  static bool ovl_is_opaquedir(struct dentry *dentry)
>> >> >  {
>> >> >         return ovl_check_dir_xattr(dentry, OVL_XATTR_OPAQUE);
>> >> > @@ -242,9 +265,16 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>> >> >                 goto put_and_out;
>> >> >         }
>> >> >         if (!d_can_lookup(this)) {
>> >> > -               d->stop = true;
>> >> >                 if (d->is_dir)
>> >>
>> >> You need to set d->stop here because this is a non-dir below upper dir.
>> >
>> > With metacopy dentry on regular files, we want to do d->stop=true only
>> > if this is not a metacopy. Otherwise we want to continue to do path
>> > based lookup in lower layers. That's the whole point of this patch
>> > series.
>> >
>>
>> Yes we do, but the point that yo missed about (d->is_dir) check is that it means
>> that upper layer was a directory (e.g. upperdir/foo) and underneath it we find
>> a non-dir (e.g. lowerdir/foo). This is a case were lookup needs to stop and
>> result in a non-merge pure upper dir.
>
> But d->is_dir does not necessarily reflect the state of upper. It
> reflects the state of last found dentry. And in case of redirect, last
> found dentry can very well be parent of current dentry.
>
> For example, say you have upperdir/foo and it has redirect set to
> lowerdir/bar/bar-child.txt. Now, by the time we find bar-child.txt
> d->is_dir is always true because it reflects the state of parent "bar"
> dentry which is always directory. I mean it does not reflect state
> of upperdir/foo. And that state is already lost.
>
> If we really want to make sure that we don't merge upper dir with lower
> non-dir, then we need to do this check in ovl_lookup() and not in
> ovl_lookup_single(), IMHO.
>

Maybe. need to see a patch.

Currently, d->is_dir can be used to stop merge dir lookup,
but with introduction of a merge-non-dir (i.e. metacopy)
ovl_lookup_layer() is broken, because it looses previous layer
d->is_dir information while doing absolute path lookup.

If I am not mistaken, it looks like ovl_lookup_layer() is already
broken w.r.t d->opaque. It should not be setting d->opaque
when doing ovl_lookup_single() on a non-last path element
if it find an opaquedir.

You can tell if ovl_lookup_single() is being called for a last path
element from ovl_lookup_layer() if 'post' is an empty string.
You can use that to determine if you need to set d->is_dir for
directory and d->stop for non-dir if (d->is_dir).

I lean towards getting the semantics of ovl_lookup_layer()
ovl_lookup_single() and the ovl_lookup_data state adjusted
to metacopy lookup and getting rid of the hidden assumptions
that are inside current code.

Thanks,
Amir.
