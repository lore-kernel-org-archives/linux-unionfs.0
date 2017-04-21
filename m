From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Overlayfs reverse mapping
Date: Fri, 21 Apr 2017 22:04:52 +0300
Message-ID: <CAOQ4uxiBKku_jh8bbCvB1L9TytdcqDUuJSnjCREsc+nacYngtw@mail.gmail.com>
References: <CAOQ4uxid0C3PLnfopBWAtWkNqyuMkickoUrZzDmj6-bEOWCDcA@mail.gmail.com>
 <CAJfpegtWH0P87mYMRB+sLpa0RSOVjvo4Ph1DH8E41UJiyJjiKw@mail.gmail.com>
 <CAOQ4uxhTaY4N5_02kg+5fK0nYLFyEKVVFfWtO5AeC33Qc7CNDw@mail.gmail.com>
 <CAJfpegv7kR-zDaE2wfD5e=_yUVnxDLMe28okMm3tTrURjLT1XQ@mail.gmail.com> <5399.1492800261@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34423 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424496AbdDUTEx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Apr 2017 15:04:53 -0400
Received: by mail-oi0-f41.google.com with SMTP id x184so108843842oia.1
        for <linux-unionfs@vger.kernel.org>; Fri, 21 Apr 2017 12:04:53 -0700 (PDT)
In-Reply-To: <5399.1492800261@jrobl>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "J. R. Okajima" <hooanon05g@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Apr 21, 2017 at 9:44 PM, J. R. Okajima <hooanon05g@gmail.com> wrote:
> Miklos Szeredi:
>> OTOH lost+found is just a plain old directory that is handled by
>> userspace tools only.  No kernel fs driver treats /lost+found
>> specially.  So putting this in upperdir would be a namespace pollution
>> issue and generally we'd like to avoid that.  Aufs has lived with that
>> sort of thing, and probably it wouldn't be a problem in practice.  But
>
> ??
> As far as I know, aufs doesn't handle lost+found specially, but the
> layer fs handles. What is the "namespace pollution" you call?
>

That would be names of files reserved for use by fs that user
cannot use (i.e. .wh. files). Miklos did not  mean that aufs handles
lost+found, but that it lives without a problem with reserved filenames.

Anyway, I do agree that avoiding namespace pollution should be
avoided if possible.

Cheers,
Amir.
