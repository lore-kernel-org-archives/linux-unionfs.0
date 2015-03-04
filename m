From: hujianyang <hujianyang@huawei.com>
Subject: Re: stat inconsistency with overlayfs
Date: Wed, 4 Mar 2015 10:24:00 +0800
Message-ID: <54F66CC0.8000602@huawei.com>
References: <54E779BB.8030209@web2web.at>	<54EEAE3A.5000006@huawei.com>	<37851744.28042779.1424933137550.JavaMail.zimbra@redhat.com>	<54F4CC02.3040808@web2web.at> <CAJfpegtV-UZmnu8HvH9RQiewv14bqpUao=OvnOCCJGhE0DXDHw@mail.gmail.com> <54F5EB8D.1080201@web2web.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:63195 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774AbbCDCYP (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 3 Mar 2015 21:24:15 -0500
In-Reply-To: <54F5EB8D.1080201@web2web.at>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Atom2 <ariel.atom2@web2web.at>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Xu Wang <xuw@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On 2015/3/4 1:12, Atom2 wrote:
> Mikolos,
> thanks for joining the party.
> 
> Am 03.03.15 um 16:14 schrieb Miklos Szeredi:
>> Atom2,
>>
>>> The use case behind that is to be able to backup only files from the
>>> upperdir for several systems sharing a common lowerdir filesystem. I have
>>> used that (scripted approach via rsync) now for quiet some time and a few
>>> kernels back and it seemed to have worked very well.
>>
>> Why don't you just back up the upper directory itself instead of
>> messing around with device numbers?
> 
> I am not aware of any such option, but if you could explain that a little bit more in detail, I am happy to explore other options.
> 
> Just for everybody to be on the same page: In my use case the r/o lowerdir's root directory is also the root of my file system (which is shared across many systems) from which (all) the systems boot. Using an initramfs during the boot process, the upperdir file system (which is different per system) is then r/w overlay-mounted over the common r/o lowerdir's root directory in order to catch any r/w access to the file system.
> 
> So in essence and according to my understanding there's no direct access to (only) the r/w upperdir (or only the lowerdir) from within any of the running systems other than using the device field to see where a file system entry actually exists - at least that's my current understanding.
> 
> But again, I am happy to learn ...
> 
> Regards Atom2
> 
> 

Seems not all upper directories are accessible.

Miklos, I didn't find the change log about device number changing, Maybe
there are some reasons?

For Atom2's requirement, I have some thoughts:

The device number of Overlayfs are now different between files and
directories, My plan is showing Overlayfs device number for upper and
upper-merged(upper and several lower) file/dir, using

"stat->dev = dentry->d_sb->s_dev"

and showing lowerfs device number for a lower only file/dir.

For upper non-directory files, report Overlayfs device number.
Do not change the stat of a lower non-directory file.

For upper and upper-merged directories, report Overlayfs device number as
before. But for lower only directories, report lowerfs device number.

After this, Atom2 could backup the files and directories have a device
number equal to Overlayfs mount device number. But as Xu mentioned, this
device number is just fake, so I don't know if there are other problems.

And for multi-lower mount, an Overlayfs directory may mixed up by several
lower directories, Atom2 seems don't want to backup this kind of directories,
we couldn't set the device number to Overlayfs device number, maybe we
could use the left most lowerdir device number, but that may confused with
the lower only directories.

Thanks,
Hu



