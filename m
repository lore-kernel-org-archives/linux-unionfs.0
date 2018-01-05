From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 04/17] ovl: decode connected upper dir file handles
Date: Fri, 5 Jan 2018 14:33:22 +0200
Message-ID: <CAOQ4uxhpNCUzcuFSvntAN_JDB=L5NDqZP4m9TxytyO-P6t3F0Q@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com> <1515086449-26563-5-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:40410 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbeAEMdY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 07:33:24 -0500
In-Reply-To: <1515086449-26563-5-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jan 4, 2018 at 7:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Until this change, we decoded upper file handles by instantiating an
> overlay dentry from the real upper dentry. This is sufficient to handle
> pure upper files, but insufficient to handle merge/impure dirs.
>
> To that end, if decoded real upper dir is connected and hashed, we
> lookup an overlay dentry with the same path as the real upper dir.
> If decoded real upper is non-dir, we instantiate a disconnected overlay
> dentry as before this change.
>
> Because ovl_fh_to_dentry() returns connected overlay dir dentries,
> exportfs never need to call get_parent() and get_name() to reconnect an
> upper overlay dir. Because connectable non-dir file handles are not
> supported, exportfs will not be able to use fh_to_parent() and get_name()
> methods to reconnect a disconnected non-dir to its parent. Therefore, the
> methods get_parent() and get_name() are implemented just to print out a
> sanity warning and the method fh_to_parent() is implemented to warn the
> user that using the 'subtree_check' exportfs option is not supported.
>

Reviewers who will get this far, should have their eyebrows slightly raised
after reading this commit message and should be asking themselves:

"Why not return a disconnected overlay dentry like any other fs and implement
ovl_get_parent()/ovl_get_name() by looking at parent/name of upper dir?"

I have had this debate with myself for a while and experimented a bit with
both approaches and in the end, I liked the "return connected dentry" result
better. I did not want to write this entire story in commit message, because
in the end, there is nothing incorrect about the choice of either implementation
there are only pros and cons to each choice.

At the moment, the only argument I can think of to counter the chosen approach
is that it adds ~100 lines on code in ovl_lookup_real() and
ovl_lookup_real_one()
helpers that could have been avoided by using the common reconnect_path()
code in fs/exportfs/expfs.c.

The arguments to counter the disconnected dir approach are:
- Obtaining a disconnected overlay dir dentry would requires a
delicate re-factoring
  of ovl_lookup() to get a dentry with overlay parent info. I
personally preferred to
  avoid doing that re-factoring unless it was proven worthy.
- Going down the path of disconnected dir would mean that the (non trivial) code
  path of d_splice_alias() could be traveled and that meant writing
more tests and
  introduces race cases that are very hard to hit on purpose. Taking the path of
  connecting overlay dentry by forward lookup is therefore the safe and boring
  way to avoid surprises.
- In the current implementation, there is an anomaly in the multi
lower layer setup.
  In that case, indexed upper dir inodes are hashed by the lower
inode, but their file
  handles are encoded from the upper inode. Obtaining a disconnected
dir from this
  type of upper file handle would have been a special case that would add more
  code and more complexity. With the forward lookup connect approach, the
  anomaly does not require changing the code - connecting the dentry
is just less
  efficient in case there is an ancestor in inode cache (we won't find
it in cache
  because we will be looking with the wrong inode) and that can be
fixed later if
  we find that use case important enough.

There. Now you see why I did not want this story in commit message?

Amir.
