From: Atom2 <ariel.atom2@web2web.at>
Subject: Re: stat inconsistency with overlayfs
Date: Tue, 03 Mar 2015 18:12:45 +0100
Message-ID: <54F5EB8D.1080201@web2web.at>
References: <54E779BB.8030209@web2web.at>	<54EEAE3A.5000006@huawei.com>	<37851744.28042779.1424933137550.JavaMail.zimbra@redhat.com>	<54F4CC02.3040808@web2web.at> <CAJfpegtV-UZmnu8HvH9RQiewv14bqpUao=OvnOCCJGhE0DXDHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from grace.univie.ac.at ([131.130.3.115]:43377 "EHLO
	grace.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbbCCRMu (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 3 Mar 2015 12:12:50 -0500
In-Reply-To: <CAJfpegtV-UZmnu8HvH9RQiewv14bqpUao=OvnOCCJGhE0DXDHw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Wang <xuw@redhat.com>, hujianyang <hujianyang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Mikolos,
thanks for joining the party.

Am 03.03.15 um 16:14 schrieb Miklos Szeredi:
> Atom2,
>
>> The use case behind that is to be able to backup only files from the
>> upperdir for several systems sharing a common lowerdir filesystem. I have
>> used that (scripted approach via rsync) now for quiet some time and a few
>> kernels back and it seemed to have worked very well.
>
> Why don't you just back up the upper directory itself instead of
> messing around with device numbers?

I am not aware of any such option, but if you could explain that a 
little bit more in detail, I am happy to explore other options.

Just for everybody to be on the same page: In my use case the r/o 
lowerdir's root directory is also the root of my file system (which is 
shared across many systems) from which (all) the systems boot. Using an 
initramfs during the boot process, the upperdir file system (which is 
different per system) is then r/w overlay-mounted over the common r/o 
lowerdir's root directory in order to catch any r/w access to the file 
system.

So in essence and according to my understanding there's no direct access 
to (only) the r/w upperdir (or only the lowerdir) from within any of the 
running systems other than using the device field to see where a file 
system entry actually exists - at least that's my current understanding.

But again, I am happy to learn ...

Regards Atom2
