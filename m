From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: xattr hash error in 4.13-rc with overlayfs over ext4
Date: Tue, 1 Aug 2017 13:34:34 +0300
Message-ID: <CAOQ4uxjtLVuuYyDZ7csJeb_xbMiWHDHs21tgQoB7bbLWC6DUew@mail.gmail.com>
References: <CAJfpegvQhuMnt=2TtfYSiMV=DTLLLbOfrvcR2xQrmvyPU9wSNg@mail.gmail.com>
 <CAAeU0aM-1UFJJvX3zF1wUjBeG8BGC+S0wn7PhiDZevTscvmkXg@mail.gmail.com>
 <CAJfpegvL2iR1PZ+3S=VGtbUiVPQ-EnW28KwE4wCzMJwWptNYKg@mail.gmail.com>
 <CAJfpegtLsnDFwMFMMxUf2yUcr2AG57PgUZSAR7M8gzbOEp16Mg@mail.gmail.com>
 <CAAeU0aOC7i6dTEBKRAP3N_HUKR0CQOW4j_MhftkfC9FSXHdCAw@mail.gmail.com> <CAJfpegvy274dZ0ZzY+qpaLwREi0QU9jNt=vE0pBpQ8W2wWCx1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:34727 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbdHAKeg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Aug 2017 06:34:36 -0400
In-Reply-To: <CAJfpegvy274dZ0ZzY+qpaLwREi0QU9jNt=vE0pBpQ8W2wWCx1w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Tahsin Erdogan <tahsin@google.com>, Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jul 31, 2017 at 7:08 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Jul 27, 2017 at 10:54 PM, Tahsin Erdogan <tahsin@google.com> wrote:
>> Still no luck reproducing the error. I am using the test script below
>> at v4.13-rc2. Do you mind checking my script to see what I am missing?
>
> Don't know.   I can reliably reproduce it under UML, but not with a
> VM.  What the hell is going on?
>

Is it the same ext4 image for UML and VM? same image size? same mkfs version?

What inode size do you have in UML setup? e.g.:

dumpe2fs -h /dev/sda3|grep Inode.size
dumpe2fs 1.42.13 (17-May-2015)
Inode size:          256

have extra_isize feature? (not sure if that matters)

dumpe2fs -h /dev/sda3|grep isize
dumpe2fs 1.42.13 (17-May-2015)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file
huge_file uninit_bg dir_nlink extra_isize
Required extra isize:     28
Desired extra isize:      28
