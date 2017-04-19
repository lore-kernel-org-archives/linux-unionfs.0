From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH 02/13] ovl: redirect dir by file handle on copy up
Date: Wed, 19 Apr 2017 17:33:39 +0200
Message-ID: <CAJfpegs3=7-2v2BL7U1QNYFnJ-fN0eAEo0vK0m2954PZtUKwmQ@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <1492387183-18847-3-git-send-email-amir73il@gmail.com> <CAJfpegsiy9_-qmMhFRVq7L23WHq_f0HM4+gQQYeW06-3-guD8Q@mail.gmail.com>
 <CAOQ4uxgQ4naPLq2n2GBEyAL0qW=Pwm=Qkw4QX8nwiNmCESDoTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34210 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765962AbdDSPdk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 11:33:40 -0400
Received: by mail-yw0-f194.google.com with SMTP id u70so2003764ywe.1
        for <linux-unionfs@vger.kernel.org>; Wed, 19 Apr 2017 08:33:40 -0700 (PDT)
In-Reply-To: <CAOQ4uxgQ4naPLq2n2GBEyAL0qW=Pwm=Qkw4QX8nwiNmCESDoTA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Apr 19, 2017 at 5:27 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Apr 19, 2017 at 6:16 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, Apr 17, 2017 at 1:59 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> When mounted with mount option redirect_dir=fh,
>>> every copy up of lower directory stores the lower
>>> dir file handle in overlay.fh xattr of upper dir.
>>
>> Is there a disadvantage to doing this unconditionally? (Same goes for patch 4)
>>
>> Is there a disadvantage to doing this even for the non-samefs case?
>>
>
> Not that I can think of. It's just that all the features that stable
> inode brings
> to the table only work for same_fs right now, but we can store overlay.fh
> anyway.
>
> When you get a chance please let me know your preference wrt
> configuration options.
> I don't see a reason to let the user turn off storing overlay.fh?
> Is there a reason to let user turn off lookup by fh? for files?
> (i.e. to preserve old weird behavior?)

The less config options the better.

We needed the redirect_dir=on/off thing because it's a backward
incompatible format change and the alternatives sucked more (i.e.
Linus didn't like them).

I don't see why we'd need to allow turning off backward compatible
changes (of course, there's a minimal overhead, but lets assume that
nobody cares about that, and if it turns out to be a problem, we'll
fix it).

Thanks,
Miklos

>
> Amir.
