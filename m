From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PATCH] overlay: stress test changes to top and bottom layers simultaneously
Date: Sat, 10 Dec 2016 02:30:03 +0900
Message-ID: <14481.1481304603@jrobl>
References: <20161208035844.18544-1-tytso@mit.edu> <20161208043739.GF29149@eguan.usersys.redhat.com> <CAOQ4uxhKvQKMqUtGS+meRyt3WRzH=-DkGndCqmEUD1d+v1_Dog@mail.gmail.com> <20161208141639.tzblbtwlqyzhckrm@thunk.org>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mfb01-md.ns.itscom.net ([175.177.155.109]:51676 "EHLO
        mfb01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933872AbcLIRfQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Dec 2016 12:35:16 -0500
Received: from mail04-md.ns.itscom.net (mail04-md.ns.itscom.net [175.177.155.114])
        by mfb01-md.ns.itscom.net (Postfix) with ESMTP id C3C38238332
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Dec 2016 02:30:06 +0900 (JST)
In-Reply-To: <20161208141639.tzblbtwlqyzhckrm@thunk.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Amir Goldstein <amir73il@gmail.com>, Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org


"Theodore Ts'o":
> Since the use of unionfs is deprecated, I didn't bother to test it,
> although I could if someone was really curious whether it would BUG or
> not.  (Given that both wrapfs and sdcardfs did BUG, I'm pretty that
> unionfs, as a wrapfs derivitive, also would go down in flames.  It
> might also be fun, since there are some Ubuntu Docker users using
> AUFS, to see if AUFS --- as another wrapfs derivitive --- might also
> be succeptible.)

If you mean that aufs is based upon wrapfs or unionfs, then it is not
true. aufs1 was based upon unionfs acutally, but aufs2 and later are
totally re-written and added many new approaches and ideas.

Some of those new approaches are opposite of overlayfs' ones.
For example,
- overlayfs added d_real_inode(), lock_inode() and others into VFS. They
  aim to get the layers' inode via overlayfs' dentry. Honestly speaking
  I am afraid they confuse people who were calling d_inode().
- aufs aims to be an ordinary filesystem against VFS, and VFS uses its
  dentry as usual. Acessing the layers' inode is totally hidden within
  aufs and VFS doesn't care about it.
  One exception aufs modifies VFS (actually MM module) is vma_struct
  which contains a file pointer to point the file mmapped. Aufs adds
  another file pointer to show the path under procfs.

Also aufs allows users to modify the files on the layers direcly,
ie. bypassing aufs. Next time when user accesses those files, aufs
re-validates it and detect the changes. Additioanlly aufs has
another option to discard the caches when the files on the layers
changed directly.


J. R. Okajima
