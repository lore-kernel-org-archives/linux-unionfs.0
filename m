From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [WIP][RFC] questions about overlay index dir design
Date: Tue, 23 May 2017 13:04:25 +0300
Message-ID: <CAOQ4uxhMkmKVxnZ+Km0HJTgesCtfkq=RcJcf1A4Cr0ZoaaOSaw@mail.gmail.com>
References: <CAOQ4uxgTG5JhmAb2hQF0ZoyFAfdOCSPDcScNL=8y7xJ1sXiHJg@mail.gmail.com>
 <CAOQ4uxgM6iJEnm8kLhHV6_cmjqN02hhPP20iuZ4eRwaK7+KV=Q@mail.gmail.com> <CAJfpegvUpKh69HTAEN+DUJo3Kwrum_dhmK+jDCOb3LQDCVqVLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34842 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934440AbdEWKE0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 May 2017 06:04:26 -0400
Received: by mail-oi0-f45.google.com with SMTP id l18so194550336oig.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 May 2017 03:04:26 -0700 (PDT)
In-Reply-To: <CAJfpegvUpKh69HTAEN+DUJo3Kwrum_dhmK+jDCOb3LQDCVqVLw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>

On Fri, May 19, 2017 at 5:16 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, May 18, 2017 at 4:15 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, May 18, 2017 at 2:08 AM, Amir Goldstein <amir73il@gmail.com> wrote:

>>> The alternative is to blow away the index dir and recreate it when mounting
>>> with an unverified upperdir. This will work fine for the testsuite, but not for
>>> the obscure users out there using the same workdir to mount with few different
>>> upperdir (not at the same time) - do we care?
>
> Actually, the "at the same time" case is interesting as well.  We
> should probably error out at mount time in that case, instead we
> destroy the first user's work directory.  Not good.
>

You are right. Posted a suggested fix for that:
https://github.com/amir73il/linux/commits/ovl-dir-lock

>>>
>>> I guess the best is to blow away index dir unless user explicitly opted-in
>>> to not blow it away, e.g. by using mount option indexdir= in place of workdir=
>>> (mutually excl.).
>>>
>>
>> Actually, it may make sense to have -o verify_lower control this behavior.
>> Specifying -o verify_lower clearly states the intention of the user to mount
>> overlay layers that were not copied, therefore it makes sense to fail rw mount.
>>
>> OTHO, with this wider meaning, I no longer like the name 'verify_lower',
>> for 2 reasons:
>> 1. It is only used to verify directories
>> 2. It is now also used to verify upper root dir
>>
>> So how about 'verify_dir'/'verify_fh'/'verify_origin'?
>
> Head spins from all these separate functions (snapshot, NFS export,
> hard link unbreaking) and what they need.  There's probably no "one
> size fits all" behavior.  Will need to think about this a bit...
>

Right. So in an effort to make the head spin a bit slower,
I implemented the different VERIFY tests internally with a bitmask -
Currently -o verify_lower is a preset that is equivalent to
-o verify_dir=3 (verify lower merge dir on lookup and verify lower
root dir on mount).

The snapshot functionality of following the decoded merge dir file handle
can be enabled with mount option -o verify_dir=7, but is currently not
in the default -o verify_lower preset.

See: https://github.com/amir73il/linux/commits/ovl-verify-dir

Bigger headache?
In the end, it will give you the flexibility to modify the presets before
applying my patches, let them be configurable or blow  away the internal
bitmask altogether.

Thoughts?
Amir.
