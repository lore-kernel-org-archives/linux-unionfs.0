From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 00/13][V5] overlayfs: Delayed copy up of data
Date: Tue, 31 Oct 2017 15:56:39 +0200
Message-ID: <CAOQ4uxjT9Vn_eYqnRLxTMrLW6i1t7P1nUSDN1UQEBuLF5iDWyQ@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxhDkDHAFxhs6mu6HQ+Z1+y8ykvcw5vbXO3H79kGJ6zAaA@mail.gmail.com>
 <20171027164032.GB5442@redhat.com> <CAOQ4uxhOLm+Jx3LoEeeXKMEK+i3yiok1+Ad93W2fRfThgJ=nDA@mail.gmail.com>
 <20171031133955.GA30720@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:44149 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753083AbdJaN4l (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Oct 2017 09:56:41 -0400
Received: by mail-yw0-f195.google.com with SMTP id k11so14798879ywh.1
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Oct 2017 06:56:41 -0700 (PDT)
In-Reply-To: <20171031133955.GA30720@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Oct 31, 2017 at 3:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, Oct 28, 2017 at 05:50:19PM +0300, Amir Goldstein wrote:
...
>>
>> That's a very good start.
>> Now I wonder if the metacopy feature can break userspace apps that relied on
>> metadata operations doing copy up to avoid the RDONLY/RDWR fd inconsistency,
>> even if they escaped the inconsistency by accident so far.
>
> There is a small possibility that somebody was relying on this. But we
> are keeping metacopy=off by default. So this should not be a backward
> compatibility issue. Those who chose to enable it, they can't rely on
> file being copied up on changing file attr.
>

Yeh. that's right.

>> I guess there is only one one to know...
>
> Not sure what does this mean.
>

Deploy the feature and wait for the shouts...

Cheers,
Amir.
