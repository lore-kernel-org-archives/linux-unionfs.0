From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix ovl_rename error handling
Date: Thu, 18 May 2017 16:13:50 +0200
Message-ID: <CAJfpeguo4rVL44Zwz8LAXwZt5k4cJ1ojfR5hjvg5hMEDto_2HA@mail.gmail.com>
References: <20170518133500.1890143-1-arnd@arndb.de> <CAOQ4uxh-EDu=Y+BVfVsve6xDwYsQuHJhx19f=LMpF72LRhow8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxh-EDu=Y+BVfVsve6xDwYsQuHJhx19f=LMpF72LRhow8g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "open list:OVERLAY FILESYSTEM" <linux-unionfs@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, May 18, 2017 at 3:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, May 18, 2017 at 4:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> We try to clean up two objects before they got initialized:
>>
>> fs/overlayfs/dir.c: In function 'ovl_rename':
>> fs/overlayfs/dir.c:1060:2: error: 'newdentry' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>> fs/overlayfs/dir.c:891:17: note: 'newdentry' was declared here
>> fs/overlayfs/dir.c:1062:2: error: 'olddentry' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>> fs/overlayfs/dir.c:890:17: note: 'olddentry' was declared here
>>
>> Assuming that no special cleanup is required for the new code, the correct
>> branch target should be "out_revert_creds" to clean up everything that
>> got initialized up to then.
>>
>
> Yep, this is correct. You are the 4th to send this patch :)
> Thanks

Pushed to overlayfs-next together with other fixes.  Sorry for the delay.

Thanks,
Miklos
