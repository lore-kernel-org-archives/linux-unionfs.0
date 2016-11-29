From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [POC/RFC PATCH] overlayfs: constant inode numbers
Date: Tue, 29 Nov 2016 11:16:37 +0100
Message-ID: <CAJfpeguTp4AwcnouMAse1=seG=LboW68eNfRjMiEpeaBjxuYQQ@mail.gmail.com>
References: <20161125212934.GB2622@veci.piliscsaba.szeredi.hu>
 <CAOQ4uxgSvo_v37aLJb8FK3c5sDqCkN2XWOd783UXaomdVAvsEQ@mail.gmail.com>
 <CAOQ4uxi2Ko-G2nA_bSWT8juuss9aS9ZfiBWS95RrdfBy30Tozg@mail.gmail.com>
 <CAOQ4uxjAODFk2L7d9P+br8wOY9NW5qKH3aaRC=umBfCGPeyxkg@mail.gmail.com>
 <CAJfpegvrRF7ZS+Shx6Q8L2BsbYpX3x3UEXkPn=3oEWs2zMP+eA@mail.gmail.com> <CAOQ4uxgSHah2OpbgW2nrDXjwXob=_ypjz9dbmHUO-1QrfwooXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36384 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755526AbcK2KQi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Nov 2016 05:16:38 -0500
Received: by mail-oi0-f65.google.com with SMTP id u15so17627703oie.3
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Nov 2016 02:16:38 -0800 (PST)
In-Reply-To: <CAOQ4uxgSHah2OpbgW2nrDXjwXob=_ypjz9dbmHUO-1QrfwooXg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Nov 28, 2016 at 12:56 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Nov 28, 2016 at 12:35 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, Nov 28, 2016 at 10:10 AM, Amir Goldstein <amir73il@gmail.com> wrote:

[...]

>>> I may be way off here, but why do you need to lookup entry and get ino
>>> from xattr at all? Wouldn't it be easier to not add the entry to the list if
>>> it was copied up and rely on the fact that it will be added to list in iter
>>> of lower layer with original ino with no extra effort?
>>
>> What about renamed entries?
>
> Right. I completely missed out on the rename case..
>
>> What about opaque ones?
>
> That's exactly the point of OVL_XATTR_INO IFF !OVL_XATTR_OPAQUE
> If you have OVL_XATTR_INO means entry cannot be opaque, so it should
> be safe to skip it

So that means if OVL_XATTR_OPAQUE is set then we don't need to check
OVL_XATTR_INO and if OVL_XATTR_INO is set we don't need to check
OVL_XATTR_OPAQUE.   But that doesn't help optimize readdir, because we
really want to check neither.


>> I do hope we can optimize directory reading, because doing lookup and
>> getxattr for all entries is going to hurt...
>>
>
> Possibly silly question:
> Do you know if programs really rely of d_ino from getdents to be sane/non-zero?
> And what are the implications of overlayfs readdir not exporting the real d_ino?

I don't know of any precedent, so it's a big unknown.

>> We do keep ino stable across rename.  We don't keep ino stable across
>> copy-up.  That's what this patch is trying to address.
>>
>> You are saying that we should have redirects for non-dir and drop
>> OVL_XATTR_INO?  That's another option, but it doesn't look like it
>> would simplify things...

There *is* actually a case where both 'opaque' and 'ino' make sense:
when an empty merged dir is exchanged for an empty opaque one in
ovl_clear_empty().

> Well, not sure if you noticed my redirect_fh (rediect by file handle) work.
> If differs from redirect by path in 2 major ways:
> 1. Like OVL_XATTR_INO, redirect is set on copy up (but only for dirs)
> 2. Lookup is much simpler (and most likely faster) then full path lookup
>
> It would be trivial to set oe->ino of merged dir from lower most entry in
> ovl_lookup().

Okay.  In fact always using the handle looks like a better option
overall.  File handle should be unique for the lifetime of the
filesystem, while inode numbers may be reused.

Biggest drawback of the file handle based redirects is exactly that:
makes backing up the overlay basically impossible, since file handles
won't work after a backup + restore.  But as an optimization, in
addition to path based redirects it would work fine and provide a good
way to get the stable ino.

Thanks,
Miklos
