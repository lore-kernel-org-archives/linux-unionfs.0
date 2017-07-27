From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: xattr hash error in 4.13-rc with overlayfs over ext4
Date: Thu, 27 Jul 2017 21:36:20 +0200
Message-ID: <CAJfpegtLsnDFwMFMMxUf2yUcr2AG57PgUZSAR7M8gzbOEp16Mg@mail.gmail.com>
References: <CAJfpegvQhuMnt=2TtfYSiMV=DTLLLbOfrvcR2xQrmvyPU9wSNg@mail.gmail.com>
 <CAAeU0aM-1UFJJvX3zF1wUjBeG8BGC+S0wn7PhiDZevTscvmkXg@mail.gmail.com> <CAJfpegvL2iR1PZ+3S=VGtbUiVPQ-EnW28KwE4wCzMJwWptNYKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36190 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbdG0TgW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Jul 2017 15:36:22 -0400
Received: by mail-oi0-f53.google.com with SMTP id g131so116122420oic.3
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Jul 2017 12:36:21 -0700 (PDT)
In-Reply-To: <CAJfpegvL2iR1PZ+3S=VGtbUiVPQ-EnW28KwE4wCzMJwWptNYKg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Jul 27, 2017 at 9:28 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jul 27, 2017 at 8:20 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>> Hi Miklos,
>> I made a first attempt to reproduce the failure but did not get lucky.
>>
>>> Inode 3093, i_blocks is 16, should be 8.  Fix<y>? yes
>> Does this inode correspond to foo, bar or a preexisting file?

The inode in question corresponds to the copy-up of bar into upper.

There's quite a lot overlayfs does in this apparently simple
operation, and that's probably why I've not been able to reproduce
without overlayfs (although admittedly I didn't try very hard).

It's basically the following:

 - create tempfile
 - copy data from lower/bar to work/index/XXX  using reflink
 - copy metadata
 - set trusted.overlay.origin xattr
 - set trusted.overlay.nlink xattr
 - hardlink index file to upper/bar
 - overwrite trusted.overlay.nlink with different value

And ther's also some attr and xattr setting going on for the upper directory.

Thanks,
Miklos
