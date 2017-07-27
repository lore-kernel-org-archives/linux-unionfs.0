From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: xattr hash error in 4.13-rc with overlayfs over ext4
Date: Thu, 27 Jul 2017 21:28:59 +0200
Message-ID: <CAJfpegvL2iR1PZ+3S=VGtbUiVPQ-EnW28KwE4wCzMJwWptNYKg@mail.gmail.com>
References: <CAJfpegvQhuMnt=2TtfYSiMV=DTLLLbOfrvcR2xQrmvyPU9wSNg@mail.gmail.com>
 <CAAeU0aM-1UFJJvX3zF1wUjBeG8BGC+S0wn7PhiDZevTscvmkXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36603 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751597AbdG0T3B (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Jul 2017 15:29:01 -0400
Received: by mail-oi0-f54.google.com with SMTP id g131so115964125oic.3
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Jul 2017 12:29:01 -0700 (PDT)
In-Reply-To: <CAAeU0aM-1UFJJvX3zF1wUjBeG8BGC+S0wn7PhiDZevTscvmkXg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, linux-fsdevel@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Jul 27, 2017 at 8:20 PM, Tahsin Erdogan <tahsin@google.com> wrote:
> Hi Miklos,
> I made a first attempt to reproduce the failure but did not get lucky.
>
>> Inode 3093, i_blocks is 16, should be 8.  Fix<y>? yes
> Does this inode correspond to foo, bar or a preexisting file?
>
> Do you mind sharing the output of the following command?
> debugfs -R "stat <3093>" /dev/${ext4_dev}

Inode: 17093   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 2184376062    Version: 0x00000000:00000001
User:     0   Group:     0   Project:     0   Size: 8
File ACL: 65561    Directory ACL: 0
Links: 2   Blockcount: 16
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x597a3e23:7d3fc138 -- Thu Jul 27 19:25:23 2017
 atime: 0x597a3dfc:a80bc138 -- Thu Jul 27 19:24:44 2017
 mtime: 0x597a3e23:7d3fc138 -- Thu Jul 27 19:25:23 2017
crtime: 0x597a3e23:787b0938 -- Thu Jul 27 19:25:23 2017
Size of extra inode fields: 32
EXTENTS:
(0):142340

Resulting fsck output:

Pass 1: Checking inodes, blocks, and sizes
Extended attribute in inode 17093 has a hash (2257320705) which is invalid
Clear<y>? yes
Inode 17093, i_blocks is 16, should be 8.  Fix<y>? yes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -65561
Fix<y>? yes
Free blocks count wrong for group #2 (13797, counted=13798).
Fix<y>? yes
Free blocks count wrong (86361, counted=86362).
Fix<y>? yes
