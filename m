From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [V9fs-developer] 9p/overlayfs: what inodes/dentries are safe to use?
Date: Tue, 13 Oct 2015 05:33:00 +0200
Message-ID: <CAJfpegujzXb49saZWuNDHzrmfboCAhqx=daLY-b+9=HA93ZKjw@mail.gmail.com>
References: <CAJfpegurhotqht8apANWM1iWOw7YWb1oAcY6Nq7nKOp80jvTaQ@mail.gmail.com>
	<20151012174759.GA31768@nautica>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33451 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbbJMDdB (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 12 Oct 2015 23:33:01 -0400
Received: by oiar126 with SMTP id r126so2806558oia.0
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Oct 2015 20:33:00 -0700 (PDT)
In-Reply-To: <20151012174759.GA31768@nautica>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Vincent Bernat <bernat@luffy.cx>, Dominique Martinet <dominique.martinet@cea.fr>, Latchesar Ionkov <lucho@ionkov.net>, Eric Van Hensbergen <ericvh@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, v9fs-developer@lists.sourceforge.net, Ron Minnich <rminnich@sandia.gov>, Al Viro <viro@zeniv.linux.org.uk>

On Mon, Oct 12, 2015 at 7:47 PM, Dominique Martinet
<asmadeus@codewreck.org> wrote:
> Miklos Szeredi wrote on Mon, Oct 12, 2015:
>> The solution depends on how 9p handles hard links.  If any dentry will
>> do then d_find_any_alias() will get you a dentry (any dentry) from the
>> inode.
>>
>> Otherwise I know of no mechanism to get the backing dentry from the file.
>
> I've got two problems at the moment:
>  - first, 9P stores informations in the superblock (accessed
> through either dentry->d_sb->s_fs_info or inode->i_sb->...), and
> operations such as read will get passed an inode and a file (which has a
> dentry), but 9P doesn't know which to trust (if I go this right - if 9P
> is underlay then the inode is 9p's, if 9P is overlay then the dentry
> is ?)

file->f_path shouldn't be trusted by filesystems for non-directories.  Ever.

Solution to this particular problem?  Not sure.

Al?

Thanks,
Miklos
