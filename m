From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 2/5] ovl: relax same fs constrain for constant st_ino
Date: Fri, 2 Jun 2017 14:27:26 +0200
Message-ID: <CAJfpeguGBDDgtgZjLu4xuQNehRUTvhMrxM1JG4dJcAt-1tPc=g@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
 <1496307779-2766-3-git-send-email-amir73il@gmail.com> <CAJfpegtacnEncCkWQg4sE=ck6W2Utd6tJe3JsvAaeLoWEkRksw@mail.gmail.com>
 <CAOQ4uxjvBUEB89T0+qO4yksVeU+8KXEphOYxShMtQYiyNdxzLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34655 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdFBM11 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 08:27:27 -0400
Received: by mail-oi0-f66.google.com with SMTP id w10so11522171oif.1
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 05:27:27 -0700 (PDT)
In-Reply-To: <CAOQ4uxjvBUEB89T0+qO4yksVeU+8KXEphOYxShMtQYiyNdxzLA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Jun 2, 2017 at 8:32 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Jun 1, 2017 at 10:55 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Jun 1, 2017 at 11:02 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> For the case of all layers not on the same fs, use the copy up
>>> origin st_ino/st_dev for non-dir, if we know it.
>>>
>>> This guarantied constant and persistent st_ino/st_dev for non-dir,
>>> but not system-wide uniqueness, like in the same fs case.
>>
>> I'd rather leave this until the st_dev uniqueness is sorted out.   Non
>> unique st_ino/st_dev is just asking for trouble.
>>
>
> I don't mind leaving this out, but you do realize that this commit
> doesn't change st_dev/st_ino uniqueness one way or the other, right?

Depends on how you look at it.

Before the patch it was (just the non-samefs, non-directory case):

 - if lower: st_ino/st_dev comes from lower
 - if upper: st_ino/st_dev comes from upper

This only violates the uniqueness rule if check+use of st_ino/st_dev
races with the copy up

After the patch it's:

 - if copied up: st_ino/st_dev comes from origin
 - otherwise same as above

Now the uniqueness is violated for all copied up files (origin and
overlay file will have the same st_ino/st_dev pair even though they
possibly have different contents).

So that transforms a race into a permanent error, which is not good.

Thanks,
Miklos
