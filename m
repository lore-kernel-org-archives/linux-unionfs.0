From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Overlayfs backport for kernel v4.9.y
Date: Thu, 7 Dec 2017 21:32:46 +0200
Message-ID: <CAOQ4uxiNgj-LnFdn8hgmYzuUvOe56nFiZCcaW1vjSnGUNoEc2Q@mail.gmail.com>
References: <CAOQ4uxiYg11XGjzNhD-2gOd-s-FgnzScgzDwwuWpp+518EHv6A@mail.gmail.com>
 <20171207182050.GA4067@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:46114 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdLGTcs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Dec 2017 14:32:48 -0500
Received: by mail-yb0-f195.google.com with SMTP id g9so3412666yba.13
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Dec 2017 11:32:47 -0800 (PST)
In-Reply-To: <20171207182050.GA4067@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Dec 7, 2017 at 8:20 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Dec 07, 2017 at 07:14:49PM +0200, Amir Goldstein wrote:
>> Hi All,
>>
>> For whom it may concern, I have backported latest overlayfs
>> features to stable kernel v4.9.y. The patches are available on
>
> Hi Amir,
>
> So what's the plan. Who is going to consume these patches. Will
> these be merged somewhere?
>

Vivek,

Those patches are for "private consumption". No merge destination.
I am going to maintain a backport branch for overlayfs snapshots,
so I figured I put the patches out there in case somebody has a use for them.

Cheers,
Amir.
