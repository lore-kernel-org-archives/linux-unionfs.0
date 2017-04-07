From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/6] ovl: consistent_fd feature
Date: Fri, 7 Apr 2017 14:04:09 +0300
Message-ID: <CAOQ4uxgWPv6TXS3qf5Z_OY-MvzNL2zsHpfsA3TC2iN+DR=1cjQ@mail.gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgcOD0DEZse2hWRWopDdBPsb+f=XX0SPQirbX_WGmLR-w@mail.gmail.com>
 <CAJfpegsidjjP_DPpAGAjUtOZEw70nu5jnoTO5E+yzPkONG4X9A@mail.gmail.com>
 <CAOQ4uxhyBeMxVCrj44Nz1L=Cy5NmqJdNCp4XV==6m6jJCv9YiQ@mail.gmail.com> <CAJfpeguDNDfZXSpep9PRNjyQPQ=DqZNFioUw=+gp4SjbbxU2BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35312 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754308AbdDGLEK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 07:04:10 -0400
Received: by mail-oi0-f42.google.com with SMTP id f193so81763769oib.2
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Apr 2017 04:04:10 -0700 (PDT)
In-Reply-To: <CAJfpeguDNDfZXSpep9PRNjyQPQ=DqZNFioUw=+gp4SjbbxU2BA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Apr 7, 2017 at 12:43 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Apr 6, 2017 at 6:46 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Yes, but do you think we should delay consistent_fd until we have a full
>> solution for constant_ino?
>> Do you think it is acceptable to fix only stat (to return lower ino) and leave
>> readdir d_ino for later?
>
> I don't know, because, as we discussed previously, these are really
> luxury bugs, and there's no push for either from real use cases.  So
> I'd add fixes in the order of becoming the obviously right fix.  I
> think we are closer to getting the constant ino resolved properly than
> consistent fd.
>
> I really want to look into sharing pages between clones.

That makes sense.
I also really want you to look into sharing pages between clone ;-)

Keep in mind that even though you are looking into sharing pages,
I think it may be still safe to propagate modification to readers lazily.

What I mean (and I may very well be talking nonsense) is that if
you choose to modify the f_mapping->host of readers some time
after copy up, maybe its enough to make a checkpoint only in
read syscall entry points?
and handle MAP_SHARED by copy up (or rocopyup) on mmap.

> "Unfortunately" I'll be taking next week off, so...
>

That is most fortunate :-)

Anyway, I sorted out the dumb rocopy race and cleaning
up the code from my tendency to over-code-reuse-with-if-else,
so will send a nicer looking version of rocopyup next week.

Amir.
