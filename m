Return-Path: <SRS0=6v4H=7K=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750F5C433DF
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 May 2020 17:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A567207BC
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 May 2020 17:35:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NHqVxxBQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405612AbgE1RfY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 May 2020 13:35:24 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49697 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405611AbgE1RfW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 May 2020 13:35:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590687319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CcDNhviUC5gzCJw3BN5w5/XW98KRAJvySkzLtgV7neU=;
        b=NHqVxxBQstiY+GGsSh69BPj8j10hpRDTZaBV+Js8KwsdscOgW2u7+Z/ZbSZXPAt96oEcMg
        /rWMfkFubcjwimJrIyGim/+wvnnLZf9obg4Urm8C5DIdvcqb57epHifNhrGKRw23PeYECD
        JLaZPibNFr8DjqaXN48I13NxFfnDW/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-_OrCnimOMLyMh1hVZvrU7Q-1; Thu, 28 May 2020 13:35:16 -0400
X-MC-Unique: _OrCnimOMLyMh1hVZvrU7Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0A98A0BDD;
        Thu, 28 May 2020 17:35:14 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-125.rdu2.redhat.com [10.10.116.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 798DE5C1C8;
        Thu, 28 May 2020 17:35:13 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id E9957220391; Thu, 28 May 2020 13:35:12 -0400 (EDT)
Date:   Thu, 28 May 2020 13:35:12 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: [PATCH] ovl: fix some bug exist in ovl_get_inode
Message-ID: <20200528173512.GA167257@redhat.com>
References: <20200527041711.60219-1-yangerkun@huawei.com>
 <CAOQ4uxjjUjEzvy=b96FZPGt4nhOfwFk1_XE2Po9scYDiPPkJgQ@mail.gmail.com>
 <20200527194925.GD140950@redhat.com>
 <CAOQ4uxis2fgf_c02q=Fy2h=C0U+_zrfUmxW1HQOJ0A7KaKqWgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxis2fgf_c02q=Fy2h=C0U+_zrfUmxW1HQOJ0A7KaKqWgg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 27, 2020 at 11:11:38PM +0300, Amir Goldstein wrote:

[..]
> > > OR we don't check metacopy xattr in ovl_get_inode().
> > >
> > > In ovl_lookup() we already checked metacopy xattr.
> > > No reason to check it again in this subtle context.
> > >
> > > In ovl_lookup() can store value of upper metacopy and after we get
> > > the inode, set the OVL_UPPERDATA inode flag according to
> > > upperdentry && !uppermetacopy.
> > >
> > > That would be consistent with ovl_obtain_alias() which sets the
> > > OVL_UPPERDATA inode flag after getting the inode.
> >
> > Hi Amir,
> >
> > This patch implements what you are suggesting. Compile tested only.
> > Does this look ok?
> >
> 
> It looks correct.
> 
> > May be I don't need to split it up in lmetacopy and umetacopy. Ideally,
> > lookup in lower layers should stop if an upper regular file is not
> > metacopy. IOW, (upperdentry && !metacopy) might be sufficient check.
> > Will look closely if this patch looks fine.
> >
> 
> I would stick uppermetacopy much like upperredirect and upperopaque.

Ok, I introduced uppermetacopy and lowermetacopy. I need to make
sure that I don't following metacopy file to lower layer if
metacopy feature is off. This check should be done both for upper
and lower metcopy files.

> 
> This test:
> 
>         if (metacopy) {
>                 /*
>                  * Found a metacopy dentry but did not find corresponding
>                  * data dentry
>                  */
>                 if (d.metacopy) {
> 
> Is equivalent to if (d.metacopy) {

Agreed. Updated the patch.

> 
> I am not sure about:
>         if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
>                 origin = stack[0].dentry;
> 
> I will let you figure it out, but it feels like it is actually testing
> !uppermetacopy

Yes this is testing !uppermetacopy. I really want to simplify it a bit
or atleast document it a bit that why metacopy case is different. Upper,
regular files done't go through lower layer loop but upper metacopy
files do. That's one difference which introduces some interesting
code changes.

- lower layer lookup loop already sets "origin" for metacopy files if
  indexing is on. This does not happen for regular non-metacopy files
  so they need to set origin here explicitly.

  if index feature is off, then we will not set "origin" for metacopy
  files in lower layer loop. But do we really need to set it given
  index is off and we don't want to lookup index.

- We don't want to set origin if upper never had xattr ORIGIN. For
  regular files, ctr will be 0 or 1 if ORIGIN xattr was found on
  upper. But for metacopy upper files, ctr can be non-zero even
  if ORGIN xattr was not found. So that's another reason that
  we check for upper metacopy here.

Difference between the case of regular and metacopy is subtle and
I think this should be simplified otherwise its very easy to break
it. 

I will spend some time on this after fixing the issue at hand. /me
always gets lost in the mage of index and origin. There seem to
be so many permutation and combination and its not clear to me
when metacopy file is different than regular file w.r.t origin
and index. It will be nice if we can minimize this difference and
document it well so that future modifications are easy.

Here is V2 of the patch. I added changelog. Also updated it to
set OVL_UPPERDATA in ovl_instantiate(). This is creating a new
file, so it can't be metacopy and should set OVL_UPPERDATA.

Miklos and Amir, please let me know what do you think about this
patch. I ran xfstetests overlay tests and these pass (except two
which fail even without the patch and are meant to fail.).

Thanks
Vivek


Subject: overlayfs: Initialize OVL_UPPERDATA in ovl_lookup()

Currently ovl_get_inode() initializes OVL_UPPERDATA flag and for that it
has to call ovl_check_metacopy_xattr() and check if metacopy xattr is
present or not.

yangerkun reported sometimes underlying filesystem might return -EIO
and in that case error handling path does not cleanup properly leading
to various warnings.

Run generic/461 with ext4 upper/lower layer sometimes may trigger the
bug as below(linux 4.19):

[  551.001349] overlayfs: failed to get metacopy (-5)
[  551.003464] overlayfs: failed to get inode (-5)
[  551.004243] overlayfs: cleanup of 'd44/fd51' failed (-5)
[  551.004941] overlayfs: failed to get origin (-5)
[  551.005199] ------------[ cut here ]------------
[  551.006697] WARNING: CPU: 3 PID: 24674 at fs/inode.c:1528 iput+0x33b/0x400
...
[  551.027219] Call Trace:
[  551.027623]  ovl_create_object+0x13f/0x170
[  551.028268]  ovl_create+0x27/0x30
[  551.028799]  path_openat+0x1a35/0x1ea0
[  551.029377]  do_filp_open+0xad/0x160
[  551.029944]  ? vfs_writev+0xe9/0x170
[  551.030499]  ? page_counter_try_charge+0x77/0x120
[  551.031245]  ? __alloc_fd+0x160/0x2a0
[  551.031832]  ? do_sys_open+0x189/0x340
[  551.032417]  ? get_unused_fd_flags+0x34/0x40
[  551.033081]  do_sys_open+0x189/0x340
[  551.033632]  __x64_sys_creat+0x24/0x30
[  551.034219]  do_syscall_64+0xd5/0x430
[  551.034800]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

One solution is to improve error handling and call iget_failed() if error
is encountered. Amir thinks that this path is little intricate and there
is not real need to check and initialize OVL_UPPERDATA in ovl_get_inode().
Instead caller of ovl_get_inode() can initialize this state. And this
will avoid double checking of metacopy xattr lookup in ovl_lookup()
and ovl_get_inode().

OVL_UPPERDATA is inode flag. So I was little concerned that initializing
it outside ovl_get_inode() might have some races. But this is one way
transition. That is once a file has been fully copied up, it can't go
back to metacopy file again. And that seems to help avoid races. So
as of now I can't see any races w.r.t OVL_UPPERDATA being set wrongly. So
move settingof OVL_UPPERDATA inside the callers of ovl_get_inode().
ovl_obtain_alias() already does it. So only two callers now left
are ovl_lookup() and ovl_instantiate(). 

metacopy variable has been split into two variables, lowermetacopy
and uppermetacopy. It just makes it easier to understand whether
metacopy if set on lower or upper. We need to set OVL_UPPERDATA
only in case of uppermetacopy.

Reported-by: yangerkun <yangerkun@huawei.com>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/dir.c   |    2 ++
 fs/overlayfs/inode.c |   11 +----------
 fs/overlayfs/namei.c |   25 ++++++++++++-------------
 3 files changed, 15 insertions(+), 23 deletions(-)

Index: redhat-linux/fs/overlayfs/namei.c
===================================================================
--- redhat-linux.orig/fs/overlayfs/namei.c	2020-05-28 10:51:57.838556592 -0400
+++ redhat-linux/fs/overlayfs/namei.c	2020-05-28 12:11:36.876964037 -0400
@@ -823,7 +823,7 @@ struct dentry *ovl_lookup(struct inode *
 	struct dentry *this;
 	unsigned int i;
 	int err;
-	bool metacopy = false;
+	bool uppermetacopy=false, lowermetacopy=false;
 	struct ovl_lookup_data d = {
 		.sb = dentry->d_sb,
 		.name = dentry->d_name,
@@ -869,7 +869,7 @@ struct dentry *ovl_lookup(struct inode *
 				goto out_put_upper;
 
 			if (d.metacopy)
-				metacopy = true;
+				uppermetacopy = true;
 		}
 
 		if (d.redirect) {
@@ -941,7 +941,7 @@ struct dentry *ovl_lookup(struct inode *
 		}
 
 		if (d.metacopy)
-			metacopy = true;
+			lowermetacopy = true;
 		/*
 		 * Do not store intermediate metacopy dentries in chain,
 		 * except top most lower metacopy dentry
@@ -982,16 +982,13 @@ struct dentry *ovl_lookup(struct inode *
 		}
 	}
 
-	if (metacopy) {
-		/*
-		 * Found a metacopy dentry but did not find corresponding
-		 * data dentry
-		 */
-		if (d.metacopy) {
-			err = -EIO;
-			goto out_put;
-		}
+	/* Found a metacopy dentry but did not find corresponding data dentry */
+	if (d.metacopy) {
+		err = -EIO;
+		goto out_put;
+	}
 
+	if (lowermetacopy || uppermetacopy) {
 		err = -EPERM;
 		if (!ofs->config.metacopy) {
 			pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n",
@@ -1023,7 +1020,7 @@ struct dentry *ovl_lookup(struct inode *
 	 *
 	 * Always lookup index of non-dir non-metacopy and non-upper.
 	 */
-	if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
+	if (ctr && (!upperdentry || (!d.is_dir && !uppermetacopy)))
 		origin = stack[0].dentry;
 
 	if (origin && ovl_indexdir(dentry->d_sb) &&
@@ -1074,6 +1071,8 @@ struct dentry *ovl_lookup(struct inode *
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
+		if (upperdentry && !uppermetacopy)
+			ovl_set_flag(OVL_UPPERDATA, inode);
 	}
 
 	ovl_dentry_update_reval(dentry, upperdentry,
Index: redhat-linux/fs/overlayfs/inode.c
===================================================================
--- redhat-linux.orig/fs/overlayfs/inode.c	2020-05-27 17:06:04.224809626 -0400
+++ redhat-linux/fs/overlayfs/inode.c	2020-05-28 10:52:12.890556592 -0400
@@ -939,7 +939,7 @@ struct inode *ovl_get_inode(struct super
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry,
 					oip->index);
 	int fsid = bylower ? lowerpath->layer->fsid : 0;
-	bool is_dir, metacopy = false;
+	bool is_dir;
 	unsigned long ino = 0;
 	int err = oip->newinode ? -EEXIST : -ENOMEM;
 
@@ -1000,15 +1000,6 @@ struct inode *ovl_get_inode(struct super
 	if (oip->index)
 		ovl_set_flag(OVL_INDEX, inode);
 
-	if (upperdentry) {
-		err = ovl_check_metacopy_xattr(upperdentry);
-		if (err < 0)
-			goto out_err;
-		metacopy = err;
-		if (!metacopy)
-			ovl_set_flag(OVL_UPPERDATA, inode);
-	}
-
 	OVL_I(inode)->redirect = oip->redirect;
 
 	if (bylower)
Index: redhat-linux/fs/overlayfs/dir.c
===================================================================
--- redhat-linux.orig/fs/overlayfs/dir.c	2020-04-22 08:47:37.419523036 -0400
+++ redhat-linux/fs/overlayfs/dir.c	2020-05-28 11:36:15.338556592 -0400
@@ -262,6 +262,8 @@ static int ovl_instantiate(struct dentry
 		inode = ovl_get_inode(dentry->d_sb, &oip);
 		if (IS_ERR(inode))
 			return PTR_ERR(inode);
+		if (inode == oip.newinode)
+			ovl_set_flag(OVL_UPPERDATA, inode);
 	} else {
 		WARN_ON(ovl_inode_real(inode) != d_inode(newdentry));
 		dput(newdentry);

