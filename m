From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v8 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
Date: Wed, 8 Nov 2017 20:16:59 +0200
Message-ID: <CAOQ4uxhyy12suZC9WfCUL83iKeVUPGSgBmXiM0Rb8FciT0ASGg@mail.gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
 <CAJfpegvBEXgi=P8Sciv+U6VqcjsLJChR1OdwZyZA_PoL3MNTNA@mail.gmail.com>
 <CAOQ4uxjvFVk5xs_zj1Ga4o-0GGStGWfYsNhY8ot+zTeB3HoBNw@mail.gmail.com> <CAOQ4uxjtTek_79chEiswmhNd4S8SnDzicH6p2_XwS7HfVM5ZjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:43783 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751897AbdKHSRA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Nov 2017 13:17:00 -0500
Received: by mail-yw0-f194.google.com with SMTP id y75so3095609ywg.0
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Nov 2017 10:16:59 -0800 (PST)
In-Reply-To: <CAOQ4uxjtTek_79chEiswmhNd4S8SnDzicH6p2_XwS7HfVM5ZjA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Nov 8, 2017 at 3:40 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Nov 8, 2017 at 2:01 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Wed, Nov 8, 2017 at 12:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
[...]
>>> I the meantime I went and committed v7 (with the noted changes) and
>>> based my cleanup for ovl_fill_super() on top of that.  So that's now
>>> pushed out to overlayfs-next, hopefully not invalidating too much of
>>> your work.
>>
>> Not a problem. most of the work on v8 was on the last patches.
>> I'll send 2 cleanup patches that make get_attr() code a bit cleaner to my taste.
>>

And finally, those are the cleanup patches from v8:
42448ca8681a ovl: factor out ovl_map_dev_ino() helper
52a325cd6b41 ovl: store layer index in ovl_layer

Can be found at the tip of:
https://github.com/amir73il/linux/commits/overlayfs-devel

The xino patches are also rebased and tested on:
https://github.com/amir73il/linux/commits/ovl-xino

In case you change your mind about this merge cycle.

Thanks,
Amir.
