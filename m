Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180402202910.GI23306@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-19-vgoyal@redhat.com>
 <CAOQ4uxhVdgZPpKahSruuGNqYeU8TPn=h4=PGD2vRN7vxcF-FSQ@mail.gmail.com> <20180402202910.GI23306@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 3 Apr 2018 08:44:33 +0300
Message-ID: <CAOQ4uxjESSZp=UfNzFwA9a=ixHDwYDuWBJs0ZjKWOE2_tY4KWQ@mail.gmail.com>
Subject: Re: [PATCH v13 18/28] ovl: Check redirects for metacopy files
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Apr 2, 2018 at 11:29 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 30, 2018 at 01:02:32PM +0300, Amir Goldstein wrote:
>> On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Right now we rely on path based lookup for data origin of metacopy upper.
>> > This will work only if upper has not been renamed. We solved this problem
>> > already for merged directories using redirect. Use same logic for metacopy
>> > files.
>> >
>> > This patch just goes on to check redirects for metacopy files.
>> >
>>
>> The patch changes the logic very subtly, but it is really hard to
>> follow because of convoluted diff. Please make changes that don't
>> change logic in a separate patch.
>>
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > ---
>> >  fs/overlayfs/namei.c | 24 ++++++++++++------------
>> >  1 file changed, 12 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> > index 1dba89e9543f..a7a9588f64b7 100644
>> > --- a/fs/overlayfs/namei.c
>> > +++ b/fs/overlayfs/namei.c
>> > @@ -260,18 +260,19 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>> >                         goto out_err;
>> >                 d->stop = !err;
>> >                 d->metacopy = !!err;
>> > -               goto out;
>> > -       }
>> > -       if (last_element)
>> > -               d->is_dir = true;
>> > -       if (d->last)
>> > -               goto out;
>> > -
>> > -       if (ovl_is_opaquedir(this)) {
>> > -               d->stop = true;
>> > +               if (!d->metacopy)
>> > +                       goto out;
>> > +       } else {
>> >                 if (last_element)
>> > -                       d->opaque = true;
>> > -               goto out;
>> > +                       d->is_dir = true;
>> > +               if (d->last)
>> > +                       goto out;
>>
>> If I am not mistaken, d->last test is relevant to both did and non-dir,
>> because it also prevents the unneeded check redirect.
>
> It is just an optimization which we do only for directories as of now
> and this patch does not change that behavior. For non-dirs we never
> check redirects anyway as of now.

This is a moot argument.
Of course this patch changes behavior.
If adds the ability to redirect non-dir and it should add the same logic as
for dir.

>
> One could argue that this optimization should be introduced for metacopy
> files as well. I could do that. Just that I did not focus too much
> on optimizations a lot. This series has been growing and dragging
> enough, that I want to focus on correctness first. And worry about
> optimizations later.

I hear your frustration, but I think the patch set is progressing very nicely
(and got a few prep patches already in overlayfs-next), so this isn't going
to break you ;-)

 if (!d->metacopy || d->last)
         goto out;

Thanks,
Amir.
