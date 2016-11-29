From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [POC/RFC PATCH] overlayfs: constant inode numbers
Date: Tue, 29 Nov 2016 13:34:01 +0200
Message-ID: <CAOQ4uxhzRkPM6aOkksMsKU1V6tdsUxhObAD938PEUPKYPp6B5Q@mail.gmail.com>
References: <20161125212934.GB2622@veci.piliscsaba.szeredi.hu>
 <CAOQ4uxgSvo_v37aLJb8FK3c5sDqCkN2XWOd783UXaomdVAvsEQ@mail.gmail.com>
 <CAOQ4uxi2Ko-G2nA_bSWT8juuss9aS9ZfiBWS95RrdfBy30Tozg@mail.gmail.com>
 <CAOQ4uxjAODFk2L7d9P+br8wOY9NW5qKH3aaRC=umBfCGPeyxkg@mail.gmail.com>
 <CAJfpegvrRF7ZS+Shx6Q8L2BsbYpX3x3UEXkPn=3oEWs2zMP+eA@mail.gmail.com>
 <CAOQ4uxgSHah2OpbgW2nrDXjwXob=_ypjz9dbmHUO-1QrfwooXg@mail.gmail.com> <CAJfpeguTp4AwcnouMAse1=seG=LboW68eNfRjMiEpeaBjxuYQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36227 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933668AbcK2LeE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Nov 2016 06:34:04 -0500
In-Reply-To: <CAJfpeguTp4AwcnouMAse1=seG=LboW68eNfRjMiEpeaBjxuYQQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, Nov 29, 2016 at 12:16 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, Nov 28, 2016 at 12:56 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
> [...]
>
>
>> Well, not sure if you noticed my redirect_fh (rediect by file handle) work.
>> If differs from redirect by path in 2 major ways:
>> 1. Like OVL_XATTR_INO, redirect is set on copy up (but only for dirs)
>> 2. Lookup is much simpler (and most likely faster) then full path lookup
>>
>> It would be trivial to set oe->ino of merged dir from lower most entry in
>> ovl_lookup().
>
> Okay.  In fact always using the handle looks like a better option
> overall.  File handle should be unique for the lifetime of the
> filesystem, while inode numbers may be reused.
>
> Biggest drawback of the file handle based redirects is exactly that:
> makes backing up the overlay basically impossible, since file handles
> won't work after a backup + restore.  But as an optimization, in
> addition to path based redirects it would work fine and provide a good
> way to get the stable ino.
>

Not sure that I understand what you are suggesting, but I would be happy
to make the needed adjustments to redirect_fh per your request if you clarify
what you mean. From what I understand:

1. If redirect_dir=fh (and supported by layers), store lower handle
    on dir copy up in new xattr OVL_XATTR_FH
2. In ovl_rename(), set OVL_XATTR_REDIRECT regardless of OVL_XATTR_FH
3. In ovl_lookup_single(), carry both d.redirct and d.redirect_fh to next layer
4. In ovl_lookup_layer(), lookup by handle first then by path

Mind you that unlike OVL_XATTR_INO, OVL_XATTR_FH points to *next* inode
rather then *lowest* inode, so it does not really improve anything wrt
getting the
stable inode. Stable inode of merged dir is available after lookup in
oe->lowerstack[oe->numlower - 1].dentry->d_inode->i_ino
regardless of whether lookup was by handle or by path or no redirect at all, so
not sure what you meant by "... and provide a good way to get the stable ino."
Either I managed to confuse you, or I am missing something?

Amir.
