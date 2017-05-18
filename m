From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix ovl_rename error handling
Date: Thu, 18 May 2017 18:16:56 +0300
Message-ID: <CAOQ4uxjUm7xxcdOGktEPsLBBoDS-GpTpmWgHx7xKJaqYpcZACQ@mail.gmail.com>
References: <20170518133500.1890143-1-arnd@arndb.de> <CAOQ4uxh-EDu=Y+BVfVsve6xDwYsQuHJhx19f=LMpF72LRhow8g@mail.gmail.com>
 <CAJfpeguo4rVL44Zwz8LAXwZt5k4cJ1ojfR5hjvg5hMEDto_2HA@mail.gmail.com>
 <CAOQ4uxjHmwde5eFaxZY5QCfV4Ryh6eyWtAK=LYLOWrWt1YDV4Q@mail.gmail.com>
 <CAJfpegsEYbFziVs+pL_t_trG2EcR28XND1BO429nELALirt9EQ@mail.gmail.com> <CAOQ4uxgeZUcS1MCUBoz7DBZCdJp-Qg3mEkd7bfXkaz4bEo9SDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36363 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932643AbdERPQ5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 May 2017 11:16:57 -0400
Received: by mail-oi0-f51.google.com with SMTP id h4so58010599oib.3
        for <linux-unionfs@vger.kernel.org>; Thu, 18 May 2017 08:16:57 -0700 (PDT)
In-Reply-To: <CAOQ4uxgeZUcS1MCUBoz7DBZCdJp-Qg3mEkd7bfXkaz4bEo9SDg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, May 18, 2017 at 6:14 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, May 18, 2017 at 5:47 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>
>>>> Pushed to overlayfs-next together with other fixes.  Sorry for the delay.
>>>>
>>>
>>> Heh! do you have "undo protection" on your git push ;) ?
>>>
>>> It's taking the bits time to travel...
>>
>> I think it's just the way the korg repositories are synced.
>>
>
> OK. looks good. But you forgot your SOB on
>  3e2e9a6 "ovl: handle rename when upper doesn't supports xattr"
>

And while at it, please fix my grammar "doesn't support[s] xattr" ...
