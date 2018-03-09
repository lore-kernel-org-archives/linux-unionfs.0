Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180309144431.GC4596@redhat.com>
References: <20180308221804.15708-1-vgoyal@redhat.com> <20180308221804.15708-4-vgoyal@redhat.com>
 <CAOQ4uxjXWE57eZoGzytqjHVon=x4Q5Xu1oXb_z5CNsAuowVN_g@mail.gmail.com> <20180309144431.GC4596@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 9 Mar 2018 17:20:30 +0200
Message-ID: <CAOQ4uxjLg3wOSssZFJu4kzQSaD2BrC0oTXcSBLYP4PFnggJFxQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: set d->is_dir and d->opaque for last path element
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 9, 2018 at 4:44 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 09, 2018 at 12:34:57AM +0200, Amir Goldstein wrote:
>> On Fri, Mar 9, 2018 at 12:18 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Certain properties in ovl_lookup_data should be set only for the last
>> > element of the path. IOW, of we are calling ovl_lookup_single() for an
>> > absolute redirect, then d->is_dir and d->opaque do not make much sense
>> > for intermediate path elements. Instead set them only if dentry being
>> > lookup is last path element.
>>
>> Yeh, that's what I said, but I realized later that this is not accurate.
>> it's true for d->is_dir, but not true for d->opaque.
>> opaqueness of path elements *can* determine that the redirect result is
>> opaque, for example when redirecting to /a/b/c and /a is opaque, then
>> the resolved redirection is opaque *unless* either /a/b or /a/b/c has
>> an absolute redirect to escape the opaqueness of /a.
>
> Hi Amir,
>
> I am not sure I understand this argument about "opaque". Why opaqueness
> of parent matters to child. Can you please give an example.
>

upper:  /redirect (redirect=/a/b/c)
lower1: /a/[b]/c       ([b] is opaque)
lower0: /a/b/c/foo

upper /redirect was created by 'mv /mnt/a/b/c/ /mnt/redirect'
before rename /mnt/a/b/c did not contain 'foo' because /mnt/a/b
is not a merge dir and therefore neither is /mnt/a/b/c.
after rename /redirect should not contain 'foo' as well.
This is handles by ovl_lookup_layer() when iterating absolute
redirect element [b] d->opaque is set in the lookup state.

The fix I sent for the case where /a/[b]/c is again an absolute
redirect (say to /a/b/c in lower0) and that *should* results in
the merge dir containing 'foo'.

Not easy...

Thanks,
Amir.
