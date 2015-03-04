From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: stat inconsistency with overlayfs
Date: Wed, 4 Mar 2015 12:06:43 +0100
Message-ID: <CAJfpegvkB5KDOkyVKM=dKgb=1JiAavG1EsL2pXDKSSV+GFwydg@mail.gmail.com>
References: <54E779BB.8030209@web2web.at>
	<54EEAE3A.5000006@huawei.com>
	<37851744.28042779.1424933137550.JavaMail.zimbra@redhat.com>
	<54F4CC02.3040808@web2web.at>
	<CAJfpegtV-UZmnu8HvH9RQiewv14bqpUao=OvnOCCJGhE0DXDHw@mail.gmail.com>
	<54F5EB8D.1080201@web2web.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:40987 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235AbbCDLGo (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 4 Mar 2015 06:06:44 -0500
Received: by qcvx3 with SMTP id x3so7494091qcv.8
        for <linux-unionfs@vger.kernel.org>; Wed, 04 Mar 2015 03:06:43 -0800 (PST)
In-Reply-To: <54F5EB8D.1080201@web2web.at>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Atom2 <ariel.atom2@web2web.at>
Cc: Xu Wang <xuw@redhat.com>, hujianyang <hujianyang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Mar 3, 2015 at 6:12 PM, Atom2 <ariel.atom2@web2web.at> wrote:
> Mikolos,
> thanks for joining the party.
>
> Am 03.03.15 um 16:14 schrieb Miklos Szeredi:
>
>> Atom2,
>>
>>> The use case behind that is to be able to backup only files from the
>>> upperdir for several systems sharing a common lowerdir filesystem. I have
>>> used that (scripted approach via rsync) now for quiet some time and a few
>>> kernels back and it seemed to have worked very well.
>>
>>
>> Why don't you just back up the upper directory itself instead of
>> messing around with device numbers?
>
>
> I am not aware of any such option, but if you could explain that a little
> bit more in detail, I am happy to explore other options.
>
> Just for everybody to be on the same page: In my use case the r/o lowerdir's
> root directory is also the root of my file system (which is shared across
> many systems) from which (all) the systems boot. Using an initramfs during
> the boot process, the upperdir file system (which is different per system)
> is then r/w overlay-mounted over the common r/o lowerdir's root directory in
> order to catch any r/w access to the file system.
>
> So in essence and according to my understanding there's no direct access to
> (only) the r/w upperdir (or only the lowerdir) from within any of the
> running systems other than using the device field to see where a file system
> entry actually exists - at least that's my current understanding.

Having access to the upperdir is just your own choice.

Without knowing the details of how you set up the mounts I can't give
you a concrete example, but see for example the pivot_root(8) man page
on how to get access to your old mountpoint.  You can also use bind
mounts to clone the upperdir into the overlay namespace.

Thanks,
Miklos
