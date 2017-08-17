From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: two questiones about overlayfs
Date: Thu, 17 Aug 2017 10:55:05 +0800
Message-ID: <b1cd78c9-17cf-df0d-f141-e72f9dde1b98@huawei.com>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
 <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
 <20170815133554.GB29201@veci.piliscsaba.szeredi.hu>
 <CAOQ4uxj6qkN-gi4a9ztKJj0FoBMrJC3DPta-m+3dVeHCxZOBNw@mail.gmail.com>
 <CAJfpegsOjqJ-BXFBA3SsuDVornt37GOomP4E8UTaNBxACtGFFw@mail.gmail.com>
 <CAOQ4uxha+B6bpKVxg824-WG-eYxfoL5OxW-PgmcWGcXGe55LXw@mail.gmail.com>
 <CAJfpegv-u+=edQ+bpD-HqAMUYf+Yy-hg-CkVGRiG6VDPT=S7aw@mail.gmail.com>
 <20170815155617.GC3551@redhat.com>
 <CAOQ4uxh4y1AAcQvv_A71E38TAUE9+Zk2vSQisOE1E=QEs7N-Jw@mail.gmail.com>
 <CAJfpegvwXL01-6FPXcbKcPiOKj+LBp69-eHnhiJtuevQdKd4tQ@mail.gmail.com>
 <CAOQ4uxgOM4Va3DnL5q+Oyz-OBtCe8-G0bq_Xf9Kuc8KToKyB5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4012 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751517AbdHQC4C (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Aug 2017 22:56:02 -0400
In-Reply-To: <CAOQ4uxgOM4Va3DnL5q+Oyz-OBtCe8-G0bq_Xf9Kuc8KToKyB5A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com, Theodore Tso <tytso@mit.edu>

On 2017/8/16 19:10, Amir Goldstein Wrote:
> On Wed, Aug 16, 2017 at 12:19 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Tue, Aug 15, 2017 at 6:16 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> On Tue, Aug 15, 2017 at 5:56 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>
>>>> IIUC, so now "chattr -p <id>" will fail on overlayfs (assume file has not
>>>> been copied up yet).
>>>>
>>>
>>> Yap.
>>>
>>>> IOW, on overlayfs, will it be responsibility of user space to make
>>>> sure file has been copied up, for chattr operation to succeed? Does that
>>>> mean we need to modify chattr to open file for WRITE instead of READ.
>>>>
>>>
>>> I guess that would make sense.
>>> I only wonder what was the reason for chattr to open RDONLY in
>>> the first place (cc Ted)??
>>
>> What about copy up of flags?  Should we?
> 
> IMO we should start with copying KSTAT_ATTR_FS_IOC_FLAGS,
> which can already be available in kstat.
> Other "standard" FS_IOC_FLAGS can be copied up when statx
> gets support for those flags.
> 
> FYI, chattr [+/-]<flags> does:
> - fgetflags(&flags): {open OPEN_FLAGS; ioctl EXT2_IOC_GETFLAGS}
> - change flags
> - fsetflags(&flags): {open OPEN_FLAGS; ioctl EXT2_IOC_SETFLAGS}
> 
> OPEN_FLAGS is defined independently in lib/e2p/f{get,set}flags.c as
> (O_RDONLY|O_NONBLOCK|O_LARGEFILE), so technically all it
> takes is to change the defined in  lib/e2p/fsetflags.c to O_RDWR
> and then chattr [+/-]<flags> can be used for preemptive "copy up flags"
> by userspace (*) to work around issues which require flags copy up.
> 

Hi Amir:
I notice that RDONLY is required if file is immutable or append-only,
chattr will fail with EPERM return value if we use O_RDWR open flag to open
a immutable or append-only file. So I think we cannot simply change
to O_RDWR in lib/e2p/fsetflags.c, we should take care about this special,
please see check in may_open() and __inode_permission().

Thanks,
Zhangyi.
