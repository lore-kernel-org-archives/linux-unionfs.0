Return-Path: <SRS0=jndh=7J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7760CC433E2
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 16:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DBF92088E
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 May 2020 16:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gchwcxAh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgE0QCt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 May 2020 12:02:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20779 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725859AbgE0QCs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 May 2020 12:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590595366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PS3dQfbEL/6uFsDh8Q1oaIa70PqNyOBYf3pxyVqavyY=;
        b=gchwcxAhs4Y2g3UlF5LtAJsEj8dG7fmoZ14N5v/95CcwlH4zQStK7NcIdChi0FQLrllOK/
        Z0tblkuON1dHfxsByDWQAomto7JG2Y+B0DAcNKGFecDe9MSS7QezWvaZL+XxgbDm7rRHpa
        fyP+TZSctABqLzsA4V53fgZvgggBZTc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-EJ0yXKAlMhGP57F2U4Evng-1; Wed, 27 May 2020 12:02:44 -0400
X-MC-Unique: EJ0yXKAlMhGP57F2U4Evng-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C54D481CBE1;
        Wed, 27 May 2020 16:02:43 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-83.rdu2.redhat.com [10.10.116.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 935BF78B2C;
        Wed, 27 May 2020 16:02:43 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 22CF2220391; Wed, 27 May 2020 12:02:43 -0400 (EDT)
Date:   Wed, 27 May 2020 12:02:43 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH] ovl: fix some bug exist in ovl_get_inode
Message-ID: <20200527160243.GA140950@redhat.com>
References: <20200527041711.60219-1-yangerkun@huawei.com>
 <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
 <CAJfpegv8-6heAchSSGu1o6Rktd=v+PCFtAddeQhdvgAeiP0ztw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegv8-6heAchSSGu1o6Rktd=v+PCFtAddeQhdvgAeiP0ztw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 27, 2020 at 04:46:37PM +0200, Miklos Szeredi wrote:
