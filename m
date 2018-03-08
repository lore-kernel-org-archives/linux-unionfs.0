Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180307185207.GH5350@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-14-vgoyal@redhat.com>
 <CAOQ4uxgLiSNpQq0AE2aXdH3zMCPsdCNgxYtp71CauuGgrd20TQ@mail.gmail.com> <20180307185207.GH5350@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 8 Mar 2018 10:55:25 +0200
Message-ID: <CAOQ4uxiNOSFQ-bk1n7=q3inxwVByJDptr=7OD5E4CdLPhEFENA@mail.gmail.com>
Subject: Re: [PATCH v12 13/17] ovl: Check redirects for metacopy files
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 7, 2018 at 8:52 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Mar 07, 2018 at 02:16:25PM +0200, Amir Goldstein wrote:
>> On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Right now we rely on path based lookup for data origin of metacopy upper.
>> > This will work only if upper has not been renamed. We solved this problem
>> > already for merged directories using redirect. Use same logic for metacopy
>> > files.
>> >
>> > This patch just goes on to check redirects for metacopy files.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > ---
>> >  fs/overlayfs/namei.c | 17 ++++++++---------
>> >  1 file changed, 8 insertions(+), 9 deletions(-)
>> >
>> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> > index 220e754c974b..a4a5c5f5540d 100644
>> > --- a/fs/overlayfs/namei.c
>> > +++ b/fs/overlayfs/namei.c
>> > @@ -265,22 +265,22 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>> >                 goto put_and_out;
>> >         }
>> >         if (!d_can_lookup(this)) {
>> > -               if (d->is_dir)
>> > -                       goto put_and_out;
>> > +               d->is_dir = false;
>>
>> That test was supposed to catch non-dir under dir from an upper layer
>> but you are loosing the information stored in d->dir.
>>
> Can you elaborate a bit more. I never understood this check.
>
> This probably worked in the past. But now absolute redirects can be put
> on regular files as well. So it is very much possible that d->is_dir
> is set and then we find a non-dir dentry and in that case we don't
> want to jump to "put_and_out"?
>
> IOW, this check worked as long as redirects were supposed to be used
> only for directories. Now with metacopy, redirects can be put on on
> non-dir as well.
>
> What I can probably do is that leave d->is_dir untouched. But not sure
> what does that buy us. When we return back to ovl_lookup() it does not
> mean anything. returned dentry could be a directory or non-directory.
>
> If we set it to d->is_dir=false, atleast this info is meaningful in
> ovl_lookup and we know if returned dentry is a direcotry or non-dir.

d->is_dir means that layer above was a directory if you find non-dir underneath
a directory, lookup should stop.

>
>> >                 err = ovl_check_metacopy_xattr(this);
>> >                 if (err < 0)
>> >                         goto out_err;
>> >                 if (!err) {
>> >                         d->stop = true;
>> >                         d->metacopy = false;
>> > +                       goto out;
>> >                 } else
>> >                         d->metacopy = true;
>> > -               goto out;
>> > -       }
>> > -       d->is_dir = true;
>> > -       if (!d->last && ovl_is_opaquedir(this)) {
>> > -               d->stop = d->opaque = true;
>> > -               goto out;
>> > +       } else {
>> > +               d->is_dir = true;
>> > +               if (!d->last && ovl_is_opaquedir(this)) {
>> > +                       d->stop = d->opaque = true;
>> > +                       goto out;
>>
>> I think there is a bug here - not related to your change, but semi related
>> to your recent fix patch (patch 1 in this series).
>>
>> d->last is set to true when lookup in parent poe->numlower layer,
>> but parent may be pure upper for example and redirect from child can still
>> continue lookup to lower layers. If a directory is marked both "redirect" and
>> "opaque" (which is an inconsistency). In that case, d->last will be true
>> and opaque xattr will not be checked, but redirect will be checked.
>
> I am not sure I understand the concern. d->last will be set only if this
> is last layer we are looking into and in that case it does not matter if
> we process opaque or not.
>
> Say we had pure upper parent and child directory had both opaque and redirect
> set. If redirect is relative, then we will not even search in lower pas
> poe->numlower=0. If redirect is absolute, then poe is reset to roe and we
> will start searching from root and d->last will be set when searching in
> last layer.
>
> So I can't see what's the issue. Can you give an example.
>

/upperdir/pure (opaque=y)
/upperdir/pure/foo (opaque=y,redirect=/bar)
/lowerdir/bar (redirect=blah)

/pure/foo is both opaque and redirect and poe->numlower == 0 so d->last is true.

In this case (which is an inconsistency) /upperdir/pure/foo *will* be
merged with
/lowerdir/bar and I don't think that redirect should overrule opaque, but the
other way around.

It is also worth noting that we do not optimize away checking redirect on
/lowerdir/bar exactly because we d->last is not set correctly.
If we set d.last = lower.layer->idx == roe->numlower - 1
then is will be correct to optimize away both opaque and redirect checks
for d->last true case.

If this is not clear enough I will send out a patch.

Thanks,
Amir.
