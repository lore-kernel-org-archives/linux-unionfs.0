From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 5/5] ovl: consistent st_ino/d_ino
Date: Wed, 21 Jun 2017 10:38:38 +0200
Message-ID: <CAJfpeguKQbG-EZTziROiKy+2t6iQU3FEwfZmc9ezPX_voEyTmA@mail.gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
 <1496307779-2766-6-git-send-email-amir73il@gmail.com> <CAJfpeguF6aW6uNdZLaqQnyTo00rz7E=NBbHbYjSpKVcMCVu1dg@mail.gmail.com>
 <CAOQ4uxiYVuhqbzmM0yx+3cUKhhzfrjBubHwKo6ro1FXedJ-Tqg@mail.gmail.com> <CAJfpegumm16iy4v7vVkOOM0upvc=_jmuMxTiXn+cgEfi5c8FFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35210 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752218AbdFUIil (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 04:38:41 -0400
Received: by mail-oi0-f49.google.com with SMTP id c189so63464260oia.2
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 01:38:40 -0700 (PDT)
In-Reply-To: <CAJfpegumm16iy4v7vVkOOM0upvc=_jmuMxTiXn+cgEfi5c8FFw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Jun 21, 2017 at 10:20 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:

> Right.  The problem is when dir becomes impure due to rename between
> two getdents(2) calls.  We can't call ovl_dir_reset() because the
> offset is not zero.  We could do a "cache with head cut off" starting
> from the current offset in the dir and finish with that.  Yeah, it's
> probably less complexity than trying to intercept the actor...

On the other hand, we'll need to accommodate the native directory
indexing (i.e. seekdir(3) hell) in the cache, which is going to add to
complexity.  Ugh.

Thanks,
Miklos
