From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix ovl_rename error handling
Date: Thu, 18 May 2017 17:26:17 +0300
Message-ID: <CAOQ4uxjHmwde5eFaxZY5QCfV4Ryh6eyWtAK=LYLOWrWt1YDV4Q@mail.gmail.com>
References: <20170518133500.1890143-1-arnd@arndb.de> <CAOQ4uxh-EDu=Y+BVfVsve6xDwYsQuHJhx19f=LMpF72LRhow8g@mail.gmail.com>
 <CAJfpeguo4rVL44Zwz8LAXwZt5k4cJ1ojfR5hjvg5hMEDto_2HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34906 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932227AbdERO0S (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 May 2017 10:26:18 -0400
Received: by mail-oi0-f43.google.com with SMTP id l18so55951900oig.2
        for <linux-unionfs@vger.kernel.org>; Thu, 18 May 2017 07:26:18 -0700 (PDT)
In-Reply-To: <CAJfpeguo4rVL44Zwz8LAXwZt5k4cJ1ojfR5hjvg5hMEDto_2HA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, May 18, 2017 at 5:13 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, May 18, 2017 at 3:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, May 18, 2017 at 4:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> We try to clean up two objects before they got initialized:
>>>
>>> fs/overlayfs/dir.c: In function 'ovl_rename':
>>> fs/overlayfs/dir.c:1060:2: error: 'newdentry' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>>> fs/overlayfs/dir.c:891:17: note: 'newdentry' was declared here
>>> fs/overlayfs/dir.c:1062:2: error: 'olddentry' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>>> fs/overlayfs/dir.c:890:17: note: 'olddentry' was declared here
>>>
>>> Assuming that no special cleanup is required for the new code, the correct
>>> branch target should be "out_revert_creds" to clean up everything that
>>> got initialized up to then.
>>>
>>
>> Yep, this is correct. You are the 4th to send this patch :)
>> Thanks
>
> Pushed to overlayfs-next together with other fixes.  Sorry for the delay.
>

Heh! do you have "undo protection" on your git push ;) ?

It's taking the bits time to travel...
