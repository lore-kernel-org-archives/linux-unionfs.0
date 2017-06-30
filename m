From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 5/5] ovl: consistent st_ino/d_ino
Date: Fri, 30 Jun 2017 22:01:55 +0300
Message-ID: <CAOQ4uxgi6R73q=bCyoHqnLWNPkQk27H+F-yQ9-eJF1ftA9zP-Q@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgtBzq8_HtSfKxGNT3mx_erg3MHw09z-ZQ25GK3RJFk6w@mail.gmail.com>
 <CAJfpeguKE2o=6bQm6q99oZXoP5w8Qt0qKZzbRDm7kGS0wYzvmA@mail.gmail.com> <3572960.FHoPbXkqrf@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34459 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbdF3TB4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Jun 2017 15:01:56 -0400
Received: by mail-oi0-f51.google.com with SMTP id l130so44354905oib.1
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Jun 2017 12:01:56 -0700 (PDT)
In-Reply-To: <3572960.FHoPbXkqrf@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Jun 30, 2017 at 7:23 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Wednesday, June 21, 2017 3:18:20 PM IST Miklos Szeredi wrote:
>> On Wed, Jun 21, 2017 at 11:36 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> > On Wed, Jun 21, 2017 at 12:20 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> >> On Wed, Jun 21, 2017 at 11:05 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> >
>> >>>
>> >>> Following up on your idea:
>> >>> - check in ovl_iterate() if version has changed and if dir became impure
>> >>> - if it did, populate od->cache, but keep the dir od->is_real
>> >>> - iterate upper cache entries and call ovl_cache_update_ino()
>> >>> - Then actor of real dir iterator can use the cache to ommit entries or use
>> >>>   p->ino from cache if p->real_ino match real d_ino, but differs from p->ino.
>> >>
>> >> For non-merge dirs we can have a simplified cache just containing the
>> >> entries with origin, recreated when the version changes or updated in
>> >> rename, whichever is simpler.  A non-merge dir will never become a
>> >> merge one, so we can keep the handling separate.
>> >>
>> >
>> > And use this cache to ommit/fix entries with actor?
>>
>> Right.  I think fixing up is better, because to correctly omit entries
>> we'd need separate lists for each open directory.  For fixing up we
>> can use a common one, just like for the merged dir.
>>
>
> Amir, Can I please take over the implementation of this feature.
>

Yeh, sure.
I suggest that you start from understanding the overlay readdir code.
It's not trivial IMO, so I expect you come back with more questions.
You should understand how od->cache is populated and when it is
updated. The current od->cache is implemented for merge dirs and
contains a merged list of entries from all layers.

The case of an impure non-merge dir needs a different sort of cache
(list of entries with origin that were moved into upper dir), whose version
is only ever updated on rename (and always under the overlay dir inode lock).

So I think you should start with my patch for the classic merge dir case
and then add patches to maintain and iterate the "impure dir cache".

As my patch adds quite a bit of performance overhead for merge dir
readdir, I expect there will be more optimization work needed before
the work can land in upstream.

Good luck,
Amir.