> On Wed, May 27, 2020 at 1:16 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, May 27, 2020 at 6:45 AM yangerkun <yangerkun@huawei.com> wrote:
> > >
> > > Run generic/461 with ext4 upper/lower layer sometimes may trigger the
> > > bug as below(linux 4.19):
> > >
> > > [  551.001349] overlayfs: failed to get metacopy (-5)
> > > [  551.003464] overlayfs: failed to get inode (-5)
> > > [  551.004243] overlayfs: cleanup of 'd44/fd51' failed (-5)
> > > [  551.004941] overlayfs: failed to get origin (-5)
> > > [  551.005199] ------------[ cut here ]------------
> > > [  551.006697] WARNING: CPU: 3 PID: 24674 at fs/inode.c:1528 iput+0x33b/0x400
> > > ...
> > > [  551.027219] Call Trace:
> > > [  551.027623]  ovl_create_object+0x13f/0x170
> > > [  551.028268]  ovl_create+0x27/0x30
> > > [  551.028799]  path_openat+0x1a35/0x1ea0
> > > [  551.029377]  do_filp_open+0xad/0x160
> > > [  551.029944]  ? vfs_writev+0xe9/0x170
> > > [  551.030499]  ? page_counter_try_charge+0x77/0x120
> > > [  551.031245]  ? __alloc_fd+0x160/0x2a0
> > > [  551.031832]  ? do_sys_open+0x189/0x340
> > > [  551.032417]  ? get_unused_fd_flags+0x34/0x40
> > > [  551.033081]  do_sys_open+0x189/0x340
> > > [  551.033632]  __x64_sys_creat+0x24/0x30
> > > [  551.034219]  do_syscall_64+0xd5/0x430
> > > [  551.034800]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > ...
> > > [  556.107515] BUG: Dentry 000000006bc1d73f{i=4129c,n=fd51}  still in use (-1) [unmount of ext4 sdb]
> > > [  556.108946] ------------[ cut here ]------------
> > > [  556.109686] WARNING: CPU: 1 PID: 24682 at fs/dcache.c:1557 umount_check+0x95/0xc0
> > > [  556.130343]  d_walk+0x10d/0x430
> > > [  556.130832]  do_one_tree+0x30/0x60
> > > [  556.131365]  shrink_dcache_for_umount+0x38/0xe0
> > > [  556.132063]  generic_shutdown_super+0x2e/0x1c0
> > > [  556.132747]  kill_block_super+0x29/0x80
> > > [  556.133338]  deactivate_locked_super+0x7a/0x100
> > > [  556.134034]  deactivate_super+0x9d/0xb0
> > > [  556.134627]  cleanup_mnt+0x67/0x100
> > > [  556.135173]  __cleanup_mnt+0x16/0x20
> > > [  556.135731]  task_work_run+0xdb/0x110
> > > [  556.136306]  exit_to_usermode_loop+0x197/0x1b0
> > > [  556.136991]  do_syscall_64+0x3ce/0x430
> > > [  556.137571]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > ...
> > > [  556.378140] VFS: Busy inodes after unmount of sdb. Self-destruct in 5 seconds.  Have a nice day...
> > >
> > > After check the code, there may some bug need to fix:
> > > 1. We need to call iput once ovl_check_metacopy_xattr fail.
> > > 2. We need to call unlock_new_inode or the above iput(also with iput in
> > >    ovl_create_object) will trigger the a WARN_ON since  the I_NEW still
> > >    exists.
> > > 3. We should move the init for upperdentry to the place below
> > >    ovl_check_metacopy_xattr. Or the dentry reference will decrease to
> > >    -1(error path in ovl_create_upper will inc, ovl_destroy_inode too).
> > >
> >
> > OR we don't check metacopy xattr in ovl_get_inode().
> >
> > In ovl_lookup() we already checked metacopy xattr.
> > No reason to check it again in this subtle context.
> >
> > In ovl_lookup() can store value of upper metacopy and after we get
> > the inode, set the OVL_UPPERDATA inode flag according to
> > upperdentry && !uppermetacopy.
> >
> > That would be consistent with ovl_obtain_alias() which sets the
> > OVL_UPPERDATA inode flag after getting the inode.
> 
> I agree that that is a good direction, however for the actual fix I
> think the following is sufficient (whitespace damaged, only for
> review).
> 
> The reason we can skip the metacopy check for the ->newinode != NULL
> case is that that only happens on object creation, which very
> obviously won't have metacopy set.
> 
> Thanks,
> Miklos
> 
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 3b7ed5d2279c..fd7f1d4adf04 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -889,7 +889,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
>      if (oip->index)
>          ovl_set_flag(OVL_INDEX, inode);
> 
> -    if (upperdentry) {
> +    if (upperdentry && !oip->newinode) {
>          err = ovl_check_metacopy_xattr(upperdentry);
>          if (err < 0)
>              goto out_err;

Hi Miklos and Amir,

How about enahncing above a bit to deal with error. Will this work. Just
compile tested.

Thanks
Vivek

---
 fs/overlayfs/inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: redhat-linux/fs/overlayfs/inode.c
===================================================================
--- redhat-linux.orig/fs/overlayfs/inode.c	2020-05-26 15:24:57.209940278 -0400
+++ redhat-linux/fs/overlayfs/inode.c	2020-05-27 11:58:17.015732493 -0400
@@ -1018,10 +1018,13 @@ struct inode *ovl_get_inode(struct super
 	if (oip->index)
 		ovl_set_flag(OVL_INDEX, inode);
 
-	if (upperdentry) {
+	if (upperdentry && !oip->newinode) {
 		err = ovl_check_metacopy_xattr(upperdentry);
-		if (err < 0)
+		if (err < 0) {
+			if (inode->i_state & I_NEW)
+				iget_failed(inode);
 			goto out_err;
+		}
 		metacopy = err;
 		if (!metacopy)
 			ovl_set_flag(OVL_UPPERDATA, inode);

