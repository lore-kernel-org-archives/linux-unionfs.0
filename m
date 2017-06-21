From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 5/5] ovl: consistent st_ino/d_ino
Date: Wed, 21 Jun 2017 12:36:47 +0300
Message-ID: <CAOQ4uxgtBzq8_HtSfKxGNT3mx_erg3MHw09z-ZQ25GK3RJFk6w@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
 <1496307779-2766-6-git-send-email-amir73il@gmail.com> <CAJfpeguF6aW6uNdZLaqQnyTo00rz7E=NBbHbYjSpKVcMCVu1dg@mail.gmail.com>
 <CAOQ4uxiYVuhqbzmM0yx+3cUKhhzfrjBubHwKo6ro1FXedJ-Tqg@mail.gmail.com>
 <CAJfpegumm16iy4v7vVkOOM0upvc=_jmuMxTiXn+cgEfi5c8FFw@mail.gmail.com>
 <CAJfpeguKQbG-EZTziROiKy+2t6iQU3FEwfZmc9ezPX_voEyTmA@mail.gmail.com>
 <CAJfpeguVYLdh5sc7-TCKVrdPdVGhxh3oSeP=EfN=nArh6wi_fA@mail.gmail.com>
 <CAOQ4uxhXQi-7sNTYxpMnDJGHC95r2QFAaoeeY5GQYWCe30EZOA@mail.gmail.com>
 <CAJfpegsCF8ZssutAe0yKEL4Bn1LZrMvqK5MXk8oQ7jj5fm0RtQ@mail.gmail.com>
 <CAOQ4uxg+ZRwa4_SERh6a_yU=RHFBEAGwumSJTBhrXr+rETnWAQ@mail.gmail.com> <CAJfpegtuepxej_o9Svb=4RoyLDryoKSXWts6_0PE79-ZjiRy0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35951 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdFUJg7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 05:36:59 -0400
Received: by mail-oi0-f50.google.com with SMTP id p187so28982319oif.3
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 02:36:58 -0700 (PDT)
In-Reply-To: <CAJfpegtuepxej_o9Svb=4RoyLDryoKSXWts6_0PE79-ZjiRy0g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Jun 21, 2017 at 12:20 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Jun 21, 2017 at 11:05 AM, Amir Goldstein <amir73il@gmail.com> wrote:

>>
>> Following up on your idea:
>> - check in ovl_iterate() if version has changed and if dir became impure
>> - if it did, populate od->cache, but keep the dir od->is_real
>> - iterate upper cache entries and call ovl_cache_update_ino()
>> - Then actor of real dir iterator can use the cache to ommit entries or use
>>   p->ino from cache if p->real_ino match real d_ino, but differs from p->ino.
>
> For non-merge dirs we can have a simplified cache just containing the
> entries with origin, recreated when the version changes or updated in
> rename, whichever is simpler.  A non-merge dir will never become a
> merge one, so we can keep the handling separate.
>

And use this cache to ommit/fix entries with actor?

Just thought of another issue related to pseudo lower st_dev
we need the underlying iter actor also for replacing real st_dev
with pseudo st_dev.

Also, just realized that with inodes index, the upper non-dir inodes
with nlink == 1 are not origin suspects. Can that help us somehow?
