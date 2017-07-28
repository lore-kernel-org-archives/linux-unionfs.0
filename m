From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 5/5] ovl: consistent st_ino/d_ino
Date: Fri, 28 Jul 2017 12:25:56 +0300
Message-ID: <CAOQ4uxif79cbhYJxgHzkG0jpNgginMimvfgm-iSXAnuRkmWUqw@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
 <1496307779-2766-6-git-send-email-amir73il@gmail.com> <CAJfpeguF6aW6uNdZLaqQnyTo00rz7E=NBbHbYjSpKVcMCVu1dg@mail.gmail.com>
 <CAOQ4uxiYVuhqbzmM0yx+3cUKhhzfrjBubHwKo6ro1FXedJ-Tqg@mail.gmail.com>
 <CAJfpegumm16iy4v7vVkOOM0upvc=_jmuMxTiXn+cgEfi5c8FFw@mail.gmail.com>
 <CAJfpeguKQbG-EZTziROiKy+2t6iQU3FEwfZmc9ezPX_voEyTmA@mail.gmail.com>
 <CAJfpeguVYLdh5sc7-TCKVrdPdVGhxh3oSeP=EfN=nArh6wi_fA@mail.gmail.com>
 <CAOQ4uxhXQi-7sNTYxpMnDJGHC95r2QFAaoeeY5GQYWCe30EZOA@mail.gmail.com>
 <CAJfpegsCF8ZssutAe0yKEL4Bn1LZrMvqK5MXk8oQ7jj5fm0RtQ@mail.gmail.com>
 <CAOQ4uxg+ZRwa4_SERh6a_yU=RHFBEAGwumSJTBhrXr+rETnWAQ@mail.gmail.com>
 <CAJfpegtuepxej_o9Svb=4RoyLDryoKSXWts6_0PE79-ZjiRy0g@mail.gmail.com>
 <CAOQ4uxgtBzq8_HtSfKxGNT3mx_erg3MHw09z-ZQ25GK3RJFk6w@mail.gmail.com>
 <CAJfpeguKE2o=6bQm6q99oZXoP5w8Qt0qKZzbRDm7kGS0wYzvmA@mail.gmail.com> <CAJfpeguM5eS2caT_k6wE++sSrBi9kGE1aLys5h6a5S+tQGJg6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:35873 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbdG1JZ5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Jul 2017 05:25:57 -0400
Received: by mail-yw0-f179.google.com with SMTP id u207so59146112ywc.3
        for <linux-unionfs@vger.kernel.org>; Fri, 28 Jul 2017 02:25:57 -0700 (PDT)
In-Reply-To: <CAJfpeguM5eS2caT_k6wE++sSrBi9kGE1aLys5h6a5S+tQGJg6A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Jul 27, 2017 at 11:00 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Jun 21, 2017 at 11:48 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Jun 21, 2017 at 11:36 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Wed, Jun 21, 2017 at 12:20 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> On Wed, Jun 21, 2017 at 11:05 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>
>>>>>
>>>>> Following up on your idea:
>>>>> - check in ovl_iterate() if version has changed and if dir became impure
>>>>> - if it did, populate od->cache, but keep the dir od->is_real
>>>>> - iterate upper cache entries and call ovl_cache_update_ino()
>>>>> - Then actor of real dir iterator can use the cache to ommit entries or use
>>>>>   p->ino from cache if p->real_ino match real d_ino, but differs from p->ino.
>>>>
>>>> For non-merge dirs we can have a simplified cache just containing the
>>>> entries with origin, recreated when the version changes or updated in
>>>> rename, whichever is simpler.  A non-merge dir will never become a
>>>> merge one, so we can keep the handling separate.
>>>>
>>>
>>> And use this cache to ommit/fix entries with actor?
>>
>> Right.  I think fixing up is better, because to correctly omit entries
>> we'd need separate lists for each open directory.  For fixing up we
>> can use a common one, just like for the merged dir.
>
> And back to this, I pushed a branch named "ovl-d_ino" to my vfs tree.
>
> Please test.
>

I can confirm that xfstest  overlay/017, the only  test I have for
constant d_ino,
passes. Although it does not cover all cases handled by the patch set
(e.g. d_ino of merge parent).

Chandan,

Can you take on the task of improving test coverage for constant d_ino?
You should create a new xfstest and cover more cases of constant d_ino
and possibly also a test for clearing of impure xattr.

When the basic test is in place, I will be able to point at more corner cases
to cover.

Also need to prepare a test to verify constant d_ino for non samefs
for after this patch is integrated with your work.
overlay/017 is a good starting point, but can't use the standard _scratch_mount
helpers that mount samefs overlay.

Thanks,
Amir.
