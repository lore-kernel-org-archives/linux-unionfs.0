From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [POC/RFC PATCH] overlayfs: constant inode numbers
Date: Mon, 5 Dec 2016 16:05:24 +0200
Message-ID: <CAOQ4uxjT8Vprx9zNXkJ7pv+OvgB7yU8LW=Ge=WiQBd5jmNMGDg@mail.gmail.com>
References: <20161125212934.GB2622@veci.piliscsaba.szeredi.hu>
 <CAOQ4uxgSvo_v37aLJb8FK3c5sDqCkN2XWOd783UXaomdVAvsEQ@mail.gmail.com>
 <CAOQ4uxi2Ko-G2nA_bSWT8juuss9aS9ZfiBWS95RrdfBy30Tozg@mail.gmail.com>
 <CAOQ4uxjAODFk2L7d9P+br8wOY9NW5qKH3aaRC=umBfCGPeyxkg@mail.gmail.com>
 <CAJfpegvrRF7ZS+Shx6Q8L2BsbYpX3x3UEXkPn=3oEWs2zMP+eA@mail.gmail.com>
 <CAOQ4uxgSHah2OpbgW2nrDXjwXob=_ypjz9dbmHUO-1QrfwooXg@mail.gmail.com>
 <CAJfpeguTp4AwcnouMAse1=seG=LboW68eNfRjMiEpeaBjxuYQQ@mail.gmail.com>
 <CAOQ4uxhzRkPM6aOkksMsKU1V6tdsUxhObAD938PEUPKYPp6B5Q@mail.gmail.com>
 <CAOQ4uxj2yMwY_eCdc0+6U0QP1ckm5aPw5x6xtMz+WdHvJ4bFTg@mail.gmail.com> <CAJfpegtRNQAebLbz2F2zV8asqt31m7Lrgc+ya28UZU1e8E1oEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:36191 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbcLEOFo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Dec 2016 09:05:44 -0500
In-Reply-To: <CAJfpegtRNQAebLbz2F2zV8asqt31m7Lrgc+ya28UZU1e8E1oEw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, Nov 29, 2016 at 11:49 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Nov 29, 2016 at 1:03 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Tue, Nov 29, 2016 at 1:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:

...
>>> Not sure that I understand what you are suggesting, but I would be happy
>>> to make the needed adjustments to redirect_fh per your request if you clarify
>>> what you mean. From what I understand:
>>>
>>> 1. If redirect_dir=fh (and supported by layers), store lower handle
>>>     on dir copy up in new xattr OVL_XATTR_FH
>>> 2. In ovl_rename(), set OVL_XATTR_REDIRECT regardless of OVL_XATTR_FH
>>> 3. In ovl_lookup_single(), carry both d.redirct and d.redirect_fh to next layer
>>> 4. In ovl_lookup_layer(), lookup by handle first then by path
>>>

Miklos,

FYI, this part of the work is done and pushed to #redirect_fh branch
on my github.
It is tested on same and not same fs and it is used as the base of
current #ovl_snapshot
branch and tested along with it.

>>> not sure what you meant by "... and provide a good way to get the stable ino."
>>> Either I managed to confuse you, or I am missing something?
>
> I meant that we can unify OVL_XATTR_INO  with "redirect/fh"
> functionality and get something good out of it.
>
>> Perhaps you meant for non-dir:
>>
>> 5. If redirect_dir=fh, *propagate* lowest-handle on non-dir copy up
>> 6. In ovl_lookup() of non-dir, decode lowest-handle to set oe->ino
>
> Yes.
>
> OVL_XATTR_FH would be safe to ignore, so this is back and forward
> compatible..  And the cost is probably not prohitive, since copy ups
> should be relatively rare.
>

I am still trying to figure out the best way of "getting something good"
out of this merger, because changing ovl_getattr() to use redirect_fh
instead of stored ino is not such a big win.

More thought are welcome.

Amir.
