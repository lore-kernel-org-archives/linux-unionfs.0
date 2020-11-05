Return-Path: <SRS0=HYNE=EL=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17B0C00A89
	for <linux-unionfs@archiver.kernel.org>; Thu,  5 Nov 2020 11:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14CD0206FB
	for <linux-unionfs@archiver.kernel.org>; Thu,  5 Nov 2020 11:39:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="NSeRHpaU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgKELje (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 5 Nov 2020 06:39:34 -0500
Received: from sender3-pp-o92.zoho.com.cn ([124.251.121.251]:25365 "EHLO
        sender3-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729992AbgKELjQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 5 Nov 2020 06:39:16 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1604576346; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=k+LSL713nuNcu8lfVuqEtx7AhiEho2Nl26vVP6tbjBEmp+zdBKEhvaaUZiKe6m0q87sDz1iDOqdNmx2CR19zc1p0HNWuwcoJFNYS9ky1Sd7iEYAIqAyZi+beuno6VfWvfSh3fTy/rzKS5J9r3luwpTKozm3XFhpumCwW0VavOxE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1604576346; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=0daSOIYa+VQkZH72HwWnco1e6/c4qs9PUIBLANXRJkI=; 
        b=F/4aLycju3SIq9dwi1eKMPM0WKvD1/QSG1hyWpQDdkGxU/ANbxzGNBnEW21u7hPr3pp4F+ArAIHY/CpQXk2tZf01pG1imBDadFRurLMPSmvy75EVh/5nzR3LhjaXyNpRHRXXAPBmNTw5yeq0FN+XqLJPbferaBMSWUQ6hbCfg3c=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1604576346;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=0daSOIYa+VQkZH72HwWnco1e6/c4qs9PUIBLANXRJkI=;
        b=NSeRHpaUVOq/ILdpOH0VVa/WKiA03NlmPEOQH3DF8yAkQ5qKwapx82tWHfvyGi2R
        G3T3qqfMHPNI1CBmbUhmc9zDvadgUgrLVqszvpFOsxDpy8C/q5ZV4w1QWqcN8QX8+sU
        Y7149zma64LDs4e/TjkKUwIzAhiPs9/75U8MPEZ4=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1604576345328456.20731976971786; Thu, 5 Nov 2020 19:39:05 +0800 (CST)
Date:   Thu, 05 Nov 2020 19:39:05 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "Amir Goldstein" <amir73il@gmail.com>,
        "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-ID: <1759833fcec.11bebc5a09074.619089384538905286@mykernel.net>
In-Reply-To: <CAJfpegu-rqL4-jn9o0+OSj2x+hKS8mLB6GswhL17Ruhb3WuMKg@mail.gmail.com>
References: <17596177926.d559c8b77834.5766617584799741474@mykernel.net>
 <CAOQ4uxgpmC_B_uWpnMXDrv9BOQ-rsMxyRTc+qC3dT72sqR8ndg@mail.gmail.com> <17597c5dc4e.fb084b178911.1848736071974456771@mykernel.net> <CAJfpegu-rqL4-jn9o0+OSj2x+hKS8mLB6GswhL17Ruhb3WuMKg@mail.gmail.com>
Subject: Re: a question about opening file
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-11-05 17:57:15 Miklos Sze=
redi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > On Thu, Nov 5, 2020 at 10:38 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-11-05 16:07:26 Amir =
Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > On Thu, Nov 5, 2020 at 6:39 AM Chengguang Xu <cgxu519@mykernel.net>=
 wrote:
 > >  > >
 > >  > > Hello,
 > >  > >
 > >  > > I have a question about opening file of underlying filesystem in =
overlayfs,
 > >  > >
 > >  > > why we use overlayfs' path(vfsmount/dentry) struct for underlying=
 fs' file
 > >  > >
 > >  > > in ovl_open_realfile()?  Is it by design?
 > >  >
 > >  > Sure. open_with_fake_path() is only used by overlayfs.
 > >  >
 > >  > IIRC, one of the reasons was to display the user expected path in
 > >  > /proc/<pid>/maps.
 > >  > There may have been other reasons.
 > >  >
 > >
 > > So if we do the mmap with overlayfs'  own page cache, then we don't ha=
ve to
 > > use pseudo path for the reason above, right?
 > >
 > > Actually, the background is I'm trying to implement overlayfs' page ca=
che for
 > > fixing mmap rorw issue. The reason why asking this is I need to open a=
 writeback
 > > file which is used for syncing dirty data from overlayfs' own page cac=
he to upper inode.
 > > However, if I use the pseudo path just like current opening behavior, =
the writeback
 > > file will hold a reference of vfsmount of overlayfs and it will cause =
umount fail with -EBUSY.
 > > So I want to open a writeback file with correct underlying path struct=
 but not sure if
 > > there is any unexpected side effect. Any suggestion?
 >=20
 > Should be no issue with plain dentry_open() for that purpose.  In fact
 > it would be really good to get rid of all that d_real*() mess
 > completely, but that seems some ways off.
 >=20
 > Did you find the prototype we did with Amir a couple of years back?  I
 > can only find bits and pieces in my mailbox...
 >=20

I searched in overlayfs mail list but unfortunately didn't  get useful info=
.
Seems Amir has a git tree for aops prototype but I'm not sure if that is th=
e
prototype you mentioned.

https://github.com/amir73il/linux/commits/ovl-aops-wip

Hi Amir,

Do you know the prototype that Miklos mentioned above? Is that the
code in your ovl-aops-wip git tree?


Thanks,
Chengguang

