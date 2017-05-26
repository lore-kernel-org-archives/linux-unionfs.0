From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: constant st_ino/st_dev for non-samefs case
Date: Fri, 26 May 2017 12:42:12 +0300
Message-ID: <CAOQ4uxgcB9YOZMy71U43RjQTYqfLCMJ4odzBNVar1-wHmumQuA@mail.gmail.com>
References: <CAOQ4uxhJdyETb96yKr_bRes9OGEeHSOUAH=L4nfX3c2ryYD6Mw@mail.gmail.com>
 <4951608.hM2HNRSCh0@localhost.localdomain> <CAOQ4uxh5anMdr7HbgCjP5v=nSC4y0gQzmq+MgD5O5P-fjmMf2g@mail.gmail.com>
 <1686894.e2G5UinVUe@localhost.localdomain> <CAOQ4uxhc853r9JbLDvhT0x4Dbcvj4jXCioGt+t0ZrtAExr-aUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35438 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425984AbdEZJmN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 26 May 2017 05:42:13 -0400
Received: by mail-oi0-f43.google.com with SMTP id l18so6478816oig.2
        for <linux-unionfs@vger.kernel.org>; Fri, 26 May 2017 02:42:13 -0700 (PDT)
In-Reply-To: <CAOQ4uxhc853r9JbLDvhT0x4Dbcvj4jXCioGt+t0ZrtAExr-aUw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Wed, May 24, 2017 at 3:59 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, May 24, 2017 at 11:51 AM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
>>
>> Amir, Thanks for informing me. I will base my work on top of your patches.
>>
>
> Chandan,
>
> FYI, just found a nasty bug in one the patches under the "relax same fs" patches
> I referred you to, so if you already pulled my ovl-constino branch,
> please re-fetch it.
> New head is:
> 931488f1acd1 ovl: consistent st_ino/d_ino
>

FYI, fixed another minor issue. Had to relax WARN_ON_ONCE in readdir
for non-samefs.

Force pushed ovl-constino branch.

New head is:
02b67e4c4e73 ovl: consistent st_ino/d_ino

Cheers,
Amir.
