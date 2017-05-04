From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v4 00/15] overlayfs constant inode numbers
Date: Thu, 4 May 2017 10:24:55 +0200
Message-ID: <CAJfpegss1jrd0LZkCOkaiQe06ECwH0atneVg3xa_YWXiG4UDOw@mail.gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
 <CAJfpegs4SnbHVTa43Wy9R=_3XRMwwnXN9SCKCpq42F-19g9LnQ@mail.gmail.com>
 <CAOQ4uxi4sjY=q4q=kU7vtJEKASUwO9DE3Xa61GMe9wEOHQ-f1g@mail.gmail.com> <CAOQ4uxgprhDhRzWyTEYUaYKdvUeYWNSafreu1r3TA-2r7xg-aA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36389 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdEDIY5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 May 2017 04:24:57 -0400
Received: by mail-io0-f194.google.com with SMTP id x86so2093070ioe.3
        for <linux-unionfs@vger.kernel.org>; Thu, 04 May 2017 01:24:57 -0700 (PDT)
In-Reply-To: <CAOQ4uxgprhDhRzWyTEYUaYKdvUeYWNSafreu1r3TA-2r7xg-aA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, May 3, 2017 at 10:01 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, May 3, 2017 at 6:46 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Wed, May 3, 2017 at 6:43 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Mon, May 1, 2017 at 3:41 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> Miklos,
>>>>
>>>> This is v4 series of redirect by file handle and constant inode numbers.
>>>> this series fixes constant inode numbers for stat(2) for overlayfs
>>>> configuration of all layers on the same fs.
>>>
>>> Great work.
>>>
>>> I did some mutilation (aka. simplification) and pushed the result to
>>> overlayfs-constino.v5
>>>
>
> Simplified indeed!
>
>>> No time to check if it works or not, so probably not...
>
> Oh but it does :-)
> Passed on my tests.
> I pushed branch master of unionmunt-tests for testing constino,
> so you can use that if you like,
> because my overlayfs-devel branch already plays with verify_lower.
>
> Anyway, I see that you relaxed the uuid_is_null() constrain, so now

Wasn't intentional; will restore it...

> you can also test ./run --ov=0 --samefs
> with (default) tmpfs, although that is not really stress testing fh decoding..

Lets just add s_uuid to tmpfs, should be trivial.

>
>>> tomorrow, but if you have time, please feel free to test and review my
>>> changes.
>>>
>>
>
> Reviewed.

Thanks.

>
> Specifically:
> ACK for simplifications of "store file handle of lower inode on copy up"
> ACK for simplifications of "lookup non-dir copy-up-origin by file handle"
>
> One bug here:
>
> +       if (IS_ERR(origin)) {
> +               if (origin == ERR_PTR(-ESTALE))
> +                       origin = NULL;
> +       }
> +       if (ovl_dentry_weird(origin) ||
>
> Should be else if.
> xfstest overlay/019 (fsstress) hits NULL pointer deref at ovl_dentry_weird()
>
> +           ((d_inode(origin)->i_mode ^ d_inode(dentry)->i_mode) & S_IFMT)) {
> +               dput(origin);
> +               origin = NULL;
> +               goto invalid;
> +       }
> +

Right, will fix.

Thanks,
Miklos
