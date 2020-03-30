Return-Path: <SRS0=PXIl=5P=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 249D2C43331
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Mar 2020 02:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92CAF2076A
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Mar 2020 02:00:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="Km7Dbs/S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgC3CA7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 22:00:59 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25338 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727801AbgC3CA6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 29 Mar 2020 22:00:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1585533639;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=V8BtFv1nRF/dJFijfOShixx3l9aLBJnhnvf3PDjSV58=;
        b=Km7Dbs/SkqBfrkFaEkEPGC6eDjUXpR9gy8MG+e9/QfBq8spfXyMqpDBJntR3gzoT
        xgzZxA0mcZTIg6aJsSbAg7DlpkJDp/bvQBEVMSs+rMOxFbpF9h6JiigIKPAUkKatRPW
        yjvKdAso6r1YMIOmasGD+Dw87c4TkcNhy8LNXPY0=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1585533637034187.47135070607897; Mon, 30 Mar 2020 10:00:37 +0800 (CST)
Date:   Mon, 30 Mar 2020 10:00:37 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>,
        "Hou Tao" <houtao1@huawei.com>
Cc:     "linux-unionfs" <linux-unionfs@vger.kernel.org>,
        "miklos" <miklos@szeredi.hu>
Message-ID: <171292b51a7.c46ef0d428143.2315914367858349664@mykernel.net>
In-Reply-To: <CAOQ4uxg+-nbV=pq_He7xTkBdikRAwq0DXpt9d-FV8tx0MdLV_w@mail.gmail.com>
References: <171155f7fb1.fb0dc6a422928.8465401279980458758@mykernel.net>
 <CAOQ4uxgAubW72xGej-Tg4juicRe3nY0gmH32p0Sf3OWV45fviA@mail.gmail.com>
 <1711a6d7ebf.1251ea7b024963.4823296748033142049@mykernel.net>
 <CAOQ4uxj-6upXZkAKVDocuLSwveO8hb5_pdbd=_0zbRx2UD9gsg@mail.gmail.com> <17126a9038c.d17770b728105.8827100903005997785@mykernel.net> <CAOQ4uxg+-nbV=pq_He7xTkBdikRAwq0DXpt9d-FV8tx0MdLV_w@mail.gmail.com>
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E6=97=A5, 2020-03-29 23:06:42 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Sun, Mar 29, 2020 at 5:19 PM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-03-27 17:45:37 Amir =
Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > On Fri, Mar 27, 2020 at 8:18 AM Chengguang Xu <cgxu519@mykernel.net=
> wrote:
 > >  > >
 > >  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-03-26 15:34:13 =
Amir Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > >  > On Thu, Mar 26, 2020 at 7:45 AM Chengguang Xu <cgxu519@mykerne=
l.net> wrote:
 > >  > >  > >
 > >  > >  > > Hello,
 > >  > >  > >
 > >  > >  > > On container use case, in order to prevent inode exhaustion =
on host file system by particular containers,  we would like to add inode l=
imitation for containers.
 > >  > >  > > However,  current solution for inode limitation is based on =
project quota in specific underlying filesystem so it will also count delet=
ed files(char type files) in overlay's upper layer.
 > >  > >  > > Even worse, users may delete some lower layer files for gett=
ing more usable free inodes but the result will be opposite (consuming more=
 inodes).
 > >  > >  > >
 > >  > >  > > It is somewhat different compare to disk size limitation for=
 overlayfs, so I think maybe we can add a limit option just for new files i=
n overlayfs. What do you think?
 > >  >
 > >  > You are saying above that the goal is to prevent inode exhaustion o=
n
 > >  > host file system,
 > >  > but you want to allow containers to modify and delete unlimited num=
ber
 > >  > of lower files
 > >  > thus allowing inode exhaustion. I don't see the logic is that.
 > >  >
 > >
 > > End users do not understand kernel tech very well, so we just want to =
mitigate
 > > container's different user experience as much as possible. In our poin=
t of view,
 > > consuming more inode by deleting lower file is the feature of overlayf=
s, it's not
 > > caused by user's  abnormal using. However, we have to limit malicious =
user
 > > program which is endlessly creating new files until host inode exhaust=
ing.
 > >
 > >
 > >  > Even if we only count new files and present this information on df =
-i
 > >  > how would users be able to free up inodes when they hit the limit?
 > >  > How would they know which inodes to delete?
 > >  >
 > >  > >  >
 > >  > >  > The questions are where do we store the accounting and how do =
we maintain them.
 > >  > >  > An answer to those questions could be - in the inode index:
 > >  > >  >
 > >  > >  > Currently, with nfs_export=3Don, there is already an index dir=
 containing:
 > >  > >  > - 1 hardlink per copied up non-dir inode
 > >  > >  > - 1 directory per copied-up directory
 > >  > >  > - 1 whiteout per whiteout in upperdir (not an hardlink)
 > >  > >  >
 > >  > >
 > >  > > Hi Amir,
 > >  > >
 > >  > > Thanks for quick response and detail information.
 > >  > >
 > >  > > I think the simplest way is just store accounting info in memory(=
maybe  in s_fs_info).
 > >  > > At very first, I just thought  doing it for container use case, f=
or container, it will be
 > >  > > enough because the upper layer is always empty at starting time a=
nd will be destroyed
 > >  > > at ending time.
 > >  >
 > >  > That is not a concept that overlayfs is currently aware of.
 > >  > *If* the concept is acceptable and you do implement a feature inten=
ded for this
 > >  > special use case, you should verify on mount time that upperdir is =
empty.
 > >  >
 > >  > >
 > >  > > Adding a meta info to index dir is a  better solution for general=
 use case but it seems
 > >  > > more complicated and I'm not sure if there are other use cases co=
ncern with this problem.
 > >  > > Suggestion?
 > >  >
 > >  > docker already supports container storage quota using project quota=
s
 > >  > on upperdir (I implemented it).
 > >  > Seems like a very natural extension to also limit no. of inodes.
 > >  > The problem, as you wrote it above is that project quotas
 > >  > "will also count deleted files(char type files) in overlay's upper =
layer."
 > >  > My suggestion to you was a way to account for the whiteouts separat=
ely,
 > >  > so you may deduct them from total inode count.
 > >  > If you are saying my suggestion is complicated, perhaps you did not
 > >  > understand it.
 > >  >
 > >
 > > I think the key point here is the count of whiteout inode. I would lik=
e to
 > > propose share same inode with different whiteout files so that we can =
save
 > > inode significantly for whiteout files. After this, I think we can jus=
t implement
 > > normal inode limit for container just like block limit.
 > >
 >=20
 > Very good idea. See:
 > https://lore.kernel.org/linux-unionfs/20180301064526.17216-1-houtao1@hua=
wei.com/
 >=20
 > I don't think Tao ever followed up with v3 patch.
 >=20

Thanks Amir, the feature looks exactly what we need.

Hi Tao,

Would you have plan to update the patch "overlay: hardlink all whiteout fil=
es into a single one" in the recent future?
I'm trying to fix a issue regarding to inode limitation in container and in=
ode sharing with whiteout files is the key point to support the solution.


Thanks,
cgxu














