From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v3 00/17] Xattr inode operation removal
Date: Mon, 30 May 2016 12:49:28 +0200
Message-ID: <CAHc6FU6gZHEcrqvyKdKJbFVrd0L8=M2ynm2GD6tQx32fzTjD=g@mail.gmail.com>
References: <1464598653-3656-1-git-send-email-agruenba@redhat.com>
	<CA+icZUXGxsw-g1W8QzwuFx=8UTnxzQD9UsNEH2PHCGrqW=0xdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33228 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbcE3Kt3 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 30 May 2016 06:49:29 -0400
Received: by mail-vk0-f48.google.com with SMTP id r140so218092512vkf.0
        for <linux-unionfs@vger.kernel.org>; Mon, 30 May 2016 03:49:28 -0700 (PDT)
In-Reply-To: <CA+icZUXGxsw-g1W8QzwuFx=8UTnxzQD9UsNEH2PHCGrqW=0xdA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: sedat.dilek@gmail.com
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, LSM <linux-security-module@vger.kernel.org>, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

On Mon, May 30, 2016 at 11:54 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On 5/30/16, Andreas Gruenbacher <agruenba@redhat.com> wrote:
>> This is version 3 of the xattr inode operation removal patch series. The
>> patches are available in git form at:
>>
>>
>> https://git.kernel.org/cgit/linux/kernel/git/agruen/linux.git/log/?h=work.xattr
[...]
>>
> Hi,
>
> I pulled in agruen/linux.git#work.xattr on top of Linux v4.7-rc1 and noticed...
>
>  92 files changed, 563 insertions(+), 703 deletions(-)
>
> So this is on top of Linux v4.7-rc1+?

Well, I've actually rebased the patches on top of commit b02b1fbd
which is the current mainline and one merge after v4.7-rc1, but the
few scsi commits in between -rc1 and b02b1fbd are completely
unrelated. You can easily see that in git.

> I am here on Ubuntu/precise AMD64 realized as a WUBI-installation.
> So I use fuse, loop-device and ext4-fs.
>
> Not sure, how to test your patchset.
> Can you give some instructions on a testcase/usecase?

The patches potentially affect xattrs and anthing that's xattr based,
like POSIX ACLs, SELinux, and Smack. There are some POSX ACL tests in
xfstests. The basic xattr functionality can of course be checked with
getfattr / setfattr. Other than that, I can probably only refer you to
the code itself.

> Booting into a kernel with your patchset looks fine to me - on the 1st sight.

Okay, thanks.

Andreas
