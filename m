From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: xattr hash error in 4.13-rc with overlayfs over ext4
Date: Thu, 27 Jul 2017 13:54:06 -0700
Message-ID: <CAAeU0aOC7i6dTEBKRAP3N_HUKR0CQOW4j_MhftkfC9FSXHdCAw@mail.gmail.com>
References: <CAJfpegvQhuMnt=2TtfYSiMV=DTLLLbOfrvcR2xQrmvyPU9wSNg@mail.gmail.com>
 <CAAeU0aM-1UFJJvX3zF1wUjBeG8BGC+S0wn7PhiDZevTscvmkXg@mail.gmail.com>
 <CAJfpegvL2iR1PZ+3S=VGtbUiVPQ-EnW28KwE4wCzMJwWptNYKg@mail.gmail.com> <CAJfpegtLsnDFwMFMMxUf2yUcr2AG57PgUZSAR7M8gzbOEp16Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:33588 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751042AbdG0UyH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Jul 2017 16:54:07 -0400
Received: by mail-yw0-f175.google.com with SMTP id x125so113528142ywa.0
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Jul 2017 13:54:07 -0700 (PDT)
In-Reply-To: <CAJfpegtLsnDFwMFMMxUf2yUcr2AG57PgUZSAR7M8gzbOEp16Mg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Still no luck reproducing the error. I am using the test script below
at v4.13-rc2. Do you mind checking my script to see what I am missing?

#!/bin/bash
set -ex

while grep /dev/sdb /proc/mounts;do umount /dev/sdb; done
mke2fs -F -t ext4 /dev/sdb
mount /dev/sdb /mnt/sdb
cd /mnt/sdb

mkdir xattrhashtest
cd xattrhashtest/
mkdir upper lower work mnt
cd lower/
echo foo > bar
ln bar baz
cd ..
mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work mnt
cd mnt/
echo xxx >> bar

cd /root
umount overlay
umount /dev/sdb

e2fsck -f -n /dev/sdb
echo done
