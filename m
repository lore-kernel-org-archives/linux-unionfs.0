From: Dominique Martinet <dominique.martinet@cea.fr>
Subject: Re: [V9fs-developer] 9p/overlayfs: read error when reading an empty
 file
Date: Mon, 17 Aug 2015 16:11:37 +0200
Message-ID: <20150817141137.GA15883@u-michard>
References: <87oai9hui2.fsf@zoro.exoscale.ch>
 <877fowita7.fsf@zoro.exoscale.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from sainfoin-out.extra.cea.fr ([132.167.192.145]:42635 "EHLO
	sainfoin-out.extra.cea.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbbHQOZK (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 17 Aug 2015 10:25:10 -0400
Received: from pisaure.intra.cea.fr (pisaure.intra.cea.fr [132.166.88.21])
	by sainfoin.extra.cea.fr (8.14.2/8.14.2/CEAnet-Internet-out-2.3) with ESMTP id t7HEBsjW030445
	for <linux-unionfs@vger.kernel.org>; Mon, 17 Aug 2015 16:11:54 +0200
Received: from pisaure.intra.cea.fr (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 4F897202CA7
	for <linux-unionfs@vger.kernel.org>; Mon, 17 Aug 2015 16:16:04 +0200 (CEST)
Received: from muguet2.intra.cea.fr (muguet2.intra.cea.fr [132.166.192.7])
	by pisaure.intra.cea.fr (Postfix) with ESMTP id 3C9D6202E3E
	for <linux-unionfs@vger.kernel.org>; Mon, 17 Aug 2015 16:16:04 +0200 (CEST)
Received: from zia.cdc.esteban.ctsi (out.dam.intra.cea.fr [132.165.76.10])
	by muguet2.intra.cea.fr (8.13.8/8.13.8/CEAnet-Intranet-out-1.2) with SMTP id t7HEBqmX025579
	for <linux-unionfs@vger.kernel.org>; Mon, 17 Aug 2015 16:11:53 +0200
Content-Disposition: inline
In-Reply-To: <877fowita7.fsf@zoro.exoscale.ch>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vincent Bernat <bernat@luffy.cx>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, v9fs-developer@lists.sourceforge.net

Vincent Bernat wrote on Sat, Aug 15, 2015 at 03:18:56PM +0200:
> For this bug, I was able to bisect to this commit:
> 
> 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01 is the first bad commit
> commit 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01
> Author: David Howells <dhowells@redhat.com>
> Date:   Thu Jun 18 14:32:31 2015 +0100
> 
>     overlayfs: Make f_path always point to the overlay and f_inode to the underlay
> 
> In fact, any file reading of files present in the lower layer will lead
> to this. No need to try to switch root or anything complex.

Hmm, that is going to be annoying to fix, since we use
file->f_path.dentry to get a new fid to the same file (clone), and
current code pretty much depends on that...

I guess it used to work because file->f_op, file->f_inode and
file->f_path used to all be from the same layer, which isn't the case
anymore.


Does any overlayfs person reading this know if it's still possible to
get the right dentry at this point?
I'm sure the object exists somewhere in memory, but it could be annoying
to find.

Thanks,
-- 
Dominique
