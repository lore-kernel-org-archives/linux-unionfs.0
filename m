Return-Path: <SRS0=Y+g3=5M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB78C43331
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 Mar 2020 05:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A143620714
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 Mar 2020 05:18:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="fBG9Bj1o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgC0FS7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 01:18:59 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25346 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725936AbgC0FS6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Mar 2020 01:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1585286318;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=jHsM//CqEymi6de1Oi/skhT4UuyP33CSk9q4SpMSOU0=;
        b=fBG9Bj1oqM33dtpIIo7c+i4yPRrhtjmvodtvwhH1kXkBGZeSq/y4BBQMsCassl7S
        g4yg/ZcamFOCweB5dKCjSmLIui+RZWqjolGj/jmu+cXvCnL6UWsIsjHYU8ASn78m4tL
        O04gxdxZQuflmdXaWLUG86X+uHz/Em0a0JFc8vdU=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1585286315715553.9252438320384; Fri, 27 Mar 2020 13:18:35 +0800 (CST)
Date:   Fri, 27 Mar 2020 13:18:35 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "linux-unionfs" <linux-unionfs@vger.kernel.org>,
        "miklos" <miklos@szeredi.hu>
Message-ID: <1711a6d7ebf.1251ea7b024963.4823296748033142049@mykernel.net>
In-Reply-To: <CAOQ4uxgAubW72xGej-Tg4juicRe3nY0gmH32p0Sf3OWV45fviA@mail.gmail.com>
References: <171155f7fb1.fb0dc6a422928.8465401279980458758@mykernel.net> <CAOQ4uxgAubW72xGej-Tg4juicRe3nY0gmH32p0Sf3OWV45fviA@mail.gmail.com>
Subject: Re: Inode limitation for overlayfs
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Priority: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-03-26 15:34:13 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Thu, Mar 26, 2020 at 7:45 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > > Hello,
 > >
 > > On container use case, in order to prevent inode exhaustion on host fi=
le system by particular containers,  we would like to add inode limitation =
for containers.
 > > However,  current solution for inode limitation is based on project qu=
ota in specific underlying filesystem so it will also count deleted files(c=
har type files) in overlay's upper layer.
 > > Even worse, users may delete some lower layer files for getting more u=
sable free inodes but the result will be opposite (consuming more inodes).
 > >
 > > It is somewhat different compare to disk size limitation for overlayfs=
, so I think maybe we can add a limit option just for new files in overlayf=
s. What do you think?
 >=20
 > The questions are where do we store the accounting and how do we maintai=
n them.
 > An answer to those questions could be - in the inode index:
 >=20
 > Currently, with nfs_export=3Don, there is already an index dir containin=
g:
 > - 1 hardlink per copied up non-dir inode
 > - 1 directory per copied-up directory
 > - 1 whiteout per whiteout in upperdir (not an hardlink)
 >=20

Hi Amir,

Thanks for quick response and detail information.=20

I think the simplest way is just store accounting info in memory(maybe  in =
s_fs_info).
At very first, I just thought  doing it for container use case, for contain=
er, it will be=20
enough because the upper layer is always empty at starting time and will be=
 destroyed=20
at ending time. =20

Adding a meta info to index dir is a  better solution for general use case =
but it seems
more complicated and I'm not sure if there are other use cases concern with=
 this problem.=20
Suggestion?


 > We can also make this behavior independent of nfs_export feature.
 > In the past, I proposed the option index=3Dall for this behavior.
 >=20
 > On mount, in ovl_indexdir_cleanup(), the index entries for file/dir/whit=
eout
 > can be counted and then maintained on index add/remove.
 >=20
 > Now if you combine that with project quotas on upper/work dir, you get:
 > <Total upper/work inodes> =3D <pure upper inodes> + <non-dir index count=
> +
 >                                            2*<dir index count> +
 > 2*<whiteout index count>

I'm not clear what the exact relationships between those indexes and nfs_ex=
port
but  if possible I hope having  separated switches for every index function=
s and a total
switch(index=3Dall) to enable all index functions at same time.

 >=20
 > Assuming that you know the total from project quotas and the index count=
s
 > from overlayfs, you can calculate total pure upper.
 >=20
 > Now you *can* implement upper inodes quota within overlayfs, but you
 > can also do that without changing overlayfs at all assuming you can
 > allow some slack in quota enforcement -
 > periodically scan the index dir and adjust project quota limits.

Dynamically changing inode limit  looks  too complicated to implement in ma=
nagement system
and having different quota limit during lifetime for same container may cau=
se confusion to sys admins.=20
So I still hope to solve this problem on overlayfs layer.

 >=20
 > Note that if inodes are really expensive on your system, index_all
 > wastes 1 inode per whiteout + 1 inode per copied up dir, but those
 > counts should be pretty small compared to number of pure upper inodes
 > and copied up files.
 >=20


Thanks,
cgxu.

