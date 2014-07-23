From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs v22 on kernel 3.15.5
Date: Wed, 23 Jul 2014 13:50:07 +0200
Message-ID: <CAJfpegubZyar3JxYg7OxFVa1O3xWoMqaHiRUS_eME_OCzv6QFA@mail.gmail.com>
References: <CAJfpeguH=BmevY+SM8HKBATS7B+htcX7_WLRiMFmypW_D-424Q@mail.gmail.com>
	<3a4b4cc25d1a8325934ba439d4777c35.squirrel@webmail.univie.ac.at>
	<CAJfpegs1_iTJJGvLddyF=-L9YreVCzbDL-Pum70FTO6W+MvozQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:33591 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaGWLuI (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 23 Jul 2014 07:50:08 -0400
Received: by mail-qa0-f47.google.com with SMTP id i13so1119880qae.6
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Jul 2014 04:50:08 -0700 (PDT)
In-Reply-To: <CAJfpegs1_iTJJGvLddyF=-L9YreVCzbDL-Pum70FTO6W+MvozQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Klaus Kreil <klaus.kreil@univie.ac.at>
Cc: linux-unionfs@vger.kernel.org

On Wed, Jul 23, 2014 at 1:48 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Jul 23, 2014 at 1:40 PM, Klaus Kreil <klaus.kreil@univie.ac.at> wrote:
>> >
>>> Is there some hint in the dmesg output?
>>>
>> The messag from dmesg reads as follows:
>> [    1.323319] overlayfs: failed to resolve '/.work': -2

You need to give absolute paths:

mount -t overlayfs overlayfs -o
lowerdir=/mnt/root_ro,upperdir=/mnt/root_rw/upper,workdir=/mnt/root_rw/work
/mnt/root

Thanks,
Miklos
