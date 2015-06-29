From: sa <sa-dev@rainbow.by>
Subject: Re: [PATCH 0/2] ovl: support NFS as lower layer
Date: Mon, 29 Jun 2015 18:08:50 +0300
Message-ID: <55915F82.3090907@rainbow.by>
References: <1433424586-7771-1-git-send-email-miklos@szeredi.hu> <559006EB.605@rainbow.by> <20150629143558.GA6605@tucsk.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mgate.rtcs.ru ([188.127.242.169]:38420 "EHLO mail.rainbow.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbbF2PI4 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 29 Jun 2015 11:08:56 -0400
In-Reply-To: <20150629143558.GA6605@tucsk.suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

On 29.06.2015 17:35, Miklos Szeredi wrote:
> On Sun, Jun 28, 2015 at 05:38:35PM +0300, sa wrote:
>> On 04.06.2015 16:29, Miklos Szeredi wrote:
>>
>>> Two small patches implementing this follow.  Comments and testing welcome.
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next
>>> ---
>>>   fs/overlayfs/super.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++-----
>>>   1 file changed, 74 insertions(+), 7 deletions(-)
>>
>> Thank you, it works in our environment mostly as expected, except
>> of the following:
>> files already existing in readonly NFS lowerdir can't be opened
>> for writing (but can be deleted). Newly created files are writable
>> as expected. The same lowerdir works with aufs without problem.
>
> Is the lower fs exported read-only on the NFS server?
>
> If so, can you please apply the following patch and specify
> 'default_permissions' mount option?


It works fine.

(sid)root@usbsid:/var# cat test
00000
(sid)root@usbsid:/var# echo 11111 > test
(sid)root@usbsid:/var# cat test
11111
(sid)root@usbsid:/var# echo 22222 >> test
(sid)root@usbsid:/var# cat test
11111
22222
(sid)root@usbsid:/var# mount | grep overlay
overlay on /var type overlay 
(rw,relatime,lowerdir=/auvar.ro,upperdir=/auvar.rw/.upperdir,workdir=/auvar.rw/.workdir,default_permissions)

Lower fs exported with (ro,async,no_root_squash,no_subtree_check).


-- 
sa
