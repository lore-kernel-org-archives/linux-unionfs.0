From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] src/t_dir_type.c: Use strtoul() instead of atoll()
Date: Tue, 14 Nov 2017 13:23:18 +0200
Message-ID: <CAOQ4uxjBihgjimmv6KNugYM=O=BPn+JAJEDGfU-NJb6uZR7uvw@mail.gmail.com>
References: <20171113144527.1034-1-chandan@linux.vnet.ibm.com>
 <CAOQ4uxjjtkTyqXWX-mRQeeWLY1KrGJn330uBAZX7f_hLs=pY-Q@mail.gmail.com> <20171114111338.GG17339@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:46036 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753186AbdKNLXT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2017 06:23:19 -0500
In-Reply-To: <20171114111338.GG17339@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Nov 14, 2017 at 1:13 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Mon, Nov 13, 2017 at 04:57:08PM +0200, Amir Goldstein wrote:
>> On Mon, Nov 13, 2017 at 4:45 PM, Chandan Rajendra
>> <chandan@linux.vnet.ibm.com> wrote:
>> > An overlayfs filesystem instance with one lowerdir filesystem and with
>> > "xino" mount option enabled can have the layer index encoded in the 63rd
>> > bit of the inode number. A signed 64 bit integer won't suffice to store
>> > this inode number. Hence this commit uses strtoul() to convert the inode
>> > number in string form to unsigned integer form.
>> >
>> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>>
>> Looks good, especially since I had to fix the same problem myself ;)
>> https://github.com/amir73il/xfstests/commits/overlayfs-devel
>>
>> My patch also changes:
>>
>>         int type = -1; /* -1 means all types */
>> -       uint64_t ino = 0;
>> +       unsigned long ino = 0;
>>         int ret = 1;
>>
>> But I am not sure that is the right thing to do here or what difference it makes
>
> I think that strtoul() returns unsigned long, which could be 32bit, and
> uint64_t is guaranteed to be 64bit size, so I tend to change the ino
> definition too. But I guess that doesn't matter that much :)
>

The thing is that 'ino' is later compared with 'd->d_ino', which is uint64_t,
so on 32bit CPU, the conversion will happen either in assignment from
strtoul() or in comparison later. I guess it doesn't matter much, so I prefer
Chandan's version that leaves ino as uint64_t.

Amir.
