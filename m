From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [V9fs-developer] 9p/overlayfs: read error when reading an empty file
Date: Mon, 12 Oct 2015 19:14:16 +0200
Message-ID: <CAJfpegurhotqht8apANWM1iWOw7YWb1oAcY6Nq7nKOp80jvTaQ@mail.gmail.com>
References: <87oai9hui2.fsf@zoro.exoscale.ch>
	<877fowita7.fsf@zoro.exoscale.ch>
	<20150817141137.GA15883@u-michard>
	<m3pp0v51ai.fsf@neo.luffy.cx>
	<20151003191955.GB17610@nautica>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35148 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbJLROQ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 12 Oct 2015 13:14:16 -0400
Received: by obbzf10 with SMTP id zf10so110958736obb.2
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Oct 2015 10:14:16 -0700 (PDT)
In-Reply-To: <20151003191955.GB17610@nautica>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Vincent Bernat <bernat@luffy.cx>, Dominique Martinet <dominique.martinet@cea.fr>, Latchesar Ionkov <lucho@ionkov.net>, Eric Van Hensbergen <ericvh@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, v9fs-developer@lists.sourceforge.net, Ron Minnich <rminnich@sandia.gov>, Al Viro <viro@zeniv.linux.org.uk>

On Sat, Oct 3, 2015 at 9:19 PM, Dominique Martinet
<asmadeus@codewreck.org> wrote:
> Vincent Bernat wrote on Sat, Oct 03, 2015:
>> Did you get any feedback on this? The problem is unfortunately still
>> present in 4.3-rc3.
>
> Sorry, haven't got any reply but I bet it is :(
>
> I've been meaning to ask again after a while but it slipped out of my
> head again...
>
> Basically 9P stores informations in both the inode and dentry, the
> change (4bacc9 "overlayfs: Make f_path always point to the overlay and
> f_inode to the underlay") makes it so that we get unexpected info in
> f_path->dentry->d_sb->s_fs_info and crash...
>
>
> I actually am not quite sure where the change needed belongs in the
> first place, I don't even know how the 9P layer could check if the filep
> isn't a "9p filep" in the first place, nor how it could work around it
> if it notices that's what happened, so I'm afraid I won't be of much
> help there...
>
> We probably can remove the need for dentry->d_sb->s_fs_info in this case
> (it's the 9p session info which we can get from the inode, which is also
> available) but 9p keeps a list with dentries for fids that I have no
> idea if it will make sense and/or be safe if we start mixing up overlay
> stuff in.
> Also, and worse, this only fixes the case where 9p is the underlay -- if
> someone gets the idea to use 9p as overlay then we'll get a "bad" inode
> and good dentry which will cause different problems, so once again we
> need to know where stuff comes from.
> And what about stacked overlays when 9P is in the middle, neither inode
> nor file would be "our's" ?...
>
> I'm sure I'm missing something simple and overcomplicating things, but I
> just don't have time to try to dig into the overlayfs code right now
> sorry.

The solution depends on how 9p handles hard links.  If any dentry will
do then d_find_any_alias() will get you a dentry (any dentry) from the
inode.

Otherwise I know of no mechanism to get the backing dentry from the file.

Thanks,
Miklos
