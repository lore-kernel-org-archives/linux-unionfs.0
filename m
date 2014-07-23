From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs v22 on kernel 3.15.5
Date: Wed, 23 Jul 2014 14:02:49 +0200
Message-ID: <CAJfpegsc4swQ2e7LfKbzHYCoa3thvetLhydzqr1My2PJr=Myag@mail.gmail.com>
References: <CAJfpeguH=BmevY+SM8HKBATS7B+htcX7_WLRiMFmypW_D-424Q@mail.gmail.com>
	<3a4b4cc25d1a8325934ba439d4777c35.squirrel@webmail.univie.ac.at>
	<CAJfpegs1_iTJJGvLddyF=-L9YreVCzbDL-Pum70FTO6W+MvozQ@mail.gmail.com>
	<CAJfpegubZyar3JxYg7OxFVa1O3xWoMqaHiRUS_eME_OCzv6QFA@mail.gmail.com>
	<207df75d465c4b3fe95b6a90f3531905.squirrel@webmail.univie.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35649 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaGWMCu (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 23 Jul 2014 08:02:50 -0400
Received: by mail-qa0-f46.google.com with SMTP id v10so1123347qac.19
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Jul 2014 05:02:50 -0700 (PDT)
In-Reply-To: <207df75d465c4b3fe95b6a90f3531905.squirrel@webmail.univie.ac.at>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Klaus Kreil <klaus.kreil@univie.ac.at>
Cc: linux-unionfs@vger.kernel.org

On Wed, Jul 23, 2014 at 1:57 PM, Klaus Kreil <klaus.kreil@univie.ac.at> wrote:

>> You need to give absolute paths:
>>
>> mount -t overlayfs overlayfs -o
>> lowerdir=/mnt/root_ro,upperdir=/mnt/root_rw/upper,workdir=/mnt/root_rw/work
>> /mnt/root
>>
> Thanks Miklos,
> I had tried that before, but that did not/does not work as well. The new
> command (adjusted to my environment and from within the rescue-shell and
> all within a single line) was:
> # mount -t overlayfs overlayfs -o
> lowerdir=/mnt/root_ro,upperdir=/mnt/root_rw,workdir=/mnt/root_rw/.work
> /mnt/root
>
> The new error message from dmesg now reads:
> [ 1369.069178] overlayfs: workdir and upperdir must be separate subtrees

Exactly. Observe that I used upperdir=/mnt/root_rw/upper.

Thanks,
Miklos
