From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: update ctx->pos on impure dir iteration
Date: Wed, 6 Dec 2017 17:03:32 +0100
Message-ID: <CAJfpegvUnLecTN7QYKFKcP1pGMhu97uY5d4YHRXPhWM-37oKQw@mail.gmail.com>
References: <1511933721-4720-1-git-send-email-amir73il@gmail.com> <20171129134642.GA17605@miguelinux-clr.zpn.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:42494 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbdLFQDd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 11:03:33 -0500
Received: by mail-qt0-f194.google.com with SMTP id g9so10014709qth.9
        for <linux-unionfs@vger.kernel.org>; Wed, 06 Dec 2017 08:03:33 -0800 (PST)
In-Reply-To: <20171129134642.GA17605@miguelinux-clr.zpn.intel.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Nov 29, 2017 at 2:46 PM, Miguel Bernal Marin
<miguel.bernal.marin@linux.intel.com> wrote:
> On Wed, Nov 29, 2017 at 07:35:21AM +0200, Amir Goldstein wrote:
>> This fixes a regression with readdir of impure dir in overlayfs
>> that is shared to VM via 9p fs.
>>
>> Reported-by: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>
>> Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
>> Cc: <stable@vger.kernel.org> #4.14
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  fs/overlayfs/readdir.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
>> index 502dc0966f91..b98f1efe50c1 100644
>> --- a/fs/overlayfs/readdir.c
>> +++ b/fs/overlayfs/readdir.c
>> @@ -663,7 +663,10 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
>>                       return PTR_ERR(rdt.cache);
>>       }
>>
>> -     return iterate_dir(od->realfile, &rdt.ctx);
>> +     err = iterate_dir(od->realfile, &rdt.ctx);
>> +     ctx->pos = rdt.ctx.pos;
>> +
>> +     return err;
>>  }
>
> This fix the issue with 9P and Overlay
>
> Tested-by: Miguel Bernal Marin <miguel.bernal.marin@linux.intel.com>

Thanks, applied.

Miklos
